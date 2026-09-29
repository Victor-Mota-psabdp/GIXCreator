SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Handling_HEA
CREATE procedure  [dbo].[spATL_Handling_HEA_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
	
)
as

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select 
			Num_Proc_hea	[JOB],
			Hand_Hea_1		[Handling 1],
			Hand_HEA_2		[Handling 2],
			Hand_HEA_3		[Handling 3]	
		from 
			Handling_HEA 
		where 
			Num_Proc_hea=@Num_Proc
	
	End
	

GO
