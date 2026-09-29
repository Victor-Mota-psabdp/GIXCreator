SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Proc_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Proc_House_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)='',
@Orderby		Char(1) = ''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_MIM, HAWB_HIM = Case when HAWB_HIM is null then '' else HAWB_HIM END, MAWB_HIM = Case When MAWB_HIM is Null then '' else MAWB_HIM End
			From 
				House_Imp_Mar 
			Where
				Num_Proc_HIM = @Processo 
			Order by 
				HAWB_HIM
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HIM, HAWB_HIM = Case when HAWB_HIM is null then '' else HAWB_HIM END,  MAWB_HIM = Case When MAWB_HIM is Null then '' else MAWB_HIM End
				From 
					House_Imp_mar
				Where 
					HAWB_HIM = @House 
				
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HIM, HAWB_HIM = Case when HAWB_HIM is null then '' else HAWB_HIM END,  MAWB_HIM = Case When MAWB_HIM is Null then '' else MAWB_HIM End
						From 
							House_Imp_Mar

						Order by 
							HAWB_HIM
					Else 
						Select 
							Num_Proc_HIM, HAWB_HIM = Case when HAWB_HIM is null then '' else HAWB_HIM END, MAWB_HIM = Case When MAWB_HIM is Null then '' else MAWB_HIM End
						From 
							House_Imp_Mar

						Order by 
							Num_Proc_HIM
				End 
		End
GO
