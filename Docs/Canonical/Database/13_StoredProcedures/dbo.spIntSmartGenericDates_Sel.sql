SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spIntSmartGenericDates_Sel]-- 'IMCSR201112451BR'
		@Num_Proc	Varchar(16)

as

select
	descr_tarefa  descr,Dt_Conclusao,replace(Smart_GenericDates,'-','')  Code 
from 
	tarefas_processos TP with(nolock)
	Join Tipo_Tarefas TT with(nolock) on TT.id_task=TP.id_task and TT.modal=left(@Num_PRoc,2)
Where
	Num_Proc=@Num_Proc 
	and Smart_GenericDates is not null
	and dt_conclusao is not null
	and descr_tarefa is not null
GO
