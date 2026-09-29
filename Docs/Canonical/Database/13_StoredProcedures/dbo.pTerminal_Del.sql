SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTerminal_Del    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTerminal_Del 
(
@Codigo 	Char(3)=''
)
AS
	If Exists(Select * From Terminal Where Cd_Terminal = @Codigo)
		Delete From  
			Terminal
		Where
			Cd_Terminal = @Codigo 
	Else
		Return -1



GO
