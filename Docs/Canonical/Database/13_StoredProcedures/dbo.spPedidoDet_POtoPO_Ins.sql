SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spPedidoDet_POtoPO_Ins]
(
@PO1 varchar(30),
@PO2 varchar(30)
)
--set @PO1='545.063'
--set @PO2='545.064'
as
	insert into Pedido_Det(	Cd_Pedido,Cd_Produto,Lote,Qty,Vlr_Item,Peso_Item,UoM,Item,NCM,NATOP,UOM_PRC,SAP_Company,
							Peso_UOM,Vlr_Total_Item,Contract,Requision,PO_GRP,Finalidade,Peso_Invoice,Peso_Bruto_TOT,
							Peso_Liquido_TOT,DN_Valida,In_Progress,Requerimento,Total_Invoice_USD,Total_Invoice_Local,UPC,Vlr_Frete)
	select
		(select top 1 cd_pedido from pedido where num_pedido=@PO2) CD_Pedido, 
		PD.Cd_Produto, 
		PD.Lote, 
		PD.Qty, 
		PD.Vlr_Item, 
		PD.Peso_Item, 
		PD.UoM, 
		isnull(cast(PD.Item as int) + cast((select max(item) from pedido_det where	cd_pedido=(select cd_pedido from pedido where num_pedido=@PO2)) as int),PD.Item) Itens,
		PD.NCM, 
		PD.NATOP, 
		PD.UOM_PRC, 
		PD.SAP_Company, 
		PD.Peso_UOM,
		PD.Vlr_Total_Item, 
		PD.Contract, 
		PD.Requision,   
		PD.PO_GRP,
		PD.Finalidade,
		PD.Peso_Invoice,
		PD.Peso_Bruto_TOT,
		PD.Peso_Liquido_TOT,
		PD.DN_Valida,
		PD.In_Progress,
		PD.Requerimento,
		PD.Total_Invoice_USD,
		PD.Total_Invoice_Local,
		PD.UPC,
		PD.Vlr_Frete
	from 
		Pedido P 
		join Pedido_Det PD on PD.cd_pedido=P.cd_pedido where P.num_pedido=@PO1







GO
