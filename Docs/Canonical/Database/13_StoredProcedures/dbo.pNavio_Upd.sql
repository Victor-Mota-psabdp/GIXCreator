SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pNavio_Upd
(
@Id_Navio			int, 
@Nome_Navio			varchar(20),
@Cd_Nacionalidade		int=Null,
@LLoyd			varchar(8)
)
AS
	
	Begin Transaction 

	Update 
		Navio 
	Set 
		Nome_Navio = @Nome_Navio, 
		Cd_Nacionalidade = @Cd_Nacionalidade,
		Lloyd =@Lloyd 
	Where 
		Id_Navio = @Id_Navio


	If @@error <> 0 or @@RowCount = 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	
	Else
		Begin 
			Commit Transaction 			
			Return 1 
		End

GO
