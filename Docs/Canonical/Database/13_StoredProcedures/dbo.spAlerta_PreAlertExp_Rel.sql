SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from job_exp_mar where num_proc_hem like 'EMATL201301005BR%'
--select * from house_exp_mar where num_proc_hem like 'EMATL201301005BR%'
--select * from master_exp_mar whselect * from Hist_Geral HST where cd_tp_ocor=44 and 
--select * from Hist_Geral where HSDDescricao like 'Pre-Alert Sending%' 
--and hsgProcesso like 'em%' and hsgdata >= '2013-04-12'
--EMATL201211022BR
--select * from Tipo_Oper where num_proc = 'EMSSZ201301005'
--select * from PO_Master where num_proc_master = 'EMSSZ201301005'
--select * from Master_exp_mar where num_proc_mem = 'EMSSZ201301005'
--select num_proc from Alerta_Email_Doc_Historico where id_alerta_email in(4)
--select * from Hist_Geral where cd_tp_ocor=44 and HSDDescricao like 'Pre-Alert Sending%' and hsgprocesso like 'em%'
--

CREATE Procedure [dbo].[spAlerta_PreAlertExp_Rel]

AS
	select 
		HOU.num_proc_hem			[JOB],
		HOU.num_proc_mem			[JOB_Master],	
		'20;74'						[Doc_Anexos],	
		'20'						[Doc_Anexos_Master],		
		'Pre_Alert - Ref.:'	+ HOU.num_proc_hem [Assunto],
		'Dear Partner,||Regarding the above-mentioned shipment, please note our pre-alert as follows: ' + '||' + 
		'Vessel: ' + isnull(HOU.Navio_hem,'') + '|' +
		'Voyage: ' + isnull(HOU.Viagem_hem,'') + '|' +
		'Date Of Shipment: ' + isnull(convert(varchar,LLP.Dt_BL_Lem,103),'') + '|' +
		'Port Of Loading: ' + LOA.nome_local + '|' +
		'Port Of Discharge: ' + DIS.nome_local + '|' +
		'Place Of Delivery: ' + DEL.nome_local + '|' +
		'House B/L NBR: ' + isnull(HOU.HAWB_HEM,'') + '|' + 
		'Master B/L NBR: ' + isnull(HOU.MAWB_HEM,'') + '|' +
		--'PO#: ' + isnull(P.Num_Pedido,'') + '|' +
		'PO#: ' + isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,1),'') + '|' +
		'Incoterm: ' + isnull(TP.Nome_Tp_Oper,'') + '|' + 
		'Carrier: ' + isnull(ARM.Nome_Armador,'') + '||' +
		'If you have any doubt, please let us know.||Please confirm the receipt by return.||Waiting for your reply.' + '|' [MSG],
		NULL												[Previsao],
--		[dbo].[fBusca_Emal_Comunicacao](MAS.cd_consig_mem,'AG%')	[Emails],
		[dbo].[fBusca_Emal_Comunicacao](HOU.cd_export_hem,'AG%')	[Emails],		
		CON.Apelido											[Cliente],
		''													[ResponderPara],		
		'| 20 - Doc. Embarque | 74 - Agent - Invoice' 		[Nome_Doc_Anexos],
		'| 20 - Doc. Embarque Master'						[Nome_Doc_Anexos_Master]
	from house_exp_mar HOU with(nolock)
		join LLP_Exp_MAR LLP with(nolock) on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		--left join Pedido_Ship PS with(nolock) on PS.Num_Proc = LLP.Num_Proc_Lem
		--left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido	
--		join master_Exp_MAR MAS with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
--		join pessoa CON	with(nolock) on CON.cd_pes = MAS.cd_consig_mem
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.cd_export_hem
		join Localidade LOA	with(nolock) on LOA.cd_local = HOU.cd_org_HEM
		join Localidade DIS	with(nolock) on DIS.cd_local = HOU.cd_dst_HEM
		join Armador ARM with(nolock) on LLP.cd_armador_lem = ARM.cd_armador		
		join doc_anexos D20 with(nolock) on D20.num_proc = HOU.num_proc_hem and D20.id_dc = 20
		join doc_anexos D74 with(nolock) on D74.num_proc = HOU.num_proc_hem and D74.id_dc = 74
		join PO_master M20 with(nolock) on M20.num_proc_master = HOU.num_proc_mem and M20.id_dc = 20
		left join Localidade DEL with(nolock) on DEL.cd_local = LLP.cd_dstfinal_LEM	
		Left Join Tipo_Oper	TP with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper		
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 4 and AEH.Num_Proc = HOU.Num_Proc_HEM
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_lem and cd_tp_ocor=44 and HSDDescricao like 'Pre-Alert Sending%'
	where
		--HOU.num_proc_hem = 'EMATL201507031BR' 
--		and
		HSGDATA >= GETDATE()- 10	 
		and AEH.Num_Proc IS NULL
--		substring(HOU.num_proc_hem,1,5) = 'EMATL'
		and (HOU.num_proc_mem <> 'JOB' and substring(HOU.num_proc_mem,1,5) <> 'EMCLI')







GO
