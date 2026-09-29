SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--1-   INVOICE  - 2
--2-   Extrato da DI - 5
--3-   BL / HAWB -44
--BL - Original ou Doc Embarque
--select * from Alerta_Email_Doc

--select * from Tipo_Tarefas where Nome_Task like '%Cambio%'
--23
--select * from Tipo_Tarefas where Nome_Task like '%planta%'
--select * from Tipo_Tarefas where Nome_Task like '%transport%'
--alterado pra Entrega de DOCS p/ Transporte - 7 - 27/2/2015 - Cadu - ticket: 100-16139
CREATE procedure [dbo].[spAlerta_EnvioDocs_Cambio_Levis]

AS
	select distinct
		HOU.Num_Proc_HIM								[JOB],
		'2;5;44'					 					[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],		
		'CAMBIO PO – ' + dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1) [Assunto],		
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		'lsbpayment@levi.com; esilva@levi.com'			[Emails],
		''												[Cliente],
		''												[ResponderPara]	,
		
		
		'| 002 - INVOICE| 005 - DI Number| 044 - BL - Original'		[Nome_Doc_Anexos],
		Null														[Nome_Doc_Anexos_Master]
	from
		House_Imp_Mar				HOU			with(nolock)
		Join LLp_Imp_mar			LLP			with(nolock)	on LLP.num_proc_lim = HOU.num_proc_him			
		join doc_anexos				D5			with(nolock)	on D5.num_proc		= HOU.num_proc_him and D5.id_dc = 5
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_him and D2.id_dc = 2
		join doc_anexos				D44			with(nolock)	on D44.num_proc		= HOU.num_proc_him and D44.id_dc = 44		
		join tarefas_processos		T7			with(nolock)	on T7.num_proc		= HOU.Num_Proc_HIM and T7.id_task = 7
		join tarefas_processos		T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIM and T23.id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 9 and AEH.Num_Proc = HOU.Num_Proc_HIM		
	where
		substring(HOU.num_proc_him,3,3) in ('LVS') 
		and t7.dt_conclusao is not null
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 
		and isnull(llp.id_status,0) <> '9'
		
UNION ALL
	select distinct
		HOU.Num_Proc_HIA								[JOB],
		'2;5;44'					 					[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],		
		'CAMBIO PO – ' + dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1) [Assunto],		
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		'lsbpayment@levi.com; esilva@levi.com'			[Emails],
		''												[Cliente],
		''												[ResponderPara],
		
		'| 002 - INVOICE| 005 - DI Number| 044 - BL - Original'		[Nome_Doc_Anexos],
		Null														[Nome_Doc_Anexos_Master]	
	from
		House_Imp_Aer				HOU			with(nolock)
		Join LLp_Imp_aer			LLP			with(nolock)	on LLP.num_proc_lia = HOU.num_proc_hia			
		join doc_anexos				D5			with(nolock)	on D5.num_proc		= HOU.num_proc_hia and D5.id_dc = 5
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_hia and D2.id_dc = 2
		join doc_anexos				D44			with(nolock)	on D44.num_proc		= HOU.Num_Proc_HIA and D44.id_dc = 44		
		join tarefas_processos		T7			with(nolock)	on T7.num_proc		= HOU.Num_Proc_HIA and T7.id_task = 7
		join tarefas_processos		T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIA and T23.id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 9 and AEH.Num_Proc = HOU.Num_Proc_HIA		
	where
		substring(HOU.num_proc_hia,3,3) in ('LVS') 
		and t7.dt_conclusao is not null
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL
		and isnull(llp.id_status,0) <> '9'


GO
