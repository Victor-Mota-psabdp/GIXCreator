SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHistorico_Geral_Del
(
@Cd_Pes			varchar(10),
@Dt_Hist			datetime
)
AS
	Delete
		Historico_Geral
	Where 
		Cd_Pes = @Cd_Pes and 
		Dt_Hist = @Dt_Hist

	Return @@RowCount

GO
