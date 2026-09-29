SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure spLLPMapa_Rel

	as


select 
	Num_Proc_Him, ETA_LIM,ETD_LIM,ATD_LIM Data_Saida,ATA_LIM Data_Chegada,
	Planta_Org.Nome_Local Planta, Origem.Nome_Local Origem, Destino.Nome_Local Destino, Destino_Final.Nome_Local Destino_Final,
	MAWB_HIM Master,HAWB_HIM House,hou.num_proc_him Processo
from 
	house_imp_mar Hou

	Join Pessoa Buyer on Buyer.cd_pes=cd_import_him
	Join Pessoa Seller on Seller.cd_pes=cd_export_him
	Join LLP_Imp_Mar LLP on LLP.num_proc_lim=hou.num_proc_him
	Left Join Localidade Planta_Org on Planta_Org.cd_local=cd_planta_lim
	Left Join Localidade Origem on Origem.cd_local=cd_org_him
	Left Join Localidade Destino on Destino.cd_local=cd_dst_him
	Left Join Localidade Destino_Final on Destino_final.cd_local=cd_dstfinal_lim
	Left Join Tarefas_processos TP on TP.num_proc=hou.num_proc_him and dt_conclusao is null
	Left Join Tipo_Tarefas TF on TF.ID_Task=TP.ID_Task
Where
	tp.num_proc is not null and ativo='S'

Group by
	Num_Proc_Him, ETA_LIM,ETD_LIM,ATD_LIM ,ATA_LIM,
	Planta_Org.Nome_Local, Origem.Nome_Local, Destino.Nome_Local, Destino_Final.Nome_Local,
	MAWB_HIM,HAWB_HIM,hou.num_proc_him  







GO
