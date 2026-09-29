SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pNavio_Ins 
(
@Nome_Navio			varchar(20),
@Cd_Nacionalidade		int=Null,
@LLoyd			varchar(8),
@Id_Navio			int = Null OUTPUT
)
AS
	Begin Transaction 
	If Exists(Select * From Navio Where Nome_Navio = @Nome_Navio and LLoyd = @LLoyd)
		Begin 
			RollBack Transaction 
			Return - 1 
		End 
	
	Set @ID_Navio = (IsNull((Select Max(Id_Navio) From Navio),0) )+ 1
	
	Insert Into Navio (Id_Navio, Nome_Navio, Cd_Nacionalidade, LLoyd)
		Values  (@Id_Navio, @Nome_Navio, @Cd_Nacionalidade, @LLoyd)
	
	If @@Error <> 0 
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
