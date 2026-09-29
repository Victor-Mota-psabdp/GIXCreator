SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwSolicitacao_Retificacao_Sel] 

AS
	
select DISTINCT
	S.NUM_SOLRET					[1_Register Number],
	S.DT_SOLICITACAO				[2_Register Date],
	SOL.Nome_Usuario				[3_Requester],
	TR.NOME_TP_SOLRET				[4_Correction Type],
	S.NUM_PROC						[5_JOB],
	DST.Nome_Local					[6_Port OF Discharge],
	P.Apelido						[7_Consignee],
	HOU.MAWB_HIM					[8_MBL],
	HOU.HAWB_HIM					[9_HBL],
	Oper.Nome_Usuario				[10_Operator],
	TU.Nome_TP_Usuario_SOLRET			[11_Requester By],
	S.NR_RETIFICACAO				[12_Correction Number],
	S.DT_RETIFICACAO				[13_Correction Date],
	S.NR_AUTO_INFRACAO				[14_Nº of Notice of Violation],
	S.DT_RCTO_AUTO_INFRACAO			[15_Notice Date],
	S.VL_AUTO_INFRACAO				[16_Value],
	S.DT_ENV_ADVOGADO				[17_Send Date to Advocate],	
	S.NM_ESCRITORIO_ADVOCATICIO		[18_Office Lawyer],
	TS.Status_Descricao				[19_Status],
	FUNC.Nome_Usuario				[20_Employee]
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



GO
