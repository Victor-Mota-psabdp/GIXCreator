SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIA_Proc_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIA_Proc_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HIA, HAWB_HIA = Case when HAWB_HIA is null then '' else HAWB_HIA END, MAWB_HIA = Case When MAWB_HIA  is Null then '' else MAWB_HIA End
			From 
				House_Imp_Aer
			Where
				Num_Proc_HIA = @Processo
			Order by 
				HAWB_HIA
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HIA, HAWB_HIA = Case when HAWB_HIA is null then '' else HAWB_HIA END, MAWB_HIA = Case When MAWB_HIA  is Null then '' else MAWB_HIA End
				From 
					House_Imp_Aer
				Where 
					HAWB_HIA = @House  
			
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HIA, HAWB_HIA = Case when HAWB_HIA is null then '' else HAWB_HIA END, MAWB_HIA = Case When MAWB_HIA  is Null then '' else MAWB_HIA End
						From 
							House_Imp_Aer

						Order by 
							HAWB_HIA
					Else 
						Select 
							Num_Proc_HIA, MAWB_HIA = Case When MAWB_HIA  is Null then '' else MAWB_HIA End
						From 
							House_Imp_Aer

						Order by 
							Num_Proc_HIA
				End 
		End
GO
