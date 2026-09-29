SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEA_Proc_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEA_Proc_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEA, HAWB_HEA = Case when HAWB_HEA is null then '' else HAWB_HEA END  , MAWB_HEA = Case When MAWB_HEA is Null then '' else MAWB_HEA End
			From 
				House_Exp_Aer
			Where
				Num_Proc_HEA = @Processo and 
				Left(Num_Proc_HEA, 3) <> 'JOB' 
			Order by 
				HAWB_HEA
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HEA, HAWB_HEA = Case when HAWB_HEA is null then '' else HAWB_HEA END,  MAWB_HEA = Case When MAWB_HEA is Null then '' else MAWB_HEA End
				From 
					House_Exp_Aer
				Where 
					HAWB_HEA = @House and 
					Left(Num_Proc_HEA, 3) <> 'JOB' 
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HEA, HAWB_HEA = Case when HAWB_HEA is null then '' else HAWB_HEA END,  MAWB_HEA = Case When MAWB_HEA is Null then '' else MAWB_HEA End
						From 
							House_Exp_Aer
						Where
							Left(Num_Proc_HEA, 3) <> 'JOB'
						Order by 
							HAWB_HEA
					Else 
						Select 
							Num_Proc_HEA,  MAWB_HEA = Case When MAWB_HEA is Null then '' else MAWB_HEA End
						From 
							House_Exp_Aer
						Where
							Left(Num_Proc_HEA, 3) <> 'JOB'
						Order by 
							Num_Proc_HEA
				End 
		End
GO
