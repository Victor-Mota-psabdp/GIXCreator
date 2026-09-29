SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartTransshipment_Sel]
		@Num_Proc	Varchar(16)
		
As

SElect 
	Id_task,dt_previsao,dt_conclusao 
from 
	tarefas_processos with(nolock)
where 
	id_task in (38,37) and num_proc=@num_proc
GO
