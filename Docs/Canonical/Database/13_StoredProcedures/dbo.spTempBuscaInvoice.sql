SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTempBuscaInvoice]
		(
			@Numero		Varchar(20),
			@SAP		Char(2)
		)

as


select PS.Num_Proc,dt_conclusao from po_hio PO
Join Pedido_Ship PS on PS.num_proc=PO.num_proc_hio
Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Join Tarefas_Processos TF on TF.num_proc=num_proc_hio and  TF.ID_TASK=23
Join Pessoa_LLP PP on PP.cd_pes=cd_seller
where numero_po_hio=@numero and (selling_sap=@SAP or right(left(cd_planta,5),2)=@SAP )


union

select PS.Num_Proc,dt_conclusao from po_him PO
Join Pedido_Ship PS on PS.num_proc=PO.num_proc_him
Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Join Tarefas_Processos TF on TF.num_proc=num_proc_him and  TF.ID_TASK=23
Join Pessoa_LLP PP on PP.cd_pes=cd_seller
where numero_po_him=@numero and (selling_sap=@SAP or right(left(cd_planta,5),2)=@SAP )

union

select PS.Num_Proc,dt_conclusao from po_hia PO
Join Pedido_Ship PS on PS.num_proc=PO.num_proc_hia
Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Join Tarefas_Processos TF on TF.num_proc=num_proc_hia and  TF.ID_TASK=23
Join Pessoa_LLP PP on PP.cd_pes=cd_seller
where numero_po_hia=@numero and (selling_sap=@SAP or right(left(cd_planta,5),2)=@SAP )


GO
