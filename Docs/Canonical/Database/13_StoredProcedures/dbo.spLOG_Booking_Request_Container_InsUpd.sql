SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help LOG_Booking_Request_Container
Create PROCEDURE [dbo].[spLOG_Booking_Request_Container_InsUpd]
(
	@ID_Log				bigint,
	@Dt_Alter			Datetime,
	@Tp_Oper			varchar(1),
	@Cd_Usuario			varchar(6),
	
	@Num_Proc			varchar(16),
	@Item_Cont			int,
	@Qty				int,
	@Cd_Tp_Cont			varchar(3),
	@Name_Tp_Cont		varchar(100),
	@Container_Comments	varchar(1000),
	@Cd_Pes_Haulage		varchar(10),
	@Name_Pes_Haulage	varchar(200),
	@Dt_Requested_Empty_PickUp	datetime,
	@Contact_Name		varchar(200),
	@Contact_Number		varchar(200),
	@Temperature		float,
	@Degree				varchar(2),
	@Humidity			float,
	@Vent_Status		varchar(10),
	@Length				decimal(9,3),
	@Width				decimal(9,3),
	@Height				decimal(9,3),
	@UoM				varchar(10)
)

AS

BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN
			set @Item_Cont=(select Isnull(max(Item_Cont),0)+1 from Booking_Request_Container with(nolock) where Num_Proc=@Num_Proc)

			Insert Into LOG_Booking_Request_Container
			(
				[Dt_Alter] ,[Tp_Oper] ,[Cd_Usuario],
				Num_Proc,Item_Cont,Qty,Cd_Tp_Cont,Name_Tp_Cont,Container_Comments,Cd_Pes_Haulage,
				Name_Pes_Haulage,Dt_Requested_Empty_PickUp,Contact_Name,Contact_Number,
				Temperature,Degree,Humidity,Vent_Status,Length,Width,Height,UoM
			)
			Values
			(
				Getdate(),@Tp_Oper,@Cd_Usuario,
				@Num_Proc,@Item_Cont,@Qty,@Cd_Tp_Cont,@Name_Tp_Cont,@Container_Comments,@Cd_Pes_Haulage,
				@Name_Pes_Haulage,@Dt_Requested_Empty_PickUp,@Contact_Name,@Contact_Number,
				@Temperature,@Degree,@Humidity,@Vent_Status,@Length,@Width,@Height,@UoM
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
