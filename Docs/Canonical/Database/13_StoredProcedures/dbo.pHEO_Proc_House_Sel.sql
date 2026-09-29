SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEO_Proc_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE [dbo].[pHEO_Proc_House_Sel] 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEO, HAWB_HEO, MAWB_HEO
			From 
				House_Exp_Out
			Where
				Num_Proc_HEO = @Processo and 
				Left(Num_Proc_HEO, 3) <> 'JOB'
			Order by 
				HAWB_HEO
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HEO, HAWB_HEO, MAWB_HEO
				From 
					House_Exp_Out
				Where 
					HAWB_HEO = @House and 
					Left(Num_Proc_HEO, 3) <> 'JOB'
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HEO, HAWB_HEO, MAWB_HEO
						From 
							House_Exp_Out
						Where
							Left(Num_Proc_HEO, 3) <> 'JOB'
						Order by 
							HAWB_HEO
					Else 
						Select 
							Num_Proc_HEO, MAWB_HEO
						From 
							House_Exp_Out
						Where
							Left(Num_Proc_HEO, 3) <> 'JOB'
						Order by 
							Num_Proc_HEO
				End 
		End


GO
