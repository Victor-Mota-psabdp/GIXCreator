SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Corteva_Alerts_With_Error_Sel] 
@all varchar(3)
AS
		BEGIN
			select top 300 * from Log_Tarefas_Processos_Alerta L
			where L.Num_Proc like '%CSR2025%'
			AND L.log_message like '%InnerException: Unable to write data to the transport%' 
			AND Dt_Log > GETDATE()-25
			order by dt_log desc
		END
GO
