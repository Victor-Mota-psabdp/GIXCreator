SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Alertas_Teste_Rel]
	
as

select Distinct 
	ps.num_proc							[JOB],
	--(case when (right(Planta,2) = 'N6' or right(Planta,2) = 'NI' or right(Planta,2) = 'XI' or right(Planta,2) = 'WY') then
	--	AEP.Destinatarios
	--Else
	--	AE.Destinatarios end)			[Emails],
	'erbson.soares@bdpint.com;carlos.eduardo@bdpint.com' [Emails],
	(case when (right(Planta,2) = 'N6' or right(Planta,2) = 'NI' or right(Planta,2) = 'XI' or right(Planta,2) = 'WY') then
		AEP.ID
	Else
		AE.id end)						[ID],
		'carlos.eduardo@bdpint.com'		[ResponderPara],		
		'Processo Desembaraçado'		[Assunto],
		Nome_local						[Destino],
		convert(varchar,dt_Conclusao,103) [Data],
		SO.Numero_PO_HIM				[Num_Pedido],
		--PO.Numero_PO_HIM				[Num_PO],
		P9.Numero_PO_HIM				[Num_PO],
		DI.numero_po_him				[DI],
		'Processo Desembaraçado'		[Descricao],
		dbo.fBusca_PRODUTO(ps.num_proc) [Produto],	
		'Envio de Aviso - DAS'			[Tipo_Ocorrencia],
		TER.Nome_Terminal					[Terminal]
from 
	Pedido_Ship						PS	With(nolock)
	Join Pedido						PD	With(nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Mar				HOU with(nolock) on hou.num_proc_him=ps.num_proc
	--Left Join PO_HIM				PO	With(nolock) on PO.num_proc_him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM				P9	With(nolock) on P9.num_proc_him=hou.num_proc_him and P9.id_dc=9
	Left Join PO_HIM				SO	With(nolock) on SO.num_proc_him=hou.num_proc_him and SO.id_dc=3
	Join Localidade					DST With(nolock) on DST.cd_local=cd_dst_him
	Join Po_HIM						DI	With(nolock) on DI.num_proC_him=hou.num_proc_him and DI.ID_DC=5
	Left Join Hist_Geral_Sistema	HSD With(nolock) on HSGPRocesso=hou.num_proc_him and cd_tp_ocor=59
	Join Tarefas_PRocessos			TF	With(nolock) on TF.num_proc=hou.num_proc_him and Id_task=4
	--left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=68
	--left join msdb.dbo.Alerta_Email	AEP with(nolock) on AEP.id=69
	left join dbo.Alerta_Email	AE	with(nolock) on AE.id=68
	left join dbo.Alerta_Email	AEP with(nolock) on AEP.id=69
	Join LLP_Imp_Mar				LLP	with(nolock) on LLP.num_proc_Lim=PS.num_proc
	Join Terminal					TER	with(nolock) on LLP.Cd_Terminal=TER.Cd_Terminal
--	Join Job_imp_Mar				Job with(nolock) on job.num_proc_him=ps.num_proc
--	Join Usuario					US	with(nolock) on US.cd_usuario=Job.cd_usuario
		
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) 
	and dt_Conclusao > getdate() - 1
	--and HSD.cd_tp_ocor is null

GO
