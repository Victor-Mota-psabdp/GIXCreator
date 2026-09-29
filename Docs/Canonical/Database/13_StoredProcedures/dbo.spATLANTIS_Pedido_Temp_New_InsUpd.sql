SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLANTIS_Pedido_Temp_New_InsUpd]
(
		@ID					bigint,
		@ID_Batch			bigint,
		@Cd_pedido 			varchar(200),
		@Num_Pedido			Varchar(200),
		@Cd_Buyer			VarChar(200),
		@Name_Buyer			varchar(200),
		@Cd_Seller			VarChar(200),
		@Name_Seller		varchar(200),
		@Incoterm			Varchar(200),
		@Name_Incoterm		varchar(200),
		@cd_modal			varchar(200),
		@Name_Modal			varchar(200),
		@cd_tp_moeda		Varchar(200),
		@Name_Moeda			varchar(200),
		@vlr_pedido			varchar(200),
		@Dt_Pedido			varchar(200),
		@DL_Chegada			varchar(200),
		@Obs_PC				VarChar(200),
		@Cd_Pes_CTT			Varchar(200),
		@Cd_Tp_Cont			Varchar(200),
		@Cd_tipo			varchar(200),
		@Name_Tipo			varchar(200),
		@Cd_Pais_Org		VarChar(200),
		@Name_Pais_Org		varchar(200),
		@Cd_Pais_Dst		VarChar(200),
		@Name_Pais_Dst		varchar(200),
		@Status				varchar(200),
		@Name_Status		varchar(200),
		@Cd_USERID			varchar(200),
		@Name_USERID		varchar(200),
		@Cd_CSRID			varchar(200),
		@Name_CSRID			varchar(200),
		@Cd_Grupo			Varchar(200),
		@Name_Grupo			varchar(200),
		@Num_PO				Varchar(200),
		@Customer_PO		VarChar(200),
		@Payment			varchar(200),
		@Order_Type			Varchar(200),
		@Cd_Consignee		VarChar(200),
		@Name_Consignee		varchar(200),
		@Selling_SAP		varchar(200),
		@PO_Responsible		Varchar(200),
		@Name_Responsible	varchar(200),
		@Planta				varchar(200),
		@Cd_Shipper			varchar(200),
		@Name_Shipper		varchar(200),
		@ID_House_Temp		varchar(200),
		@ID_Req				varchar(200),
		@Intl_Reference		varchar(200),
		@Id_TP_House_Temp	varchar(200),
		@SystemCode			varchar(200),
		@Dt_Ins				varchar(200)
)

as


BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Pedido_Temp_new
	BEGIN TRY
	
	Declare @ID_New as bigint;

	DECLARE @Cd_pedido_temp varchar(200)
		
		IF @Name_Moeda = 'BRL'
			BEGIN
				SET @Cd_Tp_Moeda='REL'
			END
		
		set @ID = (SELECT ID FROM Pedido_Temp_New with(nolock) where Num_Pedido = @Num_Pedido)
	
		IF @ID IS NULL
			BEGIN
				SET @ID_New=(SELECT ISNULL(MAX(ID),0) FROM Pedido_Temp_New)+1
							
				INSERT INTO Pedido_Temp_New
				(
					ID,ID_Batch,
					Cd_pedido,Num_Pedido,Cd_Buyer,Name_Buyer,Cd_Seller,Name_Seller,Incoterm,Name_Incoterm,Cd_Modal,Name_Modal,
					Cd_Tp_Moeda,Name_Moeda,vlr_pedido,Dt_Pedido,DL_Chegada,Obs_PC,Cd_Pes_CTT,cd_tp_cont,Cd_Tipo,Name_Tipo,
					Cd_Pais_Org,Name_Pais_Org,Cd_Pais_Dst,Name_Pais_Dst,Status,Name_Status,Cd_USERID,Name_USERID,Cd_CSRID,
					Name_CSRID,Cd_Grupo,Name_Grupo,Num_PO,Customer_PO,Payment,Order_Type,Cd_Consignee,Name_Consignee,Selling_SAP,
					PO_Responsible,Name_Responsible,Planta,--Status_Entrega,Pedido_Retorno,Pedido_Invoice_Only,Cd_Vendor,DN_R,
					Cd_Shipper,Name_Shipper,
					ID_House_Temp,ID_Req,Intl_Reference,Id_TP_House_Temp,SystemCode,Dt_Ins	
				)			
				VALUES
				(
					@ID_New,@ID_Batch,
					@Cd_pedido,@Num_Pedido,@Cd_Buyer,@Name_Buyer,@Cd_Seller,@Name_Seller,@Incoterm,@Name_Incoterm,@Cd_Modal,@Name_Modal,
					@Cd_Tp_Moeda,@Name_Moeda,@vlr_pedido,@Dt_Pedido,@DL_Chegada,@Obs_PC,@Cd_Pes_CTT,@cd_tp_cont,@Cd_Tipo,@Name_Tipo,
					@Cd_Pais_Org,@Name_Pais_Org,@Cd_Pais_Dst,@Name_Pais_Dst,@Status,@Name_Status,@Cd_USERID,@Name_USERID,@Cd_CSRID,
					@Name_CSRID,@Cd_Grupo,@Name_Grupo,@Num_PO,@Customer_PO,@Payment,@Order_Type,@Cd_Consignee,@Name_Consignee,@Selling_SAP,
					@PO_Responsible,@Name_Responsible,@Planta,--@Status_Entrega,@Pedido_Retorno,@Pedido_Invoice_Only,@Cd_Vendor,@DN_R,
					@Cd_Shipper,@Name_Shipper,
					@ID_House_Temp,@ID_Req,@Intl_Reference,@Id_TP_House_Temp,@SystemCode,GETDATE()
				)			
			END
		ELSE
			BEGIN
				set @Cd_pedido_temp = (SELECT Cd_pedido FROM Pedido_Temp_New WHERE ID=@ID)
				IF @Cd_pedido_temp IS NULL				
		 			BEGIN
						UPDATE Pedido_Temp_New
							SET	
								ID_Batch= @ID_Batch,
								Cd_pedido =	@Cd_pedido,	
								Num_Pedido=@Num_Pedido,
								Cd_Buyer=@Cd_Buyer,Name_Buyer=@Name_Buyer,Cd_Seller=@Cd_Seller,
								Name_Seller=@Name_Seller,Incoterm=@Incoterm,
								Name_Incoterm=@Name_Incoterm,Cd_Modal=@Cd_Modal,
								Name_Modal=@Name_Modal,Cd_Tp_Moeda=@Cd_Tp_Moeda,
								Name_Moeda=@Name_Moeda,vlr_pedido=@vlr_pedido,
								Dt_Pedido=@Dt_Pedido,DL_Chegada=@DL_Chegada,
								Obs_PC=@Obs_PC,	Cd_Pes_CTT=@Cd_Pes_CTT,
								cd_tp_cont=@cd_tp_cont,Cd_Tipo=@Cd_Tipo,
								Name_Tipo=@Name_Tipo,Cd_Pais_Org=@Cd_Pais_Org,
								Name_Pais_Org=@Name_Pais_Org,Cd_Pais_Dst=@Cd_Pais_Dst,
								Name_Pais_Dst=@Name_Pais_Dst,Status=@Status,
								Name_Status=@Name_Status,Cd_USERID=@Cd_USERID,
								Name_USERID=@Name_USERID,Cd_CSRID=@Cd_CSRID,
								Name_CSRID=@Name_CSRID,Cd_Grupo=@Cd_Grupo,
								Name_Grupo=@Name_Grupo,Num_PO=@Num_PO,Customer_PO=@Customer_PO,
								Payment=@Payment,Order_Type=@Order_Type,Cd_Consignee=@Cd_Consignee,
								Name_Consignee=@Name_Consignee,Selling_SAP=@Selling_SAP,PO_Responsible=@PO_Responsible,
								Name_Responsible=@Name_Responsible,Planta=@Planta,
								--Status_Entrega=@Status_Entrega,
								--Pedido_Retorno=@Pedido_Retorno,
								--Pedido_Invoice_Only=@Pedido_Invoice_Only,
								--Cd_Vendor=@Cd_Vendor,
								--DN_R=@DN_R,
								Cd_Shipper=@Cd_Shipper,Name_Shipper=@Name_Shipper,	
								ID_House_Temp=@ID_House_Temp,
								ID_Req=@ID_Req,
								Intl_Reference=@Intl_Reference,
								Id_TP_House_Temp=@Id_TP_House_Temp,
								SystemCode=@SystemCode,
								Dt_Ins=getdate()								
							WHERE 
								ID=@ID
								
							--SET @ID_New = @ID
					  END
					  
					  SET @ID_New = @ID
			END
	
	Select @ID_New as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
