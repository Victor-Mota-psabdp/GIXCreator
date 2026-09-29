SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Base_Nota_Fiscal where Nota_Fiscal = '1898' and Ref_Acesso = 'H' 
--select * from Base_Envio_LoteRps where Ref_Acesso = 'H' and numero = 1899

CREATE procedure [dbo].[spATL_NFeVitoria_RPS_Sel]--'1902'
	@NF varchar(10)
as

SET NOCOUNT ON

Declare @Nota Table
	(
		Numero						Varchar(10),	
		Serie						Varchar(3),	
		Tipo						Varchar(1),	
		DataEmissao					Varchar(25),
		NaturezaOperacao			Varchar(1),	
		RegimeEspecialTributacao	Varchar(1),	
		OptanteSimplesNacional		Varchar(1),	
		IncentivadorCultural		Varchar(1),	
		[Status]					Varchar(1),		
		ValorServicos				decimal(10,2),
		--ValorDeducoes				decimal(10,2),
		ValorPis					decimal(10,2),	
		ValorCofins					decimal(10,2),	
		ValorInss					decimal(10,2),	
		ValorIr						decimal(10,2),
		ValorCsll					decimal(10,2),
		
		IssRetido					int,
		ValorIssRetido				decimal(10,2),
		ValorIss					decimal(10,2),	
		BaseCalculo					decimal(10,2),
		--OutrasRetencoes				decimal(10,2),		
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
		
			convert(varchar(10), BNF.Emissao,120) [DataEmissao],
			
			'1' [NaturezaOperacao], 
			'1' [RegimeEspecialTributacao], --NO 
			'2' [OptanteSimplesNacional], --MO
			'2' [IncentivadorCultural],--NO		
			
			(case when BNF.cd_status = 0 then
				1 else 
			BNF.cd_status end)[Status],
			
			--[Servico]
				--[Valores]	
				
					--Nesse lote não testamos o código 33.01, por ser um serviço esporádico nessa filial,
					-- mas ele segue a mesma regra já usada para São Paulo, retenção de PIS 0,65% cofins 3% CSLL 1% 
					-- se o valor total do serviço atingir 215,17 e de 1,5% se o valor do serviço atingir R$ 667,66.   
				
							
					isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorServicos],
					
					--'0.00' [ValorDeducoes],
					
					-- PIS -  Alíquotas  0,65% 
						(case when BNF.Item_lei = '33.01'and (T.num_cpf_cnpj is not null) then
							isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00')
						else '0.00' end) [ValorPis],
				
					--[ValorCofins],
					-- COFINS - Alíquota 3%
						(case when BNF.Item_lei = '33.01' and (T.num_cpf_cnpj is not null) then
							isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
						else '0.00' end) [ValorCofins],
						
						--[ValorInss], 
						'0.00' [ValorInss], 
						
						--[ValorIr],				
						--- IR - 1,5% se o valor das notas emitidas no dia atingir R$ 666,67
						(case when (BNF.Item_lei = '10.05' or BNF.Item_lei = '33.01') and BNF.Valor_Total > 666.67 									
									and (T.num_cpf_cnpj is not null) then 
							isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
						else 
							(case when BNF.IRRF_Tx= 'S' then
								isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
							else '0.00' end)end) [ValorIr], 
						 						 
						 --[ValorCsll],
						 --- CSLL - Alíquota 1%
						 (case when BNF.Item_lei = '33.01' and (T.num_cpf_cnpj is not null) then 
							isnull(convert(varchar,convert(decimal(10,2),.01* BNF.Valor_Total)),'0.00')
							else '0.00' end) [ValorCsll],
					
					--'0.00' [OutrasRetencoes],
					
						(case when TE.Cidade = 'Vitoria' then 
						'1' else '2' end)[IssRetido],--1 SIM | 2 Não
						
						--nao utiliza
						(case when TE.Cidade = 'Vitoria' then 
							isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
							else '0.00' end)[ValorIssRetido],
					
						isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') [ValorIss],
						
						isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],	
						
						'5.00' [Aliquota],								
											
						(case when TE.Cidade = 'Vitoria' then 
							isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total) - convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')						
						else
							isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00')
						end)	[ValorLiquidoNfse],
						--nao utiliza
					
				--[Valores]
				
				BNF.Item_lei						[ItemListaServico], 
				replace(BNF.CNAE,'.','')			[CodigoCnae], 
				replace(BNF.cd_servico,'.','')		[CodigoTributacaoMunicipio],
				
				'3205309'							[CodigoMunicipio],
				
				--qdo o endereco eh de fora, só deve ir o iss
				(case when T.num_cpf_cnpj = '' OR T.num_cpf_cnpj IS NULL then
					[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSVIT](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
					' \s\n Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% R$ ' + '0.00' +
					' e Confins 7,6% R$ ' + '0.00'
				else
					[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSVIT](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
					' \s\n Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.0165*BNF.Valor_Total)),'0.00') +
					' e Confins 7,6% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.076* BNF.Valor_Total)),'0.00')					
				end)[Discriminacao],
							
				''	[MunicipioPrestacaoServico], --NO
			--[Servico]
			--[Prestador]
				'03706460000713'		[Cnpj],
				'1217852'				[InscricaoMunicipal],
			--[Prestador]
			--[Tomador]
				--[IdentificaçãoTomador]
					--[CpfCnpj]
						--(CASE WHEN T.num_cpf_cnpj = '' then '00000000000000' else T.num_cpf_cnpj end) [CpfCnpj],
						T.num_cpf_cnpj [CpfCnpj],
					--[CpfCnpj]
					(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN '' ELSE NUM_Insc_Munic END) [CpfInscricaoMunicipal],
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
					TE.Cidade	[Cidade],
					TE.Cod_IBGE [CodigoMunicipio],
					--CMN.STR_CODIGOMUN_IBGE [CodigoMunicipioEnd],
					I.UF + I.Cod_IBGE [CodigoMunicipioEnd],
					TE.UF		[Uf], 
					TE.UF		[Estado],
					TE.CEP		[Cep],
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
			base_nota_fiscal BNF
			join pessoa T on T.cd_pes = BNF.cd_pes 
			left join endereco TE on TE.cd_pes = T.cd_pes and TE.cd_tp_end = 'COM'
			left join comunicacao CO on CO.cd_pes = T.cd_pes and Co.cd_tp_com ='NF1'
			left join IBGE_Municipios_BR I on I.Nome_Município = TE.cidade and I.UF_Descr_Red = TE.UF
			--join atl_web.dbo.CAD_UF_NF CUN on CUN.str_SiglaUF   COLLATE Latin1_General_CI_AI = TE.UF
			--join atl_web.dbo.cad_mun_nf CMN on CMN.str_nomemun  COLLATE Latin1_General_CI_AI = TE.cidade and CUN.str_CodigoUF_IBGE = CMN.str_CodigoUF_IBGE		
		where
			BNF.Ref_Acesso = 'H' 			
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


BEGIN	
	 if not exists(select b.Ref_Acesso from Base_Envio_LoteRps B
		join @Nota N on N.Numero = B.Numero and N.Ref_Acesso = B.Ref_Acesso)		
		insert into Base_Envio_LoteRps
			select * from @Nota			
END

select * from @Nota


GO
