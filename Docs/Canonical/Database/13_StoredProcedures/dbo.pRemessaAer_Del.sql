SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAer_Del
(
@Num_Ref_RA			Varchar(12)
) 
AS
	Begin Transaction 

	If IsNull((Select Concil_RA From Remessa_Aer Where Num_Ref_RA = @Num_Ref_RA),'S') = 'S'
		Begin 
			RollBack Transaction 
			Return - 5
		End 

	If Exists(Select Num_Proc_HEA From  Caixa_Hou_Exp_Aer Where Num_Rcb_HEA = @Num_Ref_RA)
		Begin 
			RollBack Transaction 
			Return -3 
		End 

	If Exists(Select Num_Proc_HIA From  Caixa_Hou_Imp_Aer Where Num_Rcb_HIA = @Num_Ref_RA)
		Begin 
			RollBack Transaction 
			Return -3 
		End 

	Delete 
		Remessa_Aer

	Where
		Num_Ref_RA = @Num_Ref_RA	

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
