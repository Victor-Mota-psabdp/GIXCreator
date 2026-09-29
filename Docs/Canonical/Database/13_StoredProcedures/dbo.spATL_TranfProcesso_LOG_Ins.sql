SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TranfProcesso_LOG_Ins]
(
@Num_ProcReal Varchar(16),
@Num_Proc	 Varchar(16),
@CdUsuario	varchar(10)
)
as

insert Log_Tranf_Processo
	([Data_add],[cd_usuario],[JobMaster],[JobSelecionado])
	values
	(getdate(),@CdUsuario,@Num_ProcReal,@Num_Proc)




GO
