SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Proc_Master_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)='' 
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HIM, HAWB_HIM
			From 
				House_Imp_Mar 
			Where
				Num_Proc_MIM = @Processo
			Order by 
				HAWB_HIM
		End 
	Else
		Begin 
			If @Master <> '' 
				Select 
					Num_Proc_HIM, HAWB_HIM
				From 
					House_Imp_mar
				Where 
					MAWB_HIM = @Master
				
			Else 
				Select 
					Num_Proc_HIM, MAWB_HIM
				From 
					House_Imp_Mar
				Order by 
					Num_Proc_HIM
								
		End



GO
