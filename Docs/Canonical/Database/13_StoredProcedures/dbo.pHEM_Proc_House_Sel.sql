SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Proc_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Proc_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEM, HAWB_HEM = Case when HAWB_HEM is null then '' else HAWB_HEM END, MAWB_HEM = Case When MAWB_HEM is Null then '' else MAWB_HEM End
			From 
				House_Exp_Mar 
			Where
				Num_Proc_HEM = @Processo and 
				Left(Num_Proc_HEM, 3) <> 'JOB'
			Order by 
				HAWB_HEM
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HEM, HAWB_HEM = Case when HAWB_HEM is null then '' else HAWB_HEM END, MAWB_HEM = Case When MAWB_HEM is Null then '' else MAWB_HEM End
				From 
					House_Exp_mar
				Where 
					HAWB_HEM = @House and
					Left(Num_Proc_HEM, 3) <> 'JOB' 
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HEM, HAWB_HEM = Case when HAWB_HEM is null then '' else HAWB_HEM END, MAWB_HEM = Case When MAWB_HEM is Null then '' else MAWB_HEM End
						From 
							House_Exp_Mar
						Where
							Left(Num_Proc_HEM, 3) <> 'JOB' 
						Order by 
							HAWB_HEM
					Else 
						Select 
							Num_Proc_HEM, MAWB_HEM = Case When MAWB_HEM is Null then '' else MAWB_HEM End
						From 
							House_Exp_Mar
						Where
							Left(Num_Proc_HEM, 3) <> 'JOB' 
						Order by 
							Num_Proc_HEM
				End 
		End
GO
