SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMar_Del
(
@Num_Ref_RM			Varchar(12)
) 
AS
	Begin Transaction 

	If IsNull((Select Concil_RM From Remessa_Mar Where Num_Ref_RM = @Num_Ref_RM),'S') = 'S'
		Begin 
			RollBack Transaction 
			Return - 5
		End 

	If Exists(Select Num_Proc_HEM From  Caixa_Hou_Exp_Mar Where Num_Rcb_HEM = @Num_Ref_RM)
		Begin 
			RollBack Transaction 
			Return -3 
		End 

	If Exists(Select Num_Proc_HIM From  Caixa_Hou_Imp_Mar Where Num_Rcb_HIM = @Num_Ref_RM)
		Begin 
			RollBack Transaction 
			Return -3 
		End 

	Delete 
		Remessa_Mar
	Where
		Num_Ref_RM = @Num_Ref_RM	

	If @@Error <> 0 and  @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 	
		End 
	Else 
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
