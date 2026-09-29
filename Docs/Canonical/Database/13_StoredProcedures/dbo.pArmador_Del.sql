SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pArmador_Del    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pArmador_Del    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pArmador_Del 
(
@Codigo 	Char(3)=''
)
AS
	If Exists(Select * From Armador Where Cd_Armador = @Codigo)
		Delete From  
			Armador 
		Where
			Cd_Armador = @Codigo 
	Else
		Return -1



GO
