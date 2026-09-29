SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDemurrage_Ins
(
@Cd_Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3),
@Cd_Tp_Moeda	VarChar(3)
)
AS
	Insert Into 
		Demurrage (CD_Armador, Cd_Tp_Cont,  Cd_Tp_Moeda) 
	Values 
		(@CD_Armador, @Cd_Tp_Cont,  @Cd_Tp_Moeda) 

GO
