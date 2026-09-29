SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_IBrokerCAPI_Sel IMGVD201409005BR

CREATE procedure [dbo].[spATL_IBrokerITEA_Sel](
	@Num_proc varchar(16)
)
as
Declare @ID bigint
Set @ID = (select ID from IBROKER_CAPI_V2 where JOB = @Num_proc and Status = 1)
if @ID is not NULL
	begin
		exec [dbo].spATL_IBrokerITEAAprov_Sel @ID
	end
else
	begin 
		exec [dbo].spATL_IBrokerITEANew_Sel @Num_proc
	end
GO
