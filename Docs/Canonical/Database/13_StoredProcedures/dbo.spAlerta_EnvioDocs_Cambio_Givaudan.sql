SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--1- INVOICE  - 002 - INVOICE
--2- Extrato da DI 005 - DI Number
--3- 020(Doc Embarque)
--4- CI - 006 CI Number

CREATE procedure [dbo].[spAlerta_EnvioDocs_Cambio_Givaudan]

AS
	select distinct
		HOU.Num_Proc_HIM								[JOB],
		'2,5,6,20'										[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		'Docs para Fechamento de Cambio – ' + HOU.Num_Proc_HIM + ' / ' + dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,9) [Assunto],			
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao							[Previsao],
		--'carlos.eduardo@bdpint.com'	[Emails],
		'jairo@btcorretora.com.br'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara]	,
		
		'| 002 - INVOICE| 005 - DI Number| 006 - CI Number| 020 - Doc. Embarque'[Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]
	from
		House_Imp_Mar				HOU			with(nolock)
		join LLP_Imp_Mar			LLP			with(nolock)	on LLP.Num_Proc_Lim	= HOU.num_proc_him
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_him
		join PO_HIM					PO			with(nolock)	on PO.Num_Proc_HIM	= HOU.Num_Proc_HIM and PO.ID_DC=9
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_him and D2.id_dc = 2		
		join doc_anexos				D5			with(nolock)	on D5.num_proc		= HOU.num_proc_him and D5.id_dc = 5
		join doc_anexos				D6			with(nolock)	on D6.num_proc		= HOU.num_proc_him and D6.id_dc = 6		
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_him and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIM and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 10 and AEH.Num_Proc = HOU.Num_Proc_HIM		
	where
		substring(HOU.num_proc_him,3,3) in ('GVD','GVA') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 		
		and (D6.anexado_em >= getdate()- 10)
	
UNION ALL

	select distinct
		HOU.Num_Proc_HIA								[JOB],
		'2,5,6,20'										[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		'Docs para Fechamento de Cambio – ' + HOU.Num_Proc_HIA + ' / ' + dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,9) [Assunto],			
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		--'carlos.eduardo@bdpint.com'	[Emails],
		'jairo@btcorretora.com.br'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara]	,
		'| 002 - INVOICE| 005 - DI Number| 006 - CI Number| 020 - Doc. Embarque'[Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]
	from
		House_Imp_Aer				HOU			with(nolock)
		join LLP_Imp_Aer			LLP			with(nolock)	on LLP.Num_Proc_Lia	= HOU.Num_Proc_HIA
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_HIA
		join PO_HIA					PO			with(nolock)	on PO.Num_Proc_HIA	= HOU.Num_Proc_HIA and PO.ID_DC=9
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_HIA and D2.id_dc = 2		
		join doc_anexos				D5			with(nolock)	on D5.num_proc		= HOU.num_proc_HIA and D5.id_dc = 5
		join doc_anexos				D6			with(nolock)	on D6.num_proc		= HOU.num_proc_HIA and D6.id_dc = 6		
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_HIA and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIA and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 10 and AEH.Num_Proc = HOU.Num_Proc_HIA		
	where
		substring(HOU.num_proc_HIA,3,3) in ('GVD','GVA') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 		
		and (D6.anexado_em >= getdate()- 10)

UNION ALL

	select distinct
		HOU.Num_Proc_HIO								[JOB],
		'2,5,6,20'										[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		'Docs para Fechamento de Cambio – ' + HOU.Num_Proc_HIO + ' / ' + dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,9) [Assunto],			
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		--'carlos.eduardo@bdpint.com'	[Emails],
		'jairo@btcorretora.com.br'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara],
		'| 002 - INVOICE| 005 - DI Number| 006 - CI Number| 020 - Doc. Embarque'[Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]	
	from
		House_Imp_Out				HOU			with(nolock)
		join LLP_Imp_Out			LLP			with(nolock)	on LLP.Num_Proc_Lio	= HOU.Num_Proc_HIO
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_HIO
		join PO_HIO					PO			with(nolock)	on PO.Num_Proc_HIO	= HOU.Num_Proc_HIO and PO.ID_DC=9
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_HIO and D2.id_dc = 2		
		join doc_anexos				D5			with(nolock)	on D5.num_proc		= HOU.num_proc_HIO and D5.id_dc = 5
		join doc_anexos				D6			with(nolock)	on D6.num_proc		= HOU.num_proc_HIO and D6.id_dc = 6		
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_HIO and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIO and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 10 and AEH.Num_Proc = HOU.Num_Proc_HIO		
	where
		substring(HOU.num_proc_HIO,3,3) in ('GVD','GVA') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 		
		and (D6.anexado_em >= getdate()- 10)
		

GO
