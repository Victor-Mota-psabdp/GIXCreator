SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  PROCEDURE pJEA_Ins
(
@Num_Proc_MEA		varchar(14),
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
@Usuario			VarChar(20), 
@Cd_Tp_Oper			VarChar(3), 
@Cd_Usuario			VarChar(6), 
@Num_Proc_HEA		varchar(16)='' OUTPUT,
@Cd_Agente			VarChar(10) = Null ,
@MAWB_JEA			VarChar(25)=Null,
@Inv_HEA			VarChar(100)=Null, 
@Cd_Tp_Embal			VarChar(3)='0',
@Cd_Vendedor			VarChar(6)=Null ,
@Err_Code			Int OUTPUT,
@Dead_Line			Datetime,
@TTime_d			smallint =null, 
@TTime_h			smallint=null,
@Site				char(1) = '',
@Eventos				varchar(500)=''
)
 AS
--Parmetros de Retorno 	
--(-1) Erro na Insero do House 
-- (-2) Erro na insero do Conta Corrente
-- (-3) Peso Fora dos Limites de Peso Taxa
-- (-4) Erro nas Insero da Referencia
	Declare @DespDest 	Char(1)
	Declare @DN		Char(1)
	Declare @PesoTaxa	Float 
	Declare @Date		VarChar(12) 
	Declare @Stand 	bit 

	If @Site = 'E' 
		Set @Stand = 1 
	Else
		Set @Stand = 0 

		
		Set @Date = Convert(VarChar(12),GetDate(),103)
		Begin Transaction 
		Execute pHEA_Referencia_Ins @Num_Proc_MEA , @referencia = @Num_Proc_HEA OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -4
			End 
		Insert into House_Exp_Aer 
			(Num_Proc_HEA, Num_Proc_MEA, Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, MAWB_HEA, 
			 Cd_Consig_HEA, Cd_Export_HEA, Cd_Notify_HEA, Voo_HEA, Cd_Org_HEA, Cd_Dst_HEA, 
			ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
			Cd_Tp_Moeda, Vlr_Frete_Tot_HEA, Cd_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, 
			Prod_Perec_HEA, Cd_Cia_Aer, Cd_Sb_Ag_Nac_HEA, Cd_Dsp_HEA, EW_HEA, FOB_FCA_HEA, 
			CIF_HEA, Cli_Msq_HEA,Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
			Dt_Etg_Doc_HEA, Obs_HEA, JOB_HEA, Cd_Tp_Oper, Dead_Line, TTime_d, TTime_h, Stand)
		Values 
			(@Num_Proc_HEA, @Num_Proc_MEA, @Num_Prop_EA, @Dt_Emis_HEA, @HAWB_HEA, @MAWB_HEA, 
			 @Cd_Consig_HEA, @Cd_Export_HEA, @Cd_Notify_HEA, @Voo_HEA, @Cd_Org_HEA, @Cd_Dst_HEA, 
			 @ETD_HEA, @ETA_HEA, @Qtd_Tot_Vol_HEA, @Peso_Real_HEA, @Trf_Vd_HEA, @Tp_Frete_HEA, 
			 @Cd_Tp_Moeda, @Vlr_Frete_Tot_HEA, @Cd_Tp_Prod, @RE_DSE_HEA	, @SD_HEA, @Prod_Perig_HEA, 
			 @Prod_Perec_HEA, @Cd_Cia_Aer, @Cd_Sb_Ag_Nac_HEA, @Cd_Dsp_HEA, @EW_HEA	, @FOB_FCA_HEA, 
			 @CIF_HEA, @Cli_Msq_HEA, @Transp_HEA, @Vol_Tot_HEA, @Peso_Bruto_HEA, @Dt_Rcb_Doc_HEA, 
			@Dt_Etg_Doc_HEA, @Obs_HEA, @Num_Proc_HEA, @Cd_Tp_Oper, @Dead_Line, @TTime_d, @TTime_h, @Stand ) 
		If @@RowCount = 1 
			Begin 
				Exec pEventoHouse_Ins @Eventos, @Num_Proc_HEA
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return 30
					End



				Insert Into 
					Job_Exp_Aer 
				Values 
					(@Num_Proc_HEA, @Cd_Usuario, @CD_Agente, @MAWB_JEA, @Inv_HEA, @Cd_Tp_Embal, @Cd_Vendedor)

				Set @Err_Code = @@Error 

				If @Err_Code <> 0 
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
				RollBack Transaction
				Set @Err_Code = @@Error 
				Return -1 
			End

GO
