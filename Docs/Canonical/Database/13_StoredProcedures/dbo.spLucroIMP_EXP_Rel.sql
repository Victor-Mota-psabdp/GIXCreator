SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	Procedure [dbo].[spLucroIMP_EXP_Rel] 

AS

select 
	SHP.Apelido Shipper, 
	CSG.Apelido Consignee, 
	ORG.Pais_Local Origem, 
	DST.Pais_Local Destino, 
	CSM.Apelido Agente,
	'Exp. MAR' Modal, 
	Cd_TP_Cont Tipo_Cont, 
	Count(Cd_Tp_cont) QTY,
	Sum(Peso_Liquido_HEM) Peso_Liquido, 
	Sum(Vol_Tot_HEM) M3,
	dbo.spResultado(HOU.Num_proc_HEM) + dbo.spResultado_Mas(HOU.Num_proc_HEM) Resultado, 
	month(convert(datetime,MAS.Dt_Saida_MEM, 105)) Mês
from 
	house_exp_mar HOU
	Left Outer Join Master_exp_mar			MAS	on HOU.Num_Proc_MEM = MAS.Num_Proc_MEM
	Left Outer Join Pessoa					SHP on HOU.Cd_Export_HEM = SHP.Cd_Pes
	Left Outer Join Pessoa					CSG on HOU.Cd_Consig_HEM = CSG.Cd_Pes 
	Left Outer Join Localidade				ORG	on MAS.Cd_Org_MEM = ORG.Cd_Local
	Left Outer Join Localidade				DST	on MAS.Cd_Dst_MEM = DST.Cd_Local	
	Left Outer Join Pessoa					CSM on MAS.Cd_Consig_MEM = CSM.Cd_Pes
	Left Outer Join Container_HOu_Exp_mar	CTH	on HOU.Num_proc_Hem = CTH.Num_proC_Hem
	Left Outer Join Container_Mas_exp_Mar	CTM on CTH.Num_Proc_MEM = CTM.Num_Proc_MEM 	and CTH.item_cont_em=CTM.Item_cont_em
where 
	HOU.Num_Proc_Hem not like ('EMJOB%') and HOU.Num_Proc_Hem not like ('EMBUE%') and HOU.Num_Proc_Hem not like ('EMBEL%') and HOU.num_proc_mem <> 'JOB' and convert(datetime,MAS.Dt_Saida_MEM, 105) Between '04-01-2007' and '03-31-2008'
group by 
	SHP.Apelido, CSG.Apelido, ORG.Pais_Local, DST.Pais_Local, DST.Pais_Local, CSM.Apelido, Cd_TP_Cont, dbo.spResultado(HOU.Num_proc_HEM) + dbo.spResultado_Mas(HOU.Num_proc_HEM), month(convert(datetime,MAS.Dt_Saida_MEM, 105)) 

Union

select 
	SHP.Apelido Shipper, 
	CSG.Apelido Consignee, 
	ORG.Pais_Local Origem, 
	DST.Pais_Local Destino, 
	CSM.Apelido Agente,
	'IMP. MAR' Modal, 
	Cd_TP_Cont Tipo_Cont, 
	Count(Cd_Tp_cont) QTY,
	Sum(Peso_Bruto_HIM) Peso_Liquido, 
	Sum(Vol_Tot_HIM) M3,
	dbo.spResultado(HOU.Num_proc_HIM) + dbo.spResultado_Mas(HOU.Num_proc_HIM) Resultado, 
	month(convert(datetime,MAS.Dt_Atrac_MIM, 105)) Mês
from 
	house_IMP_mar HOU
	Left Outer Join Master_IMP_mar			MAS	on HOU.Num_Proc_MIM = MAS.Num_Proc_MIM
	Left Outer Join Pessoa					SHP on HOU.Cd_Import_HIM = SHP.Cd_Pes
	Left Outer Join Pessoa					CSG on HOU.Cd_Consig_HIM = CSG.Cd_Pes 
	Left Outer Join Localidade				ORG	on MAS.Cd_Org_MIM = ORG.Cd_Local
	Left Outer Join Localidade				DST	on MAS.Cd_Dst_MIM = DST.Cd_Local	
	Left Outer Join Pessoa					CSM on MAS.Cd_Export_MIM = CSM.Cd_Pes
	Left Outer Join Container_HOu_IMP_mar	CTH	on HOU.Num_proc_HIM = CTH.Num_proC_HIM
	Left Outer Join Container_Mas_IMP_Mar	CTM on CTH.Num_Proc_MIM = CTM.Num_Proc_MIM 	and CTH.item_cont_im=CTM.Item_cont_im
where 
	HOU.Num_Proc_HIM not like ('IMJOB%') and  HOU.num_proc_MIM <> 'JOB' and convert(datetime,MAS.Dt_Atrac_MIM, 105) Between '04-01-2007' and '03-31-2008'
group by 
	SHP.Apelido, CSG.Apelido, ORG.Pais_Local, DST.Pais_Local, DST.Pais_Local, CSM.Apelido, Cd_TP_Cont, dbo.spResultado(HOU.Num_proc_HIM) + dbo.spResultado_Mas(HOU.Num_proc_HIM), month(convert(datetime,MAS.Dt_Atrac_MIM, 105)) 
Order By 
	Consignee






GO
