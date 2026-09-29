SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmix_JuntaPDF_Averbado_RE_Sel]

AS

select distinct
	D.Num_Proc [JOB],
	'004' ID_DC
 from Doc_Anexos_Emix D with(nolock)
	Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = D.Num_Proc and ID_Task=15
where 
	Status = 'Averbado'
	and TP.Dt_Conclusao is not null
	and D.dt_envio is null
	
order by 1
OPTION(HASH JOIN)

--select * from Tipo_Doc_Cliente
--4	RE Number
GO
