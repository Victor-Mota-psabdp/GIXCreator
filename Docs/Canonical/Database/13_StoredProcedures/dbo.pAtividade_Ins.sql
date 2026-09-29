SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pAtividade_Ins    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pAtividade_Ins    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pAtividade_Ins 
(
@Cd_Tp_Ativ 	Char(3)='', 
@Atividade 	VarChar(60)=''
)
AS
	If Not Exists(Select * From Tipo_Atividade Where Cd_Tp_Ativ = @Cd_Tp_Ativ)
		Insert Into Tipo_Atividade 
			(Cd_Tp_Ativ, Nome_Tp_Ativ) 
		Values 
			(@Cd_Tp_Ativ, @Atividade ) 
	Else 
		Return -1



GO
