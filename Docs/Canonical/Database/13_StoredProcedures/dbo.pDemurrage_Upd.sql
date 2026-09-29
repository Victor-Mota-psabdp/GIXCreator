SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDemurrage_Upd
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3),
@Cd_Tp_Moeda	VarChar(3)
)
AS
	Update 
		Demurrage 
	Set 
		Cd_Tp_Moeda = @Cd_Tp_Moeda 
	Where 
		Cd_Armador = 	@Cd_Armador and 
		Cd_Tp_Cont = @Cd_Tp_Cont

GO
