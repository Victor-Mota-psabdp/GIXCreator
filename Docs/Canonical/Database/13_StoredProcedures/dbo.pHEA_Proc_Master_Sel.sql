SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHEA_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEA, HAWB_HEA
			From 
				House_Exp_Aer 
			Where
				Num_Proc_MEA = @Processo
				and Left(Num_Proc_HEA, 3) <> 'JOB'
			Order by 
				HAWB_HEA
		End 
	Else
		Begin 
			If @Master <> '' 
				Select 
					Num_Proc_HEA, HAWB_HEA
				From 
					House_Exp_Aer
				Where
					MAWB_HEA = @Master and 
					Left(Num_Proc_HEA, 3) <> 'JOB'
				
			Else 
				Select 
					Num_Proc_HEA, HAWB_HEA
				From 
					House_Exp_Aer
				Where
					Left(Num_Proc_HEA, 3) <> 'JOB'
				Order by 
					Num_Proc_HEA
		End

GO
