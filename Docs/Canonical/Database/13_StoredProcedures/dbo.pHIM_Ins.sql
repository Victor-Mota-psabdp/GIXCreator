SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE pHIM_Ins
(
@Num_Proc_MIM		VarChar(14), 
@Job				VarChar(16)='', 
@Num_Prop			varchar(11), 
@Dt_Emis			varchar(10), 
@HAWB			varchar(25),
@MAWB			varchar(25), 
@Cd_Import			varchar(10), 
@Cd_Consig			varchar(10), 
@Cd_Export			varchar(10), 
@Band_Bras			char(1), 
@Cd_Org			varchar(3), 
@Cd_Dst			varchar(3), 
@Dt_Saida			varchar(10),
@Tp_Frete			char(1),
@Cd_Tp_Moeda 		varchar(3),
@Vlr_Frete_Efet			Float, 
@Prod_Perig			char(1),
@Prod_Perec			char(1),
@Cd_Sb_Ag_Int		varchar(10),
@Cd_Sb_Ag_Nac		varchar(10), 
@Cd_Tp_Prod			varchar(3),
@EW				char(1),
@FOB_FCA			char(1), 
@CIF				char(1), 
@Cli_Msq			char(1),
@Cd_Porto_Rcb		varchar(3), 
@Cd_Emissor			VarChar(4)=Null, 
@Cd_Tp_Embal			varchar(3), 
@Qtd_Tot_Vol			Float, 
@Vol_Tot			Float, 
@Peso_Liquido			Float, 
@Peso_Bruto			Float, 
@Tp_Trf			varchar(30),
@Trf_Cp			Float, 
@Trf_Vd			Float, 
@Vlr_Frete_Negoc		Float, 
@Dt_Rcb_Doc			Varchar(10),
@Dt_Etg_Doc			Varchar(10), 
@Obs				Varchar(2000), 
@Transito_HIM			Char(1),
@TpFreteMaster		Char(1), 
@Cd_Export_MIM		VarChar(10),
@DtAtracMIM			VarChar(10), 
@Usuario			VarChar(20),
@Navio				VarChar(20)=Null,
@Viagem			VarChar(5)=Null, 
@Dt_Cheg			VarChar(10)=Null, 
@Cd_Tp_Oper			VarChar(3),
@Num_Proc_HIM		VarChar(16) = '' OUTPUT,
@Cd_Despachante		VarChar(10)=Null,
@Dup_Master			bit=0,
@Dead_Line			Datetime=null, 
@TTime_d			smallint=null,
@TTime_h			smallint=null,
@site 				char(1)='',
@SAP_ShipNumber		varchar(20)='',
@Eventos			varchar(200)=''
)
 AS
	Declare @Date		VarChar(12) 
	Declare @DespDest 	Char(1)
	Declare @PR		Char(1)
	Declare	@ID_Viagem	Int 
	Declare @Stand		Bit

	Set @Date = Convert(VarChar(12),GetDate(),103)
	Begin Transaction 
	Set @MAWB = (Select MAWB_MIM From Master_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM)
	Set @ID_Viagem = (Select ID_Viagem From Master_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM)

	If @Job <> '' 
		Set  @Stand = IsNull((Select Stand From House_Imp_Mar Where Num_Proc_HIM = @Job  ), 0) 	
	Else
		Set  @Stand = 0 

	If @Site = 'E'
			Set @Stand = 1

	Execute pHIM_Referencia_Ins @Num_Proc_MIM , @referencia = @Num_Proc_HIM OUTPUT
	If Not Exists (Select * From House_imp_mar Where Num_Proc_HIM = @Num_Proc_HIM)
		Begin 
			Insert Into 
				House_Imp_Mar 
				(Num_Proc_HIM, Num_Proc_MIM, Num_Prop_IM, Dt_Emis_HIM, HAWB_HIM, MAWB_HIM, Cd_Import_HIM, 
				Cd_Consig_HIM, Cd_Export_HIM, ID_Viagem, Band_Bras_HIM, Cd_Org_HIM, Cd_Dst_HIM, 
				Dt_Saida_HIM,  Tp_Frete_HIM, Cd_Tp_Moeda, Vlr_Frete_Efet_HIM, Prod_Perig_HIM, 
				Prod_Perec_HIM, Cd_Sb_Ag_Int_HIM, Cd_Sb_Ag_Nac_HIM, Cd_Tp_Prod, EW_HIM, FOB_FCA_HIM, 
				CIF_HIM, Cli_Msq_HIM, Cd_Porto_Rcb_HIM, Cd_Emissor, Cd_Tp_Embal, Qtd_Tot_Vol_HIM, Vol_Tot_HIM, Peso_Liquido_HIM,
				Peso_Bruto_HIM, Tp_Trf_HIM, Trf_Cp_HIM, Trf_Vd_HIM, Vlr_Frete_Negoc_HIM, Dt_Rcb_Doc_HIM, 
				Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM, Navio_HIM, Viagem_HIM, Dt_Cheg_HIM,  Cd_Tp_Oper, Job_HIM, 
				Cd_Despachante, Dead_Line, TTime_d, TTime_h, Stand, SAP_ShipNumber)
			Values 
				(@Num_Proc_HIM, @Num_Proc_MIM, @Num_Prop, @Dt_Emis, @HAWB, @MAWB, @Cd_Import, 
				@Cd_Consig, @Cd_Export, @ID_Viagem, @Band_Bras, @Cd_Org, @Cd_Dst, @Dt_Saida,
				@Tp_Frete, @Cd_Tp_Moeda, @Vlr_Frete_Efet, @Prod_Perig, @Prod_Perec, @Cd_Sb_Ag_Int, 
				@Cd_Sb_Ag_Nac, @Cd_Tp_Prod, @EW, @FOB_FCA, @CIF, @Cli_Msq, @Cd_Porto_Rcb, @Cd_Emissor, 
				@Cd_Tp_Embal, @Qtd_Tot_Vol, @Vol_Tot, @Peso_Liquido, @Peso_Bruto, @Tp_Trf, @Trf_Cp, @Trf_Vd, 
				@Vlr_Frete_Negoc, @Dt_Rcb_Doc, @Dt_Etg_Doc, @Obs, @Transito_HIM, @Navio, @Viagem, @Dt_Cheg,  @Cd_Tp_Oper, @JOB, 
				@Cd_Despachante, @Dead_Line, @TTime_d, @TTime_h, @Stand, @SAP_ShipNumber)
			
			If @@RowCount =1 
				Begin 
			
					Exec pEventoHouse_Ins @Eventos, @Num_Proc_HIM
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return 30
						End

					If @Job <> '' 
						Begin 
							Update Cta_Cte_Hou_Imp_Mar Set Num_Proc_HIM = @Num_Proc_HIM, Dt_Ins_HIM = dbo.strhoje(getdate()) Where Num_Proc_HIM = @Job
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -7
								End
--							Delete Job_Imp_Mar Where Num_Proc_HIM = @Job
--							If @@Error <> 0 
--								Begin 
--									RollBack Transaction 
--									Return -6
--								End
							Update Historico_Geral Set Refer_Hist = @Job Where Refer_Hist = @Num_Proc_HIM 
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -9
								End
							Update Volume_Imp_Mar Set Num_Proc_HIM = @Job Where Num_Proc_HIM = @Num_Proc_HIM
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -11
								End

							Update HIM_Transb Set Num_Proc_HIM = @Num_Proc_HIM  Where Num_Proc_HIM = @Job 
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -12
								End

							Update Hist_geral set hsgprocesso = @Num_Proc_HIM where hsgprocesso = @JOB
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -11
								End

							Update House_Imp_Mar Set Stand = (Select Stand From House_Imp_Mar Where Num_Proc_HIM = @Job)  Where Num_Proc_HIM = @Num_Proc_HIM
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return 18
								End		

							Delete House_Imp_Mar  Where Num_Proc_HIM = @Job
							If @@Error <> 0 
								Begin 
									RollBack Transaction 
									Return -10
								End
			
						End 


					If @Dup_Master = 1 
						Begin 

							If @Dup_Master = 1 
								Begin 
									Insert Into Cta_Cte_Hou_Imp_Mar (Num_Proc_HIM, Cd_Tp_Tx, DC_HIm, Org_Ins_HIM, Dt_Ins_HIM, 
												Cd_Tp_Moeda, Vlr_Org_HIM, Dt_Prev_Pgto_HIM, Cd_Cred_Dev_HIM, Desp_Org_HIM, 
												CPMF_HIM, Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM)
									Select 
										@Num_Proc_HIM, Cd_TP_Tx, 'C', 'Sistema', @Date, Cd_Tp_Moeda, 
										Vlr_Org_MIM, Dt_Prev_Pgto_MIM, @Cd_Import, Desp_Org_MIM, 
												CPMF_MIM, Comp_RP_MIM, Comp_DN_MIM, Comp_CN_MIM, Comp_CPA_MIM 
									From 
										cta_cte_mas_Imp_mar cte 
									Where 
										Cte.Num_Proc_MIM = Left(@Num_Proc_HIM, 14) and DC_MIM = 'D'

									Commit Transaction
									Return 1 				
				
								End 
							
						End 
					Else	
						Begin 
							If @TpFreteMaster = 'P' and @Tp_Frete = 'P' 
								Begin 
									Set @DespDest = 'S'
									Set @PR = 'N'
								End 
							Else
								Begin 
									Set @DespDest = 'N'						
									Set @PR = 'S'
								End 
		
							Execute pCtaCteHIM_Ins @Num_Proc_HIM,'FRT', 'C', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet,   @DtAtracMIM,  @Cd_Import,  @DespDest, 'N', @PR, 'N', 'N', 'N', Null,Null, @Usuario, 1 
							If @@RowCount = 1 
								Begin
									If @Tp_Frete = 'C' 
										Begin 
											Execute pCtaCteHIM_Ins @Num_Proc_HIM,'FRT', 'D', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet,   @DtAtracMIM,  @Cd_Export_MIM,  'N', 'N', 'N', 'N', 'N', 'N', Null,Null, @Usuario, 1
											If @@RowCount = 1 
												Begin 
													Commit Transaction 
													Return 1 
												End 
											Else
												Begin 
													RollBack Transaction
													Return -4
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
									Return - 3 
								End 
						End 
				End 
			Else
				Begin 
					Return -2 
				End  
		End
	Else
		Return - 1
GO
