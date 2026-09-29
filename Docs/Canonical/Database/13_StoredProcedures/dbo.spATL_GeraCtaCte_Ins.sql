SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_GeraCtaCte_Ins]

as

--CRIADO EM 10-05-2008
--INSERCAO DE CONTA CORRENTE EXPORTACAO MARITIMA GRUPO DOW
--REGRA - QUANDO O DESEMBARACO ESTA CONCLUIDO E NAO EXISTE O CTA_CTE
--Anderson

BEGIN --EXPORTACAO MARITIMA

	INSERT INTO CTA_CTE_HOU_EXP_MAR
	--TAXA DE DESEMBARACO SERVICOS PRESTADOS = 380 REAIS

	Select 
		HOU.Num_Proc_HEM,'SRV','C','ATL',convert(varchar,getdate(),105),'REL',431,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='SRV' and dc_hem='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_hem is null 
		and dt_conclusao is not null and dt_conclusao > '05-31-2009'

	UNION 
	
	Select 
		HOU.Num_Proc_HEM,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='BRO' and dc_hem='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hem is null 
		and dt_conclusao is not null and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15
	Select 
		HOU.Num_Proc_HEM,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='TTC' and dc_hem='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hem is null 
		and dt_conclusao is not null and dt_conclusao <='05-31-2009'

	UNION

	--XEROX BULK = 15
	Select 
		HOU.Num_Proc_HEM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='AUT' and dc_hem='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hem is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008' AND CD_TP_CARGA=3
		and dt_conclusao <='05-31-2009'

	union

Select 
		HOU.Num_Proc_HEM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='AUT' and dc_hem='C'
	where
		cd_pes_grupo='362' and cta.num_proc_hem is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008' --AND CD_TP_CARGA=3
		and dt_conclusao <='05-31-2009'
UNION

	--XEROX FCL/LCL= 14
	Select 
		HOU.Num_Proc_HEM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',14,
		convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_mar LLP
	Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
	Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx='AUT' and dc_hem='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hem is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008' AND CD_TP_CARGA<>3
		and dt_conclusao <='05-31-2009'


    --Substituição "-" por "/"
	UPDATE
		CTA_CTE_HOU_EXP_MAR
	SET
		Dt_Ins_HEM=REPLACE(Dt_Ins_HEM,'-','/'),
		Dt_Prev_Pgto_HEM=REPLACE(Dt_Prev_Pgto_HEM,'-','/')
	WHERE
		Dt_Ins_HEM like '%-%' or Dt_Prev_Pgto_HEM like '%-%'
END
--EXPORTACAO OUTHERS
BEGIN

	insert into cta_cte_hou_exp_out

	Select 
		HOU.Num_Proc_HEO,'SRV','C','ATL',convert(varchar,getdate(),105),'REL',431,
		convert(varchar,getdate()+20,105),Cd_Export_HEO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_Out LLP
	Join House_Exp_out HOU on llp.num_proc_leo=hou.num_proc_heo
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEo
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heo
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leo and Id_Task=4
	Left Join Cta_cte_hou_exp_out CTA on num_proc_leo=CTA.num_proc_heo and Cd_tp_Tx='SRV' and dc_heo='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_heo is null 
		and dt_conclusao is not null
		and dt_conclusao >'05-31-2009'

	UNION

	Select 
		HOU.Num_Proc_HEO,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_Export_HEO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_Out LLP
	Join House_Exp_out HOU on llp.num_proc_leo=hou.num_proc_heo
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEo
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heo
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leo and Id_Task=4
	Left Join Cta_cte_hou_exp_out CTA on num_proc_leo=CTA.num_proc_heo and Cd_tp_Tx='BRO' and dc_heo='C'
	where
		cd_pes_grupo='1' and cta.num_proc_heo is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15

	Select 
		HOU.Num_Proc_HEO,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Export_HeO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_OUT LLP
	Join House_Exp_OUT HOU on llp.num_proc_leO=hou.num_proc_heO
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leO and Id_Task=4
	Left Join Cta_cte_hou_exp_OUT CTA on num_proc_leO=CTA.num_proc_heO and Cd_tp_Tx='TTC' and dc_heO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_heO is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

UNION

	--XEROX = 13

	Select 
		HOU.Num_Proc_HEO,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',13,
		convert(varchar,getdate()+20,105),Cd_Export_HeO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_OUT LLP
	Join House_Exp_OUT HOU on llp.num_proc_leO=hou.num_proc_heO
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leO and Id_Task=4
	Left Join Cta_cte_hou_exp_OUT CTA on num_proc_leO=CTA.num_proc_heO and Cd_tp_Tx='AUT' and dc_heO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_heO is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'

UNION

	Select 
		HOU.Num_Proc_HEO,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Export_HeO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_OUT LLP
	Join House_Exp_OUT HOU on llp.num_proc_leO=hou.num_proc_heO
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leO and Id_Task=4
	Left Join Cta_cte_hou_exp_OUT CTA on num_proc_leO=CTA.num_proc_heO and Cd_tp_Tx='AUT' and dc_heO='C'
	where
		cd_pes_grupo='362' and cta.num_proc_heO is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'


	--SUBSTITUIÇÃO "-" POR "/"
	UPDATE
		CTA_CTE_HOU_EXP_OUT
	SET
		Dt_Ins_HEO=REPLACE(Dt_Ins_HEO,'-','/'),
		Dt_Prev_Pgto_HEO=REPLACE(Dt_Prev_Pgto_HEO,'-','/')
	WHERE
		Dt_Ins_HEO like '%-%' or Dt_Prev_Pgto_HEO like '%-%'

END

BEGIN
--EXPORTACACAO AEREA
	INSERT INTO CTA_CTE_HOU_EXP_AER

	--TAXA DE DESEMBARACO BRO = 350 REAIS

	Select 
		HOU.Num_Proc_HEA,'SRV','C','ATL',convert(varchar,getdate(),105),'REL',431,
		convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_AER LLP
	Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
	Left Join Cta_cte_hou_exp_AER CTA on num_proc_lea=CTA.num_proc_hea and Cd_tp_Tx='SRV' and dc_hea='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_hea is null 
		and dt_conclusao is not null
		and dt_conclusao >'05-31-2009'

UNION

	Select 
		HOU.Num_Proc_HEA,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_AER LLP
	Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
	Left Join Cta_cte_hou_exp_AER CTA on num_proc_lea=CTA.num_proc_hea and Cd_tp_Tx='BRO' and dc_hea='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hea is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15
	Select 
		HOU.Num_Proc_HEA,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_aer LLP
	Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
	Left Join Cta_cte_hou_exp_AER CTA on num_proc_leA=CTA.num_proc_heA and Cd_tp_Tx='TTC' and dc_heA='C'
	where
		cd_pes_grupo='1' and cta.num_proc_heA is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

UNION
	--XEROX = 12
	Select 
		HOU.Num_Proc_HEA,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',12,
		convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_aer LLP
	Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
	Left Join Cta_cte_hou_exp_AER CTA on num_proc_leA=CTA.num_proc_heA and Cd_tp_Tx='AUT' and dc_heA='C'
	where
		cd_pes_grupo='1' and cta.num_proc_heA is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'

union

	Select 
		HOU.Num_Proc_HEA,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
	From llp_exp_aer LLP
	Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
	Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
	Left Join Cta_cte_hou_exp_AER CTA on num_proc_leA=CTA.num_proc_heA and Cd_tp_Tx='AUT' and dc_heA='C'
	where
		cd_pes_grupo='362' and cta.num_proc_heA is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'



	--SUBSTITUIÇÃO "-" POR "/"
	UPDATE
		CTA_CTE_HOU_EXP_AER
	SET
		Dt_Ins_HEA=REPLACE(Dt_Ins_HEA,'-','/'),
		Dt_Prev_Pgto_HEA=REPLACE(Dt_Prev_Pgto_HEA,'-','/')
	WHERE
		Dt_Ins_HEA like '%-%' or Dt_Prev_Pgto_HEA like '%-%'



END



--CRIADO EM 23-05-2008
--INSERCAO DE CONTA CORRENTE IMPORTAÇÃO MARITIMA GRUPO DOW
--REGRA - QUANDO O DESEMBARACO ESTA CONCLUIDO E NAO EXISTE O CTA_CTE
--Anderson

BEGIN --IMPORTACAO MARITIMA


	INSERT INTO CTA_CTE_HOU_IMP_MAR

	
	Select 
		HOU.Num_Proc_HIM,'SRV','C','ATL',convert(varchar,getdate(),103),'REL',474,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIM,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_mar LLP
	Join House_IMP_Mar HOU on llp.num_proc_lIm=hou.num_proc_hIm
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIm
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIm and Id_Task=4
	Left Join Cta_cte_hou_IMP_mar CTA on num_proc_lIm=CTA.num_proc_hIm and Cd_tp_Tx='SRV' and dc_hIm='C'
	where
		
cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_hIm is null 
		and dt_conclusao is not null
		AND CD_DST_HIM <> 'SAP'
		and dt_conclusao >'05-31-2009'

	UNION

--TAXA DE DESEMBARACO BRO = 350 REAIS
	Select 
		HOU.Num_Proc_HIM,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIM,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_mar LLP
	Join House_IMP_Mar HOU on llp.num_proc_lIm=hou.num_proc_hIm
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIm
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIm and Id_Task=4
	Left Join Cta_cte_hou_IMP_mar CTA on num_proc_lIm=CTA.num_proc_hIm and Cd_tp_Tx='BRO' and dc_hIm='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hIm is null 
		and dt_conclusao is not null
		AND CD_DST_HIM <> 'SAP'
		and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15
	Select 
		HOU.Num_Proc_HIM,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='TTC' and dc_him='C'
	where
		cd_pes_grupo='1' and cta.num_proc_him is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

	--ORDER ENTRY = 45
	UNION
	Select 
		HOU.Num_Proc_HIM,'ORE','C','ATL',convert(varchar,getdate(),105),'REL',45,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='ORE' and dc_him='C'
	where
		cd_pes_grupo='1' and cta.num_proc_him is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

	--XEROX BULK= 15
	UNION

	Select 
		HOU.Num_Proc_HIM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='AUT' and dc_him='C'
	where
		cd_pes_grupo='1' and cta.num_proc_him is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		AND CD_TP_CARGA=3
		and dt_conclusao <='05-31-2009'
	
union	-- Desembaraco bulk SUAPE

	Select 
		HOU.Num_Proc_HIM,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',474,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='BRO' and dc_him='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1')and cta.num_proc_him is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		AND CD_TP_CARGA=3 AND CD_DST_HIM='SAP'


union

	Select 
		HOU.Num_Proc_HIM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='AUT' and dc_him='C'
	where
		cd_pes_grupo='362' and cta.num_proc_him is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		--AND CD_TP_CARGA=3

union

	Select 
		HOU.Num_Proc_HIM,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='BRO' and dc_him='C'
	where
		cd_pes_grupo='362' and cta.num_proc_him is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		--AND CD_TP_CARGA=3


	UNION
--XEROX FCL E LCL=14
	Select 
		HOU.Num_Proc_HIM,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',14,
		convert(varchar,getdate()+20,105),Cd_Consig_HIm,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_mar LLP
	Join House_imp_Mar HOU on llp.num_proc_lim=hou.num_proc_him
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIM
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
	Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx='AUT' and dc_him='C'
	where
		cd_pes_grupo='1' and cta.num_proc_him is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		AND CD_TP_CARGA<>3
		and dt_conclusao <='05-31-2009'

    --Substituição "-" por "/"
	UPDATE
		CTA_CTE_HOU_IMP_MAR
	SET
		Dt_Ins_HIM=REPLACE(Dt_Ins_HIM,'-','/'),
		Dt_Prev_Pgto_HIM=REPLACE(Dt_Prev_Pgto_HIM,'-','/')
	WHERE
		Dt_Ins_HIM like '%-%' or Dt_Prev_Pgto_HIM like '%-%'
END

BEGIN --IMPORTAÇÃO AÉREA



	INSERT INTO CTA_CTE_HOU_IMP_AER

	Select 
		HOU.Num_Proc_HIA,'SRV','C','ATL',convert(varchar,getdate(),105),'REL',474,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_AER LLP
	Join House_IMP_AER HOU on llp.num_proc_lIA=hou.num_proc_hIA
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIA and Id_Task=4
	Left Join Cta_cte_hou_IMP_AER CTA on num_proc_lIA=CTA.num_proc_hIA and Cd_tp_Tx='SRV' and dc_hIA='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_hIA is null 
		and dt_conclusao is not null
		and dt_conclusao >'05-31-2009'


	UNION


	--TAXA DE DESEMBARACO BRO = 350 REAIS

	Select 
		HOU.Num_Proc_HIA,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_AER LLP
	Join House_IMP_AER HOU on llp.num_proc_lIA=hou.num_proc_hIA
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIA and Id_Task=4
	Left Join Cta_cte_hou_IMP_AER CTA on num_proc_lIA=CTA.num_proc_hIA and Cd_tp_Tx='BRO' and dc_hIA='C'
	where
		cd_pes_grupo in ('362') and cta.num_proc_hIA is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15
	Select 
		HOU.Num_Proc_HIA,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_AER LLP
	Join House_imp_AER HOU on llp.num_proc_liA=hou.num_proc_hiA
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liA and Id_Task=4
	Left Join Cta_cte_hou_imp_AER CTA on num_proc_liA=CTA.num_proc_hiA and Cd_tp_Tx='TTC' and dc_hiA='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiA is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

	--ORDER ENTRY = 45
	UNION
	Select 
		HOU.Num_Proc_HIA,'ORE','C','ATL',convert(varchar,getdate(),105),'REL',45,
		convert(varchar,getdate()+20,105),Cd_Consig_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_AER LLP
	Join House_imp_AER HOU on llp.num_proc_liA=hou.num_proc_hiA
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liA and Id_Task=4
	Left Join Cta_cte_hou_imp_AER CTA on num_proc_liA=CTA.num_proc_hiA and Cd_tp_Tx='ORE' and dc_hiA='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiA is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

UNION

	--XEROX = 12

	Select 
		HOU.Num_Proc_HIA,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',12,
		convert(varchar,getdate()+20,105),Cd_Consig_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_AER LLP
	Join House_imp_AER HOU on llp.num_proc_liA=hou.num_proc_hiA
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liA and Id_Task=4
	Left Join Cta_cte_hou_imp_AER CTA on num_proc_liA=CTA.num_proc_hiA and Cd_tp_Tx='AUT' and dc_hiA='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiA is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'

UNION

	Select 
		HOU.Num_Proc_HIA,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Consig_HIA,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_AER LLP
	Join House_imp_AER HOU on llp.num_proc_liA=hou.num_proc_hiA
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIA
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiA
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liA and Id_Task=4
	Left Join Cta_cte_hou_imp_AER CTA on num_proc_liA=CTA.num_proc_hiA and Cd_tp_Tx='AUT' and dc_hiA='C'
	where
		cd_pes_grupo='362' and cta.num_proc_hiA is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'


    --Substituição "-" por "/"
	UPDATE
		CTA_CTE_HOU_IMP_AER
	SET
		Dt_Ins_HIA=REPLACE(Dt_Ins_HIA,'-','/'),
		Dt_Prev_Pgto_HIA=REPLACE(Dt_Prev_Pgto_HIA,'-','/')
	WHERE
		Dt_Ins_HIa like '%-%' or Dt_Prev_Pgto_HIa like '%-%'

END


BEGIN --IMPORTAÇÃO OUTROS


	INSERT INTO CTA_CTE_HOU_IMP_OUT

	Select 
		HOU.Num_Proc_HIO,'SRV','C','ATL',convert(varchar,getdate(),105),'REL',474,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_OUT LLP
	Join House_IMP_OUT HOU on llp.num_proc_lIO=hou.num_proc_hIO
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIO and Id_Task=4
	Left Join Cta_cte_hou_IMP_OUT CTA on num_proc_lIo=CTA.num_proc_hIO and Cd_tp_Tx='SRV' and dc_hIO='C'
	where
		
		cd_pes_Grupo in ('P19015','P20904','1') and cta.num_proc_hIO is null 
		and dt_conclusao is not null
		and dt_conclusao >'05-31-2009'

	UNION
	--TAXA DE DESEMBARACO BRO = 350 REAIS

	Select 
		HOU.Num_Proc_HIO,'BRO','C','ATL',convert(varchar,getdate(),105),'REL',350,
		convert(varchar,getdate()+20,105),Cd_CONSIG_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_IMP_OUT LLP
	Join House_IMP_OUT HOU on llp.num_proc_lIO=hou.num_proc_hIO
	Join Pessoa PP on PP.cd_pes=Cd_CONSIG_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_CONSIG_hIO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_lIO and Id_Task=4
	Left Join Cta_cte_hou_IMP_OUT CTA on num_proc_lIo=CTA.num_proc_hIO and Cd_tp_Tx='BRO' and dc_hIO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hIO is null 
		and dt_conclusao is not null
		and dt_conclusao <='05-31-2009'

	UNION

	--TRACKING TTC = 15
	Select 
		HOU.Num_Proc_HIO,'TTC','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_OUT LLP
	Join House_imp_OUT HOU on llp.num_proc_liO=hou.num_proc_hiO
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liO and Id_Task=4
	Left Join Cta_cte_hou_imp_OUT CTA on num_proc_liO=CTA.num_proc_hiO and Cd_tp_Tx='TTC' and dc_hiO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiO is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

	--ORDER ENTRY = 45
	UNION

	Select 
		HOU.Num_Proc_HIO,'ORE','C','ATL',convert(varchar,getdate(),105),'REL',45,
		convert(varchar,getdate()+20,105),Cd_Consig_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_OUT LLP
	Join House_imp_OUT HOU on llp.num_proc_liO=hou.num_proc_hiO
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liO and Id_Task=4
	Left Join Cta_cte_hou_imp_OUT CTA on num_proc_liO=CTA.num_proc_hiO and Cd_tp_Tx='ORE' and dc_hiO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiO is null 
		and dt_conclusao is not null 
		and dt_conclusao <='05-31-2009'

	--XEROX = 13
	UNION

	Select 
		HOU.Num_Proc_HIO,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',15,
		convert(varchar,getdate()+20,105),Cd_Consig_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_OUT LLP
	Join House_imp_OUT HOU on llp.num_proc_liO=hou.num_proc_hiO
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liO and Id_Task=4
	Left Join Cta_cte_hou_imp_OUT CTA on num_proc_liO=CTA.num_proc_hiO and Cd_tp_Tx='AUT' and dc_hiO='C'
	where
		cd_pes_grupo='1' and cta.num_proc_hiO is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
		and dt_conclusao <='05-31-2009'

	UNION

	Select 
		HOU.Num_Proc_HIO,'AUT','C','ATL',convert(varchar,getdate(),105),'REL',20,
		convert(varchar,getdate()+20,105),Cd_Consig_HIO,'N','N','S','N','N','N',NULL,
		NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
	From llp_Imp_OUT LLP
	Join House_imp_OUT HOU on llp.num_proc_liO=hou.num_proc_hiO
	Join Pessoa PP on PP.cd_pes=Cd_Consig_HIO
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiO
	Join Tarefas_Processos TP on TP.num_proc=num_proc_liO and Id_Task=4
	Left Join Cta_cte_hou_imp_OUT CTA on num_proc_liO=CTA.num_proc_hiO and Cd_tp_Tx='AUT' and dc_hiO='C'
	where
		cd_pes_grupo='362' and cta.num_proc_hiO is null 
		and dt_conclusao is not null AND DT_CONCLUSAO > '08-10-2008'
	

    --Substituição "-" por "/"
	UPDATE
		CTA_CTE_HOU_IMP_OUT
	SET
		Dt_Ins_HIO=REPLACE(Dt_Ins_HIO,'-','/'),
		Dt_Prev_Pgto_HIO=REPLACE(Dt_Prev_Pgto_HIO,'-','/')
	WHERE
		Dt_Ins_HIO like '%-%' or Dt_Prev_Pgto_HIO like '%-%'

END
GO
