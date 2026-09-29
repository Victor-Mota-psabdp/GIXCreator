SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  PROCEDURE pHIA_Ins
(
@Num_Proc_MIA		Varchar(14), 
@Job				VarChar(16)=Null, 
@Num_Prop_IA			Varchar(11)=Null, 
@Dt_Emis_HIA			Varchar(10), 
@Cd_Tp_Etapa			Varchar(3), 
@HAWB_HIA			Varchar(25), 
@MAWB_HIA			Varchar(25), 
@Cd_Import_HIA		Varchar(10), 
@Cd_Consig_HIA		Varchar(10), 
@Cd_Export_HIA		Varchar(10), 
@Voo_HIA			Varchar(13), 
@Cd_Org_HIA			Varchar(3), 
@Cd_Dst_HIA			Varchar(3), 
@ETD_HIA			Varchar(10), 
@ETA_HIA			Varchar(10), 
@Qtd_Tot_Vol_HIA		Float, 
@Peso_Real_HIA		Float, 
@Tp_Frete_HIA			char(1), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Frete_Efet_HIA		Float, 
@Back_Back_HIA		char(1), 
@Cd_Sb_Ag_Int_HIA		varchar(10), 
@Cd_Sb_Ag_Nac_HIA		varchar(10), 
@Cd_Tp_Prod			varchar(3), 
@Prod_Perig_HIA		char(1), 
@Prod_Perec_HIA		char(1), 
@Cd_Dsp_HIA			varchar(10), 
@Cli_Msq_HIA			char(1), 
@Dt_Pri_Avs_HIA		varchar(10), 
@Dt_Seg_Avs_HIA		varchar(10), 
@EW_HIA			char(1), 
@FOB_FCA_HIA		char(1), 
@CIF_HIA			char(1), 
@Vol_Tot_HIA			Float, 
@Peso_Bruto_HIA		Float, 
@Tp_Trf_HIA			Varchar(30), 
@Trf_Cp_HIA			Float, 
@Trf_Vd_HIA			Float, 
@Vlr_Frete_Negoc_HIA		Float, 
@Dt_Rcb_Doc_HIA		varchar(10),
@Dt_Etg_Doc_HIA		varchar(10), 
@Obs_HIA			varchar(2000), 
@TpFreteMaster		Char(1), 
@Cd_Export_MIA		VarChar(10),
@DtChegMIA			VarChar(10), 
@Usuario			VarChar(20),
@Cd_Tp_Oper			VarChar(3),
@Num_Proc_HIA		varchar(16) OUTPUT,
@Dup_Master			bit=0, 
@Dead_Line			datetime=null, 
@TTime_d			smallint=null, 
@TTime_h			smallint=null,
@Site				char(1) = '',
@SAP_ShipNumber		varchar(20)='',
@Eventos			varchar(200)=''
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
	Declare @Stand		Bit 

		Set @Date = Convert(VarChar(12),GetDate(),103)
		Begin Transaction 
		Set @MAWB_HIA = (Select MAWB_MIA From Master_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA)

		If @Job <> '' 
			Set  @Stand = IsNull((Select Stand From House_Imp_Aer Where Num_Proc_HIA = @Job  ), 0) 	
		Else
			Set  @Stand = 0 

		If @Site = 'E'
			Set @Stand = 1
		
		Execute pHIA_Referencia_Ins @Num_Proc_MIA , @referencia = @Num_Proc_HIA OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -1
			End 
		Insert into House_Imp_Aer
			(Num_Proc_HIA, Num_Proc_MIA, Num_Prop_IA, Dt_Emis_HIA, Cd_Tp_Etapa, HAWB_HIA, MAWB_HIA, Cd_Import_HIA,
			Cd_Consig_HIA, Cd_Export_HIA, Voo_HIA, Cd_Org_HIA, Cd_Dst_HIA, ETD_HIA, ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, 
			Tp_Frete_HIA, Cd_Tp_Moeda, Vlr_Frete_Efet_HIA, Back_Back_HIA, Cd_Sb_Ag_Int_HIA, Cd_Sb_Ag_Nac_HIA, Cd_Tp_Prod, 
			Prod_Perig_HIA, Prod_Perec_HIA, Cd_Dsp_HIA, Cli_Msq_HIA, Dt_Pri_Avs_HIA, Dt_Seg_Avs_HIA, EW_HIA, FOB_FCA_HIA, 
			CIF_HIA, Vol_Tot_HIA, Peso_Bruto_HIA, Tp_Trf_HIA, Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA, Dt_Rcb_Doc_HIA, 
			Dt_Etg_Doc_HIA, Obs_HIA, JOB_HIA, Cd_Tp_Oper, Dead_Line, TTime_d, TTime_h, Stand, SAP_ShipNumber )
		Values 
			(@Num_Proc_HIA, @Num_Proc_MIA, @Num_Prop_IA, @Dt_Emis_HIA, @Cd_Tp_Etapa, @HAWB_HIA, @MAWB_HIA, @Cd_Import_HIA,
			@Cd_Consig_HIA, @Cd_Export_HIA, @Voo_HIA, @Cd_Org_HIA, @Cd_Dst_HIA, @ETD_HIA, @ETA_HIA, @Qtd_Tot_Vol_HIA, @Peso_Real_HIA, 
			@Tp_Frete_HIA, @Cd_Tp_Moeda, @Vlr_Frete_Efet_HIA, @Back_Back_HIA, @Cd_Sb_Ag_Int_HIA, @Cd_Sb_Ag_Nac_HIA, @Cd_Tp_Prod, 
			@Prod_Perig_HIA, @Prod_Perec_HIA, @Cd_Dsp_HIA, @Cli_Msq_HIA, @Dt_Pri_Avs_HIA, @Dt_Seg_Avs_HIA, @EW_HIA, @FOB_FCA_HIA, 
			@CIF_HIA, @Vol_Tot_HIA, @Peso_Bruto_HIA, @Tp_Trf_HIA, @Trf_Cp_HIA, @Trf_Vd_HIA, @Vlr_Frete_Negoc_HIA, @Dt_Rcb_Doc_HIA, 
			@Dt_Etg_Doc_HIA, @Obs_HIA, @JOB, @Cd_TP_Oper, @Dead_Line, @TTime_d, @TTime_h, @Stand, @SAP_ShipNumber)

		If @@RowCount <> 1 
			Begin 
				RollBack Transaction
				Return -2
			End 

		Exec pEventoHouse_Ins @Eventos, @Num_Proc_HIA
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return 30
			End

		If @Job <> '' 
			Begin 
				Update Cta_Cte_Hou_Imp_Aer Set Num_Proc_HIA = @Num_Proc_HIA, Dt_Ins_HIA = dbo.strhoje(getdate()) Where Num_Proc_HIA = @Job
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -3
					End
--				Delete Job_Imp_Aer Where Num_Proc_HIA = @Job
--				If @@Error <> 0 
--					Begin 
--						RollBack Transaction 
--						Return -4
--					End
				Update Historico_Geral Set Refer_Hist = @Num_Proc_HIA Where Refer_Hist = @Job 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -5
					End

				Update Volume_Imp_Aer Set Num_Proc_HIA =  @Num_Proc_HIA  Where Num_Proc_HIA = @Job 
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -6
					End

				Update Hist_geral set hsgprocesso = @Num_Proc_HIA where hsgprocesso = @JOB
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -7
					End

				Update House_Imp_Aer Set Stand = (Select Stand From House_Imp_Aer Where Num_Proc_HIA = @Job) Where Num_Proc_HIA = @Num_Proc_HIA
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return 18
					End		

				Delete House_Imp_Aer  Where Num_Proc_HIA = @Job
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return -8
					End

			End 


			If @Dup_Master = 1 
				Begin 
					Insert Into Cta_Cte_Hou_Imp_Aer (Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Org_Ins_HIA, Dt_Ins_HIA, 
								Cd_Tp_Moeda, Vlr_Org_HIA, Dt_Prev_Pgto_HIA, Cd_Cred_Dev_HIA, Desp_Org_HIA, 
								CPMF_HIA, Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA)
					Select 
						@Num_Proc_HIA, Cd_TP_Tx, 'C', 'Sistema', @Date, Cd_Tp_Moeda, 
						Vlr_Org_MIA, Dt_Prev_Pgto_MIA, @Cd_Import_HIA, Desp_Org_MIA, 
								CPMF_MIA, Comp_RP_MIA, Comp_DN_MIA, Comp_CN_MIA, Comp_CPA_MIA 
					From 
						cta_cte_mas_Imp_aer cte 
					Where 
						Cte.Num_Proc_MIA = Left(@Num_Proc_HIA, 14) and DC_MIA = 'D'


				End 



		If @Vlr_Frete_Efet_HIA <> 0 and @Dup_Master = 0 
			Begin 

				If @TpFreteMaster = 'P' and @Tp_Frete_HIA = 'P' 
					Begin 
						Set @PR = 'N'
						Set @DespDest = 'S'
					End 
				Else
					Begin 
						Set @DespDest = 'N'						
						Set @PR = 'S'
					End 
		
				
				Execute pCtaCteHIA_Ins @Num_Proc_HIA,'FRT', 'C', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet_HIA,   @DtChegMIA,  @Cd_Import_HIA,  @DespDest, 'N', @PR, 'N', 'N', 'N', Null,Null, @Usuario, 1		
				If @@RowCount = 1 
					Begin
						If @Tp_Frete_HIA = 'C' 
							Begin 
								Execute pCtaCteHIA_Ins @Num_Proc_HIA,'FRT', 'D', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet_HIA,   @DtChegMIA,  @Cd_Export_MIA,  'N', 'N', 'N', 'N', 'N', 'N', Null,Null, @Usuario, 1		
								If @@RowCount = 1 
									Begin 
										Commit Transaction 
										Return 1 
									End 
								Else
									Begin 
										RollBack Transaction
										Return -9
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
						Return - 10
					End
			End
		Else
			Begin 
				Commit Transaction 
				Return 1
			End
GO
