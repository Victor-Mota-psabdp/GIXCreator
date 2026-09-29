SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDemurrage_Del
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3)
)
AS
	If not exists(Select * from Item_Demurrage Where Cd_Armador = @Cd_Armador and Cd_Tp_Cont = @Cd_Tp_Cont)
		Begin 
			Delete
				Demurrage 
			Where 
				Cd_Armador = 	@Cd_Armador and 
				Cd_Tp_Cont = @Cd_Tp_Cont

			Return 1 
		End 
	Else
		Return -1

GO
