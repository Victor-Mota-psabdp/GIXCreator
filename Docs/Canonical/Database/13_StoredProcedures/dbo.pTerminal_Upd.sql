SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTerminal_Upd
(
@Codigo 		Char(3)='', 
@Terminal 		VarChar(30)='',
@Cd_Term_Ofc		VarChar(7)=Null
)
AS
	If Exists(Select * From Terminal Where Cd_Terminal = @Codigo)
		Update
			Terminal
		Set 
			Nome_Terminal = @Terminal,
			Cd_Term_Ofc = @Cd_Term_Ofc
		Where 
			Cd_Terminal = @Codigo 
	Else
		Return -1



GO
