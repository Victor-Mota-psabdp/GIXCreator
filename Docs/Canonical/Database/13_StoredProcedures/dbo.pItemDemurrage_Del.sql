SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItemDemurrage_Del
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3), 
@Idm_Seq		Int
)
AS
	Begin Transaction 
	If Not Exists(Select * From Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont and Idm_Seq > @Idm_Seq  )
		Begin 
			Delete
				Item_Demurrage 
			Where 
				Cd_Armador = @Cd_Armador and 
				Cd_Tp_Cont = @Cd_Tp_Cont and 
				Idm_Seq = @Idm_Seq
		
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

		End 
	Else
		Begin 
			Rollback Transaction 
			Return -1 
		End

GO
