SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--IMOXT201212003BR ATL_DV
--CASH, AGAINST DOCUMENTS - A VISTA 5
--CASH IN ADVANCE NET – ANTECIPADO 20
--FREE OF CHARGE - 149
--DI - 5
--Fatura - 2
--Packing list - 11
--PO - 1
--Contrato de cambio - 118
--020-Doc embarque

CREATE procedure [dbo].[spAlerta_EnvioDocs_Cambio_Oxiteno]

AS
	select distinct
		HOU.Num_Proc_HIM								[JOB],
		(case when D5.Nome_arquivo is not null then
				'1;2;5;11;118;20'
			else
				'1;2;11;118;20' end) 					[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		PO.Numero_PO_HIM + ' - Fechamento de câmbio'	[Assunto],		
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		--'gustavo.kasaya@oxiteno.com;tradefinance@ultra.com.br; kathleen.valentino@oxiteno.com; juliana.otsubo@oxiteno.com; oxiteno.imp@bdp.com.br'	[Emails],
		'fernando.amaral@bdpint.com;oxiteno-matriz-bdp-importacao@oxiteno.com'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara],		
		(case when D5.Nome_arquivo is not null then
				'001 - PO | 002 - INVOICE| 005 - DI Number| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque'
			else
				'001 - PO | 002 - INVOICE| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque' 
		end) [Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]
	from
		House_Imp_Mar				HOU			with(nolock)
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_him
		join PO_HIM					PO			with(nolock)	on PO.Num_Proc_HIM	= HOU.Num_Proc_HIM and PO.ID_DC=1		
		left join doc_anexos		D5			with(nolock)	on D5.num_proc		= HOU.num_proc_him and D5.id_dc = 5
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_him and D2.id_dc = 2
		join doc_anexos				D11			with(nolock)	on D11.num_proc		= HOU.num_proc_him and D11.id_dc = 11
		join doc_anexos				D1			with(nolock)	on D1.num_proc		= HOU.num_proc_him and D1.id_dc = 1
		join doc_anexos				D118		with(nolock)	on D118.num_proc	= HOU.num_proc_him and D118.id_dc = 118
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_him and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIM and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 6 and AEH.Num_Proc = HOU.Num_Proc_HIM
		join Campo_Processo			CP			with(nolock)	on CP.num_proc		= HOU.Num_Proc_HIM and id_campo = 87
	where
		--Hou.Num_Proc_HIM = 'IMOXT201608093BR'
		substring(HOU.num_proc_him,3,3) in ('OXT') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 
		and CP.Campo_dados not in (149,5,20)
		and (D118.anexado_em >= getdate()- 30)
	
UNION ALL

	select
		HOU.Num_Proc_HIA								[JOB],
		(case when D5.Nome_arquivo is not null then
				'1;2;5;11;118;20'
			else
				'1;2;11;118;20' end) 					[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		PO.Numero_PO_HIA + ' - Fechamento de câmbio'	[Assunto],		
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		'fernando.amaral@bdpint.com;oxiteno-matriz-bdp-importacao@oxiteno.com'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara],
		(case when D5.Nome_arquivo is not null then
				'001 - PO | 002 - INVOICE| 005 - DI Number| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque'
			else
				'001 - PO | 002 - INVOICE| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque' 
		end) [Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]	
	from
		House_Imp_Aer				HOU			with(nolock)
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_hia
		join PO_HIA					PO			with(nolock)	on PO.Num_Proc_HIA	= HOU.Num_Proc_HIA and PO.ID_DC=1		
		left join doc_anexos		D5			with(nolock)	on D5.num_proc		= HOU.num_proc_hia and D5.id_dc = 5
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_hia and D2.id_dc = 2
		join doc_anexos				D11			with(nolock)	on D11.num_proc		= HOU.num_proc_hia and D11.id_dc = 11
		join doc_anexos				D1			with(nolock)	on D1.num_proc		= HOU.num_proc_hia and D1.id_dc = 1
		join doc_anexos				D118		with(nolock)	on D118.num_proc	= HOU.num_proc_hia and D118.id_dc = 118
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_hia and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIA and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 6 and AEH.Num_Proc = HOU.Num_Proc_HIA
		join Campo_Processo			CP			with(nolock)	on CP.num_proc		= HOU.Num_Proc_HIA and id_campo = 87
	where
		substring(HOU.num_proc_hia,3,3) in ('OXT') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 
		and CP.Campo_dados not in (149,5,20)
		and (D118.anexado_em >= getdate()- 30)

UNION ALL

	select
		HOU.Num_Proc_HIO								[JOB],
		(case when D5.Nome_arquivo is not null then
				'1;2;5;11;118;20'
			else
				'1;2;11;118;20' end) 					[Doc_Anexos],
		''												[JOB_Master],
		''												[Doc_Anexos_Master],
		PO.Numero_PO_HIO + ' - Fechamento de câmbio'	[Assunto],		
		'Segue documentos para fechamento de câmbio.'	[MSG],
		T23.dt_previsao									[Previsao],
		'fernando.amaral@bdpint.com;oxiteno-matriz-bdp-importacao@oxiteno.com'	[Emails],
		SHP.Apelido										[Cliente],
		''												[ResponderPara]	,
		(case when D5.Nome_arquivo is not null then
				'001 - PO | 002 - INVOICE| 005 - DI Number| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque'
			else
				'001 - PO | 002 - INVOICE| 011 - Packing List| 118 - Contrato de Cambio| 020 - Doc. Embarque' 
		end) [Nome_Doc_Anexos],
		Null											[Nome_Doc_Anexos_Master]
	from
		House_Imp_Out				HOU			with(nolock)
		join pessoa					SHP			with(nolock)	on SHP.cd_pes		= HOU.cd_consig_hio
		join PO_HIO					PO			with(nolock)	on PO.Num_Proc_HIO	= HOU.Num_Proc_HIO and PO.ID_DC=1		
		left join doc_anexos		D5			with(nolock)	on D5.num_proc		= HOU.num_proc_hio and D5.id_dc = 5
		join doc_anexos				D2			with(nolock)	on D2.num_proc		= HOU.num_proc_hio and D2.id_dc = 2
		join doc_anexos				D11			with(nolock)	on D11.num_proc		= HOU.num_proc_hio and D11.id_dc = 11
		join doc_anexos				D1			with(nolock)	on D1.num_proc		= HOU.num_proc_hio and D1.id_dc = 1
		join doc_anexos				D118		with(nolock)	on D118.num_proc	= HOU.num_proc_hio and D118.id_dc = 118
		join doc_anexos				D20			with(nolock)	on D20.num_proc		= HOU.num_proc_hio and D20.id_dc = 20
		left join tarefas_processos T23			with(nolock)	on T23.num_proc		= HOU.Num_Proc_HIO and id_task = 23
		left join Alerta_Email_DOC_Historico AEH with(nolock)	on AEH.Id_Alerta_Email = 6 and AEH.Num_Proc = HOU.Num_Proc_HIO
		join Campo_Processo			CP			with(nolock)	on CP.num_proc		= HOU.Num_Proc_HIO and id_campo = 87
	where		
		substring(HOU.num_proc_hio,3,3) in ('OXT') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 
		and CP.Campo_dados not in (149,5,20)
		and (D118.anexado_em >= getdate()- 30)
		

GO
