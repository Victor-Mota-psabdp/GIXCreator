SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spATL_Verifica_Incoterm_Sel]
(
	@JOB varchar(16)
)
as

	select Cd_Tp_Oper from vwClienteALLJOBS
	where num_proc = @JOB
	
	
GO
