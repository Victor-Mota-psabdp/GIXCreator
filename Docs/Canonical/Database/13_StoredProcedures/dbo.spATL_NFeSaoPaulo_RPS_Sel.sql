SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--24/05/2017 - Cadu - Rotina alterada para ser feita pelo web service
--[spATL_NFe_Header_Sel] '2017-05-13','2017-06-01','A'

--cadu 166/2017 - alterada para a rotina automatica
--[spATL_NFe_Header_Sel] '2017-06-06','2017-06-17','A'
CREATE procedure [dbo].[spATL_NFeSaoPaulo_RPS_Sel]

as

SET NOCOUNT ON

Declare @Nota Table
	(
		Nota_Fiscal					Varchar(10),	
		Serie						Varchar(1),	
		Tipo						Varchar(1),	
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
		NUM_RG_IE						Varchar(25),
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
		Pais							varchar(100),
		
		cd_tp_pes						Varchar(50)
		
	)

BEGIN	
	insert into @Nota
		select distinct								
			BNF.Nota_Fiscal [Numero], 
			'1' [Serie], 
			'1' [Tipo], 
					
			convert(varchar(10), BNF.Emissao,120) [DataEmissao],
			'1' [NaturezaOperacao], 
			'0' [RegimeEspecialTributacao], --NO 
			'2' [OptanteSimplesNacional], --MO
			'2' [IncentivadorCultural],--NO
			
			BNF.cd_status	[Status],
				
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
					isnull([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(Observ_NF))),'') +
					' | Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% ' + '0.00' +
					' e Confins 7,6% R$ ' + '0.00'
				else
					isnull([dbo].[FRemoveCaracteresEspeciais](rtrim(ltrim(Observ_NF))),'')+
					' | Conforme Lei 12.741/2012: ISS 5% R$ ' +  
					isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') + 
					',  PIS 1,65% ' + 
					isnull(convert(varchar,convert(decimal(10,2),.0165*BNF.Valor_Total)),'0.00') +
					' e Confins 7,6% R$ ' + 
					isnull(convert(varchar,convert(decimal(10,2),.076* BNF.Valor_Total)),'0.00')					
				end)Observ_NF, --[Discriminacao],
			
			''					[MunicipioPrestacaoServico],
			'?'					[Cnpj],
			'?'					[InscricaoMunicipal],
			
			isnull(TM.Num_CPF_CNPJ,'')Num_CPF_CNPJ, --TM.num_cpf_cnpj [CpfCnpj],
			isnull(TM.Num_RG_IE,'')NUM_RG_IE ,					
			isnull(TM.Num_Insc_Munic,'')NUM_INSC_MUNIC,--[CpfInscricaoMunicipal],
			TM.nome_raz_soc [RazaoSocial], 
			isnull(ENDE.Rua,'') Rua,
			isnull(ENDE.Numero,'') Numero, --[Numero],
			isnull(ENDE.Compl_End,'') Compl_End,	--[Complemento],
			isnull(ENDE.Bairro,'') Bairro, --	[Bairro],
			isnull(ENDE.Cidade,'') Cidade, --	[Cidade],
			''	 [CodigoMunicipio],
			'' [CodigoMunicipioEnd],
			isnull(ENDE.UF,'') UF, --		[Uf], 
			''		[Estado],
			right('00000000' + replace(replace(isnull(ENDE.CEP,'00000000'),'.',''),'-',''),8) CEP,--	[Cep],
						
			'' [Telefone],

			isnull(COM.Compl_Fone,'') Compl_Fone, --[Email],
			BNF.Ref_Acesso,		
				
			'0.00' ValorCargaTributaria,
			isnull(ENDE.PAIS,'')	Pais,
			
			TM.cd_tp_pes
			
	from 
		base_nota_fiscal BNF
		left outer join Pessoa TM on BNF.cd_pes = TM.cd_pes
		left outer join endereco ENDE on BNF.cd_pes = ENDE.cd_pes and Cd_tp_end = 'COM'
		left outer join comunicacao COM on BNF.cd_pes = COM.cd_pes and COM.cd_tp_com = 'NF1'
		where 
			ref_acesso = 'A' 
			and rps_data is null 
			and emissao > '2010-01-01'
			and emissao < '2017-06-15'
			and cd_Status <> 2
			--and convert(int,BNF.Nota_Fiscal) < 110067
		order by nota_fiscal
    
 END
 
update 
	T  
set 
	[ValorLiquidoNfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis],
	ValorCargaTributaria = [ValorCsll] + [ValorIr] + [ValorCofins]+ [ValorPis]
from 
	@Nota as T

--BEGIN	
--	 if not exists(select * from Base_Envio_LoteRps B
--		join @Nota N on N.Numero = B.Numero and N.Ref_Acesso = B.Ref_Acesso)		
--		insert into Base_Envio_LoteRps
--			select * from @Nota			
--END

select * from @Nota   

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
