SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu - alterei o codigo do para qdo for Status da Nota Fiscal = 2, alterar o SitId para C e incluir a data
--do cancelamento da prefeitura
--\\192.168.11.204\ti$\Desenv\IT\Integracoes\TXTtoSQL_3.0

--incluid na stord para nao buscar nf com cd_status <> 2 no primeiro where
CREATE procedure [dbo].[spATL_RPSRec_Sel]

as

SET NOCOUNT ON

Declare @Nota Table
	(
		Nota_Fiscal					Varchar(10),	
		Serie						Varchar(1),	
		Tipo						Varchar(1),	
		Emissao						Varchar(25),						
		NaturezaOperacao			Varchar(2),	
		RegimeEspecialTributacao	Varchar(2),	
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
		
		cd_tp_pes						Varchar(50),
		Aliq_ISS							decimal(10,2)
		
	)
	
Declare @DataInicial as Datetime
Declare @DataFinal as Datetime
--Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-2)as varchar(2))+'-01'
Set @DataInicial= dateadd(mm,-1,dateadd(dd,-day(getdate())+1,getdate()))
Set @DataFinal= getdate()

BEGIN	
	insert into @Nota
		select distinct								
			BNF.Nota_Fiscal [Numero], 
			'1' [Serie], 
			'1' [Tipo], 
					
			convert(varchar(10), BNF.Emissao,120) [DataEmissao],
			'01' [NaturezaOperacao], --tipo de Tributação de serviços, sempre 01 - Tributaão no Municipio
			'00' [RegimeEspecialTributacao], --NO 
			'0' [OptanteSimplesNacional], --MO
			'0' [IncentivadorCultural],--NO
			
			(case when BNF.cd_status = 0 then '1' 
			else
				BNF.cd_status END) [Status],
			--BNF.cd_status	[Status],
				
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00')			[ValorServicos],
			
			--(case when  ENDE.cd_pais = 'BR'  then
			--	isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00')
			--else '0.00' end) [ValorPis],
			'0.00'  [ValorPis],

			--(case when  ENDE.cd_pais = 'BR' then
			--	isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
			--else '0.00' end) [ValorCofins],
			'0.00' [ValorCofins],
			
			'0.00' [ValorInss], 

			--(case when ENDE.cd_pais = 'BR' and BNF.Valor_Total > '900'	then 
			--	isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
			--else '0.00' end) [ValorIr], 
			'0.00'  [ValorIr],
						
			--(case when  ENDE.cd_pais = 'BR' then
			--	isnull(convert(varchar,convert(decimal(10,2),.01* BNF.Valor_Total)),'0.00')
			--else '0.00' end) [ValorCsll],
			'0.00' [ValorCsll],
								
						
			(case when  upper(ENDE.cidade) = 'RECIFE'	then
				'1'else '0' end) [IssRetido],
			
			'0.00'	[ValorIssRetido],			
			'0.00'	[ValorIss],
			
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],				
			'0.05' [Aliquota],
			isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorLiquidoNfse],			
					
			replace(BNF.Item_lei,'.','')		[ItemListaServico], 
			replace(BNF.cd_servico,'.','')			[CodigoCnae], 
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
			
			(case when ENDE.cd_pais = 'BR' then
				'J'
			else
				'E'
			end) cd_tp_pes,
			BNF.Aliq_ISS
	from base_nota_fiscal BNF 
		left outer join Pessoa TM on BNF.cd_pes = TM.cd_pes  
		left outer join endereco ENDE on BNF.cd_pes = ENDE.cd_pes and Cd_tp_end = 'COM'  
		left outer join comunicacao COM on BNF.cd_pes = COM.cd_pes and COM.cd_tp_com = 'NF1'  
	where 
		(Ref_Acesso = 'C'  and RPS_Data is null 
			and Emissao between @DataInicial and @DataFinal 
			and BNF.Nota_Fiscal > ('9120')
			AND Cd_Status <> 2) 
		OR 
		(Emissao between @DataInicial and @DataFinal 
			and Ref_Acesso = 'C' and CdsId is not null
			AND Cd_Status = 2 and SitId <> 'C' 
			and BNF.Nota_Fiscal > ('9120'))
	order by nota_fiscal
	--ref_acesso = 'C' and rps_data is null and emissao > '2010-01-01' and cd_Status <> 2	and BNF.Nota_Fiscal > ('9120')
	--order by nota_fiscal
    
 END
 
update 
	T  
set 
	[ValorLiquidoNfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis],
	[ValorCargaTributaria] = [ValorCsll] + [ValorIr] + [ValorCofins]+ [ValorPis]
from 
	@Nota as T

--BEGIN	
--	 if not exists(select * from Base_Envio_LoteRps B
--		join @Nota N on N.Numero = B.Numero and N.Ref_Acesso = B.Ref_Acesso)		
--		insert into Base_Envio_LoteRps
--			select * from @Nota			
--END

select * from @Nota   


   
GO
