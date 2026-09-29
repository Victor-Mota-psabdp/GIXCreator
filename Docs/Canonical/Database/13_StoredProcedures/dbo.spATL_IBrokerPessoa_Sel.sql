SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerPessoa_Sel](
	@Num_proc varchar(16),
	@Tipo varchar(1)
)
as
Declare @ID bigint
Set @ID = (select ID from IBROKER_CAPI_V2 where JOB = @Num_proc and Status = 1)
if @ID is not NULL
	begin
		exec [dbo].spATL_IBrokerPessoaAprov_Sel @ID, @Tipo
	end
else
	begin 
		exec [dbo].spATL_IBrokerPessoaNew_Sel @Num_proc,@Tipo
	end
GO
