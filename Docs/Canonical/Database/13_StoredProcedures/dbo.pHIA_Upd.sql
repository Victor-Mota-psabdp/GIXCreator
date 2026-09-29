SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE pHIA_Upd
(
@Num_Proc_HIA		varchar(16),
@Num_Prop_HIA		varchar(12)=Null,
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
@Tp_Trf_HIA			varchar(30), 
@Trf_Cp_HIA			Float, 
@Trf_Vd_HIA			Float, 
@Vlr_Frete_Negoc_HIA		Float, 
@Dt_Rcb_Doc_HIA		varchar(10),
@Dt_Etg_Doc_HIA		varchar(10), 
@Obs_HIA			varchar(2000) ,
@Cd_Tp_Oper			VarChar(3)=Null,
@Cd_Usuario			VarChar(6)=Null,
@Cd_Agente			VarChar(10)=Null, 
@MAWB_JIA			VarChar(25)='',
@Inv_HIA			VarChar(100)='', 
@Cd_Tp_Embal			VarChar(3)='0' ,
@Cd_Vendedor			VarChar(6)=Null,
@SAP_ShipNumber		varchar(20)= '',
@Eventos			varchar(200)=''
)
 AS
	Begin Transaction 
	Declare @TpFreteMaster 	char(1) 
	Declare @DespDest 		Char(1)
	Declare @DN			Char(1)
	Declare @PR			Char(1)
	Declare @PesoTaxa		Float 
	Declare @Date			VarChar(12) 
	Declare @DtChegMIA		VarChar(10) 
	Declare @Cd_Export_MIA	varchar(10)
	Declare @BooFreteC		bit 
	Declare @BooFreteD		bit 

	If Exists(Select Cd_Tp_Tx From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx = 'FRT' and DC_HIA = 'C')
		Set @BooFreteC = 1 
	Else 
		Set @BooFreteC = 0 


	If Exists(Select Cd_Tp_Tx From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx = 'FRT' and DC_HIA = 'D')
		Set @BooFreteD = 1 
	Else 
		Set @BooFreteD = 0 


	Set @Date = Convert(VarChar(12),GetDate(),103)
	Select @Cd_Export_MIA = IsNull(Cd_Export_MIA, ''),  @DtChegMIA = IsNull(Dt_Cheg_MIA, ''),  @TpFreteMaster =  IsNull(Tp_Frete_MIA, '')  From Master_Imp_Aer Where Num_Proc_MIA = Left(@Num_Proc_HIA , 14)

	Print  @Cd_Export_MIA

	Update 
		House_Imp_Aer 
	Set 
		Dt_Emis_HIA =@Dt_Emis_HIA, 
		Cd_Tp_Etapa = @Cd_Tp_Etapa , 
		HAWB_HIA = @HAWB_HIA , 
--		MAWB_HIA = @MAWB_HIA, 
		Cd_Import_HIA =@Cd_Import_HIA , 
		Cd_Consig_HIA = @Cd_Consig_HIA, 
		Cd_Export_HIA  = @Cd_Export_HIA, 
		Voo_HIA = @Voo_HIA, 
		Cd_Org_HIA  = @Cd_Org_HIA, 
		Cd_Dst_HIA  = @Cd_Dst_HIA, 
		ETD_HIA = @ETD_HIA,
		ETA_HIA = @ETA_HIA, 
		Qtd_Tot_Vol_HIA  = @Qtd_Tot_Vol_HIA, 
		Peso_Real_HIA  = @Peso_Real_HIA,
		Tp_Frete_HIA  = @Tp_Frete_HIA, 
		Cd_Tp_Moeda  = @Cd_Tp_Moeda, 
		Vlr_Frete_Efet_HIA  = @Vlr_Frete_Efet_HIA, 
		Back_Back_HIA  = @Back_Back_HIA , 
		Cd_Sb_Ag_Int_HIA  = @Cd_Sb_Ag_Int_HIA, 
		Cd_Sb_Ag_Nac_HIA  = @Cd_Sb_Ag_Nac_HIA, 
		Cd_Tp_Prod = @Cd_Tp_Prod,
		Prod_Perig_HIA = @Prod_Perig_HIA, 
		Prod_Perec_HIA  = @Prod_Perec_HIA, 
		Cd_Dsp_HIA  = @Cd_Dsp_HIA, 
		Cli_Msq_HIA  = @Cli_Msq_HIA, 
		Dt_Pri_Avs_HIA  = @Dt_Pri_Avs_HIA,  
		Dt_Seg_Avs_HIA = @Dt_Seg_Avs_HIA, 
		EW_HIA = @EW_HIA, 
		FOB_FCA_HIA  = @FOB_FCA_HIA, 
		CIF_HIA  = @CIF_HIA, 
		Vol_Tot_HIA  = @Vol_Tot_HIA,  
		Peso_Bruto_HIA = @Peso_Bruto_HIA, 
		Tp_Trf_HIA = @Tp_Trf_HIA, 
		Trf_Cp_HIA  = @Trf_Cp_HIA,  
		Trf_Vd_HIA = @Trf_Vd_HIA, 
		Vlr_Frete_Negoc_HIA = @Vlr_Frete_Negoc_HIA, 
		Dt_Rcb_Doc_HIA  = @Dt_Rcb_Doc_HIA, 
		Dt_Etg_Doc_HIA = @Dt_Etg_Doc_HIA, 
		Obs_HIA =  @Obs_HIA,
		Cd_Tp_Oper = @Cd_Tp_Oper,
		SAP_ShipNumber = @SAP_ShipNumber
	Where 
		Num_Proc_HIA = @Num_Proc_HIA


	Exec pEventoHouse_Ins @Eventos, @Num_Proc_HIA
	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return 30
		End


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
	If @DtChegMIA = null or @DtChegMIA = '' 
		Begin 
			Set @DtChegMIA = dbo.strhoje(getdate())
		End 


	If @booFreteC = 0   and @Vlr_Frete_Efet_HIA <> 0  and left(@Num_Proc_HIA, 5) <> 'IAJOB'
		Begin 
			Execute pCtaCteHIA_Ins @Num_Proc_HIA,'FRT', 'C', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet_HIA,   @DtChegMIA,  @Cd_Import_HIA,  @DespDest, 'N', @PR, 'N', 'N', 'N', Null,Null, @Cd_Usuario, 1		

			If @@Error <>0 
				Begin
					RollBack Transaction 
					Return - 9 
				End 
		End 


	If @booFreteD = 0   and @Vlr_Frete_Efet_HIA <> 0 and left(@Num_Proc_HIA, 5) <> 'IAJOB'
		Begin 
			If @Tp_Frete_HIA = 'C' 
				Begin 
					Execute pCtaCteHIA_Ins @Num_Proc_HIA,'FRT', 'D', 'Sistema', @Date, @Cd_Tp_Moeda,@Vlr_Frete_Efet_HIA,   @DtChegMIA,  @Cd_Export_MIA,  'N', 'N', 'N', 'N', 'N', 'N', Null,Null, @Cd_Usuario, 1		
					If @@RowCount <> 1 or @@Error <> 0 
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


	If @@Error <>0 
		Begin 
			Rollback Transaction 
			Return -1
		End 
	Else 
		Begin 
			If Left(@Num_Proc_HIA , 5) = 'IAJOB'
				Begin 
					Update 
						Job_Imp_Aer
					Set 
						Cd_Usuario = @Cd_Usuario,
						Cd_Agente = @Cd_Agente ,
						MAWB_HIA = @MAWB_JIA, 
						Cd_Tp_Embal = @Cd_Tp_Embal, 
						Inv_HIA = @Inv_HIA,	
						Cd_Vendedor = @Cd_Vendedor
					Where 
						Num_proc_HIA = @Num_Proc_HIA
	
					If @@Error <> 0 
						Begin 
							Rollback Transaction 
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
GO
