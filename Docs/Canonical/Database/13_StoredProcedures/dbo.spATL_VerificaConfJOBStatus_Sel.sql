SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spATL_VerificaConfJOBStatus_Sel]
(
	@Num_Proc varchar(16)
)
as

select 
	isnull(c.Status,'Pendente') [Status]
from vwClienteALLJOBS V			with(nolock)
	left join Confer_Job C		with(nolock) on C.Num_Proc = V.num_proc
Where
	V.num_proc = @Num_Proc
/*
ALTER procedure [dbo].[spATL_ConferenciaJOB_Sel](
	@Num_Proc varchar(16)
)
as

select * from Confer_Job with(nolock)
where num_proc = @Num_Proc
*/


GO
