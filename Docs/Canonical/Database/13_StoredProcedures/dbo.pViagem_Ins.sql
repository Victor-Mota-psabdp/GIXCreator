SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pViagem_Ins 
(
@Nr_Viagem			varchar(5),
@Ano_Viagem			int,
@Porto				Varchar(3), 
@Dt_Previs			datetime, 
@Dt_Atrac			datetime,
@ID_Navio			int,
@ID_Loc_Atrac			int,
@Dt_Oper			datetime,
@Nr_Viagem_Age		varchar(5),
@ID_Viagem			int=Null OUTPUT
)
AS
	Set @ID_Viagem = IsNull((Select Max(Id_Viagem) From Viagem),0)+1
	Insert into Viagem
		(ID_Viagem, Nr_Viagem, Ano_Viagem, Porto, Dt_Previs, Dt_Atrac, ID_Navio, ID_Loc_Atrac, Dt_Oper, Nr_Viagem_Age) 
	Values 
		(@ID_Viagem, @Nr_Viagem, @Ano_Viagem, @Porto, @Dt_Previs, @Dt_Atrac, @ID_Navio, @ID_Loc_Atrac, @Dt_Oper, @Nr_Viagem_Age) 
	If @@Error <> 0 
		Begin 
			Set @Id_Viagem = 0
			Return -1 
		End 
	Else
		Return 1
GO
