SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_BuscaIncoterm_Sel]
(
	@JOB varchar(16)
)
as

	select isnull(Cd_Tp_Oper,'BDP')Cd_Tp_Oper from vwClienteALLJOBS
	where num_proc = @JOB
GO
