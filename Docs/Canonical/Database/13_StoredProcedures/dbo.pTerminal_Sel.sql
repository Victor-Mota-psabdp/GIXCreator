SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTerminal_Sel 
(
@Cd_Terminal		Char(3)='', 
@Terminal		VarChar(30) =''
)
 AS
	If @Cd_Terminal <> '' 
		Select 
			*
		From 
			Terminal Left Outer Join Aux_Terminal on (Terminal.Cd_Term_Ofc = Aux_Terminal.Cd_Term_Ofc)
		Where
			Cd_Terminal = @Cd_Terminal 
	Else
		Begin 
			If @Terminal <> '' 
				Select 
					*
				From 
					Terminal Left Outer Join Aux_Terminal on (Terminal.Cd_Term_Ofc = Aux_Terminal.Cd_Term_Ofc)
				Where 
					Terminal.Nome_Terminal = @Terminal 
			Else 
				Select 
					*
				From 
					Terminal Left Outer Join Aux_Terminal on (Terminal.Cd_Term_Ofc = Aux_Terminal.Cd_Term_Ofc)
				Order by 	
					Terminal.Nome_Terminal 
		End



GO
