SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_VerificaNumHouse_Sel](
@House varchar(25),
@Num_Proc varchar(16)
)
as
Declare @JOBs	varchar(500) 

if exists (select Num_proc from vwCliente with(nolock) where num_proc = @Num_Proc and  Master <> 'JOB')
	begin
		select @JOBs = COALESCE(@JOBS,' ')+H.Num_Proc +',' from vwHouse_Exp H with(nolock)
		--join vwCliente C with(nolock) on H.Num_Proc = C.num_proc
		where HAWB = @House and H.num_proc <> @Num_Proc --and C.Master <> 'JOB'

		select @JOBs = COALESCE(@JOBS,' ')+H.Num_Proc +',' from vwHouse_Imp H with(nolock)
		--join vwCliente C with(nolock) on H.Num_Proc = C.num_proc
		where HAWB = @House and H.num_proc <> @Num_Proc --and C.Master <> 'JOB'
	end
Select left(@JOBs,len(@JOBs)-1) Num_Proc



GO
