SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Booking_Request
Create PROCEDURE [dbo].[spLog_Booking_Request_InsUpd]
(
	@ID_Log				bigint,
	@Dt_Alter			Datetime,
	@Tp_Oper			varchar(1),
	@Cd_Usuario			varchar(6),
	@Num_Proc	varchar(16),
	@Cd_Armador	varchar(3),
	@Name_Armador	varchar(200),
	@Contract_Number	varchar(200),
	@Cd_Local	varchar(3),
	@Cd_Shipper	varchar(10),
	@Name_Shipper	varchar(1000),
	@Cd_Forwarder	varchar(10),
	@Name_Forwarder	varchar(1000),
	@Cd_Consignee	varchar(10),
	@Name_Consignee	varchar(1000),
	@Shipper_Reference_Number	varchar(200),
	@Forwarder_Reference_Number	varchar(200),
	@Purchase_Order_Number	varchar(200),
	@Consignee_Reference_Number	varchar(200),
	@Cd_Tp_Move	varchar(200),
	@Name_Tp_Move	varchar(200),
	@Cd_Carrier_Receipt	varchar(200),
	@Name_Carrier_Receipt	varchar(200),
	@Dt_Earliest_Departure	datetime,
	@Cd_Carrier_Delivery	varchar(200),
	@Name_Carrier_Delivery	varchar(200),
	@Dt_Latest_Delivery	datetime,
	@Cd_Org	varchar(200),
	@Name_Org	varchar(200),
	@ETD	datetime,
	@Cd_Dst	varchar(200),
	@Name_Dst	varchar(200),
	@ETA	datetime,
	@Navio	varchar(200),
	@Name_Navio	varchar(200),
	@Viagem	varchar(200),
	@Name_Viagem	varchar(200),
	@Id_Viagem	varchar(200),
	
	@Dt_Ins	datetime,
	@Cd_Pes_Grupo varchar(10),
	@Notes			 varchar(MAX),
	@Nr_Reserva		varchar(200),
	@DL_Cargo_Lem	datetime,
	@DL_Draft_Lem	datetime,
	@DL_VGM_Lem		datetime,
	@INTTRA_Ref		varchar(250),
	@Cd_Tp_Carga	int,
	@Cd_Tp_Frete	 varchar(1)
)

AS

BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN
			Insert Into Log_Booking_Request
			(
				[Dt_Alter] ,[Tp_Oper] ,
				Num_Proc,Cd_Armador,Name_Armador,Contract_Number,Cd_Local,Cd_Shipper,Name_Shipper,Cd_Forwarder,
				Name_Forwarder,Cd_Consignee,Name_Consignee,Shipper_Reference_Number,Forwarder_Reference_Number,
				Purchase_Order_Number,Consignee_Reference_Number,Cd_Tp_Move,Name_Tp_Move,Cd_Carrier_Receipt,
				Name_Carrier_Receipt,Dt_Earliest_Departure,Cd_Carrier_Delivery,Name_Carrier_Delivery,Dt_Latest_Delivery,
				Cd_Org,Name_Org,ETD,Cd_Dst,Name_Dst,ETA,Navio,Name_Navio,Viagem,Name_Viagem,Id_Viagem,Cd_Usuario,Cd_Pes_Grupo,
				Notes,Nr_Reserva,DL_Cargo_Lem,DL_Draft_Lem,DL_VGM_Lem,INTTRA_Ref
				,Cd_Tp_Carga,Cd_Tp_Frete
			)
			Values
			(
				Getdate(),@Tp_Oper,
				@Num_Proc,@Cd_Armador,@Name_Armador,@Contract_Number,@Cd_Local,@Cd_Shipper,@Name_Shipper,
				@Cd_Forwarder,@Name_Forwarder,@Cd_Consignee,@Name_Consignee,@Shipper_Reference_Number,@Forwarder_Reference_Number,
				@Purchase_Order_Number,@Consignee_Reference_Number,@Cd_Tp_Move,@Name_Tp_Move,@Cd_Carrier_Receipt,
				@Name_Carrier_Receipt,@Dt_Earliest_Departure,@Cd_Carrier_Delivery,@Name_Carrier_Delivery,@Dt_Latest_Delivery,
				@Cd_Org,@Name_Org,@ETD,@Cd_Dst,@Name_Dst,@ETA,@Navio,@Name_Navio,@Viagem,@Name_Viagem,@Id_Viagem,@Cd_Usuario,@Cd_Pes_Grupo
				,@Notes,@Nr_Reserva,@DL_Cargo_Lem,@DL_Draft_Lem,@DL_VGM_Lem,@INTTRA_Ref
				,@Cd_Tp_Carga,@Cd_Tp_Frete
			)					
			set @ID_New = @@IDENTITY
			Select @ID_New as Retorno;	
		END

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	
END


GO
