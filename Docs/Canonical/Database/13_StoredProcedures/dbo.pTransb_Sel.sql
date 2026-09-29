SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTransb_Sel 
(
@Num_Proc		VarChar(16)
)
AS
	If Left(@Num_Proc, 2) = 'EM' and (len(@Num_Proc) = 16 or Left(@Num_Proc, 5) = 'EMJOB')
		Begin 
			Select 
				* 
			From 
				HEM_Transb 
			Where 
				Num_Proc_HEM = @Num_Proc 
	
		End 
	
	If Left(@Num_Proc, 2) = 'IM' and (len(@Num_Proc) = 16 or Left(@Num_Proc, 5) = 'IMJOB')
		Begin 
			Select 
				* 
			From 
				HIM_Transb 
			Where 
				Num_Proc_HIM = @Num_Proc 

		End 

	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 14
		Begin 
			Select 
				* 
			From 
				MEM_Transb 
			Where 
				Num_Proc_MEM = @Num_Proc 
	
		End 
	
	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 14
		Begin 
			Select 
				* 
			From 
				MIM_Transb 
			Where 
				Num_Proc_MIM = @Num_Proc 

		End

	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 11
		Begin 
			Select 
				* 
			From 
				Prop_EM_Transb 
			Where 
				Num_Prop_EM = @Num_Proc 
	
		End 
	
	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 11
		Begin 
			Select 
				* 
			From 
				Prop_IM_Transb 
			Where 
				Num_Prop_IM = @Num_Proc 

		End

GO
