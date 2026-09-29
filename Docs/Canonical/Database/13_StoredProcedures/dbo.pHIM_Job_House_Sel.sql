SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHIM_Job_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='',
@Orderby		Char(1) = ''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_MIM, HAWB_HIM, MAWB_HIM
			From 
				House_Imp_Mar 
			Where
				Num_Proc_HIM = @Processo and 
				Left(Num_Proc_HIM,5) = 'IMJOB'
			Order by 
				HAWB_HIM
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HIM, HAWB_HIM, MAWB_HIM
				From 
					House_Imp_mar
				Where 
					HAWB_HIM = @House and 
					Left(Num_Proc_HIM,5) = 'IMJOB'
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HIM, HAWB_HIM, MAWB_HIM
						From 
							House_Imp_Mar
						Where 
							HAWB_HIM Is Not Null and 
							Left(Num_Proc_HIM,5) = 'IMJOB'
						Order by 
							HAWB_HIM
					Else 
						Select 
							Num_Proc_HIM, HAWB_HIM, MAWB_HIM
						From 
							House_Imp_Mar
						Where
							Left(Num_Proc_HIM,5) = 'IMJOB'
						Order by 
							Num_Proc_HIM
				End 
		End

GO
