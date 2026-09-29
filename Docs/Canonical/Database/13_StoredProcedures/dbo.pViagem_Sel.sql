SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pViagem_Sel 
(
@ID_Viagem		int=Null,
@Nr_Viagem		varchar(5)='',
@Ano_Viagem		int=Null,
@Porto			VarChar(3)='',
@Nome_Navio		VarChar(25)='',
@LLoyd		VarChar(8)=''
)
AS
	If @ID_Viagem = Null 
		Begin 
			If @Nr_Viagem <> '' 
				Begin 
					If @LLoyd <> '' 
						Select 
							Vg.*, Nv.*, LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto
						From 
							Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
							Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
							Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
						Where
							Nr_Viagem = @Nr_Viagem and 
							Vg.Ano_Viagem = @Ano_Viagem  and 
							Vg.Porto = @Porto and 
							Nv.Lloyd = @Lloyd 
					Else
						Select 
							Vg.*, Nv.*, LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto
						From 
							Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
							Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
							Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
						Where
							Nr_Viagem = @Nr_Viagem and 
							Vg.Ano_Viagem = @Ano_Viagem  and 
							Vg.Porto = @Porto and 
							Nv.Nome_Navio = @Nome_Navio 						
						

				End 		
			Else
				Begin 
					If @Ano_Viagem <> Null 			
						Select 
							Vg.*, Nv.*, LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto 
						From 
							Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
							Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
							Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
						Where
							Vg.Ano_Viagem = @Ano_Viagem 
					Else 
						Begin 
							If @Nome_Navio <> ''
								Select 
									Vg.*, Nv.*,  LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto
								From 
									Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
									Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
									Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
								Where
									NV.Nome_Navio = @Nome_Navio and 
									Vg.Porto = @Porto 
							Else
								Select 
									Vg.*, Nv.*,  LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto
								From 
									Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
									Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
									Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
						End 
				End 
		End 
	Else
		Select 
			Vg.*, Nv.*, LA.Nome_Loc_Atrac as Loc_Atrac, Porto.Nome_Local as Nome_Porto
		From 
			Viagem as Vg Join Navio as NV on Vg.ID_Navio = Nv.ID_Navio
			Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac = LA.ID_Loc_Atrac
			Join Localidade as Porto on Porto.Cd_Local = Vg.Porto
		Where
			Vg.Id_Viagem = @ID_Viagem

GO
