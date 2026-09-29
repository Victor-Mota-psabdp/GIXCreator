SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spJob_Reabertos_Rel]'2016-07-01','2016-07-31'
CREATE Procedure [dbo].[spJob_Reabertos_Rel]
	@DtInicial datetime,
	@DtFinal datetime
as

select distinct
	L.num_proc			[JOB],
	TP.Nome_BDP_Produto	[Produto],
	dbo.FBusca_GrupoporJOB(L.Num_Proc)	[Grupo],
	D.Apelido			[Cliente],
	(case when C.Tp_Oper_CC = 'I' then 'Incluido'
		else
		(case when C.Tp_Oper_CC = 'A' then 'Alterado'
			else 
				(case when C.Tp_Oper_CC = 'E' then 'Excluido'
			else C.Tp_Oper_CC 
		End)End)End) [Ocorrencia],	
	TT.Nome_Tp_Tx		[Taxa],
	C.DC_CC				[D/C],
	C.Vlr_Org			[Valor],
	
	(Case when FV.FatCod is null then S.Par_Moeda else FV.Paridade end)			[Rate],
	U.Nome_Usuario		[Usuario],
	S.ID				[Numero de Registro],
	S.Nome_Usuario		[Usuario Solicitante],
	C.Data_cc	[Data],
	--convert(varchar(50),C.Data_cc,113)	[Data],
	convert(varchar(2),V.ID_Status) + '-' + P.Status_Descricao	[Status],
	max(L.dt_ins)			[Data Reabertura],	
	convert(varchar(2),L.ID_Status_old) + '-' + O.Status_Descricao	[Status Antigo]
--from [Log_Status] L
from Log_Job_SFDC L with(nolock)
	join vwALL_JOBs V with(nolock) on V.num_proc = L.num_proc
	left join Log_Cta_Cte C with(nolock) on C.Num_Proc_CC = L.num_proc and C.Data_CC > L.Dt_Ins
	left Join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx = C.Cd_Tp_Tx
	left JOin Usuario U with(nolock) on U.Cd_Usuario = C.Cd_Usuario
	left join Tipo_status_Processo P with(nolock) on P.id_status = V.id_status
	left join Tipo_status_Processo O with(nolock) on O.id_status = L.ID_Status_old
	left join Pessoa D with(nolock) on D.Cd_Pes = C.Cd_Cred_Dev
	left join vwSolPgtoCtaCte_Report S with(nolock) on C.Num_Proc_CC = S.num_proc and C.Cd_Tp_Tx = S.Cd_Tp_Tx and C.DC_CC = S.DC
	left join vwFaturasValidas FV with(nolock) on C.Num_Proc_CC = FV.num_proc and C.Cd_Tp_Tx = FV.Cd_Tp_Tx and C.DC_CC = FV.DC
	Left Join Campo_Processo		CP With(Nolock) on CP.num_proc=L.Num_Proc and Id_Campo=143
	left Join BDP_Produto	TP with(nolock) on CP.Campo_Dados = TP.ID_PD
where 
	--L. Num_Proc = 'IMCSR201605616BR'
	L.dt_ins between @DtInicial and @DtFinal	
	and V.id_status not in (5,9)
	and L.ID_Status_old in (5,8)
group by 
	L.num_proc,D.Apelido,C.Tp_Oper_CC,TT.Nome_Tp_Tx,C.DC_CC	,C.Vlr_Org,U.Nome_Usuario,C.Data_cc,
	V.ID_Status,P.Status_Descricao,L.ID_Status_old,O.Status_Descricao,S.ID,	S.Nome_Usuario,S.Par_Moeda, TP.Nome_BDP_Produto, FV.FatCod, FV.Paridade
order by 1,4,5,8,10


GO
