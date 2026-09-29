SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE pHIA_Del 
(
@Num_Proc_HIA		varchar(16)
)
 AS
	Declare @JOB	VarChar(16)
	Set @JOB = IsNull((Select JOB_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA),'')
	Begin Transaction 
	If @JOB = '' or   (@Job <> '' and Left(@Num_Proc_HIA, 5) = 'IAJOB')
		Begin 
			If Substring(@Num_Proc_HIA, 3,3) = 'JOB' 
				Begin 
					Delete 
						Job_Imp_Aer
					Where 
						Num_Proc_HIA = @Num_Proc_HIA
	
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return -4 
						End 
				End

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From seaair.dbo.Atmp_Processo Where TmpProcesso = @Num_Proc_HIA)  

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 16
				End

			Delete SeaAir.dbo.Atmp_Processo Where TmpProcesso = @Num_Proc_HIA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 17
				End


			Delete
				House_Imp_Aer 
			Where 
				Num_Proc_HIA = @Num_Proc_HIA
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
			Insert Into House_Imp_Aer 
				(Num_Proc_HIA, Num_Proc_MIA, Num_Prop_IA, Dt_Emis_HIA, Cd_Tp_Etapa, HAWB_HIA, MAWB_HIA, Cd_Import_HIA,
				Cd_Consig_HIA, Cd_Export_HIA, Voo_HIA, Cd_Org_HIA, Cd_Dst_HIA, ETD_HIA, ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, 
				Tp_Frete_HIA, Cd_Tp_Moeda, Vlr_Frete_Efet_HIA, Back_Back_HIA, Cd_Sb_Ag_Int_HIA, Cd_Sb_Ag_Nac_HIA, Cd_Tp_Prod, 
				Prod_Perig_HIA, Prod_Perec_HIA, Cd_Dsp_HIA, Cli_Msq_HIA, Dt_Pri_Avs_HIA, Dt_Seg_Avs_HIA, EW_HIA, FOB_FCA_HIA, 
				CIF_HIA, Vol_Tot_HIA, Peso_Bruto_HIA, Tp_Trf_HIA, Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA, Dt_Rcb_Doc_HIA, 
				Dt_Etg_Doc_HIA, Obs_HIA, JOB_HIA)
			Select 
				@JOB, 'JOB', Num_Prop_IA, Dt_Emis_HIA, Cd_Tp_Etapa, HAWB_HIA, MAWB_HIA, Cd_Import_HIA,
				Cd_Consig_HIA, Cd_Export_HIA, Voo_HIA, Cd_Org_HIA, Cd_Dst_HIA, ETD_HIA, ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, 
				Tp_Frete_HIA, Cd_Tp_Moeda, Vlr_Frete_Efet_HIA, Back_Back_HIA, Cd_Sb_Ag_Int_HIA, Cd_Sb_Ag_Nac_HIA, Cd_Tp_Prod, 
				Prod_Perig_HIA, Prod_Perec_HIA, Cd_Dsp_HIA, Cli_Msq_HIA, Dt_Pri_Avs_HIA, Dt_Seg_Avs_HIA, EW_HIA, FOB_FCA_HIA, 
				CIF_HIA, Vol_Tot_HIA, Peso_Bruto_HIA, Tp_Trf_HIA, Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA, Dt_Rcb_Doc_HIA, 
				Dt_Etg_Doc_HIA, Obs_HIA, @JOB
			From 
				House_Imp_Aer 
			Where 
				Num_Proc_HIA = @Num_Proc_HIA 


			Update Cta_Cte_Hou_Imp_Aer Set Num_Proc_HIA = @JOB  Where Num_Proc_HIA = @Num_Proc_HIA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -7
				End

			Delete Job_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -6
				End

			Update Historico_Geral Set Refer_Hist = @JOB  Where Refer_Hist = @Num_Proc_HIA 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -9
				End

			Update Volume_Imp_Aer Set Num_Proc_HIA = @Job Where Num_Proc_HIA = @Num_Proc_HIA 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -11
				End

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From SeaAir.dbo.Atmp_Processo Where TmpProcesso = @Job)  

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 16
				End

			Delete SeaAir.dbo.Atmp_Processo Where TmpProcesso = @Job
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 17
				End

			Delete House_Imp_Aer  Where Num_Proc_HIA = @Num_Proc_HIA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -10
				End
			Else
				Begin 
					Commit Transaction
					Return 1
				End 
			
		End
GO
