SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pClasse_Del    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pClasse_Del 
(
@Cd_Tp_Classe 	Char(3)
)
AS
	If Exists(Select * From Tipo_Classe Where Cd_Tp_Classe = @Cd_Tp_Classe)
		Delete From  
			Tipo_Classe
		Where
			Cd_Tp_Classe  = @Cd_Tp_Classe 
	Else
		Return -1



GO
