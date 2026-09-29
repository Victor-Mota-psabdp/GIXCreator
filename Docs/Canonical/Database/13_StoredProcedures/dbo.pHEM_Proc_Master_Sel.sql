SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Proc_Master_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HEM, HAWB_HEM
			From 
				House_Exp_Mar 
			Where
				Num_Proc_MEM = @Processo and 
				Left(Num_Proc_MEM, 3) <> 'JOB'
			Order by 
				HAWB_HEM
		End 
	Else
		Begin 
			If @Master <> '' 
				Select 
					Num_Proc_HEM, HAWB_HEM
				From 
					House_Exp_mar
				Where 
					MAWB_HEM = @Master and 
					Left(Num_Proc_MEM, 3) <> 'JOB'
				
			Else 
				Select 
					Num_Proc_HEM, HAWB_HEM
				From 
					House_Exp_mar
				Where
					Left(Num_Proc_MEM, 3) <> 'JOB'
				Order by 
					Num_Proc_HEM
		End

GO
