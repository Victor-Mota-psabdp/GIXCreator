SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIA_Proc_Master_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIA_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HIA, HAWB_HIA
			From 
				House_Imp_Aer
			Where
				Num_Proc_MIA = @Processo
			Order by 
				HAWB_HIA
		End 
	Else
		Begin 
			If @Master <> '' 
				Select 
					Num_Proc_HIA, HAWB_HIA
				From 
					House_Imp_Aer
				Where 
					MAWB_HIA = @Master
				
			Else 
				Select 
					Num_Proc_HIA, MAWB_HIA
				From 
					House_Imp_Aer
				Order by 
					Num_Proc_HIA
		End



GO
