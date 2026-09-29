SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE  PROCEDURE pJIA_Ins
(
@Num_Prop_IA			Varchar(11)=Null, 
@Dt_Emis_HIA			Varchar(10), 
@Cd_Tp_Etapa			Varchar(3), 
@HAWB_HIA			Varchar(25), 
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
@Cia_Aer			VarChar(3), 
@Cd_Tp_Oper			VarChar(3),
@Cd_Usuario			VarChar(6), 
@Num_Proc_HIA		varchar(16) OUTPUT,
@Cd_Agente			VarChar(10)=Null, 
@MAWB_HEA			VarChar(25)='', 
@Inv_HEA			VarChar(100)='', 
@Cd_Tp_Embal			VarChar(3)=0,
@Cd_Vendedor			VarChar(6)=Null, 
@Dead_Line			datetime, 
@TTime_d			int=null, 
@TTime_h			int=null,
@Site				char(1)='' 

)
 AS
--Parmetros de Retorno 	
--(-1) Erro na Insero do House 
-- (-2) Erro na insero do Conta Corrente
-- (-3) Peso Fora dos Limites de Peso Taxa
-- (-4) Erro nas Insero da Referencia
		Declare @DespDest 		Char(1)
		Declare @DN			Char(1)
		Declare @PesoTaxa		Float 
		Declare @Date			VarChar(12) 
		Declare @Num_Proc_MIA	Varchar(14) 
		Declare @MAWB_HIA		Varchar(25) 
		Declare @Stand			bit 
		Declare @erro			Int 

		If @Site = 'E'
			Set @Stand = 1 
		Else
			Set @Stand = 0 

		Set @Num_Proc_MIA = 'JOB'
		Set @MAWB_HIA = 'JOB'
		Set @Date = Convert(VarChar(12),GetDate(),103)
		Begin Transaction 
		Execute pHIA_Referencia_Ins @Num_Proc_MIA , @referencia = @Num_Proc_HIA OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -4
			End 
		Insert into House_Imp_Aer
			(Num_Proc_HIA, Num_Proc_MIA, Num_Prop_IA, Dt_Emis_HIA, Cd_Tp_Etapa, HAWB_HIA, MAWB_HIA, Cd_Import_HIA,
			Cd_Consig_HIA, Cd_Export_HIA, Voo_HIA, Cd_Org_HIA, Cd_Dst_HIA, ETD_HIA, ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, 
			Tp_Frete_HIA, Cd_Tp_Moeda, Vlr_Frete_Efet_HIA, Back_Back_HIA, Cd_Sb_Ag_Int_HIA, Cd_Sb_Ag_Nac_HIA, Cd_Tp_Prod, 
			Prod_Perig_HIA, Prod_Perec_HIA, Cd_Dsp_HIA, Cli_Msq_HIA, Dt_Pri_Avs_HIA, Dt_Seg_Avs_HIA, EW_HIA, FOB_FCA_HIA, 
			CIF_HIA, Vol_Tot_HIA, Peso_Bruto_HIA, Tp_Trf_HIA, Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA, Dt_Rcb_Doc_HIA, 
			Dt_Etg_Doc_HIA, Obs_HIA, JOB_HIA, Dead_Line, TTime_d, TTime_h, Stand, Cd_Tp_Oper )
		Values 
			(@Num_Proc_HIA, @Num_Proc_MIA, @Num_Prop_IA, @Dt_Emis_HIA, @Cd_Tp_Etapa, @HAWB_HIA, @MAWB_HIA, @Cd_Import_HIA,
			@Cd_Consig_HIA, @Cd_Export_HIA, @Voo_HIA, @Cd_Org_HIA, @Cd_Dst_HIA, @ETD_HIA, @ETA_HIA, @Qtd_Tot_Vol_HIA, @Peso_Real_HIA, 
			@Tp_Frete_HIA, @Cd_Tp_Moeda, @Vlr_Frete_Efet_HIA, @Back_Back_HIA, @Cd_Sb_Ag_Int_HIA, @Cd_Sb_Ag_Nac_HIA, @Cd_Tp_Prod, 
			@Prod_Perig_HIA, @Prod_Perec_HIA, @Cd_Dsp_HIA, @Cli_Msq_HIA, @Dt_Pri_Avs_HIA, @Dt_Seg_Avs_HIA, @EW_HIA, @FOB_FCA_HIA, 
			@CIF_HIA, @Vol_Tot_HIA, @Peso_Bruto_HIA, @Tp_Trf_HIA, @Trf_Cp_HIA, @Trf_Vd_HIA, @Vlr_Frete_Negoc_HIA, @Dt_Rcb_Doc_HIA, 
			@Dt_Etg_Doc_HIA, @Obs_HIA, @Num_Proc_HIA, @Dead_Line, @TTime_d, @TTime_h, @Stand, @Cd_Tp_Oper )

		Set @erro = @@Error

		iF @erro <> 0 
			Begin 
				Rollback Transaction 
				Return @erro
			End 	
				

		Insert Into Job_Imp_Aer 
			Values(@Num_Proc_HIA, @Cia_Aer, @Cd_Usuario, @Cd_Agente, @MAWB_HEA, @Inv_HEA, @Cd_Tp_Embal, @Cd_Vendedor)

		Set @erro = @@Error


		iF @Erro <> 0 
			Begin 
				Rollback Transaction 
				Return @Erro
			End 	

		else
			Begin 	
				Commit Transaction 
				Return 1 
			End
GO
