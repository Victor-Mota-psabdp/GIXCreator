SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIA_Proc_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIA_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)='',
@OrderBy		Char(1)=''
)
AS
	Declare @Masters 	Int 
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_MIA, MAWB_MIA
			From 
				Master_Imp_Aer
			Where
				Num_Proc_MIA = @Processo and 
				Num_Proc_MIA <> 'JOB'
			Order by 
				MAWB_MIA
		End 
	Else
		Begin 
			If @Master <> '' 
				Begin 	
					Set @Masters = IsNull((Select Count(*) From Master_Imp_Aer Where MAWB_MIA = @Master),0)
					Select 
						Num_Proc_MIA, MAWB_MIA, @Masters as Masters 
					From 
						Master_Imp_Aer
					Where 
						MAWB_MIA = @Master and 
						Num_Proc_MIA <> 'JOB'
				End 
			Else 
				Begin 
					If @OrderBy = 'P'
						Select 
							Num_Proc_MIA, MAWB_MIA
						From 
							Master_Imp_Aer
						Where
							Num_Proc_MIA <> 'JOB'
						Order by 
							Num_Proc_MIA
					Else
						Select 
							Num_Proc_MIA, MAWB_MIA
						From 
							Master_Imp_Aer
						Where
							Num_Proc_MIA <> 'JOB'
						Order by 
							MAWB_MIA
				End 
		End

GO
