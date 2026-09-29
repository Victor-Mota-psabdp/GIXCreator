SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Agencia_Del]
(
	@Cd_Banco	varchar(3),
	@Cd_Agencia varchar(5)
)
as
	if exists(SELECT Cd_Banco FROM Agencia WHERE Cd_Banco = @Cd_Banco AND Cd_Agencia = @Cd_Agencia)
	Begin
		update Agencia set ATivo = 0 Where Cd_Banco = @Cd_Banco And Cd_Agencia = @Cd_Agencia
	End

GO
