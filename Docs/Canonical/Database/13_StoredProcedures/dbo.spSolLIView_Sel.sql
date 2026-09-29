SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Data de Deferimento, Orgão Anuente e Tipo de Regime
CREATE procedure [dbo].[spSolLIView_Sel]
(
	@Num_Proc varchar(16)
)
as
select 
	SL.Num_Solicitacao,
	TL.Nome_Tp_LI, 
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103) Dt_Solicitacao,
	SL.Num_LI,
	CONVERT(varchar(10),SL.Dt_LI,103) Dt_LI, 
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao) Status_LI ,  
	US.Nome_Usuario Solicitante,
	D.Nome_Arquivo,
	SL.Dt_Deferimento,
	OA.Nome_Orgao_Anuente,
	(RIGHT('000'+CAST(TR.id_Regime_li as varchar(2)),2) + ' - ' + TR.Regime_Li_Descricao) Regime_Li_Descricao	
from Solicitacao_LI SL with(nolock)
	join Tipo_LI TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	left join Doc_Anexos D with(nolock) on D.Num_Proc = SL.Num_Solicitacao and Id_DC = 23
	left join solicitacao_li_orgao_anuente SO  with(nolock) on SO.Num_Solicitacao = SL.Num_Solicitacao
	left join Orgao_Anuente OA with(nolock) on SO.ID_Orgao_Anuente = OA.ID_Orgao
	Left join Tipo_Regime_LI TR with(nolock) on SL.ID_Regime=TR.ID_Regime_LI
where 
	SL.Num_Proc = @Num_Proc 
order by  Sl.Dt_Solicitacao 



GO
