SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pArmazem_Upd    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pArmazem_Upd    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pArmazem_Upd
(
@Codigo 	Char(3)='', 
@Armazem 	VarChar(30)=''
)
AS
	If Exists(Select * From Armazem Where Cd_Armazem = @Codigo)
		Update
			 Armazem
		Set 
			Nome_Armazem = @Armazem
		Where 
			Cd_Armazem = @Codigo 
	Else
		Return -1



GO
