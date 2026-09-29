SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tarefas_Processos_Temp
CREATE Procedure [dbo].[spATLANTIS_Tarefas_Processos_Temp_Sel]--'2'
(
	@ID	BIGINT
)

as
	select 
		ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,ID_TP_Temp,ID_Task,
		Name_Task,Dt_Conclusao,Dt_Previsao,cd_usuario,Dt_Insert
	from Tarefas_Processos_Temp with(nolock)
	where
		ID = @ID


GO
