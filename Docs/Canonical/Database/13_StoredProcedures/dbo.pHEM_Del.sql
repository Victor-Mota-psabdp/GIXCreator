SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHEM_Del 
(
@Processo 		VarChar(16)
)
AS
	Declare @Job		VarChar(16)
	Begin Transaction 
	Set @JOB = IsNull((Select JOB_HEM From House_Exp_Mar Where Num_Proc_HEM = @Processo),'') 
	If @Job = '' or    (@Job <> '' and Left(@Processo, 5) = 'EMJOB')
		Begin 	
			If Substring(@Processo, 3,3) = 'JOB' 
				Begin 
					Delete 
						Job_Exp_Mar
					Where 
						Num_Proc_HEM = @Processo
	
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return -4 
						End 

				End
			Delete SeaAir.dbo.Processo_Atividade Where ProId in 
				(Select TmpProcId From Atmp_Processo Where Tmp_Processo = @Processo)  

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
				House_Exp_Mar 
			Where
				Num_Proc_HEM = @Processo
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
			Insert into House_Exp_Mar
				(Num_Proc_HEM, Num_Proc_MEM, Num_Prop_EM, Dt_Emis_HEM,Dt_Etg_BL_HEM, HAWB_HEM, 
				MAWB_HEM, Cd_Consig_HEM, Cd_Export_HEM, Cd_Notify_HEM, ID_Viagem,
				Band_Bras_HEM, Cd_Org_HEM, Cd_Dst_HEM,Cd_Sb_Ag_Nac_HEM,Trf_Vd_HEM,Tp_Frete_HEM, 
				Cd_Tp_Moeda, Vlr_Frete_Tot_HEM,Cd_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM,
				Prod_Perec_HEM, Cd_Dsp_HEM, Cli_Msq_HEM,Transp_HEM, EW_HEM, FOB_FCA_HEM, 
				CIF_HEM, Cd_Tp_Embal, Qtd_Tot_Vol_HEM, Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM,
				Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, Obs_HEM, Transito_HEM, Cd_Emissor, Navio_HEM, Viagem_HEM, Cd_Tp_Oper, Job_HEM)
			Select 
				@JOB, 'JOB', Num_Prop_EM, Dt_Emis_HEM,Dt_Etg_BL_HEM, HAWB_HEM, 
				'JOB', Cd_Consig_HEM, Cd_Export_HEM, Cd_Notify_HEM, ID_Viagem,
				Band_Bras_HEM, Cd_Org_HEM, Cd_Dst_HEM,Cd_Sb_Ag_Nac_HEM,Trf_Vd_HEM,Tp_Frete_HEM, 
				Cd_Tp_Moeda, Vlr_Frete_Tot_HEM,Cd_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM,
				Prod_Perec_HEM, Cd_Dsp_HEM, Cli_Msq_HEM,Transp_HEM, EW_HEM, FOB_FCA_HEM, 
				CIF_HEM, Cd_Tp_Embal, Qtd_Tot_Vol_HEM, Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM,
				Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, Obs_HEM, Transito_HEM, Cd_Emissor, Navio_HEM, Viagem_HEM, Cd_Tp_Oper,  @JOB 				
			From 
				House_Exp_Mar 
			Where
				Num_Proc_HEM = @Processo 

				Update Cta_Cte_Hou_Exp_Mar Set Num_Proc_HEM = @JOB Where Num_Proc_HEM = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -7
					End

				Update Prd_Hou_Exp_Mar Set Num_Proc_HEM = @JOB Where Num_Proc_HEM = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -11
					End


				Update Historico_Geral Set Refer_Hist = @Job Where Refer_Hist = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -9
					End

				Update Volume_Exp_Mar Set Num_Proc_HEM = @Job Where Num_Proc_HEM = @Processo
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -10
					End
					
				Update Mrk_Hou_Exp_Mar Set Num_Proc_HEM = @Job Where Num_Proc_HEM = @Processo
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -11
					End


				Update HEM_Transb Set Num_Proc_HEM = @Job  Where Num_Proc_HEM = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -12
					End

				Update PO_HEM Set Num_Proc_HEM = @Job  Where Num_Proc_HEM = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -42
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

				Delete House_Exp_Mar  Where Num_Proc_HEM = @Processo 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -10
					End
				Else
					Begin 
						--RollBack Transaction 
						--Return -10

						Commit Transaction 
						Return 1 
					End 
		End
GO
