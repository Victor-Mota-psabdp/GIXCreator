SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_NFeSaoPaulo_RPS_Web_Sel]'106979'
--spATL_NFeSaoPaulo_RPS_Web_Sel '110074'
--sp_help Base_Envio_LoteRps
CREATE procedure [dbo].[spATL_NFeSaoPaulo_RPS_Web_Sel]--'110172'
	@NF varchar(10)

as

SET NOCOUNT ON

Declare @Nota Table
	(
		Nota_Fiscal					Varchar(12),	
		Serie						Varchar(3),	
		Tipo						Varchar(5),	
		Emissao						Varchar(25),						
		NaturezaOperacao			Varchar(1),	
		RegimeEspecialTributacao	Varchar(1),	
		OptanteSimplesNacional		Varchar(1),	
		IncentivadorCultural		Varchar(1),	
		cd_status					Varchar(1),		
		Valor_Total					decimal(10,2),
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
		ValorLiquidoNfse			decimal(10,2),	
		ItemListaServico			Varchar(10),		
		CodigoCnae					Varchar(10),
		cd_servico					Varchar(10),	
		CodigoMunicipio				Varchar(10),
		Observ_NF					Varchar(MAX),
		MunicipioPrestacaoServico		Varchar(10),	
		Cnpj							Varchar(25),
		InscricaoMunicipal				Varchar(25),	
		Num_CPF_CNPJ					Varchar(25),
		--NUM_RG_IE						Varchar(25),
		NUM_INSC_MUNIC					Varchar(25),	
		Nome_Raz_Soc					Varchar(60),
		Rua								Varchar(100),	
		Numero							Varchar(25),
		Compl_End						Varchar(25),	
		Bairro							Varchar(50),
		Cidade							Varchar(50),
		CodigoMunicipioE				Varchar(10),
		CodigoMunicipioEnd				Varchar(10),	
		UF								Varchar(10),
		Estado							Varchar(50),
		CEP								Varchar(25),
		Telefone						Varchar(25),	
		Compl_Fone						Varchar(50),
		Ref_Acesso						varchar(1),
		ValorCargaTributaria			decimal(10,2),
		Pais							varchar(100)		
	)

BEGIN	
	insert into @Nota
		select distinct								
			right('000000000000' + BNF.Nota_Fiscal,12) [Numero], 
			''				[Serie], 
			'RPS'				[Tipo], 					
			convert(varchar(10), BNF.Emissao,120) [DataEmissao],
			'1' [NaturezaOperacao], 
			'T' [RegimeEspecialTributacao], --verificar com a andreia
			'2' [OptanteSimplesNacional], --MO
			'2' [IncentivadorCultural],--NO
			
			(case when BNF.cd_status = '2' then 'C' else 'N' end)	[Status],
				
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00')			[ValorServicos],
			
			--só tem se for replace(BNF.cd_servico,'.','') = 06637  - PIS/PASEP -  0.65% ? SIM TEM
			(case when BNF.cd_servico = '6637' then
				isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00')
			else '0.00' end) [ValorPis],

			--só tem se for replace(BNF.cd_servico,'.','') = 06637 - COFINS - 3.00% ?SIM TEM
			(case when BNF.cd_servico = '6637' then
				isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
			else '0.00' end) [ValorCofins],
			
			'0.00' [ValorInss], 
			
			--só tem se for replace(BNF.cd_servico,'.','') = 06637 ou  06298 código lei 10.05 ou 
			--06335 código lei 10.06
			--IR - 1.50% ? SIM TEM
			(case when 
				((BNF.cd_servico = '6637') 	OR 
				(BNF.cd_servico = '6298' and BNF.Item_lei = '10.05')  OR 
				(BNF.cd_servico = '6335' and BNF.Item_lei = '10.06' and BNF.Irrf_TX= 'S'))
			then 
				isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
			else '0.00' end) [ValorIr], 
			
			--só tem se for replace(BNF.cd_servico,'.','') = 06637 - CSSL - 1.00%
			(case when BNF.cd_servico = '6637' then
				isnull(convert(varchar,convert(decimal(10,2),.01* BNF.Valor_Total)),'0.00')
			else '0.00' end) [ValorCsll],
									
			'2'		[IssRetido],
			'0.00'	[ValorIssRetido],			
			'0.00'	[ValorIss],
			
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],				
			'0.05' [Aliquota],
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorLiquidoNfse],			
					
			replace(BNF.Item_lei,'.','')		[ItemListaServico], 
			replace(BNF.CNAE,'.','')			[CodigoCnae], 
			replace(BNF.cd_servico,'.','')		cd_servico,	--	[CodigoTributacaoMunicipio],		
			'?'									[CodigoMunicipio],
			
			--isnull([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(Observ_NF))),'') Observ_NF,--		[Discriminacao],
			
			
			(case when TM.num_cpf_cnpj = '' OR TM.num_cpf_cnpj IS NULL then
					isnull([dbo].[FRemoveAcentuacao](rtrim(ltrim([dbo].[fBusca_spRPSSP](BNF.Nota_Fiscal,BNF.Ref_Acesso)))),'') +
					' | Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% ' + '0.00' +
					' e Confins 7,6% R$ ' + '0.00'
				else
					isnull([dbo].[FRemoveAcentuacao](rtrim(ltrim([dbo].[fBusca_spRPSSP](BNF.Nota_Fiscal,BNF.Ref_Acesso)))),'')+
					' | Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% ' + 
					isnull(convert(varchar,convert(decimal(10,2),.0165*BNF.Valor_Total)),'0.00') +
					' e Confins 7,6% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.076* BNF.Valor_Total)),'0.00')					
				end)Observ_NF, --[Discriminacao],
			
			''					[MunicipioPrestacaoServico],
			'03706460000128'					[Cnpj],
			'28921712'			[InscricaoMunicipal],--InscricaoPrestador
			
			isnull(TM.Num_CPF_CNPJ,'')Num_CPF_CNPJ, --TM.num_cpf_cnpj [CpfCnpj],
			--isnull(TM.Num_RG_IE,'')NUM_RG_IE ,					
			--isnull(TM.Num_Insc_Munic,'')NUM_INSC_MUNIC,--[CpfInscricaoMunicipal],
			(case when LEN(isnull(TM.Num_Insc_Munic,'')) > 3 then TM.Num_Insc_Munic
			else ''  end)	NUM_INSC_MUNIC,
			TM.nome_raz_soc [RazaoSocial], 
			isnull(ENDE.Rua,'') Rua,
			isnull(ENDE.Numero,'') Numero, --[Numero],
			isnull(ENDE.Compl_End,'') Compl_End,	--[Complemento],
			isnull(ENDE.Bairro,'') Bairro, --	[Bairro],
			isnull(ENDE.Cidade,'') Cidade, --	[Cidade],
			--''	 [CodigoMunicipio],
			--'' [CodigoMunicipioEnd],
			ENDE.Cod_IBGE [CodigoMunicipio],
			--CMN.STR_CODIGOMUN_IBGE [CodigoMunicipioEnd],
			I.UF + I.Cod_IBGE [CodigoMunicipioEnd],
			
			
			isnull(ENDE.UF,'') UF, --		[Uf], 
			''		[Estado],
			right('00000000' + replace(replace(isnull(ENDE.CEP,'00000000'),'.',''),'-',''),8) CEP,--	[Cep],
						
			'' [Telefone],

			isnull(COM.Compl_Fone,'') Compl_Fone, --[Email],
			--'andreia.tiesi@bdpint.com' Compl_Fone,
			BNF.Ref_Acesso,		
				
			'0.00' ValorCargaTributaria,
			isnull(ENDE.PAIS,'')	Pais
			
	from 
		base_nota_fiscal BNF with(nolock)
		left outer join Pessoa TM with(nolock) on BNF.cd_pes = TM.cd_pes
		left outer join endereco ENDE with(nolock) on BNF.cd_pes = ENDE.cd_pes and Cd_tp_end = 'COM'
		left outer join comunicacao COM with(nolock) on BNF.cd_pes = COM.cd_pes and COM.cd_tp_com = 'NF1'
		left join IBGE_Municipios_BR I with(nolock) on I.Nome_Município = ENDE.cidade and I.UF_Descr_Red = ENDE.UF
		where 
			ref_acesso = 'A' 
			and BNF.Nota_Fiscal = @NF
			and rps_data is null 
			and emissao > '2010-01-01' 
			and cd_Status <> 2
			--and BNF.Nota_Fiscal in ('85508')
		order by right('000000000000' + BNF.Nota_Fiscal,12)
    
 END
 
update 
	T  
set 
	[ValorLiquidoNfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis],
	ValorCargaTributaria = [ValorCsll] + [ValorIr] + [ValorCofins]+ [ValorPis]
from 
	@Nota as T

BEGIN	
	 if not exists(select B.Numero from Base_Envio_LoteRps B with(nolock)
		join @Nota N on right('000000000000'+N.Numero,12) = right('000000000000'+B.Numero,12) and N.Ref_Acesso = B.Ref_Acesso)
		insert into Base_Envio_LoteRps
			select * from @Nota			
END

select *, 
	[InscricaoMunicipal] +
	left([Serie] + '     ',5) +
	[Nota_Fiscal] +
	REPLACE([Emissao],'-','') +
	[RegimeEspecialTributacao] +
	cd_status +
	(case when [IssRetido] <> '0' then 'N' else 'C' end)  + 
	right('000000000000000' + replace(CONVERT(varchar(25),Valor_total),'.',''),15) +
	right('000000000000000' + replace(CONVERT(varchar(25),[ValorInss]),'.',''),15) +
	right('00000' + replace(CONVERT(varchar(25),[cd_servico]),'.',''),5) +
	(case when left([Pais],2) = 'BR' then '2' else '3' end) +
	(case when left([Pais],2) = 'BR' then  
		right('00000000000000' + replace(CONVERT(varchar(25),Num_CPF_CNPJ),'.',''),14)
	else 
		'00000000000000' end)
	[Assinatura]
 from @Nota   

/*Explicação dos impostos
1- Somente para o serviço 06637 - serviços de despacho terá as retenções de 
PIS/PASEP -  0.65% COFINS - 3.00% IR - 1.50% CSSL - 1.00%

PIS/PASEP -  0.65% ? SIM TEM
COFINS - 3.00% ?SIM TEM
INSS- 0.00 ? NÃO TEM
IR - 1.50% ? SIM TEM
CSSL - 1.00% ? SIM TEM

2- Para o serviço 06298 código lei 10.05 CNAE 52.50-08-03 - agenciamento aéreo, temos redenções somente IR - 1.50%

PIS/PASEP -  0.65% ? NÃO TEM
COFINS - 3.00% ? NÃO TEM
INSS- 0.00 ? NÃO TEM
IR - 1.50% ? SIM TEM
CSSL - 1.00% ? NÃO TEM

3- Para p serviço 06335 código lei 10.06 CNAE 52.50-08-00 - agenciamento marítimo, 
temos redenções somente IR - 1.50% somente quando for comissão, quando for puro agenciamento não teremos retenções.

PIS/PASEP -  0.65% ? NÃO TEM
COFINS - 3.00% ? NÃO TEM
INSS- 0.00 ? NÃO TEM
IR - 1.50% ? SIM TEM *SOMENTE QUANDO 
CSSL - 1.00% ? NÃO TEM
*/
   
GO
