SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spATL_Booking_Request_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc from Booking_Request where Num_Proc = @Num_Proc)
	Begin
		Delete Booking_Request where Num_Proc = @Num_Proc
	End

			
Commit Transaction

GO
