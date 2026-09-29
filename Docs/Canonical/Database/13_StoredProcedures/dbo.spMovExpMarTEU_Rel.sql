SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spMovExpMarTEU_Rel
		@DataInicial Varchar(10),
		@DataFinal   Varchar(10)

as

select 
	year(convert(datetime,dt_saida_mem,105)) Ano, Nome_Armador,org.nome_local Origem, 
	Dst.Nome_Local Destino,cm.cd_tp_cont,nome_regiao,  count(iteM_cont_em) Qty, Cd_CC_Ofc 
from 
	master_exp_mar MAS
	join container_mas_exp_mar CM on CM.num_proc_mem=mas.num_proc_mem
	Left Join Armador ARM on ARm.cd_armador=mas.cd_armador
	Join Localidade Org on Org.cd_local=cd_org_mem
	Join Localidade Dst on Dst.cd_local=cd_dst_mem
	join Regiao RG on RG.cd_regiao=dst.cd_regiao
	Left Join Tipo_container TT on TT.cd_tp_cont=CM.cd_tp_cont
Where 
	convert(datetime,dt_saida_mem,105) between @DataInicial and @DataFinal
	and cm.cd_tp_cont not in ('LCL','LCM') 
GROUP BY 
	year(convert(datetime,dt_saida_mem,105)), Nome_Armador,org.nome_local , Dst.Nome_Local ,cm.cd_tp_cont,nome_regiao, Cd_CC_Ofc



GO
