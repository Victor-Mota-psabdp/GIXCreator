SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from msdb.dbo.alerta_email where id = 70
--select * from msdb.dbo.alerta_email where id = 71
--select * from alerta_email_historico where id_alerta_email = 70
--2 minutos

--select * from Tarefas_PRocessos where substring(num_proc,3,3) = 'UPL' 
--and Id_task=7 and dt_conclusao >= 
--convert(datetime,convert(varchar(10),getdate(),103),103)
--
--[spAlertas_rel]

CREATE Procedure [dbo].[spATL_AlertasUPL_rel]
	
as

--desabilitado o envio do processo desembaraçado, pois ainda não foi definido os emails q irão receber o alerta
--select Distinct
--		ps.num_proc						[JOB],
--		AE.Destinatarios				[Emails],
--		AE.id							[ID],
--		'bessie@bdp.com.br'				[ResponderPara],		
--		'Processo Desembaraçado'		[Assunto],
--		Nome_local						[Destino],
--		convert(varchar,dt_Conclusao,103) [Data],
--		SO.Numero_PO_HIM				[Customer_PO],
--		PO.Numero_PO_HIM				[Num_PO],
--		DI.numero_po_him				[DI],
--		'Processo Desembaraçado'		[Descricao],
--		dbo.fBusca_PRODUTO(ps.num_proc) [Produto],	
--		'Envio de E-mail'				[Tipo_Ocorrencia]
--from 
--	Pedido_Ship						PS	With(nolock)
--	Join Pedido						PD	With(nolock) on PD.cd_pedido=PS.cd_pedido
--	Join House_Imp_Mar				HOU with(nolock)  on hou.num_proc_him=ps.num_proc
--	Left Join PO_HIM				PO	With(nolock) on PO.num_proc_him=hou.num_proc_him and PO.id_dc=1
--	Left Join PO_HIM				SO	With(nolock) on SO.num_proc_him=hou.num_proc_him and SO.id_dc=9
--	Join Localidade					DST With(nolock) on DST.cd_local=cd_dst_him
--	Join Po_HIM						DI	With(nolock) on DI.num_proC_him=hou.num_proc_him and DI.ID_DC=5
--	Left Join Hist_Geral_Sistema	HSD With(nolock) on HSGPRocesso=hou.num_proc_him and cd_tp_ocor=79
--	Join Tarefas_PRocessos			TF	With(nolock) on TF.num_proc=hou.num_proc_him and Id_task=4
--
--	left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=71	
--Where 
--	dt_Conclusao > getdate() - 8
--	and substring(HOU.num_proc_him,3,3) = 'UPL'
--	and HSD.cd_tp_ocor is null
--
--union all

select Distinct
		ps.num_proc							[JOB],
		AE.Destinatarios					[Emails],
		AE.id								[ID],
		'bessie@bdp.com.br'					[ResponderPara],
		'Entrega de Docs. para Transporte'	[Assunto],
		Nome_local							[Destino],
		convert(varchar,dt_Conclusao,103)	[Data],
		SO.Numero_PO_HIM					[Customer_PO],
		PO.Numero_PO_HIM					[Num_PO],
		DI.numero_po_him					[DI],
		'Entrega de Docs. para Transporte'	[Descricao],
		dbo.fBusca_PRODUTO(ps.num_proc)		[Produto],	
		'Envio Alerta - Ent. na Planta'		[Tipo_Ocorrencia]
from 
	Pedido_Ship						PS	With(Nolock)
	Join Pedido						PD	With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Mar				HOU With(Nolock) on hou.num_proc_him=ps.num_proc
	Join Localidade					DST With(Nolock) on DST.cd_local=cd_dst_him
	Join Po_HIM						DI	With(Nolock) on DI.num_proC_him=hou.num_proc_him and DI.ID_DC=5
	Left Join PO_HIM				PO	With(nolock) on PO.num_proc_him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM				SO	With(nolock) on SO.num_proc_him=hou.num_proc_him and SO.id_dc=9
	Left Join Hist_Geral_Sistema	HSD With(Nolock) on HSGPRocesso=hou.num_proc_him and cd_tp_ocor=60
	Join Tarefas_PRocessos			TF	With(Nolock) on TF.num_proc=hou.num_proc_him and Id_task=7

	left join dbo.Alerta_Email	AE	with(nolock) on AE.id=70
	--left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=70
Where 
	dt_Conclusao >=  convert(datetime,convert(varchar(10),getdate(),103),103)
--	dt_Conclusao >  getdate() - 8
	and substring(HOU.num_proc_him,3,3) = 'UPL'
	and HSD.cd_tp_ocor is null


Union All

--select Distinct
--		ps.num_proc							[JOB], 
--		AE.Destinatarios					[Emails],
--		AE.id								[ID],
--		'bessie@bdp.com.br'					[ResponderPara],
--		'Processo Desembaraçado'			[Assunto],
--		Nome_local							[Destino],
--		convert(varchar,dt_Conclusao,103)	[Data],
--		SO.Numero_PO_HIA					[Customer_PO],
--		PO.Numero_PO_HIA					[Num_PO],
--		DI.numero_po_hia					[DI],
--		'Processo Desembaraçado'			[Descricao],
--		dbo.fBusca_PRODUTO(ps.num_proc)		[Produto],	
--		'Envio de E-mail'					[Tipo_Ocorrencia]
--from 
--	Pedido_Ship PS With(Nolock)
--	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
--	Join House_Imp_Aer HOU With(Nolock) on hou.num_proc_HIA=ps.num_proc
--	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIA
--	Join Po_HIA DI With(Nolock) on DI.num_proC_HIA=hou.num_proc_HIA and DI.ID_DC=5
--	Left Join PO_HIA PO	With(nolock) on PO.num_proc_hia=hou.num_proc_hia and PO.id_dc=1
--	Left Join PO_HIA SO	With(nolock) on SO.num_proc_hia=hou.num_proc_hia and SO.id_dc=9
--	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIA and cd_tp_ocor=79
--	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIA and Id_task=4
--
--	left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=71
--Where 
--	dt_Conclusao >  getdate() - 8
--	and substring(HOU.num_proc_hia,3,3) = 'UPL'
--	and HSD.cd_tp_ocor is null
--
--
--union all

select Distinct 
		ps.num_proc							[JOB],
		AE.Destinatarios					[Emails],
		AE.id								[ID],
		'bessie@bdp.com.br'					[ResponderPara],
		 'Entrega de Docs. para Transporte'	[Assunto],
		Nome_local							[Destino],
		convert(varchar,dt_Conclusao,103)	[Data],
		SO.Numero_PO_HIA					[Customer_PO],
		PO.Numero_PO_HIA					[Num_PO],
		DI.numero_po_hia					[DI],
		 'Entrega de Docs. para Transporte'	[Descricao],
		dbo.fBusca_PRODUTO(ps.num_proc)		[Produto],	
		'Envio Alerta - Ent. na Planta'		[Tipo_Ocorrencia]
from 
	Pedido_Ship PS With(Nolock)
	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Aer HOU With(Nolock) on hou.num_proc_HIA=ps.num_proc
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIA
	Join Po_HIA DI With(Nolock) on DI.num_proC_HIA=hou.num_proc_HIA and DI.ID_DC=5
	Left Join PO_HIA PO	With(nolock) on PO.num_proc_hia=hou.num_proc_hia and PO.id_dc=1
	Left Join PO_HIA SO	With(nolock) on SO.num_proc_hia=hou.num_proc_hia and SO.id_dc=9
	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIA and cd_tp_ocor=60
	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIA and Id_task=7

	--left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=70
	left join dbo.Alerta_Email	AE	with(nolock) on AE.id=70
Where 
	dt_Conclusao >=  convert(datetime,convert(varchar(10),getdate(),103),103)
	and substring(HOU.num_proc_hia,3,3) = 'UPL'
	and HSD.cd_tp_ocor is null

--union all
--
--select Distinct 
--		ps.num_proc							[JOB],
--		AE.Destinatarios					[Emails],
--		AE.id								[ID],
--		'bessie@bdp.com.br'					[ResponderPara],
--		'Processo Desembaraçado'			[Assunto],
--		Nome_local							[Destino],
--		convert(varchar,dt_Conclusao,103)	[Data],
--		SO.Numero_PO_HIO					[Customer_PO],
--		PO.Numero_PO_HIO					[Num_PO],
--		DI.numero_po_hio					[DI],
--		'Processo Desembaraçado'			[Descricao],
--		dbo.fBusca_PRODUTO(ps.num_proc)		[Produto],	
--		'Envio de E-mail'					[Tipo_Ocorrencia]
--from 
--	Pedido_Ship PS With(Nolock)
--	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
--	Join House_Imp_Out HOU With(Nolock) on hou.num_proc_HIO=ps.num_proc
--	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIO
--	left Join Po_HIO DI With(Nolock) on DI.num_proC_HIO=hou.num_proc_HIO and DI.ID_DC=5
--	Left Join PO_HIO PO	With(nolock) on PO.num_proc_hio=hou.num_proc_hio and PO.id_dc=1
--	Left Join PO_HIO SO	With(nolock) on SO.num_proc_hio=hou.num_proc_hio and SO.id_dc=9
--	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIO and cd_tp_ocor=79
--	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIO and Id_task=4
--
--	left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=71
--Where 
--	dt_Conclusao > getdate() - 8
--	and substring(HOU.num_proc_hio,3,3) = 'UPL'
--	and HSD.cd_tp_ocor is null
--
--
--

GO
