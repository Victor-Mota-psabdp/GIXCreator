SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TranfCancelJOB_Upd]
(
@Num_ProcTemp varchar(16)
)
as

update LLP_Imp_Mar set ID_Status = 9
where Num_Proc_Lim = @Num_ProcTemp

update LLP_Imp_Aer set ID_Status = 9
where Num_Proc_Lia = @Num_ProcTemp



GO
