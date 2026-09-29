SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTaskVctoFatura_Sel]
As
	select
		Num_Proc , Dt_Previsao, Email
	from
		tarefas_Processos TP
		join usuario U on TP.cd_usuario=U.Cd_usuario
	where
		(dt_previsao - 7 <= getdate()) and id_task = 22 and Dt_Conclusao is null 
	order by
		dt_previsao

GO
