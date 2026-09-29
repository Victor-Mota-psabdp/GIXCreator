SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Booking_Request_Container
CREATE Procedure [dbo].[spATL_Booking_Request_Container_Del]
(
	@Num_Proc			VarChar(16),
	@Item_Cont			int
)
			
AS
Begin Transaction

If Exists(Select Num_Proc from Booking_Request_Container where Num_Proc = @Num_Proc and Item_Cont = @Item_Cont)
	Begin
		Delete Booking_Request_Container where Num_Proc = @Num_Proc and Item_Cont = @Item_Cont
	End

			
Commit Transaction

GO
