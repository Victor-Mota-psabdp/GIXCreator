SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_JOB_HBO_Sel]
(
	@Num_Proc_HBO	VarChar(16),
	@Num_Proc		VarChar(16),
	@Tipo			char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select  
			[Num_Proc_HBO],
			[Num_Proc]
		From  
			JOB_HBO HOU
		Where
			HOU.Num_Proc_HBO= @Num_Proc_HBO 
		
	END

	

GO
