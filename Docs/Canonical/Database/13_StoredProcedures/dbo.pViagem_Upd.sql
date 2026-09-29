SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pViagem_Upd
(
@Id_Viagem			Int, 
@Nr_Viagem			varchar(5),
@Ano_Viagem			int,
@Porto				varchar(3), 
@Dt_Previs			Datetime=Null, 	
@Dt_Atrac			datetime=Null,
@ID_Navio			int,
@ID_Loc_Atrac			int,
@Dt_Oper			datetime=Null,
@Nr_Viagem_Age		varchar(5)
)
AS
	Declare @OldPorto	VarChar(3) 
	Begin Transaction 
	Set @OldPorto = (Select Porto From Viagem  Where Id_Viagem = @Id_Viagem)
	If @OldPorto <> @Porto 
		Begin 
			If Exists(Select * From Master_Imp_Mar Where Id_Viagem = @ID_Viagem)
				Begin 
					RollBack Transaction 
					Return -5
				End 
			If Exists(Select * From Viagem Where Nr_Viagem = @Nr_Viagem and Ano_Viagem = @Ano_Viagem and Porto = @Porto)
				Begin 
					RollBack Transaction 
					Return -6 
				End 
		End 
	
	Update 
		Viagem
	Set 
		Nr_Viagem = @Nr_Viagem, 
		Ano_Viagem = @Ano_Viagem, 
		Porto = @Porto, 
		Dt_Previs = @Dt_Previs,  
		Dt_Atrac = @Dt_Atrac, 
		ID_Navio = @ID_Navio, 
		ID_Loc_Atrac = @ID_Loc_Atrac, 
		Dt_Oper = @Dt_Oper, 
		Nr_Viagem_Age = @Nr_Viagem_Age
	Where
		Id_Viagem = @Id_Viagem 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1
		End 
	

	If @Dt_Atrac <> Null  
		Begin 
			Update 
				Master_Imp_Mar 
			Set 	
				Navio_MIM = (Select Nome_Navio From Navio Where ID_Navio = @ID_Navio), 
				Dt_Atrac_MIM = dbo.StrHoje(@Dt_Atrac), 
				Dt_Oper_MIM = dbo.StrHoje(@Dt_Oper)
			Where 
				ID_Viagem = @ID_Viagem 

			If @@Error <> 0 
				Begin 
					Rollback Transaction
					Return -1
				End 

			Update 
				House_Imp_Mar
			Set 	
				Navio_HIM = (Select Nome_Navio From Navio Where ID_Navio = @ID_Navio), 
				Dt_Cheg_HIM = dbo.StrHoje(@Dt_Atrac)
			Where 
				ID_Viagem = @ID_Viagem 			

			If @@Error <> 0 
				Begin 
					Rollback Transaction
					Return -2
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End 
	Else 
		Begin
			Update 
				Master_Imp_Mar 
			Set 	
				Navio_MIM = (Select Nome_Navio From Navio Where ID_Navio = @ID_Navio), 
				Dt_Atrac_MIM = dbo.StrHoje(@Dt_Previs), 
				Dt_Oper_MIM = dbo.StrHoje(@Dt_Oper)
			Where 
				ID_Viagem = @ID_Viagem 

			If @@Error <> 0 
				Begin 
					Rollback Transaction
					Return -1
				End 

			Update 
				House_Imp_Mar
			Set 	
				Navio_HIM = (Select Nome_Navio From Navio Where ID_Navio = @ID_Navio), 
				Dt_Cheg_HIM = dbo.StrHoje(@Dt_Previs)
			Where 
				ID_Viagem = @ID_Viagem 			

			If @@Error <> 0 
				Begin 
					Rollback Transaction
					Return -2
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End
GO
