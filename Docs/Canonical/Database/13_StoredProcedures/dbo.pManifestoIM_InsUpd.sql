SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pManifestoIM_InsUpd 
(
@Bl_Master                     VarChar(30),
@Id_Viagem		Int,
@Tp_Manifesto		Char(1), 
@Master_Cop		int,
@SubMaster_Cop	int,
@HBL_Cop		int,
@SubMaster_NN_Cop	int,
@Dec_Agente		int,
@DARF		int,
@Outros		int,
@Prazo			bit,
@Multa_Vol		varchar(100),
@Cd_Embarque		varchar(3) = Null,
@Cd_Represent		Int ,
@Dt_Manifesto		Datetime=null 
)
AS
	Begin Transaction 
	If Not Exists(Select Bl_Master From Manifesto_IM Where Bl_Master = @Bl_Master and Id_Viagem = @Id_Viagem)
		Begin 
			Insert Into 
				Manifesto_IM
				(Bl_Master, Id_Viagem, Tp_Manifesto, Master_Cop, SubMaster_Cop, HBL_Cop, SubMaster_NN_Cop, Dec_Agente, DARF, Outros, Prazo, Multa_Vol, Cd_Embarque, Cd_Represent, Dt_Manifesto)
			Values 
				(@Bl_Master, @Id_Viagem, @Tp_Manifesto,  @Master_Cop, @SubMaster_Cop, @HBL_Cop, @SubMaster_NN_Cop, @Dec_Agente, @DARF, @Outros, @Prazo, @Multa_Vol, @Cd_Embarque, @Cd_Represent, @Dt_Manifesto)
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
		End 
	Else
		Begin 
			Update 
				Manifesto_IM
			Set 
				Tp_Manifesto = @Tp_Manifesto, 
				Master_Cop = @Master_Cop, 
				SubMaster_Cop = @SubMaster_Cop, 
				HBL_Cop = @HBL_Cop, 
				SubMaster_NN_Cop = @SubMaster_NN_Cop, 
				Dec_Agente = @Dec_Agente, 
				DARF = @DARF, 
				Outros = @Outros, 
				Prazo = @Prazo, 
				Multa_Vol = @Multa_Vol,
				Cd_Embarque = @Cd_Embarque, 
				Cd_Represent = @Cd_Represent,
				Dt_Manifesto = @Dt_Manifesto
			Where
				Bl_Master = @Bl_Master and 
				Id_Viagem = @Id_Viagem

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
		End
GO
