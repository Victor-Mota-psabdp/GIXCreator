SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  PROCEDURE pHEA_Ins
(
@Num_Proc_MEA		varchar(14),
@JOB				VarChar(16)='', 
@Num_Prop_EA		varchar(11)=Null,
@Dt_Emis_HEA			varchar(10),
@HAWB_HEA			varchar(25),
@MAWB_HEA			varchar(25),
@Cd_Consig_HEA		varchar(10),
@Cd_Export_HEA		varchar(10),
@Cd_Notify_HEA		varchar(10),
@Voo_HEA			varchar(13),
@Cd_Org_HEA			varchar(3),
@Cd_Dst_HEA			varchar(3),
@ETD_HEA			varchar(10),
@ETA_HEA			varchar(10),
@Qtd_Tot_Vol_HEA		Float, 
@Peso_Real_HEA		Float, 
@Trf_Vd_HEA			Float, 
@Tp_Frete_HEA		char(1),
@Cd_Tp_Moeda		varchar(3),
@Vlr_Frete_Tot_HEA		Float, 
@Cd_Tp_Prod			Varchar(3),
@RE_DSE_HEA		Varchar(20),
@SD_HEA			Varchar(20),
@Prod_Perig_HEA		Char(1),
@Prod_Perec_HEA		Char(1),
@Cd_Cia_Aer			Varchar(3),
@Cd_Sb_Ag_Nac_HEA		Varchar(10),
@Cd_Dsp_HEA			Varchar(10),
@EW_HEA			Char(1),
@FOB_FCA_HEA		Char(1),
@CIF_HEA			Char(1),
@Cli_Msq_HEA			Char(1),
@Transp_HEA			Varchar(30),
@Vol_Tot_HEA			Float, 
@Peso_Bruto_HEA		Float, 
@Dt_Rcb_Doc_HEA		Varchar(10),
@Dt_Etg_Doc_HEA		Varchar(10),
@Obs_HEA			Varchar(2000),
@TpFreteMaster		Char(1),
@DtSaidaMEA			VarChar(10), 
@Usuario			VarChar(20), 
@Cd_Tp_Oper			VarChar(3), 
@Num_Proc_HEA		varchar(16)='' OUTPUT,
@HAWB_Instruct		VarChar(500)='',
@Tx_Refer_HEA		Float=0,
@Peso_Tax			Float=0 ,
@Dup_Master			int=0,
@Dead_Line			datetime = null ,
@TTime_d			smallint = 0,
@TTime_h			smallint = 0,
@Site				Char(1)='',
@Eventos			varchar(500)='',
@SAP_ShipNumber		varchar(20)=''
)
 AS
--Parmetros de Retorno 	
--(-1) Erro na Insero do House 
-- (-2) Erro na insero do Conta Corrente
-- (-3) Peso Fora dos Limites de Peso Taxa
-- (-4) Erro nas Insero da Referencia
	Declare @DespDest 	Char(1)
	Declare @DN		Char(1)
	Declare @PR		Char(1)
	Declare @PesoTaxa	Float 
	Declare @Date		VarChar(12) 
	Declare @CredDevFrt	VarChar(10)
	Declare @Stand		bit

		Set @Date = Convert(VarChar(12),GetDate(),103)

		Begin Transaction 
		If @Job <> '' 
			Set  @Stand = IsNull((Select Stand From House_Exp_Aer Where Num_Proc_HEA = @Job  ), 0) 	
		Else
			Set  @Stand = 0 

		If @Site = 'E'
			Set @Stand = 1 

		Set @MAWB_HEA = (Select MAWB_MEA From Master_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA)
		Execute pHEA_Referencia_Ins @Num_Proc_MEA , @referencia = @Num_Proc_HEA OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -1
			End 
		Insert into House_Exp_Aer 
			(Num_Proc_HEA, Num_Proc_MEA, Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, MAWB_HEA, 
			 Cd_Consig_HEA, Cd_Export_HEA, Cd_Notify_HEA, Voo_HEA, Cd_Org_HEA, Cd_Dst_HEA, 
			ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
			Cd_Tp_Moeda, Vlr_Frete_Tot_HEA, Cd_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, 
			Prod_Perec_HEA, Cd_Cia_Aer, Cd_Sb_Ag_Nac_HEA, Cd_Dsp_HEA, EW_HEA, FOB_FCA_HEA, 
			CIF_HEA, Cli_Msq_HEA,Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
			Dt_Etg_Doc_HEA, Obs_HEA, Cd_Tp_Oper, Job_HEA, HAWB_Instruct, Tx_Refer_HEA, Peso_Tax, Dead_Line, TTime_d,  TTime_h, Stand, SAP_ShipNumber)
		Values 
			(@Num_Proc_HEA, @Num_Proc_MEA, @Num_Prop_EA, @Dt_Emis_HEA, @HAWB_HEA, @MAWB_HEA, 
			 @Cd_Consig_HEA, @Cd_Export_HEA, @Cd_Notify_HEA, @Voo_HEA, @Cd_Org_HEA, @Cd_Dst_HEA, 
			 @ETD_HEA, @ETA_HEA, @Qtd_Tot_Vol_HEA, @Peso_Real_HEA, @Trf_Vd_HEA, @Tp_Frete_HEA, 
			 @Cd_Tp_Moeda, @Vlr_Frete_Tot_HEA, @Cd_Tp_Prod, @RE_DSE_HEA	, @SD_HEA, @Prod_Perig_HEA, 
			 @Prod_Perec_HEA, @Cd_Cia_Aer, @Cd_Sb_Ag_Nac_HEA, @Cd_Dsp_HEA, @EW_HEA	, @FOB_FCA_HEA, 
			 @CIF_HEA, @Cli_Msq_HEA, @Transp_HEA, @Vol_Tot_HEA, @Peso_Bruto_HEA, @Dt_Rcb_Doc_HEA, 
			@Dt_Etg_Doc_HEA, @Obs_HEA, @Cd_Tp_Oper, @JOB, @HAWB_Instruct, @Tx_Refer_HEA, @Peso_Tax, @Dead_Line, @TTime_d,  @TTime_h, @Stand, @SAP_ShipNumber) 
		If @@RowCount = 1 
 			Begin 


				Exec pEventoHouse_Ins @Eventos, @NUm_PRoc_HEA		
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return 30
					End




				If @Job <> '' 
					Begin 
						Update Cta_Cte_Hou_Exp_Aer Set Num_Proc_HEA = @Num_Proc_HEA, Dt_Ins_HEA = dbo.strhoje(getdate())  Where Num_Proc_HEA = @Job
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -2
							End

--						Delete Job_Exp_Aer Where Num_Proc_HEA = @Job
--						If @@Error <> 0 
--							Begin 
--								RollBack Transaction 
--								Return -3
--							End

						Update Historico_Geral Set Refer_Hist = @Job Where Refer_Hist = @Num_Proc_HEA 
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -4
							End
						Update Volume_Exp_Aer Set Num_Proc_HEA = @Num_Proc_HEA Where Num_Proc_HEA = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -5
							End
							
						Update Mrk_Hou_Exp_Aer Set Num_Proc_HEA = @Num_Proc_HEA Where Num_Proc_HEA = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 6
							End
						
						Update Hist_geral set hsgprocesso = @Num_Proc_HEA where hsgprocesso = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 8
							End

						Update evento_house set Num_Proc_H = @Num_Proc_HEA where Num_Proc_H = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 19
							End


						Update po_hea set Num_Proc_HEA = @Num_Proc_HEA where Num_Proc_HEA = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 27
							End



						Update House_Exp_Aer Set Stand = (Select Stand From House_Exp_Aer Where Num_Proc_HEA = @Job) Where Num_Proc_HEA = @Num_Proc_HEA
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 18
							End						

						Delete House_Exp_Aer  Where Num_Proc_HEA = @Job
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 7
							End

					End 


				If @Dup_Master = 1 
					Begin 
						Print 'Passou' 

						Insert Into Cta_Cte_Hou_Exp_Aer (Num_Proc_HEA, Cd_Tp_Tx, DC_HEA, Org_Ins_HEA, Dt_Ins_HEA, 
									Cd_Tp_Moeda, Vlr_Org_HEA, Dt_Prev_Pgto_HEA, Cd_Cred_Dev_HEA, Desp_Dst_HEA, 
									CPMF_HEA, Comp_RP_HEA, Comp_DN_HEA, Comp_CN_HEA, Comp_CPA_HEA)
						Select 
							@Num_Proc_HEA, Cd_TP_Tx, 'C', 'Sistema', @Date, Cd_Tp_Moeda, 
							Vlr_Org_MEA, Dt_Prev_Pgto_MEA, @Cd_Export_HEA, Desp_Dst_MEA, 
									CPMF_MEA, Comp_RP_MEA, Comp_DN_MEA, Comp_CN_MEA, Comp_CPA_MEA 
						From 
							cta_cte_mas_exp_aer cte 
						Where 
							Cte.Num_Proc_MEA = Left(@Num_Proc_HEA, 14) and DC_MEA = 'D'


					End 

				If (@TpFreteMaster = 'P' Or @Tp_Frete_HEA = 'P' ) and @Dup_Master = 0 
					Begin 
						--If @TpFreteMaster = 'C' And @Tp_Frete_HEA = 'C' 
						--	Begin 
						--           		Set @DespDest = 'S'
						--		Set @PR = 'N'
						--	End 
					             --Else
						--	Begin 
							            	Set @DespDest = 'N'
								Set @PR = 'S'
						--	End 
			
						If @TpFreteMaster = 'P' And @Tp_Frete_HEA = 'C' 
							Begin 
							            Set @CredDevFrt = IsNull((Select Cd_Export_MEA From Master_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA), @Cd_Export_HEA)
							            Set @DN = 'S'
							End 
					             Else
							Begin
								Set @CredDevFrt =  @Cd_Export_HEA
						            		Set @DN = 'N'
							End 
			
						Execute pCtaCteHEA_Ins @Num_Proc_HEA,'FRT', 'C', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Tot_HEA,   @DtSaidaMEA,  @CredDevFrt,  @DespDest, 'N', @PR, @DN, 'N', 'S', Null,Null, @Usuario, 'N', 1
						If @@RowCount <> 1 
							Begin 
								RollBack Transaction 
								Return -13
							End 
						Else
							Begin 
								Commit Transaction 
								Return 1 
							End 
					End 
				Else
					Begin 
						Commit Transaction 
						Return 1 
					End 
			End 
		Else
			Begin 
				RollBack Transaction
				Return -14
			End
GO
