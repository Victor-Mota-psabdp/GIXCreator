SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Tarefas where Nome_Task like  '%faturamento%'
--select  * from report where HSGProcesso = 'IMATL201410015BR'

CREATE Procedure [dbo].[spATL_NON_CONFORMANCE_CODE_Rel]--'2014-10-01','2015-11-01'
(
	@DtInicial datetime,
	@DtFinal datetime	
)
As		
	select 
		HSGProcesso										[BDP REF.],					
		'Ocean'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],
		PG.Apelido										[GRUPO],	
		'Import'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.NUMERO_PO_HIM								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		join House_Imp_Mar	HOU		with(nolock) on HOU.Num_Proc_HIM	= HSGProcesso		
		Join LLP_Imp_Mar	LLP		with(nolock) on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		Join JOB_Imp_Mar	JOB		with(nolock) on HOU.Num_Proc_HIM	= JOB.Num_Proc_HIM	
		
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIM 	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIM 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIM 		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIM 		= DST.Cd_Local
		Left Outer Join PO_HIM	DI	on HOU.Num_Proc_HIM	= DI.Num_Proc_him  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIM = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HIM = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HIM = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HIM = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HIM = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente			TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario =JOB.cd_usuario 
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIM and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')
		
UNION ALL
	select 
		HSGProcesso										[BDP REF.],					
		'Air'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],
		PG.Apelido										[GRUPO],	
		'Import'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.Numero_PO_HIA								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		Join HOUSE_Imp_aer	HOU	with(nolock) on HOU.Num_Proc_HIA	= HG.HSGProcesso		
		Join LLP_Imp_aer	LLP		with(nolock) on HOU.Num_Proc_HIA	= LLP.Num_Proc_LIA
		Join Job_Imp_Aer	JOB		with(nolock) on HOU.Num_Proc_HIA	= JOB.Num_Proc_HIA
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIA 	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIA 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIA 		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIA		= DST.Cd_Local
		Left Outer Join PO_HIA	DI	on HOU.Num_Proc_HIA	= DI.Num_Proc_hiA  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIA = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HIA = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HIA = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HIA = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HIA = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente				TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario = JOB.cd_usuario 
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIA and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')	

UNION ALL
	select 
		HSGProcesso										[BDP REF.],					
		'Other'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],	
		PG.Apelido										[GRUPO],	
		'Import'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.Numero_PO_HIO								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		Join HOUSE_Imp_OUT	HOU	with(nolock) on HOU.Num_Proc_HIO	= HG.HSGProcesso		
		Join LLP_Imp_OUT	LLP		with(nolock) on HOU.Num_Proc_HIO	= LLP.Num_Proc_LIO	
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
						
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIo 	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIo 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIo		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIo		= DST.Cd_Local
		Left Outer Join PO_HIo	DI	on HOU.Num_Proc_HIo	= DI.Num_Proc_hio  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIO = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HIO = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HIO = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HIO = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HIO = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente				TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario = LLP.Cd_Usuario
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIo and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')	


UNION ALL
	select 
		HSGProcesso										[BDP REF.],					
		'Ocean'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],	
		PG.Apelido										[GRUPO],	
		'Export'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.NUMERO_PO_HEM								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		join House_EXp_Mar	HOU		with(nolock) on HOU.Num_Proc_HEM	= HSGProcesso		
		Join LLP_Exp_Mar	LLP		with(nolock) on HOU.Num_Proc_HeM	= LLP.Num_Proc_Lem
		Join Job_Exp_Mar	JOB		with(nolock) on HOU.Num_Proc_HEM	= JOB.Num_Proc_HEM
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
		
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEM 	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEM 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEM 		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEM 		= DST.Cd_Local
		Left Outer Join PO_HEM	DI	on HOU.Num_Proc_HEM	= DI.Num_Proc_hEm  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HEM = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HEM = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HEM = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HEM = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HEM = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente				TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario = JOB.cd_usuario 
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_Hem and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')
UNION ALL
	select 
		HSGProcesso										[BDP REF.],					
		'Air'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],	
		PG.Apelido										[GRUPO],				
		'Export'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.Numero_PO_HEA								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		join House_EXp_aer	HOU		with(nolock) on HOU.Num_Proc_HEa	= HSGProcesso		
		Join LLP_Exp_aer	LLP		with(nolock) on HOU.Num_Proc_Hea	= LLP.Num_Proc_Lea
		Join Job_Exp_Aer	JOB		with(nolock) on HOU.Num_Proc_HEA	= JOB.Num_Proc_HEA	
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
		
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEa	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEa 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEa 		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEa 		= DST.Cd_Local
		Left Outer Join PO_HEA	DI	on HOU.Num_Proc_HEA	= DI.Num_Proc_hEa  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HEA = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HEA = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HEA = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HEA = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HEA = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente				TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario = JOB.cd_usuario 
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_Hea and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')
UNION ALL
	select 
		HSGProcesso										[BDP REF.],					
		'Other'											[MODAL],
		--(case when CP32.Campo_Dados='2' then 'N'
		--		else
		--		'Y'	end)								[CHB Y/N],
		PG.Apelido										[GRUPO],	
		'Export'										[IMPORT/EXPORT],
		--Ship.Nome_Raz_Soc								[SHIPPER],
		--Consig.Nome_Raz_Soc								[CONSIGNEE]	,
		--ORG.nome_local									[ORIGIN],
		--DST.nome_local									[DESTINATION],
		T4.DT_Conclusao									[CUSTOMS CLEARENCE]	,			
		DI.Numero_PO_HEO								[DI / RE],						
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],
		T26.DT_Conclusao								[ENVIO DE DOCS PARA FATURAMENTO],
		T68.DT_Conclusao								[AVERBAÇAO DATE],
		T35.DT_Conclusao								[RECEBIMENTO DE FATURAMENTO],
		Descricao_NC									[BILLING HISTORIC],
		Nome_Usuario									[CSR]
	from
		Hist_Geral HG	with(nolock)
		join House_EXp_out	HOU		with(nolock) on HOU.Num_Proc_HEO	= HSGProcesso		
		Join LLP_Exp_OUT	LLP		with(nolock) on HOU.Num_Proc_HEo	= LLP.Num_Proc_LeO
		
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Notify_HEO --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
		
		--Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEO	= Ship.Cd_Pes
		--Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEO 	= Consig.Cd_Pes
		--Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEO		= ORG.Cd_Local 
		--Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEO 		= DST.Cd_Local
		Left Outer Join PO_HEo	DI	on HOU.Num_Proc_HEo= DI.Num_Proc_hEo  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HEO = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T7	on HOU.Num_Proc_HEO = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T68	on HOU.Num_Proc_HEO = T68.Num_proc and T68.ID_Task = 68
		Left Outer Join Tarefas_processos	T35	on HOU.Num_Proc_HEO = T35.Num_proc and T35.ID_Task = 35
		Left Outer Join Tarefas_processos	T26	on HOU.Num_Proc_HEO = T26.Num_proc and T26.ID_Task = 26
		left Join Tipo_NC_Cliente				TPNC on HG.id_nc =TPNC.cD_NC 
		left join Usuario					U on U.cd_usuario = LLP.Cd_Usuario 
		left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HEO and CP32.id_campo=32	
	where
		HG.HSGData between @DtInicial and @DtFinal
		and 
		ID_NC in ('BILLING - RCVINC','BILLING - SBAX','BILLING - SDORI','BILLING - SRARM','BILLING - SRFT')

GO
