SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spJOB_HBO_Vinculado_Sel]--'EAGVA201606001BR'
(
	@Num_Proc		VarChar(16)
)
AS
	Select  
		[Num_Proc_HBO],
		[Num_Proc]
	From  
		JOB_HBO HOU
		join LLP_BDP_OUT L on  L.Num_Proc_LBO = HOU.Num_Proc_HBO	
	Where
		HOU.Num_Proc= @Num_Proc
		and L.ID_Status = 4 
GO
