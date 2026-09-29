SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spJOB_HBO_Sel]
(
	@Processo		VarChar(16)
)
AS
	Select  
		[Num_Proc_HBO],
		[Num_Proc]
	From  
		JOB_HBO HOU
	Where
		HOU.Num_Proc_HBO= @Processo 
GO
