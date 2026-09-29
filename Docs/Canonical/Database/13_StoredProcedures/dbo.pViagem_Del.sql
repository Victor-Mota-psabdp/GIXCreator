SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pViagem_Del
(
@Nr_Viagem			varchar(5),
@Ano_Viagem			int
)
AS
	Delete 
		Viagem
	Where
		Nr_Viagem = @Nr_Viagem and 
		Ano_Viagem = @Ano_Viagem
	Return @@RowCount



GO
