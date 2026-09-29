SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATLDN_Viagem_LLP_Del]
(	
	@ID_Viagem		int
)
	
as
	if exists(select ID_Viagem from Viagem_LLP where ID_Viagem = @ID_Viagem)
	Begin
		update Viagem_LLP set Ativo = 0 where ID_Viagem = @ID_Viagem
	End

GO
