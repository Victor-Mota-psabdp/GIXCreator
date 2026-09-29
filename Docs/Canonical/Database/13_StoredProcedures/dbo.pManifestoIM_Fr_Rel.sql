SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pManifestoIM_Fr_Rel 
(
@Master		VarChar(30),
@IdViagem		Int, 
@Tp_Manif		Char(1)
)
AS
	Declare @Navio_Vg		VarChar(50)
	Declare @Dt_Atrac		DateTime 
	Declare @Dt_Previs		DateTime
	Declare @Local_Atrac		VarChar(50)
	Declare @QtdCC		Int
	Declare @Num_Proc_MIM	VarChar(30)
	Declare @Consolidador		VarChar(50) 
	Declare @Emissor		VarChar(30)
	Declare @Origem			Varchar(60)
	Declare @SubMaster		VarChar(100)
	Declare @EmissorC		VarChar(30)
	Declare @OrigemC		Varchar(30)
	Declare @SubMasterC		VarChar(100)
	Declare @NrCC			VarChar(100)
	Declare @Conteiners		VarChar(300)

	If @Tp_Manif = 'M'
		Begin 
			Set @Num_Proc_MIM = (Select Num_Proc_MIM From Master_Imp_Mar Where MAWB_MIM = @Master and Id_Viagem = @IdViagem)
			Set @QtdCC = (Select  Count(*) From Container_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM)
			Declare CurCC Cursor For 
			Select  Distinct Num_Cont_IM From Container_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM

			Set @Conteiners = '' 		

			Open CurCC 
			Fetch Next From CurCC into @NrCC 
			While @@Fetch_Status = 0 		
				Begin 
					If @Conteiners = '' 
						Set @Conteiners = @NrCC 
					Else
						Set @Conteiners = @Conteiners + ', ' + @NrCC 
					Fetch Next From CurCC into @NrCC 
				End 
			Close CurCC 
			Deallocate CurCC 

			Select 
				MAWB_MIM as Master, Nome_Navio +'/' + Nr_Viagem_Age as Navio_Vg, 
				Dt_Atrac, Dt_Previs, Nome_Loc_Atrac as Local_Atrac, 
				Ship.Nome_Raz_Soc as Consolidador, @QtdCC as Qtd_CC,
				Nome_Armador as Armador, Org.Nome_Local as Porto_Embarque,
				'' as SubMaster, '' as Emissor, '' as PortodeOrigem,
				Nome_Terminal as Terminal, Bl_Master, MIM.Id_Viagem, 
				Tp_Manifesto, Master_Cop, SubMaster_Cop, HBL_Cop, 
				SubMaster_NN_Cop, Dec_Agente, DARF, Outros, 
				Prazo, Multa_Vol, @Conteiners as Conteiners, 
				 Nome_Represent as Representante, 
				CPF_Represent as CPF_Rep, Dt_Manifesto
			From 
				Master_Imp_Mar as MIM 
				Join Viagem as Vg on Vg.Id_Viagem = MIM.ID_Viagem 
				Join Navio as Nv on Vg.Id_navio = Nv.Id_Navio 
				Join Pessoa as Ship on Ship.Cd_Pes = MIM.Cd_Export_MIM 
				Join Armador as Arm on Arm.Cd_Armador = MIM.Cd_Armador
				Join Localidade as Org on Org.Cd_Local = MIM.Cd_Org_MIM 	
				Join Terminal as Term on Term.Cd_Terminal = MIM.Cd_Terminal 
				Join Manifesto_IM as Manif on Manif.Bl_Master = @Master
				Left Outer Join Locais_Atrac as LA on LA.ID_Loc_Atrac = Vg.ID_Loc_Atrac
				Left Outer Join Represent_Manif as RM on RM.Cd_Represent = Manif.Cd_Represent
			Where 
				MAWB_MIM = @Master and MIM.Id_Viagem = @IdViagem

		
		End 
	Else
		Begin 
			Set @Emissor = ''
			Set @Origem = ''
			Set @SubMaster = ''

			Set @QtdCC = (Select  Count(Distinct Num_Cont_IM) From Container_Mas_Imp_Mar Where Num_Proc_MIM in 
			(Select Num_Proc_MIM From Master_Imp_Mar Where Sub_Master_Col_MIM = @Master and Id_Viagem = @IdViagem))

			Declare CurCC Cursor For 
			Select  Distinct  Num_Cont_IM From Container_Mas_Imp_Mar Where Num_Proc_MIM in 
			(Select Num_Proc_MIM From Master_Imp_Mar Where Sub_Master_Col_MIM = @Master and Id_Viagem = @IdViagem)

			Set @Conteiners = '' 		

			Open CurCC 
			Fetch Next From CurCC into @NrCC 
			While @@Fetch_Status = 0 		
				Begin 
					If @Conteiners = '' 
						Set @Conteiners = @NrCC 
					Else
						Set @Conteiners = @Conteiners + ', ' + @NrCC 
					Fetch Next From CurCC into @NrCC 
				End 
			Close CurCC 
			Deallocate CurCC 

			Declare CurSubM Cursor For 
				Select MAWB_MIM, Nome_Armador, Nome_Local From Master_Imp_Mar as MIM Join Armador as Arm on Arm.Cd_Armador = MIM.Cd_Armador Join Localidade as Loc on Loc.Cd_Local = MIM.Cd_Org_MIM Where Sub_Master_Col_MIM = @Master and MIM.Id_Viagem = @IdViagem

			Open CurSubM 
			
			Fetch Next From CurSubM into @SubMasterC, @EmissorC, @OrigemC
			While @@Fetch_Status = 0 
				Begin 
					If @Emissor = '' 
						Set @Emissor = @EmissorC
					Else
						Set @Emissor = @Emissor + char(13) + @EmissorC 
			
					If @Origem = '' 
						Set @Origem = @OrigemC

					Else
						Set @Origem = @Origem + char(13) + @OrigemC 

					If @SubMaster = '' 
						Set @SubMaster = @SubMasterC
					Else
						Set @SubMaster = @SubMaster + char(13) + @SubMasterC 

					Fetch Next From CurSubM into @SubMasterC, @EmissorC, @OrigemC

				End 
			Close CurSubM
			Deallocate CurSubM
			Select Distinct
				@Master as Master, Nome_Navio +'/' + Nr_Viagem_Age as Navio_Vg, 
				Dt_Atrac, Dt_Previs, Nome_Loc_Atrac as Local_Atrac, 
				Ship.Nome_Raz_Soc as Consolidador, @QtdCC as Qtd_CC,
				Nome_Armador as Armador, Org.Nome_Local as Porto_Embarque,
				@SubMaster as SubMaster, @Emissor as Emissor, @Origem as PortodeOrigem,
				Nome_Terminal as Terminal, Bl_Master, MIM.Id_Viagem, 
				Tp_Manifesto, Master_Cop, SubMaster_Cop, HBL_Cop, 
				SubMaster_NN_Cop, Dec_Agente, DARF, Outros, 
				Prazo, Multa_Vol, @Conteiners as Conteiners, 
				Nome_Represent as Representante, CPF_Represent as CPF_Rep, Dt_Manifesto
			From 
				Master_Imp_Mar as MIM 
				Join Viagem as Vg on Vg.Id_Viagem = MIM.ID_Viagem 
				Join Navio as Nv on Vg.Id_Navio = Nv.Id_Navio 
				Join Armador as Arm on Arm.Cd_Armador = MIM.Cd_Armador_SM
				Join Pessoa as Ship on Ship.Cd_Pes = MIM.Cd_Export_MIM 
				Join Terminal as Term on Term.Cd_Terminal = MIM.Cd_Terminal 
				Join Manifesto_IM as Manif on Manif.Bl_Master = @Master
				Left Outer Join Localidade as Org on Org.Cd_Local = Manif.Cd_Embarque
				Left Outer Join Locais_Atrac as LA on LA.ID_Loc_Atrac = Vg.ID_Loc_Atrac
				Left Outer Join Represent_Manif as RM on RM.Cd_Represent = Manif.Cd_Represent
			Where 
				Sub_Master_Col_MIM = @Master and MIM.Id_Viagem = @IdViagem


		End
GO
