SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE   PROCEDURE pJIM_Ins
(
@Num_Prop			varchar(11), 
@Dt_Emis			varchar(10), 
@HAWB			varchar(25),
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
@Navio				VarChar(15)=Null,
@Viagem			VarChar(5)=Null, 
@Dt_Cheg			VarChar(10)=Null, 
@Cd_Terminal			VarChar(3)=Null, 
@Cd_Tp_Oper			VarChar(3)=Null,
@Cd_Armador			Varchar(3)=Null,
@Cd_Usuario			VarChar(6),
@Bl_Orig			Bit=0,
@Fat_Orig			Bit=0,  
@Num_Proc_HIM		VarChar(16) = '' OUTPUT,
@Cd_Despachante		VarChar(10) = Null, 
@Cd_Agente			VarChar(10) = Null,
@MAWB_HIM			VarChar(25)=Null ,
@Inv_HIM			VarChar(100)='',
@Cd_Vendedor			VarChar(6)=Null ,
@Dead_Line			Datetime=Null, 
@TTime_d			smallint=null,
@TTime_h			smallint=null,
@Site				char(1)=''
)
 AS
	Declare @Date			VarChar(12) 
	Declare @DespDest 		Char(1)
	Declare @Num_Proc_MIM	VarChar(14) 
	Declare @MAWB		Varchar(25) 
	Declare @ID_Viagem		Int
	Declare @Stand			bit 

	If @Site = 'E'
		Set @Stand = 1 
	Else
		Set @Stand = 0

	Set @Date = Convert(VarChar(12),GetDate(),103)
	Begin Transaction 
	Set @ID_Viagem = (Select ID_Viagem From Master_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM)
	Execute pHIM_Referencia_Ins 'JOB' , @referencia = @Num_Proc_HIM OUTPUT
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
				Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM, Navio_HIM, Viagem_HIM, Dt_Cheg_HIM, JOB_HIM, 
				Cd_Despachante, Dead_Line, TTime_d, TTime_h, Stand, Cd_Tp_Oper)
			Values 
				(RTrim(@Num_Proc_HIM), 'JOB', @Num_Prop, @Dt_Emis, @HAWB, 'JOB', @Cd_Import, 
				@Cd_Consig, @Cd_Export, @ID_Viagem, @Band_Bras, @Cd_Org, @Cd_Dst, @Dt_Saida,
				@Tp_Frete, @Cd_Tp_Moeda, @Vlr_Frete_Efet, @Prod_Perig, @Prod_Perec, @Cd_Sb_Ag_Int, 
				@Cd_Sb_Ag_Nac, @Cd_Tp_Prod, @EW, @FOB_FCA, @CIF, @Cli_Msq, @Cd_Porto_Rcb, @Cd_Emissor, 
				@Cd_Tp_Embal, @Qtd_Tot_Vol, @Vol_Tot, @Peso_Liquido, @Peso_Bruto, @Tp_Trf, @Trf_Cp, @Trf_Vd, 
				@Vlr_Frete_Negoc, @Dt_Rcb_Doc, @Dt_Etg_Doc, @Obs, @Transito_HIM, @Navio, @Viagem, @Dt_Cheg, @Num_Proc_HIM, 
				@Cd_Despachante, @Dead_Line, @TTime_d, @TTime_h, @Stand, @Cd_Tp_Oper)
			
			If @@RowCount =1 
				Begin 
					Insert Into Job_Imp_Mar Values (@Num_Proc_HIM, @Cd_Terminal,@Cd_Armador, @Cd_usuario, @Bl_Orig, @Fat_Orig, @Cd_Agente, @MAWB_HIM, @Inv_HIM, @Cd_Vendedor)
					Commit Transaction 
					Return 1 
				End 
			Else
				Begin 
					RollBack Transaction
					Return -2 
				End  
		End
	Else
		Return - 1
GO
