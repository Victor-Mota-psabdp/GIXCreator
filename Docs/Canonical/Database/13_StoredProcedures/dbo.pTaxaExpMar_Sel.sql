SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTaxaExpMar_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTaxaExpMar_Sel 
(
@Cd_Tp_Grupo		VarChar(3), 
@Cd_Tp_Tx		VarChar(3), 
@Cd_Peso_Tx		Char(1)
)
 AS
	Select 
		*		
	From 
		Taxa_Exp_Mar
	Where
		Cd_Tp_Grupo = @Cd_Tp_Grupo and 
		Cd_Tp_Tx = @Cd_Tp_Tx and 
		Cd_Peso_Tx = @Cd_Peso_Tx



GO
