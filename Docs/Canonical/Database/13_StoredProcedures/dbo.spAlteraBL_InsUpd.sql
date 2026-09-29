SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from altera_bl


CREATE PROCEDURE [dbo].[spAlteraBL_InsUpd]

	@num_proc			VarChar(16),
	@cmbShipper			VarChar(20),
	@txtShipper			VarChar(200),
	@cmbConsignee		VarChar(20),
	@txtConsignee		VarChar(200),
	@cmbNotify			VarChar(20),
	@txtNotify			VarChar(200),
	@cmbOrigin			VarChar(30),
	@cmbLoading			VarChar(30),
	@cmbDelivery		VarChar(30),
	@cmbFinalDestination VarChar(30),
	@cmbCarrier			VarChar(50),
	@cmbVoyage			VarChar(50),
	@txtVessel			VarChar(100),
	@cmbCiaAerea		varchar(30),
	@txtVoo				varchar(13),
	@txtVoyage			varchar(25),
	@cmbVessel			varchar(25),
	@cd_usuario			VarChar(6),
	
	@cmbIssuing			varchar(20),
	@txtIssuing			varchar(200),
	@txtCarriage		varchar(50),
	@txtCustoms			varchar(50),
	@txtAmount			varchar(50),
	@txtSignatureShipper varchar(50),
	@txtSignatureCarrier varchar(50)	

 AS

Begin Transaction

	if not exists( select * from altera_bl where num_proc = @num_proc)
		Begin
			Insert Into 
				Altera_Bl
					(
					num_proc,
					cmbShipper,
					txtShipper,
					cmbConsignee,
					txtConsignee,
					cmbNotify,
					txtNotify,
					cmbOrigin,
					cmbLoading,
					cmbDelivery,
					cmbFinalDestination,
					cmbCarrier,
					cmbVoyage,
					txtVessel,
					cmbCiaAerea,
					txtVoo,
					txtVoyage,
					cmbVessel,
					cd_usuario,
					status,
					dt_ins,
					cmbIssuing,
					txtIssuing,
					txtCarriage,
					txtCustoms,
					txtAmount,
					txtSignatureShipper,
					txtSignatureCarrier
					)
			Values
				(
					@num_proc,
					@cmbShipper,
					@txtShipper,
					@cmbConsignee,
					@txtConsignee,
					@cmbNotify,
					@txtNotify,
					@cmbOrigin,
					@cmbLoading,
					@cmbDelivery,
					@cmbFinalDestination,
					@cmbCarrier,
					@cmbVoyage,
					@txtVessel,
					@cmbCiaAerea,
					@txtVoo,
					@txtVoyage,
					@cmbVessel,					
					@cd_usuario,
					1,
					getdate(),
					@cmbIssuing,
					@txtIssuing,
					@txtCarriage,
					@txtCustoms,
					@txtAmount,
					@txtSignatureShipper,
					@txtSignatureCarrier
				)		
		End
	Else
		Begin
			Update
				Altera_Bl
			Set					
					cmbShipper = @cmbShipper,
					txtShipper = @txtShipper,
					cmbConsignee = @cmbConsignee,
					txtConsignee = @txtConsignee,
					cmbNotify = @cmbNotify,
					txtNotify = @txtNotify,
					cmbOrigin = @cmbOrigin,
					cmbLoading = @cmbLoading,
					cmbDelivery = @cmbDelivery,
					cmbFinalDestination = @cmbFinalDestination,
					cmbCarrier = @cmbCarrier,
					cmbVoyage = @cmbVoyage,
					txtVessel = @txtVessel,
					cmbCiaAerea = @cmbCiaAerea,
					txtVoo = @txtVoo,
					txtVoyage = @txtVoyage,
					cmbVessel = @cmbVessel,
					cd_usuario = @cd_usuario,					
					dt_ins = Getdate(),
					cmbIssuing = @cmbIssuing,
					txtIssuing = @txtIssuing,
					txtCarriage = @txtCarriage,
					txtCustoms = @txtCustoms,
					txtAmount = @txtAmount,
					txtSignatureShipper = @txtSignatureShipper,
					txtSignatureCarrier = @txtSignatureCarrier,
					status = 1
			Where
				Num_Proc = @num_proc
		End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
GO
