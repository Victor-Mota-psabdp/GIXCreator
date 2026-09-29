SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Solicitacao_LI_Orgao_Anuente
--sp_help Orgao_Anuente
CREATE Procedure [dbo].[spATL_Solicitacao_LI_Orgao_Anuente_Ins]
(
	@Num_Solicitacao	Varchar(13),
	@Nome_Orgao_Anuente	Varchar(25)
)

AS

Begin Transaction
	Declare @ID_Orgao int
	Set @ID_Orgao=(select ID_Orgao from Orgao_Anuente where Nome_Orgao_Anuente=@Nome_Orgao_Anuente)

	if not exists(select num_solicitacao from Solicitacao_LI_Orgao_Anuente where Num_Solicitacao=@Num_Solicitacao
			 and ID_Orgao_Anuente=@ID_Orgao)
		Begin
			Insert into 
					dbo.Solicitacao_LI_Orgao_Anuente
						(
							Num_Solicitacao,ID_Orgao_Anuente
						)
			Values
					(
						@Num_Solicitacao,@ID_Orgao
					)
		End

if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End
Commit Transaction

GO
