SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_JOB_Existe_Sel]
(
@JOB varchar(16)
)
as
select Num_Proc , HAWB, MAWB,ID_Status from vwALL_JOBs
where Num_Proc = @JOB

GO
