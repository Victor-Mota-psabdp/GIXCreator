SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxTarAer_Del
(
@TAEID		Int,
@Cd_Tp_Tx		VarChar(30)
)
AS
	Set  @Cd_Tp_Tx = (Select Cd_Tp_Tx From Tipo_Taxa Where Nome_Tp_Tx = @Cd_Tp_Tx)
	Delete  Tax_Tar_Aer Where TAEID = @TAEID and Cd_Tp_Tx = @Cd_Tp_Tx
	Return @@RowCount
GO
