SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE Procedure [dbo].[spEntregaVSFaturamento_Sel]

as


select tp.num_proc,p.apelido,tp.dt_conclusao,cast(getdate()-tp.dt_conclusao as int) Dias from tarefas_processos TP
left join fatura_chb FC on tp.num_proc=fc.processo_pc
join grupo G on g.grupo=right(left(tp.num_proc,5),3)
join pessoa P on g.cd_pes_grupo=p.cd_pes
where id_task='13' and dt_conclusao is not null and left(num_proc,1)='I' and fatura_pc is null order by dias desc





GO
