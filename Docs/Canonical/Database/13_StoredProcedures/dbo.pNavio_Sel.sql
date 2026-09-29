SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pNavio_Sel 
(
@ID_Navio		int=Null,
@Nome_Navio		varchar(26)='',
@LLoyd		varchar(8)=''
)
AS
	If @ID_Navio <> Null 
		Select 
			*
		From 
			Navio 
		Where
			ID_Navio = @ID_Navio
	Else
		Begin 
			If @LLoyd <> ''
				Begin 
					If @Nome_Navio <> '' 
						Select 
							*
						From
							Navio 
						Where
							LLoyd = @LLoyd and 
							Nome_Navio = @Nome_Navio 							
					Else 
						Select 
							*
						From
							Navio 
						Where
							LLoyd = @LLoyd
				End 
			Else
				Begin 
					If @Nome_Navio <> '' 
						Select 
							*
						From 
							Navio
						Where
							Nome_Navio Like @Nome_Navio
						Order by
							Nome_Navio
					Else 
						Select 
							*
						From 
							Navio
						Order by
							Nome_Navio
				End 
		End

GO
