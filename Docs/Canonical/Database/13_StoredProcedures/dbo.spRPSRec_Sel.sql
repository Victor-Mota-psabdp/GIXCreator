SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from pessoa where nome_raz_soc = 'BOLTE LOJISTIK HIZ LTD. STI'

--select dateadd(mm,-1,dateadd(dd,-day(getdate())+1,getdate()))
--cadu - 06/01/2015 - incluido pra pegar como data inicial o mes passado

CREATE procedure [dbo].[spRPSRec_Sel]

as
Declare @DataInicial as Datetime
Declare @DataFinal as Datetime
--Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-2)as varchar(2))+'-01'
Set @DataInicial= dateadd(mm,-1,dateadd(dd,-day(getdate())+1,getdate()))
Set @DataFinal= getdate()


select 
	cd_status,
	RPS_Data,
	SitId, 
	BNF.Nota_Fiscal,
	BNF.Emissao, 
	BNF.Valor_Total,
	BNF.CdsId,
	(case when ENDE.cd_pais = 'BR' then
		'J'
	else
		'E'
	end) cd_tp_pes,
--	TM.cd_tp_pes,
	isnull(TM.Num_CPF_CNPJ,'')Num_CPF_CNPJ,
	isnull(TM.Num_RG_IE,'')NUM_RG_IE ,
	isnull(TM.Num_Insc_Munic,'')NUM_INSC_MUNIC,
	TM.Nome_Raz_Soc,
	isnull(ENDE.Rua,'') Rua,
	isnull(ENDE.Numero,'') Numero, 
	isnull(ENDE.Compl_End,'') Compl_End,
	isnull(ENDE.Bairro,'') Bairro, 
	isnull(ENDE.Cidade,'') Cidade,
	isnull(ENDE.UF,'') UF,
	isnull(ENDE.CEP,'') CEP, 
	isnull(COM.Compl_Fone,'') Compl_Fone,
	replace(replace(isnull(BNF.Observ_NF,''),char(10),'|'),char(13),'|') Observ_NF,
	BNF.Aliq_ISS
from 
	base_nota_fiscal BNF 
left outer join Pessoa TM on BNF.cd_pes = TM.cd_pes  
left outer join endereco ENDE on BNF.cd_pes = ENDE.cd_pes and Cd_tp_end = 'COM'  
left outer join comunicacao COM on BNF.cd_pes = COM.cd_pes and COM.cd_tp_com = 'TC1'  
where 
	(Ref_Acesso = 'C'  and RPS_Data is null and Emissao between @DataInicial and @DataFinal) 
	OR (Emissao between @DataInicial and @DataFinal and  Ref_Acesso = 'C' and CdsId is not null AND Cd_Status = 2 and SitId <> 'C')


	--(Ref_Acesso = 'C'  and RPS_Data is null and Emissao >= '2009-08-01') 
	--OR (Emissao >= '2009-08-01' and  Ref_Acesso = 'C' and CdsId is not null AND Cd_Status = 2 and SitId <> 'C') 
order by emissao desc



GO
