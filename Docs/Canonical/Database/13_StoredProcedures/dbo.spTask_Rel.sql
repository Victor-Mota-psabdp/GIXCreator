SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure spTask_Rel

as


select Num_proc,Nome_Task, Dt_Previsao,Dt_Conclusao from tarefas_processos TP
Join Tipo_tarefas TF on TF.ID_Task=TP.ID_Task
where ativo='S'



GO
