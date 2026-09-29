SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIOrgaoAnuente_Del]
	@Num_Solicitacao	Varchar(13),
	@Nome_Orgao_Anuente	Varchar(25)

AS
Begin Transaction
	Declare @Id_Orgao_Anuente int
	Set @Id_Orgao_Anuente=(select id_orgao from orgao_Anuente where nome_orgao_anuente=@nome_orgao_anuente)

	if exists(select * from solicitacao_li_orgao_anuente where num_solicitacao=@num_solicitacao and id_orgao_anuente=@id_orgao_anuente)
		Begin
			delete	
				dbo.Solicitacao_LI_Orgao_Anuente
			Where
				num_solicitacao=@num_solicitacao and
				id_orgao_anuente=@id_orgao_anuente	
		End

if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End
Commit Transaction

GO
