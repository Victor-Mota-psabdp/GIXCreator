SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEA_Proc_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEA_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)='',
@OrderBy		Char(1)='P'
)
AS
	Declare @Masters 	Int 
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_MEA, MAWB_MEA
			From 
				Master_Exp_Aer
			Where
				Num_Proc_MEA = @Processo
			Order by 
				MAWB_MEA
		End 
	Else
		Begin 
			If @Master <> '' 
				Begin 	
					Set @Masters = IsNull((Select Count(*) From Master_Exp_Aer Where MAWB_MEA = @Master),0)
					Select 
						Num_Proc_MEA, MAWB_MEA, @Masters as Masters 
					From 
						Master_Exp_Aer
					Where 
						MAWB_MEA = @Master
				End 
			Else 
				Begin 
					If @OrderBy = 'P'
						Select 
							Num_Proc_MEA, MAWB_MEA
						From 
							Master_Exp_Aer
						Order by 
							Num_Proc_MEA
					Else
						Select 
							Num_Proc_MEA, MAWB_MEA
						From 
							Master_Exp_Aer
						Order by 
							MAWB_MEA
				End 
		End



GO
