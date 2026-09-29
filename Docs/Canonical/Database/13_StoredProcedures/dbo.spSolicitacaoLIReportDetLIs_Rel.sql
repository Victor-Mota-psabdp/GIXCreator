SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolicitacaoLIReportDetLIs_Rel]
		@Num_PRoc	varchar(16)

aS

select Nome_Tp_LI,dt_solicitacao,dt_li,dt_deferimento,dt_Vencimento,num_li,Motivo, 
OA.Nome_Orgao_anuente OrgaoAnuente, 
num_requerimento [Número do Requerimento],dt_requerimento [Dt. Requerimento]
from solicitacao_li SL
Join Tipo_LI TLI						on TLI.id_tipo=SL.ID_TIPO_LI
join Solicitacao_LI_Orgao_Anuente OALI	on OALI.Num_Solicitacao	= SL.Num_Solicitacao
join Orgao_Anuente OA					on OA.ID_Orgao = OALI.ID_Orgao_anuente
Where
	NUM_PROC=@NUM_PROC


GO
