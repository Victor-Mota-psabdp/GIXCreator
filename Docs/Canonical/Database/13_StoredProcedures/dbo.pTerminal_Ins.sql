SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTerminal_Ins 
(
@Codigo 		Char(3)='', 
@Terminal 		VarChar(30)='',
@Cd_Term_Ofc		VarChar(7)=Null
)
AS
	If Not Exists(Select * From Terminal Where Cd_Terminal = @Codigo)
		Insert Into Terminal
			(Cd_Terminal, Nome_Terminal, Cd_Term_Ofc) 
		Values 
			(@Codigo, @Terminal, @Cd_Term_Ofc) 
	Else 
		Return -1



GO
