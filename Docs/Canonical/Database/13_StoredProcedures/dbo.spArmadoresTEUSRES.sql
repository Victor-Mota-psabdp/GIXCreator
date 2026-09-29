SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE spArmadoresTEUSRES

		@DataInicial	VarChar(10),
		@DataFinal	VarChar(10)

as


Select 
	'EM' Modal,Nome_tp_cont,count(cnh.item_cont_em) QTY,
	org.Nome_Local Origem,dst.nome_local Destino,sh.Apelido Shipper, 
	Cs.Apelido Consignee,Nome_tp_Prod,shm.apelido Shipper_Master,'FCL' Tipo
From 
	House_exp_mar HOU
	Join Pessoa SH on SH.cd_pes=cd_export_hem
	Join Pessoa CS on cs.cd_pes=cd_consig_hem
	Join Master_Exp_Mar MAS on MAS.num_proc_mem=HOU.num_proc_mem
	Join Container_Mas_exp_mar CN on CN.num_proc_mem=mas.num_proC_mem
	join Localidade Org on Org.cd_local=cd_org_hem
	Join Localidade DST on DST.cd_local=cd_dst_hem
	Join Armador AM on AM.cd_armador=MAS.cd_armador
	Join Pessoa ShM on Shm.cd_pes=cd_consig_mem
	Join container_hou_exp_mar CNH on CN.num_proc_mem=CNH.num_proc_mem and CN.Item_Cont_EM=CNH.Item_Cont_EM
	join Tipo_Container TC on TC.cd_tp_cont=CN.cd_tp_cont
	Left join Tipo_Produto TP on hou.cd_tp_prod=TP.cd_tp_prod
WHERE
	CONVERT(DATETIME,DT_SAIDA_MEM,105) Between @DataInicial and @DataFinal and TC.CD_TP_CONT NOT IN ('LCL','LCM')
Group by 
	Nome_tp_cont,org.Nome_Local,dst.nome_local,sh.Apelido, Cs.Apelido,Nome_tp_Prod,shm.apelido

union

Select 
	'IM',Nome_tp_cont,count(cnh.item_cont_im) QTY,
	org.Nome_Local Origem,dst.nome_local Origem,sh.Apelido Shipper, 
	Cs.Apelido Consignee,Nome_tp_Prod,shm.apelido Shipper_Master,'FCL'
From 
	House_imp_mar HOU
	Join Pessoa SH on SH.cd_pes=cd_EXport_him
	Join Pessoa CS on cs.cd_pes=cd_consig_him
	Join Master_imp_Mar MAS on MAS.num_proc_MIM=HOU.num_proc_MIM
	Join Container_Mas_imp_mar CN on CN.num_proc_MIM=mas.num_proC_MIM
	join Localidade Org on Org.cd_local=cd_org_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Armador AM on AM.cd_armador=MAS.cd_armador
	Join Pessoa ShM on Shm.cd_pes=cd_EXPORT_MIM
	Join container_hou_imp_mar CNH on CN.num_proc_MIM=CNH.num_proc_MIM and CN.Item_Cont_iM=CNH.Item_Cont_iM
	join Tipo_Container TC on TC.cd_tp_cont=CN.cd_tp_cont
	Left join Tipo_Produto TP on hou.cd_tp_prod=TP.cd_tp_prod
WHERE
	CONVERT(DATETIME,DT_ATRAC_MIM,105) Between @DataInicial and @DataFinal and TC.CD_TP_CONT NOT IN ('LCL','LCM')
Group by 
	Nome_tp_cont,org.Nome_Local,dst.nome_local,sh.Apelido, Cs.Apelido,Nome_tp_Prod,shm.apelido

UNION

Select 
	'EM',Nome_tp_cont,sum(VOL_TOT_MEM) QTY,
	org.Nome_Local Origem,dst.nome_local Destino,sh.Apelido Shipper, 
	Cs.Apelido Consignee,Nome_tp_Prod,shm.apelido Shipper_Master,'LCL' Tipo
From 
	House_exp_mar HOU
	Join Pessoa SH on SH.cd_pes=cd_export_hem
	Join Pessoa CS on cs.cd_pes=cd_consig_hem
	Join Master_Exp_Mar MAS on MAS.num_proc_mem=HOU.num_proc_mem
	Join Container_Mas_exp_mar CN on CN.num_proc_mem=mas.num_proC_mem
	join Localidade Org on Org.cd_local=cd_org_hem
	Join Localidade DST on DST.cd_local=cd_dst_hem
	Join Armador AM on AM.cd_armador=MAS.cd_armador
	Join Pessoa ShM on Shm.cd_pes=cd_consig_mem
	Join container_hou_exp_mar CNH on CN.num_proc_mem=CNH.num_proc_mem and CN.Item_Cont_EM=CNH.Item_Cont_EM
	join Tipo_Container TC on TC.cd_tp_cont=CN.cd_tp_cont
	Left join Tipo_Produto TP on hou.cd_tp_prod=TP.cd_tp_prod
WHERE
	CONVERT(DATETIME,DT_SAIDA_MEM,105) Between @DataInicial and @DataFinal and TC.CD_TP_CONT IN ('LCL','LCM')
Group by 
	Nome_tp_cont,org.Nome_Local,dst.nome_local,sh.Apelido, Cs.Apelido,Nome_tp_Prod,shm.apelido

union

Select 
	'IM',Nome_tp_cont,sum(VOL_TOT_MIM) QTY,
	org.Nome_Local Origem,dst.nome_local Origem,sh.Apelido Shipper, 
	Cs.Apelido Consignee,Nome_tp_Prod,shm.apelido Shipper_Master,'LCL'
From 
	House_imp_mar HOU
	Join Pessoa SH on SH.cd_pes=cd_EXport_him
	Join Pessoa CS on cs.cd_pes=cd_consig_him
	Join Master_imp_Mar MAS on MAS.num_proc_MIM=HOU.num_proc_MIM
	Join Container_Mas_imp_mar CN on CN.num_proc_MIM=mas.num_proC_MIM
	join Localidade Org on Org.cd_local=cd_org_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Armador AM on AM.cd_armador=MAS.cd_armador
	Join Pessoa ShM on Shm.cd_pes=cd_EXPORT_MIM
	Join container_hou_imp_mar CNH on CN.num_proc_MIM=CNH.num_proc_MIM and CN.Item_Cont_iM=CNH.Item_Cont_iM
	join Tipo_Container TC on TC.cd_tp_cont=CN.cd_tp_cont
	Left join Tipo_Produto TP on hou.cd_tp_prod=TP.cd_tp_prod
WHERE
	CONVERT(DATETIME,DT_ATRAC_MIM,105) Between @DataInicial and @DataFinal and TC.CD_TP_CONT IN ('LCL','LCM')
Group by 
	Nome_tp_cont,org.Nome_Local,dst.nome_local,sh.Apelido, Cs.Apelido,Nome_tp_Prod,shm.apelido





GO
