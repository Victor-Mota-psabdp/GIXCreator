SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSolicitacao_Retificacao_Rel]
	@Dt_Inicial as Datetime,
	@Dt_Final as Datetime
AS
select DISTINCT
	S.NUM_SOLRET					[Register Number],
	S.DT_SOLICITACAO				[Register Date],
	SOL.Nome_Usuario				[Requester],
	TR.NOME_TP_SOLRET				[Correction Type],
	S.NUM_PROC						[JOB],
	DST.Nome_Local					[Port OF Discharge],
	P.Apelido						[Consignee],
	HOU.MAWB_HIM					[MBL],
	HOU.HAWB_HIM					[HBL],
	Oper.Nome_Usuario				[Operator],
	TU.Nome_TP_Usuario_SOLRET		[Requester By],
	FUNC.Nome_Usuario				[Employee],
	S.NR_RETIFICACAO				[Correction Number],
	S.DT_RETIFICACAO				[Correction Date],
	S.NR_AUTO_INFRACAO				[Nº of Notice of Violation],
	S.DT_RCTO_AUTO_INFRACAO			[Notice Date],
	S.VL_AUTO_INFRACAO				[Value],
	S.DT_ENV_ADVOGADO				[Send Date to Advocate],	
	S.NM_ESCRITORIO_ADVOCATICIO		[Office Lawyer],
	TS.Status_Descricao				[Status]
	--S.ATIVO							[Ativo]
	
from [Solicitacao_Retificacao] S
	join LLP_IMP_Mar LLP on LLP.Num_Proc_Lim = S.NUM_PROC
	join House_Imp_Mar HOU on HOU.Num_Proc_HIM = S.NUM_PROC
	join Localidade DST on DST.Cd_Local = HOU.Cd_Dst_HIM
	join Pessoa P on Cd_Pes = HOU.Cd_Consig_HIM
	left join usuario SOL on SOL.Cd_Usuario = S.CD_SOLICITANTE
	left join usuario OPER on OPER.Cd_Usuario = S.CD_OPERADOR
	left join usuario FUNC on FUNC.Cd_Usuario = S.CD_FUNCIONARIO
	left join Tipo_Status_Solicitacao_Retificacao TS on TS.ID_Status = S.ID_STATUS
	left join Tipo_Solicitacao_Retificacao TR on TR.ID_TP_SOLRET = S.ID_TP_SOLRET
	left join Tipo_Usuario_Solicitacao_Retificacao TU on TU.ID_TP_Usuario_SOLRET = S.ID_TP_SOLRET
Where
	S.DT_SOLICITACAO between @Dt_Inicial and @Dt_Final













GO
