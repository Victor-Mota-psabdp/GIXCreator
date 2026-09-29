SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spInt_Task]
	(
		@num_proc	Varchar(16)
	)
as



		--select * from tarefas_processos TF with(nolock)
		--Join Tipo_tarefas TT with(nolock) on tt.Id_Task=TF.Id_Task and modal=left(num_proc,2) 
		--where num_proc=@num_proc
		--and cd_pes_grupo in (select cd_pes_grupo from grupo with(nolock) where (grupo=right(left(num_proc,5),3) or grupo='BDP'))

--Alterado por Erbson 01/12/2015 --- Solicitação para atender GT Nexus
		select TT.ID_Task,Nome_Task, Dt_Previsao, Dt_Conclusao, (Case When TS.Campo_Conclusao is Null then Smart_Conclusao else TS.Campo_Conclusao end) Smart_Conclusao,(Case When TS.Campo_Previsao is Null then Smart_Previsao else TS.Campo_Previsao end) Smart_Previsao from tarefas_processos TF with(nolock)
		Join Tipo_tarefas TT with(nolock) on tt.Id_Task=TF.Id_Task and modal=left(num_proc,2) 
		left Join Task_Smart TS with(nolock) on TT.ID_Task = TS.ID_Task and TT.Modal = TS.Modal 
		where num_proc=@num_proc and cd_pes_grupo in (select cd_pes_grupo from grupo with(nolock) where (grupo=right(left(num_proc,5),3) or grupo='BDP'))	
	






 




GO
