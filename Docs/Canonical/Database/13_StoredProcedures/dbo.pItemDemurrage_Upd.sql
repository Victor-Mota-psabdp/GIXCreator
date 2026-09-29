SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItemDemurrage_Upd
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3), 
@Idm_Seq		Int,
@Idm_Per_Inic		Int, 
@Idm_Per_Fim		Int, 
@Idm_Tx		Decimal(9, 2) 
)
AS
	Declare @Idm_Per_Fim_Last Int 
	Declare @Idm_Per_Inic_Last Int 
	Begin Transaction 
	If @Idm_Seq > 1 
		Begin 
			Set @Idm_Per_Fim_Last  =  (Select Idm_Per_Fim From Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont and Idm_Seq = @Idm_Seq -1)
			If @Idm_Per_Fim_Last  >= @Idm_Per_Inic 
				Begin 
					Rollback Transaction 
					Return -1 
				End 
		End 	
	Set @Idm_Per_Inic_Last = IsNull((Select Idm_Per_Inic From Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont and Idm_Seq = @Idm_Seq +1 ),0)

	If @Idm_Per_Inic_Last <> 0 and (@Idm_Per_Inic_Last <= @Idm_Per_Fim )
		Begin 
			Rollback Transaction 
			Return -2 
		End 
		

	Update 
		Item_Demurrage 
	Set 
		Idm_Per_Inic = @Idm_Per_Inic, 
		Idm_Per_Fim = @Idm_Per_Fim, 
		Idm_Tx = @Idm_Tx
	Where 
		Cd_Armador = @Cd_Armador and 
		Cd_Tp_Cont = @Cd_Tp_Cont and 
		Idm_Seq = @Idm_Seq

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return - 3
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
