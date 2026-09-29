SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view vwteste
as
select 
	hou.num_proc_hem,mas.num_proc_mem,org.nome_local Origem,dst.nome_local Destino,dst.bitri,
	vlr_frete_mem,Vlr_Frete_Tot_hem Valor ,Peso_Bruto_MEM Qt
from 
	master_exp_mar MAS
	Join container_mas_exp_mar CM on CM.num_proc_mem=mas.num_proC_mem
	Join Localidade Org on Org.cD_local=MAS.cd_org_mem
	Join Localidade DST on DST.cd_local=mas.cd_dst_mem
	Join house_exp_mar Hou on hou.num_proc_mem=mas.num_proc_mem
	--Join Tipo_container TC on TC.cd_tp_cont=cm.cd_tp_cont
Where cm.cd_tp_cont  in ('LCL','LCM')
and convert(datetime,dt_saida_mem,105)>='01-01-2006'
group by 
num_proc_hem,mas.num_proc_mem,org.nome_local,dst.nome_local,dst.bitri,vlr_frete_mem,Vlr_Frete_Tot_hem
,Peso_Bruto_MEM


GO
