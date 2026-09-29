SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pClasse_Ins    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pClasse_Ins 
(
@Cd_Tp_Classe 	Char(3)='', 
@Classe 		VarChar(30)=''
)
AS
	If Not Exists(Select * From Tipo_Classe Where Cd_Tp_Classe = @Cd_Tp_Classe)
		Insert Into Tipo_Classe 
			(Cd_Tp_Classe, Nome_Tp_Classe) 
		Values 
			(@Cd_Tp_Classe, @Classe ) 
	Else 
		Return -1



GO
