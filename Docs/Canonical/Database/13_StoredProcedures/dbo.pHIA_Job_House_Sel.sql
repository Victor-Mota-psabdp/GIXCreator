SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHIA_Job_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HIA, HAWB_HIA, MAWB_HIA
			From 
				House_Imp_Aer
			Where
				Num_Proc_HIA = @Processo and 
				Left(Num_Proc_HIA, 5) = 'IAJOB'
			Order by 
				HAWB_HIA
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HIA, HAWB_HIA, MAWB_HIA 
				From 
					House_Imp_Aer
				Where 
					HAWB_HIA = @House  and
					Left(Num_Proc_HIA, 5) = 'IAJOB'
			
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HIA, HAWB_HIA, MAWB_HIA
						From 
							House_Imp_Aer
						Where
							Left(Num_Proc_HIA, 5) = 'IAJOB'
						Order by 
							HAWB_HIA
					Else 
						Select 
							Num_Proc_HIA, MAWB_HIA
						From 
							House_Imp_Aer
						Where
							Left(Num_Proc_HIA, 5) = 'IAJOB'
						Order by 
							Num_Proc_HIA
				End 
		End

GO
