SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItemDemurrage_Ins
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3), 
@Idm_Per_Inic		Int, 
@Idm_Per_Fim		Int, 
@Idm_Tx		Decimal(9, 2) ,
@Idm_Seq		Int=Null OUTPUT 
)
AS
	Declare @Idm_Per_Fim_Last Int 
	Begin Transaction 
	Set @Idm_Seq	= IsNull((Select max(Idm_Seq) From Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont),0)
	If @Idm_Seq <> 0
		Set @Idm_Per_Fim_Last = (Select Idm_Per_Fim From Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont and Idm_Seq = @Idm_Seq)
	Else
		Set @Idm_Per_Fim_Last = @Idm_Per_Fim - 1

	Set @Idm_Seq	= @Idm_Seq + 1 
	
	If @Idm_Seq > 1 and ( @Idm_Per_Inic <> @Idm_Per_Fim_Last + 1 )
		Begin 	
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Item_Demurrage (Cd_Armador, Cd_Tp_Cont, Idm_Seq, Idm_Per_Inic, Idm_Per_Fim, Idm_Tx)
	values (@Cd_Armador, @Cd_Tp_Cont, @Idm_Seq, @Idm_Per_Inic, @Idm_Per_Fim, @Idm_Tx)

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return - 2 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
