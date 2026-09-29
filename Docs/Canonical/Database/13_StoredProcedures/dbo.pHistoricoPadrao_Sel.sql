SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHistoricoPadrao_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHistoricoPadrao_Sel 
(
@Cd_Hist_Pdr 		VarChar(3)='',
@Nome_Hist_Pdr  	VarChar(30)=''
)
 AS
	If @Cd_Hist_Pdr <> '' 
		Begin 
			Select 
				*
			From 
				Historico_Padrao 
			Where 
				Cd_Hist_Pdr = @Cd_Hist_Pdr
				
		End 
	Else 
		Begin 
			If @Nome_Hist_Pdr <> ''
				Select 
					*
				From 
					Historico_Padrao 
				Where 
					Nome_Hist_Pdr  = @Nome_Hist_Pdr 				
			Else
				Select 
					*
				From 
					Historico_Padrao 
				Order by 
					Nome_Hist_Pdr
		End 



GO
