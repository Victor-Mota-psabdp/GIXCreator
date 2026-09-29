SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxTarMar_Del
(
@TAMID		Int,
@Cd_Tp_Tx		VarChar(30)
)
AS
	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx From Tipo_Taxa where Nome_Tp_Tx = @Cd_Tp_Tx)
	Delete  Tax_Tar_Mar Where TAMID = @TAMID and Cd_Tp_Tx = @Cd_Tp_Tx
	Return @@RowCount
GO
