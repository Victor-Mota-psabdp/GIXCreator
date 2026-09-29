SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tipo_doc_cliente
--select * from HIST_GERAL_SISTEMA where hsgprocesso='EAATL201208004BR' and cd_tp_ocor= 79 
--select * from HIST_GERAL where hsgprocesso='IAATL201303007BR' and cd_tp_ocor= 79 
--select Report_name from Alerta_Email_Doc
--select * from Alerta_Email_Doc_Historico
--select * from tipo_tarefas where id_task  =128
--select * from tarefas_processos where id_task  =128	
--update tarefas_processos set dt_conclusao =  null where id_task  =128 and num_proc in ('EAATL201301009BR'),'EAATL201208004BR')
----select * from doc_anexos where num_proc = 'IAATL201303007BR'
--select nome_tp_ocor from tipo_ocorrencia where cd_tp_ocor = 79
--select * from Caixa_Hou_Exp_Aer where num_proc_hea = 'EAATL201208004BR'
--select * from campo_pessoa where campo_dados = '1' and id_campo = 8
--select * from campo_pessoa where campo_dados = '1' and id_campo = 9
--
--000002
--P000007543
--P12976
--select * from pessoa where cd_pes = 'P000007543'
--select * from comunicacao where cd_pes =  'P000007543'
--select * from house_imp_aer where cd_consig_hia = 'P12976'
--select * from house_exp_aer where cd_export_hea = '000002'

CREATE Procedure [dbo].[spAlerta_EnvioReciboAereo_Rel]

AS
--79 = Envio de E-mail
	select
		HOU.num_proc_hea		[JOB],
		'146;147' 				[Doc_Anexos],
		''						[JOB_Master],
		''						[Doc_Anexos_Master],
		'Envio de Recibo e NF' [Assunto],
		'Prezados Sr(s). ||Agradecemos por seu embarque e encaminhamos em anexo o recibo referente a:|' + 
		'Shipper: ' + SHP.Nome_raz_Soc + '|' +
		'Consignee: ' + CON.Nome_raz_Soc + '|' + 
		'MAWB: ' + isnull(HOU.MAWB_HEA,'') + '|' + 'HAWB: ' + isnull(HOU.HAWB_HEA,'') + '|' +
		'Invoice: ' + isnull(INV.Numero_PO_HEA,'') + '|' + 'Data de Partida: ' + isnull(convert(varchar,LLP.ATD_LEA,103),'') + '|' +
		'Para retirada dos originais, por favor disponibilizar cópia do comprovante de pagamento, no momento da retirada: ' + '||' +
		[dbo].fBusca_Pessoa_Aeroporto(cd_planta_lea) + '||' +
		'O recibo será disponibilizado em 48 horas, após a compensação do pagamento e enviado pela mesma via.' [MSG],
		T128.dt_previsao									[Previsao],
		[dbo].[fBusca_Emal_Comunicacao](HOU.cd_export_hea,'EM%')	[Emails],
		SHP.Apelido											[Cliente],
		CSR.Email											[ResponderPara]
	from house_exp_aer HOU with(nolock)
		join LLP_Exp_AER LLP with(nolock) on LLP.Num_Proc_LEA = HOU.Num_Proc_HEA
		join JOB_Exp_AER JOB with(nolock) on JOB.Num_Proc_HEA = HOU.Num_Proc_HEA
		join Usuario CSR with(nolock) on CSR.cd_usuario = JOB.cd_usuario	
		join pessoa SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_hea
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.cd_consig_hea	
		left join PO_HEA INV with(nolock) on INV.Num_Proc_HEA = HOU.Num_Proc_HEA and INV.ID_DC=2
		join campo_pessoa CP8 with(nolock) on CP8.cd_pes = HOU.cd_export_hea and CP8.id_campo = 8
		left join campo_pessoa CP9 with(nolock) on CP9.cd_pes = CP8.cd_pes and CP8.campo_dados = CP9.campo_dados and CP9.id_campo = 9
		join doc_anexos D146 with(nolock) on D146.num_proc = HOU.num_proc_hea and D146.id_dc = 146
		join doc_anexos D147 with(nolock) on D147.num_proc = HOU.num_proc_hea and D147.id_dc = 147
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 1 and AEH.Num_Proc = HOU.Num_Proc_HEA	
		left join tarefas_processos T128	with(nolock)	on T128.num_proc = HOU.Num_Proc_HEA and id_task = 128
--		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=HOU.num_proc_hea and cd_tp_ocor= 79
	where 	
		AEH.Num_Proc IS NULL
		and t128.dt_conclusao is null	
--		AND HSGDATA is null	
		and HOU.num_proc_mea <> 'JOB'
		and (Isnull(LLP.ID_Status,1) <> 9)

UNION ALL

	select 
		HOU.num_proc_hia		[JOB],
		'146;147' 				[Doc_Anexos],
		''						[JOB_Master],
		''						[Doc_Anexos_Master],
		'Envio de Recibo e NF' [Assunto],
		'Prezados Sr(s). ||Agradecemos por seu embarque e encaminhamos em anexo o recibo referente a:|' + 
		'Shipper: ' + SHP.Nome_raz_Soc + '|' +
		'Consignee: ' + CON.Nome_raz_Soc + '|' + 
		'MAWB: ' + isnull(HOU.MAWB_HIA,'') + '|' + 'HAWB: ' + isnull(HOU.HAWB_HIA,'') + '|' +
		'Invoice: ' + isnull(INV.Numero_PO_HIA,'') + '|' + 'Data de chegada: ' + isnull(convert(varchar,LLP.ATA_LIA,103),'') + '|' +
		'Para retirada dos originais, por favor disponibilizar cópia do comprovante de pagamento, no momento da retirada: ' + '||' +
		[dbo].[fBusca_Pessoa_Aeroporto](LLP.cd_dstfinal_lia) + '||' +
		'O recibo será disponibilizado em 48 horas, após a compensação do pagamento e enviado pela mesma via.' [MSG],
		T128.dt_previsao									[Previsao],
		[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_hia,'EM%')	[Emails],
		CON.Apelido											[Cliente],
		CSR.Email											[ResponderPara]		
	from house_imp_aer HOU with(nolock)
		join LLP_IMP_AER LLP with(nolock) on LLP.Num_Proc_LIA = HOU.Num_Proc_HIA
		join JOB_IMp_AER JOB with(nolock) on JOB.Num_Proc_HIA = HOU.Num_Proc_HIA
		join Usuario CSR with(nolock) on CSR.cd_usuario = JOB.cd_usuario
		join pessoa SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_hia
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.cd_consig_hia
		left join PO_HIA INV with(nolock) on INV.Num_Proc_HIA = HOU.Num_Proc_HIA and INV.ID_DC=2
		join campo_pessoa CP8 with(nolock) on CP8.cd_pes = HOU.cd_consig_hia and CP8.id_campo = 8
		left join campo_pessoa CP9 with(nolock) on CP9.cd_pes = CP8.cd_pes and CP8.campo_dados = CP9.campo_dados and CP9.id_campo = 9
		join doc_anexos D146 with(nolock) on D146.num_proc = HOU.num_proc_hia and D146.id_dc = 146
		join doc_anexos D147 with(nolock) on D147.num_proc = HOU.num_proc_hia and D147.id_dc = 147
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 1 and AEH.Num_Proc = HOU.Num_Proc_HIA	
		left join tarefas_processos T128	with(nolock) on T128.num_proc = HOU.Num_Proc_HIA and id_task = 128
--		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=HOU.num_proc_hia and cd_tp_ocor= 79
	where 
		AEH.Num_Proc IS NULL
		and t128.dt_conclusao is null	
--		AND HSGDATA is null	
		and HOU.num_proc_mia <> 'JOB'
		and (Isnull(LLP.ID_Status,1) <> 9)
	

GO
