SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pArmazem_Ins    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pArmazem_Ins    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pArmazem_Ins 
(
@Codigo 	Char(3)='', 
@Armazem 	VarChar(30)=''
)
AS
	If Not Exists(Select * From Armazem Where Cd_Armazem = @Codigo)
		Insert Into Armazem 
			(Cd_Armazem, Nome_Armazem) 
		Values 
			(@Codigo, @Armazem) 
	Else 
		Return -1



GO
