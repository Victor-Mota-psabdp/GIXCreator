SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE  PROCEDURE pHEA_Del 
(
@Num_Proc_HEA		varchar(16)
)
 AS
	Begin Transaction 
	Declare @Job 	VarChar(16)
	Set @Job = IsNull((Select JOB_HEA From House_Exp_Aer Where num_Proc_HEA = @Num_Proc_HEA),'')
	If @Job = '' or  (@Job <> '' and Left(@Num_Proc_HEA, 5) = 'EAJOB')
		Begin 
			If  Left(@Num_Proc_HEA, 5) = 'EAJOB' 
				Begin 
					Delete 
						Job_Exp_Aer
					Where 
						Num_Proc_HEA = @Num_Proc_HEA
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return -1	
						End 
				End 

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From Atmp_Processo Where Tmp_Processo = @Num_Proc_HEA)  

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 16
				End

			Delete SeaAir.dbo.Atmp_Processo Where TmpProcesso = @Num_Proc_HEA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 17
				End


			Delete
				House_Exp_Aer 
			Where 
				Num_Proc_HEA = @Num_Proc_HEA
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
			Insert Into House_Exp_Aer 
				(Num_Proc_HEA, Num_Proc_MEA, Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, MAWB_HEA, 
				 Cd_Consig_HEA, Cd_Export_HEA, Cd_Notify_HEA, Voo_HEA, Cd_Org_HEA, Cd_Dst_HEA, 
				ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
				Cd_Tp_Moeda, Vlr_Frete_Tot_HEA, Cd_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, 
				Prod_Perec_HEA, Cd_Cia_Aer, Cd_Sb_Ag_Nac_HEA, Cd_Dsp_HEA, EW_HEA, FOB_FCA_HEA, 
				CIF_HEA, Cli_Msq_HEA,Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
				Dt_Etg_Doc_HEA, Obs_HEA, Job_HEA)

			Select 	@JOB, 'JOB', Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, 'JOB', 
				Cd_Consig_HEA, Cd_Export_HEA, Cd_Notify_HEA, Voo_HEA, Cd_Org_HEA, Cd_Dst_HEA, 
				ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
				Cd_Tp_Moeda, Vlr_Frete_Tot_HEA, Cd_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, 
				Prod_Perec_HEA, Cd_Cia_Aer, Cd_Sb_Ag_Nac_HEA, Cd_Dsp_HEA, EW_HEA, FOB_FCA_HEA, 
				CIF_HEA, Cli_Msq_HEA,Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
				Dt_Etg_Doc_HEA, Obs_HEA, Job_HEA
			From 
				House_Exp_Aer 
			Where 
				Num_Proc_HEA = @Num_Proc_HEA

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -3
				End

			Update Cta_Cte_Hou_Exp_Aer Set Num_Proc_HEA = @Job Where Num_Proc_HEA = @Num_Proc_HEA 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -4
				End

			Update Historico_Geral Set Refer_Hist = @Job Where Refer_Hist = @Num_Proc_HEA 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -5
				End

			Update Volume_Exp_Aer Set Num_Proc_HEA = @Job Where Num_Proc_HEA = @Num_Proc_HEA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -5
				End
				
			Update Mrk_Hou_Exp_Aer Set Num_Proc_HEA = @Job Where Num_Proc_HEA = @Num_Proc_HEA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 6
				End

			Update Po_HEA Set Num_Proc_HEA = @Job Where Num_Proc_HEA = @Num_Proc_HEA
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 6
				End

			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From Atmp_Processo Where Tmp_Processo = @Job)  

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

			Delete House_Exp_Aer  Where Num_Proc_HEA = @Num_Proc_HEA 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return - 6 
				End
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End
GO
