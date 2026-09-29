SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE   Procedure [dbo].[spAlertas_rel]
	as

select 
	Distinct SO.Numero_PO_HIM Num_Pedido, PO.Numero_PO_HIM Num_PO, 'Processo Desembaraçado' Descricao, PS.num_proc,Nome_local Porto,DI.numero_po_him DI,
	Planta,dt_Conclusao Data, dbo.fBusca_PRODUTO(ps.num_proc) Produto, 'Envio de Aviso - DAS' Tipo_Ocorrencia,ps.num_proc
from 
	Pedido_Ship PS With(nolock)
	Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Mar HOU with(nolock)  on hou.num_proc_him=ps.num_proc
	Left Join PO_HIM PO With(nolock) on PO.num_proc_him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM SO With(nolock) on SO.num_proc_him=hou.num_proc_him and SO.id_dc=3
	Join Localidade DST With(nolock) on DST.cd_local=cd_dst_him
	Join Po_HIM DI With(nolock) on DI.num_proC_him=hou.num_proc_him and DI.ID_DC=5
	Left Join Hist_Geral_Sistema HSD With(nolock) on HSGPRocesso=hou.num_proc_him and cd_tp_ocor=59
	Join Tarefas_PRocessos TF With(nolock) on TF.num_proc=hou.num_proc_him and Id_task=4
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) and dt_Conclusao > getdate() - 8
	and HSD.cd_tp_ocor is null

union all

select 
	Distinct Num_Pedido, Num_PO, 'Entrega de Docs. para Transporte' Descricao, PS.num_proc,Nome_local Porto,numero_po_him DI,
	Planta,dt_Conclusao Data, dbo.fBusca_PRODUTO(ps.num_proc) Produto, 'Envio Alerta - Ent. na Planta' Tipo_Ocorrencia, ps.num_proc
from 
	Pedido_Ship PS With(Nolock)
	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Mar HOU With(Nolock) on hou.num_proc_him=ps.num_proc
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_him
	Join Po_HIM DI With(Nolock) on DI.num_proC_him=hou.num_proc_him and ID_DC=5
	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_him and cd_tp_ocor=60
	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_him and Id_task=7
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) and dt_Conclusao >  getdate() - 8
	and HSD.cd_tp_ocor is null

Union All

select 
	Distinct Num_Pedido, Num_PO, 'Processo Desembaraçado' Descricao, PS.num_proc,Nome_local Porto,numero_po_HIA DI,
	Planta,dt_Conclusao Data, dbo.fBusca_PRODUTO(ps.num_proc) Produto, 'Envio de Aviso - DAS' Tipo_Ocorrencia,ps.num_proc
from 
	Pedido_Ship PS With(Nolock)
	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Aer HOU With(Nolock) on hou.num_proc_HIA=ps.num_proc
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIA
	Join Po_HIA DI With(Nolock) on DI.num_proC_HIA=hou.num_proc_HIA and ID_DC=5
	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIA and cd_tp_ocor=59
	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIA and Id_task=4
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) and dt_Conclusao >  getdate() - 8
	and HSD.cd_tp_ocor is null

union all

select 
	Distinct Num_Pedido, Num_PO, 'Entrega de Docs. para Transporte' Descricao, PS.num_proc,Nome_local Porto,numero_po_HIA DI,
	Planta,dt_Conclusao Data, dbo.fBusca_PRODUTO(ps.num_proc) Produto, 'Envio Alerta - Ent. na Planta' Tipo_Ocorrencia, ps.num_proc
from 
	Pedido_Ship PS With(Nolock)
	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Aer HOU With(Nolock) on hou.num_proc_HIA=ps.num_proc
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIA
	Join Po_HIA DI With(Nolock) on DI.num_proC_HIA=hou.num_proc_HIA and ID_DC=5
	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIA and cd_tp_ocor=60
	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIA and Id_task=7
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) and dt_Conclusao >  getdate() - 8
	and HSD.cd_tp_ocor is null

union all

select 
	Distinct Num_Pedido, Num_PO, 'Processo Desembaraçado' Descricao, PS.num_proc,Nome_local Porto,numero_po_HIO DI,
	Planta,dt_Conclusao Data, dbo.fBusca_PRODUTO(ps.num_proc) Produto, 'Envio de Aviso - DAS' Tipo_Ocorrencia,ps.num_proc
from 
	Pedido_Ship PS With(Nolock)
	Join Pedido PD With(Nolock) on PD.cd_pedido=PS.cd_pedido
	Join House_Imp_Out HOU With(Nolock) on hou.num_proc_HIO=ps.num_proc
	Join Localidade DST With(Nolock) on DST.cd_local=cd_dst_HIO
	Join Po_HIO DI With(Nolock) on DI.num_proC_HIO=hou.num_proc_HIO and ID_DC=5
	Left Join Hist_Geral_Sistema HSD With(Nolock) on HSGPRocesso=hou.num_proc_HIO and cd_tp_ocor=59
	Join Tarefas_PRocessos TF With(Nolock) on TF.num_proc=hou.num_proc_HIO and Id_task=4
Where 
	(Planta like ('05044%') or Planta in ('C021','C034','C035','C036','C037','C038')) and dt_Conclusao > getdate() - 8
	and HSD.cd_tp_ocor is null





GO
