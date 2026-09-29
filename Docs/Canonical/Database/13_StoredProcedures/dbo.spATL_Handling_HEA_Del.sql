SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Handling_HEA
CREATE procedure  [dbo].[spATL_Handling_HEA_Del]
(
	@Num_Proc	VarChar(16)	
)
as
	if exists(select Num_Proc_hea from  Handling_HEA where Num_Proc_hea=@Num_Proc)
		Begin
			Delete Handling_HEA	where Num_Proc_hea=@Num_Proc
		
		End
	

GO
