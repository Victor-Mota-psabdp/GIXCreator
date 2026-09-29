SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwexc]
as

select distinct num_proc from tarefas_processos
where num_proc
like 'IMCSR2011%'
or
num_proc like 'IMCSR2010%'
GO
