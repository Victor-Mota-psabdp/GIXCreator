SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Booking_Request_Cargo
--sp_help produto_cliente
CREATE Procedure [dbo].[spATL_Booking_Request_Cargo_Del]
(
	@Num_Proc			VarChar(16),
	--@Cd_Proc_Cliente	VarChar(30),
	@NCM				varchar(20)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc from Booking_Request_Cargo where Num_Proc = @Num_Proc and NCM = @NCM) --and Cd_Proc_Cliente = @Cd_Proc_Cliente)
	Begin
		Delete Booking_Request_Cargo where Num_Proc = @Num_Proc and NCM = @NCM --and Cd_Proc_Cliente = @Cd_Proc_Cliente
	End

			
Commit Transaction

GO
