SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_AuditoriaCelula_Rel 'hl'
CREATE procedure [dbo].[spATL_AuditoriaCelula_Rel]

@grupo varchar(50)

as

select 
HOU.Num_Proc [JOB],
PGR.Apelido [Grupo],
US.Nome_Usuario [Customer JOB],
TP194.Dt_Conclusao [Auditoria Célula],
US194.Nome_Usuario[Customer Auditoria Célula],
TP173.Dt_Conclusao [ENVIO DE COA P/ TRANSP.]
 from vwHouse_Imp HOU with(nolock)
join Usuario	  US with(nolock) on HOU.cd_usuario = US.Cd_Usuario
left join Tarefas_Processos TP194 with(nolock) on HOU.Num_Proc = TP194.Num_Proc and TP194.ID_Task = '194'
left join Usuario US194  with(nolock) on TP194.cd_usuario = US194.Cd_Usuario
left join Tarefas_Processos TP173 with(nolock) on HOU.Num_Proc = TP173.Num_Proc and TP173.ID_Task = '173'
left join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig = PL.Cd_Pes
left join Grupo GR with(nolock) on PL.Cd_Pes_Grupo = GR.Cd_Pes_Grupo
left join Pessoa PGR with(nolock) on GR.Cd_Pes_Grupo = PGR.Cd_Pes
where HOU.ATA >= GETDATE()-365

union all

select 
HOU.Num_Proc [JOB],
PGR.Apelido [Grupo],
US.Nome_Usuario [Customer JOB],
TP194.Dt_Conclusao [Auditoria Célula],
US194.Nome_Usuario[Customer Auditoria Célula],
TP173.Dt_Conclusao [ENVIO DE COA P/ TRANSP.]
 from vwHouse_exp HOU with(nolock)
join Usuario US with(nolock) on HOU.cd_usuario = US.Cd_Usuario
left join Tarefas_Processos TP194 with(nolock) on HOU.Num_Proc = TP194.Num_Proc and TP194.ID_Task = '194'
left join Usuario US194  on TP194.cd_usuario = US194.Cd_Usuario
left join Tarefas_Processos TP173 with(nolock) on HOU.Num_Proc = TP173.Num_Proc and TP173.ID_Task = '173'
left join Pessoa_LLP PL with(nolock) on HOU.Cd_Export = PL.Cd_Pes
left join Grupo GR with(nolock) on PL.Cd_Pes_Grupo = GR.Cd_Pes_Grupo
left join Pessoa PGR with(nolock) on GR.Cd_Pes_Grupo = PGR.Cd_Pes
where HOU.ATA >= GETDATE()-365

option(hash join)
GO
