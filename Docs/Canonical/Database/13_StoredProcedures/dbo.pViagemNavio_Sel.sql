SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pViagemNavio_Sel 
(
@ID_Viagem		Int=Null, 
@Nr_Viagem 		VarChar(5)='', 
@Ano_Viagem		Int=Null,
@Porto 			VarChar(3)=''
)
AS
	If @ID_Viagem = Null 
		Begin
			If @Nr_Viagem = '' 
				Select 
					Vg.*, Nv.Nome_Navio, Nv.LLoyd	
				From 
					Viagem as Vg Join Navio as Nv on Vg.ID_Navio = Vg.ID_Navio 
					Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac =  LA.ID_Loc_Atrac				
				Where
					Vg.Nr_Viagem = @Nr_Viagem and 
					Vg.Ano_Viagem	= @Ano_Viagem and 
					Vg.Porto = @Porto 
			Else
				Select 
					Vg.*, Nv.Nome_Navio, Nv.LLoyd	
				From 
					Viagem as Vg Join Navio as Nv on Vg.ID_Navio = Vg.ID_Navio 
					Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac =  LA.ID_Loc_Atrac
				Order by 
					 Ano_Viagem, Nr_Viagem
		End 
	Else
	Select 
		Vg.*, Nv.Nome_Navio, Nv.LLoyd	
	From 
		Viagem as Vg Join Navio as Nv on Vg.ID_Navio = Vg.ID_Navio 
		Left Outer Join Locais_Atrac as LA on Vg.ID_Loc_Atrac =  LA.ID_Loc_Atrac
GO
