SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pLocalidade_Del    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pLocalidade_Del 
(
@Cd_Local			varchar(3)
)
 AS 
	If  Exists(Select * From Localidade Where cd_Local = @Cd_Local) 
		Begin 
			Delete From Localidade Where Cd_Local = @Cd_Local
		End 
	Else
		Return -1



GO
