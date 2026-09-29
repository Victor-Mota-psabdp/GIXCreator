SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pHIO_Proc_House_Sel] 
(
@Processo 		VarChar(16)='', 
@House 			VarChar(25)='', 
@Orderby		Char(1)=''
)
AS
	If @Processo <> '' 
		Begin 
			Select 
				Num_Proc_HIO, HAWB_HIO, MAWB_HIO
			From 
				House_Imp_Out
			Where
				Num_Proc_HIO = @Processo
			Order by 
				HAWB_HIO
		End 
	Else
		Begin 
			If @House <> '' 
				Select 
					Num_Proc_HIO, HAWB_HIO, MAWB_HIO
				From 
					House_Imp_Out
				Where 
					HAWB_HIO = @House 
			
			Else 
				Begin 
					If @Orderby = 'H'
						Select 
							Num_Proc_HIO, HAWB_HIO, MAWB_HIO
						From 
							House_Imp_Out
						Order by 
							HAWB_HIO
					Else 
						Select 
							Num_Proc_HIO, MAWB_HIO
						From 
							House_Imp_Out
						Order by 
							Num_Proc_HIO
				End 
		End




GO
