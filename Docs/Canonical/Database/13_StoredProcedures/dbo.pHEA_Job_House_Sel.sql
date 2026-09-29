SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHEA_Job_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEA, HAWB_HEA, MAWB_HEA
			From 
				House_Exp_Aer
			Where
				Num_Proc_HEA = @Processo
			Order by 
				HAWB_HEA
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HEA, HAWB_HEA, MAWB_HEA
				From 
					House_Exp_Aer
				Where 
					HAWB_HEA = @House 
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HEA, HAWB_HEA, MAWB_HEA
						From 
							House_Exp_Aer
						Where
							Left(Num_Proc_HEA, 5)  = 'EAJOB'
						Order by 
							HAWB_HEA
					Else 
						Select 
							Num_Proc_HEA, MAWB_HEA
						From 
							House_Exp_Aer
						Where
							Left(Num_Proc_HEA, 5)  = 'EAJOB'
						Order by 
							Num_Proc_HEA
				End 
		End

GO
