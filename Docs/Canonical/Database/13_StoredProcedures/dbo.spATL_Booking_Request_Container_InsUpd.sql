SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Booking_Request_Container
CREATE PROCEDURE [dbo].[spATL_Booking_Request_Container_InsUpd]
(
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

Begin Transaction

	If Not Exists(Select Num_Proc from Booking_Request_Container with(nolock) where Num_Proc = @Num_Proc and Item_Cont = @Item_Cont)
		Begin
			set @Item_Cont=(select Isnull(max(Item_Cont),0)+1 from Booking_Request_Container with(nolock) where Num_Proc=@Num_Proc)
		
			Insert Into Booking_Request_Container
			(
				Num_Proc,Item_Cont,Qty,Cd_Tp_Cont,Name_Tp_Cont,Container_Comments,Cd_Pes_Haulage,
				Name_Pes_Haulage,Dt_Requested_Empty_PickUp,Contact_Name,Contact_Number,
				Temperature,Degree,Humidity,Vent_Status,Length,Width,Height,UoM
			)
			Values
			(
				@Num_Proc,@Item_Cont,@Qty,@Cd_Tp_Cont,@Name_Tp_Cont,@Container_Comments,@Cd_Pes_Haulage,
				@Name_Pes_Haulage,@Dt_Requested_Empty_PickUp,@Contact_Name,@Contact_Number,
				@Temperature,@Degree,@Humidity,@Vent_Status,@Length,@Width,@Height,@UoM
			)		
		End
	Else
		Begin
			Update
				Booking_Request_Container
			Set	
				Qty=@Qty,
				Cd_Tp_Cont=@Cd_Tp_Cont,
				Name_Tp_Cont=@Name_Tp_Cont,
				Container_Comments=@Container_Comments,
				Cd_Pes_Haulage=@Cd_Pes_Haulage,
				Name_Pes_Haulage=@Name_Pes_Haulage,
				Dt_Requested_Empty_PickUp=@Dt_Requested_Empty_PickUp,
				Contact_Name=@Contact_Name,
				Contact_Number=@Contact_Number,
				Temperature=@Temperature,
				Degree=@Degree,
				Humidity=@Humidity,
				Vent_Status=@Vent_Status,
				Length=@Length,
				Width=@Width,
				Height=@Height,
				UoM=@UoM
			Where
				Num_Proc = @Num_Proc and Item_Cont = @Item_Cont
		End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
