SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spGeraTxExpediente_Ins

AS
--Taxa Automatica para todos os processos de desembaraço - 15 - Solicitado por Roberto Croce em 15/03/2011

	INSERT INTO CTA_CTE_HOU_EXP_MAR
	--TAXA DE DESEMBARACO SERVICOS PRESTADOS = 380 REAIS

	Select 
		HOU.Num_Proc_HEM,'EXX','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='EXX' and dc_hem='C'
	where
		dt_conclusao >'03-01-2011'
		and cta.num_proc_hem is null


	INSERT INTO CTA_CTE_HOU_IMP_MAR
	--TAXA DE DESEMBARACO SERVICOS PRESTADOS = 380 REAIS

	Select 
		HOU.Num_Proc_HIM,'EXX','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIM,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HiM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=Cd_Consig_HiM
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='EXX' and dc_him='C'
	where
		dt_conclusao >'03-01-2011'
		and cta.num_proc_him is null


GO
