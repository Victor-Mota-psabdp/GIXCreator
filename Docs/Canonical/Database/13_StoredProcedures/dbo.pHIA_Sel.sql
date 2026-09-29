SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIA_Sel 
(
@Processo 		VarChar(16)='', 
@House 		VarChar(25)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				*
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
					*
				From 
					House_Imp_Aer
				Where 
					HAWB_HIA = @House 
				Order by 
					HAWB_HIA
				
			Else 
				Select 
					*
				From 
					House_Imp_Aer
				Order by 
					Num_Proc_HIA
		End



GO
