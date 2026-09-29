SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pHIM_Upd]
(
@Num_Proc_HIM		VarChar(16), 
@Num_Proc_MIM		VarChar(14),
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
@Dt_Cheg			varchar(10),
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
@Cd_Tp_Oper			VarChar(3)=Null,
@Cd_Terminal			VarChar(3)=Null,
@Cd_Armador			VarChar(3)=Null,
@Cd_Usuario			VarChar(6)=Null,
@BL_Orig			Bit=0,
@Fat_Orig			Bit=0,
@Cd_Despachante		VarChar(10)=Null,
@Navio_HIM			VarChar(20)='',
@Viagem_HIM			VarChar(10)='',
@Cd_Agente			VarChar(10)=Null, 
@MAWB_JIM			VarChar(25)='',
@Inv_HIM			VarChar(100)='',
@Cd_Vendedor			VarChar(6)=Null,
@SAP_ShipNumber		varchar(20)='',
@Eventos			varchar(200)=''
)
 AS
	Begin Transaction 
	If Exists (Select * From House_imp_mar Where Num_Proc_HIM = @Num_Proc_HIM)
		Begin 
			Update 
				House_imp_mar
			Set 
				Num_Prop_IM = @Num_Prop, 
				Dt_Emis_HIM = @Dt_Emis , 
				HAWB_HIM = @HAWB, 
--				MAWB_HIM = @MAWB, 
				Cd_Import_HIM = @Cd_Import, 
				Cd_Consig_HIM = @Cd_Consig, 
				Cd_Export_HIM = @Cd_Export,  
				Band_Bras_HIM = @Band_Bras, 
				Cd_Org_HIM = @Cd_Org, 
				Cd_Dst_HIM = @Cd_Dst, 
				Dt_Saida_HIM = @Dt_Saida, 
				--Dt_Cheg_HIM = @Dt_Cheg, 
				Tp_Frete_HIM = @Tp_Frete, 
				Cd_Tp_Moeda = @Cd_Tp_Moeda, 
				Vlr_Frete_Efet_HIM = @Vlr_Frete_Efet, 
				Prod_Perig_HIM = @Prod_Perig, 
				Prod_Perec_HIM = @Prod_Perec, 
				Cd_Sb_Ag_Int_HIM = @Cd_Sb_Ag_Int, 
				Cd_Sb_Ag_Nac_HIM = @Cd_Sb_Ag_Nac, 
				Cd_Tp_Prod = @Cd_Tp_Prod, 
				EW_HIM = @EW, 
				FOB_FCA_HIM = @FOB_FCA, 
				CIF_HIM = @CIF, 
				Cli_Msq_HIM = @Cli_Msq, 
				Cd_Porto_Rcb_HIM = @Cd_Porto_Rcb, 
				Cd_Emissor = @Cd_Emissor,  
				Cd_Tp_Embal = @Cd_Tp_Embal, 
				Qtd_Tot_Vol_HIM = @Qtd_Tot_Vol, 
				Vol_Tot_HIM = @Vol_Tot, 
				Peso_Liquido_HIM = @Peso_Liquido,
				Peso_Bruto_HIM = @Peso_Bruto, 
				Tp_Trf_HIM = @Tp_Trf, 
				Trf_Cp_HIM = @Trf_Cp, 
				Trf_Vd_HIM = @Trf_Vd, 
				Vlr_Frete_Negoc_HIM = @Vlr_Frete_Negoc, 
				Dt_Rcb_Doc_HIM = @Dt_Rcb_Doc, 
				Dt_Etg_Doc_HIM = @Dt_Etg_Doc, 
				Obs_HIM = @Obs,
				Transito_HIM = @Transito_HIM,
				Cd_Tp_Oper = @Cd_Tp_Oper, 
				Cd_Despachante = @Cd_Despachante,
				SAP_ShipNumber = @SAP_ShipNumber
			Where
				Num_Proc_HIM = @Num_Proc_HIM
			
			If Left(@Num_Proc_HIM, 5) = 'IMJOB' 
				Begin 
					Update 
						House_imp_mar
					Set 
						Navio_HIM = @Navio_HIM,
						Viagem_HIM = @Viagem_HIM,
						Dt_Cheg_HIM = @Dt_Cheg

					Where
						Num_Proc_HIM = @Num_Proc_HIM


					If @@Error <> 0 		
						Begin 
							Rollback Transaction 
							Return -5
						End 

					Update 
						Job_Imp_Mar
					Set 
						Cd_Terminal = @Cd_Terminal,
						Cd_Armador = @Cd_Armador ,
						Cd_Usuario = @Cd_Usuario,
						BL_Orig =  @BL_Orig, 
						Fat_Orig = @Fat_Orig,
						Cd_Agente = @Cd_Agente, 
						MAWB_HIM = @MAWB_JIM,
						Inv_HIM = @Inv_HIM,
						Cd_Vendedor = @Cd_Vendedor 
					Where
						Num_Proc_HIM = @Num_Proc_HIM


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

					Exec pEventoHouse_Ins @Eventos, @Num_Proc_HIM
					If @@Error <> 0 
						Begin 
							RollBack Transaction 
							Return 30
						End

					Commit Transaction			
					Return 1 
				End 
	
		End
	Else
		Return - 1
GO
