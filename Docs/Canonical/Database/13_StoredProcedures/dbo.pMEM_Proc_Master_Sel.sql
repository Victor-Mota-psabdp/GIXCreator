SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Proc_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Proc_Master_Sel 
(
@Processo 		VarChar(16)='', 
@Master 		VarChar(25)='', 
@Orderby		Char(1)='P'
)
AS
	Declare @masters  int 
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_MEM, MAWB_MEM
			From 
				Master_Exp_Mar 
			Where
				Num_Proc_MEM = @Processo
			Order by 
				MAWB_MEM
		End 
	Else
		Begin 
			If @Master <> '' 
				Begin 
					Set @Masters = IsNull((Select Count(*) From Master_Imp_Mar Where MAWB_MIM = @Master),0)
					Select 
						Num_Proc_MEM, MAWB_MEM, @Masters as Masters 
					From 
						Master_Exp_mar
					Where 
						MAWB_MEM = @Master
				End 
			Else 
				Begin 
					If @Orderby = 'P'
						Select 
							Num_Proc_MEM, MAWB_MEM
						From 
							Master_Exp_Mar
						Order by	 
							Num_Proc_MEM
					Else
						Select 							
							Num_Proc_MEM, MAWB_MEM
						From 
							Master_Exp_Mar
						Order by	 
							MAWB_MEM
				End
			
		End



GO
