SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHEM_Job_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEM, HAWB_HEM, MAWB_HEM
			From 
				House_Exp_Mar 
			Where
				Num_Proc_HEM = @Processo and Left(Num_Proc_HEM, 5) = 'EMJOB'
			Order by 
				HAWB_HEM
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HEM, HAWB_HEM, MAWB_HEM
				From 
					House_Exp_Mar
				Where 
					HAWB_HEM = @House and Left(Num_Proc_HEM, 5) = 'EMJOB'
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HEM, HAWB_HEM, MAWB_HEM
						From 
							House_Exp_Mar
						Where 
							Left(Num_Proc_HEM, 5) = 'EMJOB'
						Order by 
							HAWB_HEM
					Else 
						Select 
							Num_Proc_HEM, MAWB_HEM
						From 
							House_Exp_Mar
						Where 
							Left(Num_Proc_HEM, 5) = 'EMJOB'
						Order by 
							Num_Proc_HEM
				End 
		End

GO
