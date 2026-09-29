SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTipoTaxa_Del
(
@Cd_Tp_Tx			varchar(3)
)
AS
	Delete
		Tipo_Taxa 

	Where 
		Cd_Tp_Tx = @Cd_Tp_Tx

	If @@Error <> 0 
		Return -1 
	Else
		Return 1

GO
