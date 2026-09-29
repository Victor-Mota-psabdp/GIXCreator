SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Solicitacao_LI_Del]
(
	@Num_Solicitacao	varchar(13)
)

as

if exists(select num_solicitacao from Solicitacao_LI where num_solicitacao=@num_solicitacao 
	and ID_Status <> 13)
	begin
		update Solicitacao_LI set ID_Status = 13 where 
			num_solicitacao=@num_solicitacao and ID_Status <> 13
	end

GO
