SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Temp_New
CREATE Procedure [dbo].[spATLANTIS_Pedido_Temp_New_Sel]
(
	--@ID	BIGINT
	@ID_House_Temp BIGINT
)

as
	select 
		ID,ID_Batch,
		Cd_pedido,Num_Pedido,Cd_Buyer,Name_Buyer,Cd_Seller,Name_Seller,Incoterm,Name_Incoterm,Cd_Modal,Name_Modal,
		Cd_Tp_Moeda,Name_Moeda,vlr_pedido,Dt_Pedido,DL_Chegada,Obs_PC,Cd_Pes_CTT,cd_tp_cont,Cd_Tipo,Name_Tipo,
		Cd_Pais_Org,Name_Pais_Org,Cd_Pais_Dst,Name_Pais_Dst,Status,Name_Status,Cd_USERID,Name_USERID,Cd_CSRID,
		Name_CSRID,Cd_Grupo,Name_Grupo,Num_PO,Customer_PO,Payment,Order_Type,Cd_Consignee,Name_Consignee,Selling_SAP,
		PO_Responsible,Name_Responsible,Planta,Status_Entrega,Pedido_Retorno,Pedido_Invoice_Only,Cd_Vendor,DN_R,
		Cd_Shipper,Name_Shipper,
		ID_House_Temp,ID_Req,Intl_Reference,Id_TP_House_Temp,SystemCode,Dt_Ins			
	from 
		Pedido_Temp_New
	where
		--ID = @ID
		ID_House_Temp = @ID_House_Temp

GO
