SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure spTerminaisRedest_Rel
		@DataInicial	Char(10),
		@datafinal	Char(10)

as


SELECT HAWB_HIM,count(ch.item_cont_im), pp.apelido, cs.apelido Consignee, convert(datetime,dt_atrac_mim,105) Atracacao, converT(datetime,dtredest_mim,105) Redestinacao, obs_mim,  Nome_Terminal FROM HOUSE_IMP_MAR HOU
Join Pessoa PP on PP.cd_pes=cd_export_him
Join Pessoa CS on CS.cd_pes=cd_consig_him
Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
Join Terminal TM on MAS.cd_terminal=TM.cd_terminal
Join Container_mas_imp_mar CM on CM.num_proc_mim=mas.num_proc_mim
Join Container_hou_imp_mar CH on CH.num_proc_him=hou.num_proc_him and cm.num_proc_mim=ch.num_proc_mim and cm.item_cont_im=CH.item_cont_im
where convert(datetime,dt_atrac_mim,105) between @datainicial and @datafinal
Group by hawb_him, pp.apelido, cs.apelido, dt_atrac_mim,nome_terminal,obs_mim,dtredest_mim





GO
