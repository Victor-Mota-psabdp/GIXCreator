SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE pHEA_Upd
(
@Num_Proc_HEA		varchar(16), 
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
@Cd_Tp_Oper			VarChar(3),
@Cd_Usuario			VarChar(6)=Null, 
@HAWB_Instruct		VarChar(500)='',
@Tx_Refer_HEA		Float=0,
@Cd_Agente			VarChar(10)=Null,
@MAWB_JEA			VarChar(25)=Null,
@Inv_HEA			VarChar(100)=Null, 
@Cd_Tp_Embal			VarChar(3)='0', 
@Cd_Vendedor 			VarChar(6)=Null,
@Peso_Tax			Float=0,
@Eventos			varchar(500)='',
@SAP_ShipNumber		varchar(20)=''
)
 AS
--Parâmetros de Retorno 	
--(-1) Erro na Inserção do House 
-- (-2) Erro na inserção do Conta Corrente
-- (-3) Peso Fora dos Limites de Peso Taxa
-- (-4) Erro nas Inserção da Referencia
	Begin Transaction 
	Update 
		House_Exp_Aer 
	Set 
		Num_Prop_EA = @Num_Prop_EA,
		Dt_Emis_HEA = @Dt_Emis_HEA, 
		HAWB_HEA = @HAWB_HEA, 
--		MAWB_HEA = @MAWB_HEA, 
		Cd_Consig_HEA = @Cd_Consig_HEA, 
		Cd_Export_HEA = @Cd_Export_HEA, 
		Cd_Notify_HEA = @Cd_Notify_HEA, 
		Voo_HEA = @Voo_HEA, 
		Cd_Org_HEA = @Cd_Org_HEA, 
		Cd_Dst_HEA = @Cd_Dst_HEA, 
		ETD_HEA = @ETD_HEA, 
		ETA_HEA = @ETA_HEA, 
		Qtd_Tot_Vol_HEA = @Qtd_Tot_Vol_HEA, 
		Peso_Real_HEA = @Peso_Real_HEA, 
		Trf_Vd_HEA = @Trf_Vd_HEA, 
		Tp_Frete_HEA = @Tp_Frete_HEA, 
		Cd_Tp_Moeda = @Cd_Tp_Moeda, 
		Vlr_Frete_Tot_HEA= @Vlr_Frete_Tot_HEA, 
		Cd_Tp_Prod = @Cd_Tp_Prod, 
		RE_DSE_HEA = @RE_DSE_HEA, 
		SD_HEA = @SD_HEA, 
		Prod_Perig_HEA = @Prod_Perig_HEA, 
		Prod_Perec_HEA = @Prod_Perec_HEA, 
		Cd_Cia_Aer= @Cd_Cia_Aer, 
		Cd_Sb_Ag_Nac_HEA= @Cd_Sb_Ag_Nac_HEA, 
		Cd_Dsp_HEA = @Cd_Dsp_HEA, 
		EW_HEA = @EW_HEA, 
		FOB_FCA_HEA = @FOB_FCA_HEA, 
		CIF_HEA = @CIF_HEA, 
		Cli_Msq_HEA = @Cli_Msq_HEA, 
		Transp_HEA = @Transp_HEA, 
		Vol_Tot_HEA = @Vol_Tot_HEA, 
		Peso_Bruto_HEA = @Peso_Bruto_HEA, 
		Dt_Rcb_Doc_HEA = @Dt_Rcb_Doc_HEA, 
		Dt_Etg_Doc_HEA = @Dt_Etg_Doc_HEA, 
		Obs_HEA = @Obs_HEA , 
		Cd_Tp_Oper = @Cd_Tp_Oper ,
		HAWB_Instruct = @HAWB_Instruct, 
		Tx_Refer_HEA = @Tx_Refer_HEA,
		Peso_Tax = @Peso_Tax, 
		SAP_ShipNumber = @SAP_ShipNumber
	Where
		Num_Proc_HEA = @Num_Proc_HEA

	If @@Error <>0 
		Begin 
			Rollback Transaction 
			Return -1
		End 
	Else 
		Begin 

			Exec pEventoHouse_Ins @Eventos, @NUm_PRoc_HEA		
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 30
				End



			If Left(@Num_Proc_HEA , 5) = 'EAJOB'
				Begin 
					Update 
						Job_Exp_Aer 
					Set 
						Cd_Usuario = @Cd_Usuario, 
						MAWB_HEA = @MAWB_JEA, 
						Cd_Agente = @Cd_Agente,
						Inv_HEA = @Inv_HEA, 
						Cd_Tp_Embal = @Cd_Tp_Embal , 
						Cd_Vendedor= @Cd_Vendedor 
					Where 
						Num_proc_HEA = @Num_Proc_HEA
	
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
