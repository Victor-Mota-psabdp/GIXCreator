SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE pHEM_Ins
(
@Num_Proc_MEM			varchar(14), 
@Job					varchar(16)='',
@Num_Prop				varchar(11)='',
@Dt_Emis				varchar(10),
@Dt_Etg_BL_HEM			varchar(10), 
@HAWB				varchar(25),
@MAWB				varchar(25),
@Cd_Consig				varchar(10),
@Cd_Export				varchar(10), 
@Cd_Notify				varchar(10), 
@Band_Bras				char(1), 
@Cd_Org				varchar(3),
@Cd_Dst				varchar(3), 
@Cd_Sb_Ag_Nac			varchar(10),
@Trf_Vd				Float, 
@Tp_Frete				char(1),
@Cd_Tp_Moeda			varchar(3), 
@Vlr_Frete_Tot				Float, 
@Cd_Tp_Prod				varchar(3), 
@RE_DSE				varchar(15), 
@SD					varchar(15), 
@Prod_Perig				char(1), 
@Prod_Perec				char(1),
@Cd_Dsp				varchar(10), 
@Cli_Msq				char(1), 
@Transp				varchar(30), 
@EW					char(1), 
@FOB_FCA				char(1), 
@CIF					char(1), 
@Cd_Tp_Embal				varchar(3),
@Qtd_Tot_Vol				Float, 
@Vol_Tot				Float, 
@Peso_Liquido				Float, 
@Peso_Bruto				Float,
@Dt_Rcb_Crg				varchar(10),
@Dt_Rcb_Doc				varchar(10),
@Obs					varchar(2000),
@Transito_HEM				Char(1)=Null, 
@TpFreteMaster			Char(1), 
@DtSaidaMEM				VarChar(10), 
@Usuario				VarChar(20),
@Cd_Emissor				VarChar(4)=Null, 
@Navio					VarChar(15)='',
@Viagem				VarChar(5)='',
@Cd_Tp_Oper				VarChar(3), 
@Num_Proc_HEM			varchar(16) ='' OUTPUT,
@Dup_Master				bit=0 , 
@Dead_Line				datetime= null, 
@TTime_d				int=null,
@TTime_h				int=null,
@Site					char(1) = '',
@Eventos				varchar(500)='',
@SAP_ShipNumber			varchar(20)='',
@CourrierCode				varchar(20)=''

)
 AS
--Parâmetros de Retorno 	
--(-1) Erro na Inserção do House 
-- (-2) Erro na inserção do Conta Corrente
-- (-3) Peso Fora dos Limites de Peso Taxa
-- (-4) Erro nas Inserção da Referencia
	Declare @DespDest 	Char(1)
	Declare @DN		Char(1)
	Declare @PR		Char(1)
	Declare @PesoTaxa	Float 
	Declare @Date		VarChar(12) 
	Declare @ID_Viagem	Int
	Declare @CredDevFrt	VarChar(10)
	Declare @Stand		Bit 

		Set @Date = Convert(VarChar(12),GetDate(),103)
		Begin Transaction 



		Set @MAWB = (Select MAWB_MEM From Master_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM)
		Set @ID_Viagem = (Select ID_Viagem From Master_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM)
		If @Job <> '' 
			Set  @Stand = IsNull((Select Stand From House_Exp_Mar Where Num_Proc_HEM = @Job  ), 0) 	
		Else
			Set  @Stand = 0 

		If @Site = 'E'
			Set @Stand = 1

		Execute pHEM_Referencia_Ins @Num_Proc_MEM , @referencia = @Num_Proc_HEM OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -4
			End 
		Insert into House_Exp_Mar
			(Num_Proc_HEM, Num_Proc_MEM, Num_Prop_EM, Dt_Emis_HEM,Dt_Etg_BL_HEM, HAWB_HEM, 
			MAWB_HEM, Cd_Consig_HEM, Cd_Export_HEM, Cd_Notify_HEM, ID_Viagem,
			Band_Bras_HEM, Cd_Org_HEM, Cd_Dst_HEM,Cd_Sb_Ag_Nac_HEM,Trf_Vd_HEM,Tp_Frete_HEM, 
			Cd_Tp_Moeda, Vlr_Frete_Tot_HEM,Cd_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM,
			Prod_Perec_HEM, Cd_Dsp_HEM, Cli_Msq_HEM,Transp_HEM, EW_HEM, FOB_FCA_HEM, 
			CIF_HEM, Cd_Tp_Embal, Qtd_Tot_Vol_HEM, Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM,
			Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, Obs_HEM, Transito_HEM, Cd_Emissor, Navio_HEM, Viagem_HEM, 
			Cd_Tp_Oper, JOB_HEM, Dead_Line, TTime_D, TTime_h, Stand, SAP_ShipNumber, CourrierCode	) 
		Values 
			(@Num_Proc_HEM ,@Num_Proc_MEM, @Num_Prop, @Dt_Emis, @Dt_Etg_BL_HEM, @HAWB, 
			 @MAWB,@Cd_Consig, @Cd_Export, @Cd_Notify, @ID_Viagem, @Band_Bras, @Cd_Org, 
			 @Cd_Dst, @Cd_Sb_Ag_Nac, @Trf_Vd, @Tp_Frete, @Cd_Tp_Moeda, @Vlr_Frete_Tot, @Cd_Tp_Prod,
			 @RE_DSE, @SD, @Prod_Perig, @Prod_Perec, @Cd_Dsp, @Cli_Msq, @Transp, @EW, @FOB_FCA, 
			 @CIF, @Cd_Tp_Embal, @Qtd_Tot_Vol, @Vol_Tot, @Peso_Liquido, @Peso_Bruto, @Dt_Rcb_Crg,
			 @Dt_Rcb_Doc, @Obs, @Transito_HEM, @Cd_Emissor, @Navio,  @Viagem, 
			@Cd_Tp_Oper, @Job, @Dead_line, @TTime_d, @TTime_H, @Stand, @SAP_ShipNumber, @CourrierCode)	
		If @@RowCount = 1 
			Begin 

				Exec pEventoHouse_Ins @Eventos, @NUm_PRoc_HEM
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return 30
					End


				If @Job <> '' 
					Begin 
						Update Cta_Cte_Hou_Exp_Mar Set Num_Proc_HEM = @Num_Proc_HEM, Dt_Ins_HEM = dbo.strhoje(getdate()) Where Num_Proc_HEM = @Job
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -7
							End

--						Delete Job_Exp_Mar Where Num_Proc_HEM = @Job
--						If @@Error <> 0 
--							Begin 
--								RollBack Transaction 
--								Return -6
--							End

						Update Historico_Geral Set Refer_Hist = @Num_Proc_HEM Where Refer_Hist = @Job 
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -9
							End
						Update Volume_Exp_Mar Set Num_Proc_HEM = @Num_Proc_HEM Where Num_Proc_HEM = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -10
							End
							
						Update Mrk_Hou_Exp_Mar Set Num_Proc_HEM = @Num_Proc_HEM Where Num_Proc_HEM = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -11
							End

						Update Prd_Hou_Exp_Mar Set Num_Proc_HEM = @Num_Proc_HEM  Where Num_Proc_HEM = @Job 
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -12
							End

						Update HEM_Transb Set Num_Proc_HEM = @Num_Proc_HEM  Where Num_Proc_HEM = @Job 
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -12
							End

						Update Hist_geral set hsgprocesso = @Num_Proc_HEM where hsgprocesso = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -14
							End

						Update evento_house set Num_Proc_H = @Num_Proc_HEM where Num_Proc_H = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 19
							End


						Update po_hem set Num_Proc_HEM = @Num_Proc_HEM where Num_Proc_HEM = @JOB
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return 43
							End


						Delete House_Exp_Mar  Where Num_Proc_HEM = @Job
						If @@Error <> 0 
							Begin 
								RollBack Transaction 
								Return -13
							End

					End 


				If @Dup_Master = 1 
					Begin 
						Insert Into Cta_Cte_Hou_Exp_Mar (Num_Proc_HEM, Cd_Tp_Tx, DC_HEM, Org_Ins_HEM, Dt_Ins_HEM, 
									Cd_Tp_Moeda, Vlr_Org_HEM, Dt_Prev_Pgto_HEM, Cd_Cred_Dev_HEM, Desp_Dst_HEM, 
									CPMF_HEM, Comp_RP_HEM, Comp_DN_HEM, Comp_CN_HEM, Comp_CPA_HEM)
						Select 
							@Num_Proc_HEM, Cd_TP_Tx, 'C', 'Sistema', @Date, Cd_Tp_Moeda, 
							Vlr_Org_MEM, Dt_Prev_Pgto_MEM, @Cd_Export, Desp_Dst_MEM, 
									CPMF_MEM, Comp_RP_MEM, Comp_DN_MEM, Comp_CN_MEM, Comp_CPA_MEM 
						From 
							cta_cte_mas_exp_mar cte 
						Where 
							Cte.Num_Proc_MEM = Left(@Num_Proc_HEM, 14) and DC_MEM = 'D'


					End 
				

				If (@TpFreteMaster = 'P' Or @Tp_Frete = 'P' ) and @Dup_Master = 0
					Begin  
						--If @TpFreteMaster = 'C' And @Tp_Frete = 'C' 
						--	Begin 
						--	            	Set @DespDest = 'S'	
						--		Set @PR = 'N'
						--	End 
					             --Else
						--	Begin 
							            	Set @DespDest = 'N'
								Set @PR = 'S'
						--	End 
			
						If @TpFreteMaster = 'P' And @Tp_Frete = 'C' 
							Begin 
						            		Set @DN = 'S'
								Set @CredDevFrt = IsNull((Select Cd_Export_MEM From Master_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM), @Cd_Export)
							End
					             Else
							Begin 
						            		Set @DN = 'N'
								Set @CredDevFrt = @Cd_Export
							End 
			
			
						Execute pCtaCteHEM_Ins @Num_Proc_HEM,'FRT', 'C', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Tot,   @DtSaidaMEM,  @CredDevFrt,  @DespDest, 'N', @PR, @DN, 'N', 'S', Null,Null, @Usuario, 1
						If @@RowCount <> 1 
							Begin 
								RollBack Transaction 
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
						Commit Transaction 
						Return 1 
					End 
			End 
		Else
			Begin 
				RollBack Transaction
				Return -1 
			End
GO
