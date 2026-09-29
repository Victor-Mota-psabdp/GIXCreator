SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pHIM_Del 
(
@Processo 		VarChar(16)
)
AS
	Declare @JOB 	VarChar(16) 
	Begin Transaction 
	Set @JOB = IsNull((Select JOB_HIM From House_Imp_Mar Where Num_Proc_HIM = @Processo),'')
	If @Job = '' or   (@Job <> '' and Left(@Processo, 5) = 'IMJOB')
		Begin 
			If Substring(@Processo, 3,3) = 'JOB' 
				Begin 
					Delete 
						Job_Imp_Mar
					Where 
						Num_Proc_HIM = @Processo
	
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return -4 
						End 
				End

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From seaair.dbo.Atmp_Processo Where TmpProcesso = @Processo)  

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 16
				End

			Delete SeaAir.dbo.Atmp_Processo Where TmpProcesso = @Processo
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 17
				End


			Delete From 
				House_Imp_Mar 
			Where
				Num_Proc_HIM = @Processo
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
			Insert Into 
			House_Imp_Mar 
				(Num_Proc_HIM, Num_Proc_MIM, Num_Prop_IM, Dt_Emis_HIM, HAWB_HIM, MAWB_HIM, Cd_Import_HIM, 
				Cd_Consig_HIM, Cd_Export_HIM, ID_Viagem, Band_Bras_HIM, Cd_Org_HIM, Cd_Dst_HIM, 
				Dt_Saida_HIM,  Tp_Frete_HIM, Cd_Tp_Moeda, Vlr_Frete_Efet_HIM, Prod_Perig_HIM, 
				Prod_Perec_HIM, Cd_Sb_Ag_Int_HIM, Cd_Sb_Ag_Nac_HIM, Cd_Tp_Prod, EW_HIM, FOB_FCA_HIM, 
				CIF_HIM, Cli_Msq_HIM, Cd_Porto_Rcb_HIM, Cd_Emissor, Cd_Tp_Embal, Qtd_Tot_Vol_HIM, Vol_Tot_HIM, Peso_Liquido_HIM,
				Peso_Bruto_HIM, Tp_Trf_HIM, Trf_Cp_HIM, Trf_Vd_HIM, Vlr_Frete_Negoc_HIM, Dt_Rcb_Doc_HIM, 
				Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM, Navio_HIM, Viagem_HIM, Dt_Cheg_HIM, JOB_HIM, Cd_Tp_Oper)
			Select 
				@JOB, 'JOB', Num_Prop_IM, Dt_Emis_HIM, HAWB_HIM, MAWB_HIM, Cd_Import_HIM, 
				Cd_Consig_HIM, Cd_Export_HIM, ID_Viagem, Band_Bras_HIM, Cd_Org_HIM, Cd_Dst_HIM, 
				Dt_Saida_HIM,  Tp_Frete_HIM, Cd_Tp_Moeda, Vlr_Frete_Efet_HIM, Prod_Perig_HIM, 
				Prod_Perec_HIM, Cd_Sb_Ag_Int_HIM, Cd_Sb_Ag_Nac_HIM, Cd_Tp_Prod, EW_HIM, FOB_FCA_HIM, 
				CIF_HIM, Cli_Msq_HIM, Cd_Porto_Rcb_HIM, Cd_Emissor, Cd_Tp_Embal, Qtd_Tot_Vol_HIM, Vol_Tot_HIM, Peso_Liquido_HIM,
				Peso_Bruto_HIM, Tp_Trf_HIM, Trf_Cp_HIM, Trf_Vd_HIM, Vlr_Frete_Negoc_HIM, Dt_Rcb_Doc_HIM, 
				Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM, Navio_HIM, Viagem_HIM, Dt_Cheg_HIM, @JOB, Cd_Tp_Oper
			From 
				House_Imp_Mar 	
			Where 
				Num_Proc_HIM = @Processo
			Update Cta_Cte_Hou_Imp_Mar Set Num_Proc_HIM = @JOB Where Num_Proc_HIM = @Processo 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -7
				End
			Delete Job_Imp_Mar Where Num_Proc_HIM = @Job
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -6
				End
			Update Historico_Geral Set Refer_Hist = @Job Where Refer_Hist = @Processo 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -9
				End
			Update Volume_Imp_Mar Set Num_Proc_HIM = @Job Where Num_Proc_HIM = @Processo
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -11
				End
			Update HIM_Transb Set Num_Proc_HIM = @Job  Where Num_Proc_HIM = @Processo 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -12
				End

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From seaair.dbo.Atmp_Processo Where TmpProcesso = @Job)  

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

			Delete Container_Hou_Imp_Mar  Where Num_Proc_HIM = @Processo
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return - 13
				End

			Delete House_Imp_Mar  Where Num_Proc_HIM = @Processo
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
