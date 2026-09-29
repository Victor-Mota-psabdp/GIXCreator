SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Sel 
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
					*
				From 
					House_Imp_Mar
				Where 
					HAWB_HIM = @House 
				Order by 
					HAWB_HIM
				
			Else 
				Select 
					*
				From 
					House_Imp_mar
				Order by 
					Num_Proc_HIM
		End



GO
