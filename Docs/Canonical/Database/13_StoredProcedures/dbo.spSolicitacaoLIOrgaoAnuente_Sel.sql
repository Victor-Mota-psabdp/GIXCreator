SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIOrgaoAnuente_Sel]
	@Num_Solicitacao Varchar(13)
as
select Nome_Orgao_Anuente,num_solicitacao from orgao_anuente
Left Join Solicitacao_LI_Orgao_Anuente on ID_Orgao_anuente=Id_Orgao and num_solicitacao=@Num_solicitacao


GO
