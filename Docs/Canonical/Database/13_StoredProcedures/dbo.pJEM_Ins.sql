SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  PROCEDURE pJEM_Ins
(
@Num_Prop				varchar(11)='',
@Dt_Emis				varchar(10),
@Dt_Etg_BL_HEM			varchar(10), 
@HAWB				varchar(25),
@Cd_Consig				varchar(10),
@Cd_Export				varchar(10), 
@Cd_Notify				varchar(10), 
@Band_Bras				char(1), 
@Cd_Org				varchar(3),
@Cd_Dst				varchar(3), 
@Cd_Sb_Ag_Nac			varchar(10),
@Trf_Vd				Float, 
@Trf_Cp				Float, 
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
@Cd_Tp_Oper				VarChar(3)=Null,
@Cd_Usuario				VarChar(6),
@Nr_Reserva				VarChar(20)=Null, 
@Dead_Line				Datetime=Null,
@Dt_ETA				Datetime=Null, 
@Num_Proc_HEM			varchar(16) ='' OUTPUT,
@Cd_Agente 				VarChar(10)=Null,
@MAWB_HEM				VarChar(25)='',
@Inv_HEM				VarChar(100)='',
@Cd_Vendedor				VarChar(6)=Null,
@Ttime_d				smallint=null, 
@Ttime_h				smallint=null,
@Site					char(1)='' ,
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
	Declare @ID_Viagem	Int
	Declare @Stand		bit 

	if @Site = 'E'
		Set @Stand = 1 
	Else
		Set @Stand = 0  
 
		Set @Date = Convert(VarChar(12),GetDate(),103)
		Begin Transaction 
		Set @ID_Viagem = (Select ID_Viagem From Master_Exp_Mar Where Num_Proc_MEM = 'JOB')
		Execute pHEM_Referencia_Ins 'JOB' , @referencia = @Num_Proc_HEM OUTPUT
		If @@Error <> 0 
			Begin 
				RollBack Transaction 
				Return -4
			End 
		Insert into House_Exp_Mar
			(Num_Proc_HEM, Num_Proc_MEM, Num_Prop_EM, Dt_Emis_HEM,Dt_Etg_BL_HEM, HAWB_HEM, 
			MAWB_HEM, Cd_Consig_HEM, Cd_Export_HEM, Cd_Notify_HEM, ID_Viagem,
			Band_Bras_HEM, Cd_Org_HEM, Cd_Dst_HEM,Cd_Sb_Ag_Nac_HEM,Trf_Vd_HEM,Trf_Cp_HEM,Tp_Frete_HEM, 
			Cd_Tp_Moeda, Vlr_Frete_Tot_HEM,Cd_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM,
			Prod_Perec_HEM, Cd_Dsp_HEM, Cli_Msq_HEM,Transp_HEM, EW_HEM, FOB_FCA_HEM, 
			CIF_HEM, Cd_Tp_Embal, Qtd_Tot_Vol_HEM, Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM,
			Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, Obs_HEM, Transito_HEM, Cd_Emissor, Navio_HEM, Viagem_HEM, 
			JOB_HEM, Cd_Tp_Oper, Dead_Line, TTime_d, TTime_h, Stand ) 
		Values 
			(@Num_Proc_HEM ,'JOB', @Num_Prop, @Dt_Emis, @Dt_Etg_BL_HEM, @HAWB, 
			 'JOB',@Cd_Consig, @Cd_Export, @Cd_Notify, @ID_Viagem, @Band_Bras, @Cd_Org, 
			 @Cd_Dst, @Cd_Sb_Ag_Nac, @Trf_Vd, @Trf_Cp, @Tp_Frete, @Cd_Tp_Moeda, @Vlr_Frete_Tot, @Cd_Tp_Prod,
			 @RE_DSE, @SD, @Prod_Perig, @Prod_Perec, @Cd_Dsp, @Cli_Msq, @Transp, @EW, @FOB_FCA, 
			 @CIF, @Cd_Tp_Embal, @Qtd_Tot_Vol, @Vol_Tot, @Peso_Liquido, @Peso_Bruto, @Dt_Rcb_Crg,
			 @Dt_Rcb_Doc, @Obs, @Transito_HEM, @Cd_Emissor, @Navio,  @Viagem, @Num_Proc_HEM, @Cd_Tp_Oper, 
			@Dead_Line, @TTime_d, @TTime_h, @Stand )	
		If @@RowCount = 1 
			Begin 
				Exec pEventoHouse_Ins @Eventos, @NUm_PRoc_HEM
				If @@Error <> 0 
					Begin 
						RollBack Transaction 
						Return 30
					End


				Insert Into 
					Job_Exp_Mar
					(Num_Proc_HEM, Cd_Usuario, Nr_Reserva, Dead_Line, Dt_ETA, Cd_Agente, MAWB_HEM, Inv_HEM, Cd_Vendedor )
				Values 
					(@Num_Proc_HEM, @Cd_Usuario, @Nr_Reserva, @Dead_Line, @Dt_ETA, @Cd_Agente, @MAWB_HEM, @Inv_HEM, @Cd_Vendedor)

				If @@Error  <> 0 
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
				Return -1 
			End

GO
