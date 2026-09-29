SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBDP_XML_OUT_Status_Sel]
(
	@Num_Proc	Varchar(16),
	@id_task		int

)
as

	Select
		Dt_Conclusao [StatusDate]	
	from 
		Tarefas_Processos PP with(nolock)
	Where  
		pp.Num_Proc =@Num_Proc and pp.ID_Task =@id_task 
GO
