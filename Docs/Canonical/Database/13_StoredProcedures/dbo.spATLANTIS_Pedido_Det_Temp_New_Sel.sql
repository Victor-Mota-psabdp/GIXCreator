SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Temp_New
CREATE Procedure [dbo].[spATLANTIS_Pedido_Det_Temp_New_Sel]
(
	--@ID	BIGINT
	@ID_House_Temp BIGINT
)

as
	select 
		ID,Cd_Pedido,Cd_Produto,Name_Produto,Lote,Qty,Vlr_Item,Peso_Item,UoM,Name_UoM,Item,NCM,
		NATOP,UOM_PRC,SAP_Company,Peso_UOM,Vlr_Total_Item,Contract,Requision,PO_GRP,Finalidade,
		Peso_Invoice,Peso_Bruto_TOT,Peso_Liquido_TOT,DN_Valida,In_Progress,Requerimento,Total_Invoice_USD,
		Total_Invoice_Local,UPC,Vlr_Frete,Qtde_Embal,Cd_Tp_Embal,Name_Embal,
		ID_House_Temp,ID_Req,Intl_Reference	
	from 
		Pedido_Det_Temp_New
	where
		--ID = @ID
		ID_House_Temp = @ID_House_Temp

GO
