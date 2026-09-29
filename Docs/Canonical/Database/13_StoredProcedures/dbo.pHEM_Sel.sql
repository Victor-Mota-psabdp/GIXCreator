SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pHEM_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Sel 
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
				House_Exp_Mar 
			Where
				Num_Proc_HEM = @Processo
			Order by 
				HAWB_HEM
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					*
				From 
					House_Exp_mar
				Where 
					HAWB_HEM = @House 
				
			Else 
				Select 
					*
				From 
					House_Exp_mar
				Order by 
					Num_Proc_HEM
		End




GO
