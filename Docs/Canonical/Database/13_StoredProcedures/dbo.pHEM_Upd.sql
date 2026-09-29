SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pHEM_Upd
(
@Num_Proc_HEM			varchar(16),
@Num_Proc_MEM			varchar(14), 
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
@Cd_Emissor				VarChar(4)=Null,
@Navio					VarChar(15)='',
@Viagem				VarChar(5)='',
@Cd_Tp_Oper				VarChar(3),
@Trf_Cp				Float=Null,
@cd_usuario				VarChar(6)=Null,
@Nr_Reserva				VarChar(20)=Null, 
@Dead_Line				DateTime=Null,
@Dt_ETA				DateTime=Null,
@Cd_Agente				VarChar(10)=Null,
@MAWB_HEM				VarChar(25)='',
@Inv_HEM				VarChar(100)='',
@Cd_Vendedor				VarChar(6)=Null,
@Eventos				varchar(500)='',
@SAP_ShipNumber			varchar(20)='',
@CourrierCode				varchar(20)=''
 
)
 AS
	Begin Transaction 
	If Exists(Select * From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM)
		Begin 
			Update  
				House_Exp_Mar
			Set 
				Dt_Emis_HEM = @Dt_Emis,
				Dt_Etg_BL_HEM = @Dt_Etg_BL_HEM, 
				HAWB_HEM = @HAWB, 
--				MAWB_HEM =@MAWB, 
				Cd_Consig_HEM = @Cd_Consig, 
				Cd_Export_HEM = @Cd_Export, 
				Cd_Notify_HEM = @Cd_Notify, 
				Band_Bras_HEM = @Band_Bras, 
				Cd_Org_HEM = @Cd_Org, 
				Cd_Dst_HEM = @Cd_Dst,
				Cd_Sb_Ag_Nac_HEM = @Cd_Sb_Ag_Nac,
				Trf_Vd_HEM = @Trf_Vd,
				Tp_Frete_HEM = @Tp_Frete, 
				Cd_Tp_Moeda = @Cd_Tp_Moeda, 
				Vlr_Frete_Tot_HEM = @Vlr_Frete_Tot,
				Cd_Tp_Prod = @Cd_Tp_Prod, 
				RE_DSE_HEM = @RE_DSE, 
				SD_HEM = @SD, 
				Prod_Perig_HEM = @Prod_Perig,
				Prod_Perec_HEM = @Prod_Perec, 
				Cd_Dsp_HEM = @Cd_Dsp, 
				Cli_Msq_HEM = @Cli_Msq, 
				Transp_HEM = @Transp, 
				EW_HEM = @EW, 
				FOB_FCA_HEM = @FOB_FCA, 
				CIF_HEM = @CIF, 
				Cd_Tp_Embal = @Cd_Tp_Embal, 
				Qtd_Tot_Vol_HEM = @Qtd_Tot_Vol, 
				Vol_Tot_HEM = @Vol_Tot, 
				Peso_Liquido_HEM = @Peso_Liquido, 
				Peso_Bruto_HEM = @Peso_Bruto,
				Dt_Rcb_Crg_HEM = @Dt_Rcb_Crg, 
				Dt_Rcb_Doc_HEM = @Dt_Rcb_Doc, 
				Obs_HEM = @Obs,
				Transito_HEM = @Transito_HEM,
				Cd_Emissor = @Cd_Emissor,
				Navio_HEM = @Navio,
				Viagem_HEM = @Viagem,
				Cd_Tp_Oper = @Cd_Tp_Oper,
				Trf_Cp_HEM = @Trf_CP,
				SAP_ShipNumber = @SAP_ShipNumber,
				CourrierCode = @CourrierCode
			Where 
				Num_Proc_HEM = @Num_Proc_HEM
		End

	If @@Error <>0 
		Begin 
			Rollback Transaction 
			Return -1
		End 
	Else 
		Begin 

			Exec pEventoHouse_Ins @Eventos, @NUm_PRoc_HEM
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return 30
				End
				

			If Left(@Num_Proc_HEM , 5) = 'EMJOB'
				Begin 
					Update 
						Job_Exp_Mar
					Set 
						Cd_Usuario = @Cd_Usuario,
						Nr_Reserva = @Nr_Reserva, 
						Dead_Line = @Dead_Line,
						Dt_ETA=@Dt_ETA, 
						Cd_Agente   = @Cd_Agente,
						MAWB_HEM  = @MAWB_HEM,
						Inv_HEM = @Inv_HEM,
 						Cd_Vendedor= @Cd_Vendedor 
					Where 
						Num_proc_HEM = @Num_Proc_HEM
	
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
