SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spAlertasIMP_Rel] --'FCN'
(
@Email as varchar(100)
)
as
	if @Email='EXISTE'
		select
				distinct Email
		from
			Hist_Geral HG
			Join Pedido_Ship			PS	on HG.HSGProcesso = PS.Num_Proc
			Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
			Join Pedido_Det 			PD	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
			Join Usuario				U	on U.cd_usuario=HG.cd_usuario
			Left Join Tarefas_Processos TP	on TP.num_proc=HG.HSGProcesso and TP.id_task=13
		where 
 			(PO_GRP IN ('041','431')) 
			and dbo.fBusca_Historico_DataFU(HSGProcesso,54)  between  getdate()-1 and  getdate()+3
			and HSGProcesso like '%I%CSR%'
			and Dt_Conclusao is null
			and cd_tp_ocor=54
			and convert(char, HSGData, 103)  <> convert(char, getdate(), 103)

	ELSE

		select
				distinct HSGProcesso
		from
			Hist_Geral HG
			Join Pedido_Ship			PS	on HG.HSGProcesso = PS.Num_Proc
			Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
			Join Pedido_Det 			PD	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
			Join Usuario				U	on U.cd_usuario=HG.cd_usuario
			Left Join Tarefas_Processos TP	on TP.num_proc=HG.HSGProcesso and TP.id_task=13
		where 
 			(PO_GRP IN ('041','431')) 
			and dbo.fBusca_Historico_DataFU(HSGProcesso,54)  between  getdate()-1 and  getdate()+3
			and HSGProcesso like '%I%CSR%'
			and Dt_Conclusao is null
			and cd_tp_ocor=54
			and convert(char, HSGData, 103)  <> convert(char, getdate(), 103)
			and Email = @Email






GO
