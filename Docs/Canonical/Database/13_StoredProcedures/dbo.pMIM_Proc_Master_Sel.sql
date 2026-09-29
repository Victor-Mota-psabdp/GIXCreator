SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIM_Proc_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIM_Proc_Master_Sel 
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
				Num_Proc_MIM, MAWB_MIM
			From 
				Master_Imp_Mar 
			Where
				Num_Proc_MIM = @Processo
			Order by 
				MAWB_MIM
		End 
	Else
		Begin 
			If @Master <> '' 
				Begin 	
					Set @Masters = IsNull((Select Count(*) From Master_Imp_Mar Where MAWB_MIM = @Master),0)
					Select 
						Num_Proc_MIM, MAWB_MIM, Navio_MIM, Viagem_MIM, @Masters as Masters 
					From 
						Master_Imp_Mar
					Where 
						MAWB_MIM = @Master
				End 
			Else 
				Begin 
					If @OrderBy = 'P'
						Select 
							Num_Proc_MIM, MAWB_MIM
						From 
							Master_Imp_Mar
						Order by 
							Num_Proc_MIM
					Else
						Select 
							Num_Proc_MIM, MAWB_MIM
						From 
							Master_Imp_Mar
						Order by 
							MAWB_MIM
				End 
		End



GO
