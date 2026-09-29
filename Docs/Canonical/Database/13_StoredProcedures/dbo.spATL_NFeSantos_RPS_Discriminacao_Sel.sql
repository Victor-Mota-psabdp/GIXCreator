SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_NFeSantos_RPS_Discriminacao_Sel]--3889
	@NF varchar(10)
	--@dtInicial datetime,
	--@dtFinal datetime
as

SET NOCOUNT ON

Declare @Nota Table
	(
		Numero						Varchar(10),	
		Serie						Varchar(1),	
		Tipo						Varchar(1),	
		DataEmissao					Varchar(25),						
		NaturezaOperacao			Varchar(1),	
		RegimeEspecialTributacao	Varchar(1),	
		OptanteSimplesNacional		Varchar(1),	
		IncentivadorCultural		Varchar(1),	
		[Status]					Varchar(1),		
		ValorServicos				decimal(10,2),
		ValorPis					decimal(10,2),	
		ValorCofins					decimal(10,2),	
		ValorInss					decimal(10,2),	
		ValorIr						decimal(10,2),
		ValorCsll					decimal(10,2),	
		IssRetido					int,					
		ValorIssRetido				decimal(10,2),	
		ValorIss					decimal(10,2),
		BaseCalculo					decimal(10,2),
		Aliquota					decimal(10,2),
		ValorLiquidoNfse				decimal(10,2),	
		ItemListaServico				Varchar(10),		
		CodigoCnae						Varchar(10),
		CodigoTributacaoMunicipio		Varchar(10),	
		CodigoMunicipio					Varchar(10),
		Discriminacao					Varchar(MAX),
		MunicipioPrestacaoServico		Varchar(10),	
		Cnpj							Varchar(25),
		InscricaoMunicipal				Varchar(25),	
		CpfCnpj							Varchar(25),	
		CpfInscricaoMunicipal			Varchar(25),	
		RazaoSocial						Varchar(60),
		Endereco						Varchar(100),	
		NumeroEnd						Varchar(25),
		Complemento						Varchar(25),	
		Bairro							Varchar(50),
		Cidade							Varchar(50),
		CodigoMunicipioE				Varchar(10),
		CodigoMunicipioEnd				Varchar(10),	
		Uf								Varchar(10),
		Estado							Varchar(50),
		Cep								Varchar(25),
		Telefone						Varchar(25),	
		Email							Varchar(50),
		Ref_Acesso						varchar(1),
		ValorCargaTributaria			decimal(10,2),
		Pais							varchar(100)
			
	)

BEGIN	
	insert into @Nota	
		select distinct
			--[IdentificacaoRps]					
				BNF.Nota_Fiscal [Numero], 
				'1' [Serie], 
				'1' [Tipo], 
			--[IdentificacaoRps]
		
			convert(varchar(10), BNF.Emissao,120)+ 'T00:00:00' [DataEmissao],
			'1' [NaturezaOperacao], 
			'1' [RegimeEspecialTributacao], --NO 
			'2' [OptanteSimplesNacional], --MO
			'2' [IncentivadorCultural],--NO
			
			(case when BNF.cd_status = 0 then
				1 else 
			BNF.cd_status end)[Status],
			
			--[Servico]
				--[Valores]				
					isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorServicos],
					
					--[ValorPis],
					
					-- PIS -  Alíquotas  0,65% se o valor das notas emitidas no dia atingir R$ 215,17
						(case when BNF.Item_lei = '33.01' and BNF.Valor_Total > 215.17 
									--and TE.Cidade <> 'SANTOS' 
									and (T.num_cpf_cnpj is not null) then
							isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00')
							else '0.00' end) [ValorPis],
				
					--[ValorCofins],
					-- COFINS - Alíquota 3% se o valor das notas emitidas no dia atingir R$ 215,17
						(case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 215.17 
								--and TE.Cidade <> 'SANTOS' 
								and (T.num_cpf_cnpj is not null) then
							isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
							else '0.00' end) [ValorCofins],
						
						--[ValorInss], 
						--- INSS -  não preenche											
						'0.00' [ValorInss], 
					
						--[ValorIr],				
						--- IR - 1,5% se o valor das notas emitidas no dia atingir R$ 666,67
						(case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 666.67 
									--and TE.Cidade <> 'SANTOS' 
									and (T.num_cpf_cnpj is not null) then 
							isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
						else (case when BNF.IRRF_Tx= 'S' then
							isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
							else '0.00' end)end) [ValorIr], 
						 
						 
						 --[ValorCsll],
						 --- CSLL - Alíquota 1% se se se o valor das notas emitidas no dia atingir R$ 215,17
						 (case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 215.17 
							--and TE.Cidade <> 'SANTOS' 
							and (T.num_cpf_cnpj is not null) then 
							isnull(convert(varchar,convert(decimal(10,2),.01* BNF.Valor_Total)),'0.00')
							else '0.00' end) [ValorCsll],
					
					(case when TE.Cidade = 'SANTOS' then 
					'1' else '2' end)[IssRetido],--1 SIM | 2 Não
					
					
					(case when TE.Cidade = 'SANTOS' then 
						isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
						else '0.00' end)[ValorIssRetido],
					
					--isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [ValorIssRetido],
					
					isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [ValorIss],
					
					isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],				
					'0.03' [Aliquota],
					
					(case when TE.Cidade = 'SANTOS' then 
						isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total) - convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
						--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') - isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
					else
						isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00')
					end)	[ValorLiquidoNfse],
					--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorLiquidoNfse],
					--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total - ((.0065+.03+.01+.05)*BNF.Valor_Total))),'0.00') [ValorLiquidoNfse],
				--[Valores]
				
				replace(BNF.Item_lei,'.','')		[ItemListaServico], 
				replace(BNF.CNAE,'.','')			[CodigoCnae], 
				replace(BNF.cd_servico,'.','')		[CodigoTributacaoMunicipio],
				
				'3548500'							[CodigoMunicipio],
			
				
				--qdo o endereco eh de fora, só deve ir o iss
				(case when T.num_cpf_cnpj = '' OR T.num_cpf_cnpj IS NULL then
					--[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
					' | Conforme Lei 12.741/2012: ISS 3% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% R$ ' + '0.00' +
					' e Confins 7,6% R$ ' + '0.00'
				else
					--[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
					' | Conforme Lei 12.741/2012: ISS 3% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.0165*BNF.Valor_Total)),'0.00') +
					' e Confins 7,6% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.076* BNF.Valor_Total)),'0.00')					
				end)[Discriminacao],
							
				''	[MunicipioPrestacaoServico], --NO
			--[Servico]
			--[Prestador]
				'03706460000209'		[Cnpj],
				'1366280'				[InscricaoMunicipal],
			--[Prestador]
			--[Tomador]
				--[IdentificaçãoTomador]
					--[CpfCnpj]
						--(CASE WHEN T.num_cpf_cnpj = '' then '00000000000000' else T.num_cpf_cnpj end) [CpfCnpj],
						T.num_cpf_cnpj [CpfCnpj],
					--[CpfCnpj]
					(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN '' ELSE replace(NUM_Insc_Munic,'.','') END) [CpfInscricaoMunicipal],
				--[IdentificaçãoTomador]
				[dbo].[FRemoveAcentuacao](T.nome_raz_soc) [RazaoSocial], 
				--[Endereco]
					TE.Rua		[Endereco],
					(case when (TE.numero = '' or TE.numero is null) then 'S/N' else TE.numero end)  [Numero],
					--TE.numero	[Numero],
					TE.Compl_End	[Complemento],
					(case when TE.bairro = '' OR TE.bairro IS null then
						'Nao Informado' else
						TE.bairro
					End)	[Bairro],
					--TE.bairro	[Bairro],
					TE.Cidade	[Cidade],
					TE.Cod_IBGE [CodigoMunicipio],
					--CMN.STR_CODIGOMUN_IBGE [CodigoMunicipioEnd],
					I.UF + I.Cod_IBGE [CodigoMunicipioEnd],
					TE.UF		[Uf], 
					TE.UF		[Estado],
					right('00000000000' + replace(TE.CEP,'-',''),8)		[Cep],
				--[Endereco]
				--[Contato]
					--(CO.cd_area_fone + CO.Prefixo + CO.num_fone) [Telefone],
					right('00000000000' + replace(replace(isnull((CO.cd_area_fone + CO.Prefixo + CO.num_fone),'00000000'),'.',''),'-',''),11) [Telefone],
				--[Contato]	
				--[Email]
					co.Compl_Fone [Email],
				--[Contato]		
			 --[Tomador]
			 BNF.Ref_Acesso,			 			
			'0.00' ValorCargaTributaria,
			isnull(TE.Pais,'')	Pais
		from 
			base_nota_fiscal BNF with(nolock)
			join pessoa T with(nolock) on T.cd_pes = BNF.cd_pes 
			left join endereco TE with(nolock) on TE.cd_pes = T.cd_pes and TE.cd_tp_end = 'COM'
			left join comunicacao CO with(nolock) on CO.cd_pes = T.cd_pes and Co.cd_tp_com ='NF1'
			left join IBGE_Municipios_BR I with(nolock) on I.Nome_Município = TE.cidade and I.UF_Descr_Red = TE.UF
			--join atl_web.dbo.CAD_UF_NF CUN on CUN.str_SiglaUF   COLLATE Latin1_General_CI_AI = TE.UF
			--join atl_web.dbo.cad_mun_nf CMN on CMN.str_nomemun  COLLATE Latin1_General_CI_AI = TE.cidade and CUN.str_CodigoUF_IBGE = CMN.str_CodigoUF_IBGE		
		where
			BNF.Ref_Acesso = 'I' 			
			and BNF.Cd_Status <> 2 
			and BNF.RPS_Envio <> 1			
			--and ((emissao between @dtInicial and @dtFinal) OR 
			and Nota_Fiscal = @NF
	END
	
update 
	T  
set 
	[ValorLiquidoNfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis] - [ValorIssRetido]
from 
	@Nota as T
--where
--	T.Cidade <> 'SANTOS'

BEGIN	
	 if not exists(select * from Base_Envio_LoteRps B with(nolock)
		join @Nota N on N.Numero = B.Numero and N.Ref_Acesso = B.Ref_Acesso)		
		insert into Base_Envio_LoteRps
			select * from @Nota			
END

select * from @Nota



GO
