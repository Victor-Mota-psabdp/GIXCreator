SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HEA_InsUpd]
(
	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@MAWB				varchar(25),
	@HAWB				varchar(25),
	@Cd_Export_HEA 		Varchar(10), --@Export				varchar(50),
	@Cd_consig_HEA 		Varchar(10), --@Consignee			varchar(50),
	@Cd_Notify_HEA 		Varchar(10), --@Notify				varchar(50),
	@Cd_Org_HEA 		Varchar(10), --@Origem				varchar(50),
	@Cd_Dst_HEA 		VarChar(10), --@Destino			varchar(50),
	@Voo_HEA			VarChar(10),	
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Real			Float,
	@Peso_Cubado_Lea	Float,	
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Cd_Tp_Moeda 		Varchar(3), --@Moeda 				varchar(50),
	@Vlr_Frete_Efet		Float,
	@Obs				Varchar(2000),
	@Cd_Dsp_HEA 		VarChar(10), --@CHB				varchar(50),
	@SAP_ShipNumber		varchar(20),
	@Cd_Tp_Oper 		VarChar(3), --@Incoterm			varchar(50),
	@Cd_Terminal		Varchar(10), --@Terminal			Varchar(50),
	@TTime_d			smallint,
--Variaveis Job_Exp_Aer
	@Nr_Reserva			varchar(20),
	@Cd_Agente			Varchar(10), --@Agente				varchar(50),
	@Cd_Vendedor		Varchar(30), --@Vendedor			varchar(50),
	@Cd_Usuario			Varchar(30), --@Customer			varchar(50),
	@Cd_CiaAerea_Lea	varchar(3), --@CiaAerea			varchar(50),	
--Variaveis LLP_Exp_Aer
	@ETA_Lea			Datetime,
	@ETD_Lea			Datetime,
	@ATA_Lea			Datetime,
	@ATD_Lea			Datetime,
	@Cd_Planta_LEA		varchar(3), --@Planta				varchar(50),
	@Cd_DstFinal_LEA 	varchar(3)	, --@DstFinal			varchar(50),
	@Intl_Ref_Lea		Varchar(50),
	@Canal_Lea			Varchar(20),
	@DL_Cargo_Lea		Datetime,
	@Cd_Courier			Varchar(10)	, --@Courier			Varchar(50),
	@Courier_Number_Lea	Varchar(50),	
	@Cd_Order			Varchar(10), --@Order				Varchar(50),	
	@Original_ETA_Lea	Datetime,
	@Cd_Forwarder		Varchar(10), --@Forwarder			Varchar(50),
	@Cd_Transportadora	Varchar(10), --@Transportadora		varchar(50),
	@Vlr_Invoice		float,
	@cd_moeda_INV 		Varchar(3), --@Moeda_INV			varchar(30),
	
	@Tx_Refer_Hea		float,	
	@Net_Rates_Lea		Float,
	@Selling_Rates_Lea	Float,
	@Cd_Notify_2		Varchar(10), --@Notify_2			varchar(50),
	@Comissao_Agente_Lea float,
	@ProcessoN		VarChar(16) OUTPUT
)

 AS

Begin Transaction

	Declare @Seq				Varchar(10)			
	Declare @Job				VarChar(16)
	if @Processo is null
		Begin 
			Declare @Grupo	varchar(3)
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Export_HEA)
			Set @Processo = 'EA' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LEA,14),3)),0)+1 from LLP_exp_Aer where left(Num_Proc_LEA,11)=@Processo)

			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into House_exp_Aer
				(
					Num_Proc_HEA,Num_Proc_MEA,Dt_Emis_HEA,MAWB_HEA,HAWB_HEA,Cd_Export_HEA,Cd_Consig_HEA,Cd_Notify_HEA,
					Cd_Org_HEA,Cd_Dst_HEA,Voo_HEA,Cd_Dsp_HEA,Qtd_Tot_Vol_HEA,Peso_Bruto_HEA,Peso_Real_HEA,
					Vol_Tot_HEA,Tp_Frete_HEA,Cd_Tp_Moeda,Vlr_Frete_Tot_HEA,SAP_ShipNumber,Cd_Tp_Oper,
					TTime_d,Tx_Refer_HEA,Obs_HEA
				)
			Values
				(
					@Processo,'JOB',@Dt_Emis,@MAWB,@HAWB,@Cd_Export_HEA,@Cd_Consig_HEA,@Cd_Notify_HEA,
					@Cd_Org_HEA,@Cd_Dst_HEA,@Voo_HEA,@Cd_Dsp_HEA,@Qtd_Tot_Vol,@Peso_Bruto,@Peso_Real,
					@Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,@SAP_ShipNumber,@cd_tp_oper,
					@TTime_d,@Tx_Refer_HEA,@Obs
				)
			Set @ProcessoN = @Processo
		End
	Else
		Begin
			Update
				House_exp_Aer
			Set
				Dt_Emis_HEA	= @Dt_Emis,
				MAWB_HEA	= @MAWB,
				HAWB_HEA	= @HAWB,
				Cd_Export_HEA	= @Cd_Export_HEA,
				Cd_Consig_HEA	= @Cd_Consig_HEA,
				Cd_Notify_HEA	= @Cd_Notify_HEA,
				Cd_Org_HEA	= @Cd_Org_HEA,
				Cd_Dst_HEA	= @Cd_Dst_HEA,
				Voo_HEA		= @Voo_HEA,
				Cd_Dsp_HEA	= @Cd_Dsp_HEA,
				Qtd_Tot_Vol_HEA	= @Qtd_Tot_Vol,
				Peso_Bruto_HEA	= @Peso_Bruto,
				Peso_Real_HEA	= @Peso_Real,
				Vol_Tot_HEA	= @Vol_Tot,
				Tp_Frete_HEA	= @Tp_Frete,
				Cd_Tp_Moeda	= @cd_tp_Moeda,
				Vlr_Frete_Tot_HEA=@Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper	= @Cd_Tp_Oper,
				TTime_d		= @TTime_d,
				Tx_Refer_HEA	= @Tx_Refer_HEA,
				Obs_HEA		= @Obs
			Where
				Num_Proc_HEA	= @Processo
	End

	if exists(select num_proc_HEA from job_exp_Aer where num_proc_HEA=@Processo)
		Begin
			Update
				Job_exp_Aer
			SET				
				--Nr_Reserva = @Nr_Reserva,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario),
				Cd_Agente = @Cd_Agente,
				Cd_vendedor=@cd_vendedor,
				Mawb_HEA=@Mawb
			WHERE
				num_proc_HEA=@Processo
		END
	ELSE
		BEGIN
			Insert into	Job_exp_Aer
				(
					Num_Proc_HEA,Cd_Usuario,Cd_Agente,MAWB_HEA,Cd_Vendedor
				)
			Values
				(
					@Processo,@Cd_Usuario,@Cd_Agente,@MAWB,@Cd_Vendedor
				)
		END

--TRATAMENTO PARA A TABELA LLP_EXP_Aer
	If  exists (select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Processo)
		Begin
			Update
				LLP_Exp_Aer
			Set
				ETA_LEA 			= @ETA_LEA,
				ETD_LEA				= @ETD_LEA,
				ATA_LEA				= @ATA_LEA,
				ATD_LEA				= @ATD_LEA,
				Cd_CiaAerea_Lea		= @Cd_CiaAerea_Lea,
				Cd_Planta_LEA		= @Cd_Planta_LEA,
				Cd_DstFinal_LEA		= @Cd_DstFinal_LEA,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_LEA	= @Courier_Number_LEA,	
				Cd_Forwarder 		= @Cd_Forwarder,
				Intl_Ref_LEA		= @Intl_Ref_LEA,
				Net_Rates_LEA		= @Net_Rates_LEA,
				Selling_Rates_LEA	= @Selling_Rates_LEA,
				Peso_Cubado_LEA		= @Peso_Cubado_LEA,
				Cd_Order			= @CD_Order,
				Cd_Terminal			= @CD_Terminal,
				DL_Cargo_Lea		= @DL_Cargo_Lea,
				Canal_Lea			= @Canal_Lea,
				Cd_Transportadora	= @Cd_Transportadora,
				Cd_Notify_2			= @Cd_Notify_2,
				Original_ETA_Lea	= @Original_ETA_Lea,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv,
				Comissao_Agente_Lea		= @Comissao_Agente_Lea
			Where
				Num_Proc_LEA	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Exp_Aer
				(
					Num_Proc_LEA,ETA_LEA,ETD_LEA,ATA_LEA,ATD_LEA,Cd_CiaAerea_Lea,Cd_Planta_LEA,Cd_DstFinal_LEA,
					Cd_Courier,Courier_Number_LEA,Intl_Ref_LEA,Net_Rates_LEA,Selling_Rates_LEA,Peso_Cubado_LEA,
					Cd_Order,DL_Cargo_Lea,Canal_Lea,Cd_Transportadora,Cd_Notify_2,Original_ETA_Lea,	Vlr_Invoice,
					Cd_Moeda_Invoice,Comissao_Agente_Lea
				)
			Values
				(
					@Processo,@ETA_LEA,@ETD_LEA,@ATA_LEA,@ATD_LEA,@Cd_CiaAerea_Lea,	@Cd_Planta_LEA,@Cd_DstFinal_LEA,
					@Cd_Courier,@Courier_Number_LEA,@Intl_Ref_LEA,@Net_Rates_LEA,@Selling_Rates_LEA,@Peso_Cubado_LEA,
					@Cd_Order,@DL_Cargo_Lea,@Canal_Lea,@Cd_Transportadora,@Cd_Notify_2,@Original_ETA_Lea,@Vlr_Invoice,
					@Cd_Moeda_Inv,@Comissao_Agente_Lea
				)
		End


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION	RETURN -1
			END

Commit Transaction

GO
