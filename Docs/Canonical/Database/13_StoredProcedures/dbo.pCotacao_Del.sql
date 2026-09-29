SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCotacao_Del
(
@Num_Cot			varchar(10)

)
AS

	Delete
		Cotacao
	Where
		Num_Cot = @Num_Cot

	Return @@RowCount

GO
