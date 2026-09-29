SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Log_Oper
CREATE procedure [dbo].[spATL_Tipo_Log_Oper_Del]
(
	@Cd_Tp_Log_Oper varchar(2)
)
as
	UPDATE Tipo_Log_Oper SET Status= 0 where Cd_Tp_Log_Oper= @Cd_Tp_Log_Oper

GO
