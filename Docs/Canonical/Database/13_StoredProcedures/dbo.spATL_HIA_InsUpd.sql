SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT created,last_altered, *
--FROM    information_schema . routines
--WHERE   routine_type  =  'PROCEDURE'
--and specific_name like '%spATL_HIA_InsUpd%'

CREATE PROCEDURE [dbo].[spATL_HIA_InsUpd]
(
	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@MAWB				varchar(25),
	@HAWB				varchar(25),
	@Cd_Export_HIA 		Varchar(10), --@Export			varchar(20),
	@Cd_Consig_HIA 		Varchar(10), --@Consignee		varchar(20),
	@Cd_Import_HIA 		Varchar(10),--@Import			varchar(20),
	@Cd_Org_HIA 		Varchar(10), --@Origem			varchar(30),
	@Cd_Dst_HIA 		VarChar(10), --@Destino		varchar(30), 
	@Voo_HIA			VarChar(13),
	@Qtd_Tot_Vol		Float,
	@Peso_Real			Float,
	@Peso_Bruto			Float,
	@Peso_Cubado_LIA	Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Cd_Tp_Moeda 		Varchar(3), --@Moeda 			varchar(30),
	@Vlr_Frete_Efet		Float,
	@Obs				Varchar(2000),
	@Cd_Dsp_HIA			VarChar(10), --@CHB			varchar(20),
	@SAP_ShipNumber		varchar(20),
	@Cd_Tp_Oper			Varchar(10), --@Incoterm		varchar(50),
	@Cd_Terminal		varchar(10), --@Terminal		varchar(50),
	@TTime_d			smallint,

--Job_Imp_Aer
	@Cd_Agente			varchar(10), --@Agent			varchar(20),	
	@Cd_Vendedor		varchar(6), --@Sales			varchar(30),	
	@Cd_Usuario			Varchar(10), --@Customer		varchar(30),	
	@Cd_Cia_Aer			varchar(3), --@CiaAerea		varchar(30),

--LLP_Imp_Aer
	@ETD_LIA				Datetime,
	@ATD_LIA				Datetime,	
	@ETA_LIA				Datetime,
	@ATA_LIA				Datetime,
	@Cd_Planta_LIA		varchar(3), --@Planta			varchar(30),
	@Cd_DstFinal_LIA 	varchar(3), --@DstFinal	 	varchar(30),	
	@Intl_Ref_LIA		varchar(50),	
	@Canal_Lia			varchar(20), 	
	@DL_Cargo_Lia		Datetime,	
	@Cd_Courier			Varchar(10), --@Courier		Varchar(50),	
	@Courier_Number_Lia	Varchar(50),	
	@Cd_Order			Varchar(10), --@Order			Varchar(50),	
	@Original_ETA_Lia	Datetime,	
	@Cd_Forwarder		varchar(10), --@Forwarder		varchar(20),
	@Cd_Transportadora	Varchar(10), --@Transportadora	varchar(50),
	@Vlr_Invoice		float,
	@cd_moeda_INV 		Varchar(3), --@Moeda_INV		varchar(30),
	@ProcessoN			VarChar(16) OUTPUT
)

 AS

Begin Transaction

	Declare @Seq			VarChar(10)	

	if @Processo is null
		Begin 
			Declare @Grupo	varchar(3)
			Set @Grupo = (select Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_consig_HIA)
			Set @Processo = 'IA' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LIA,14),3)),00)+1 from LLP_Imp_Aer where left(Num_Proc_LIA,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)
			Insert Into House_Imp_Aer
				(
					Num_Proc_HIA,Num_Proc_MIA,Dt_Emis_HIA,MAWB_HIA,	HAWB_HIA,Cd_Export_HIA,Cd_Consig_HIA,
					Cd_Import_HIA,Cd_Org_HIA,Cd_Dst_HIA,Voo_HIA,Cd_Dsp_HIA,	Qtd_Tot_Vol_HIA,Peso_Real_HIA,
					Peso_Bruto_HIA,	Vol_Tot_HIA,Tp_Frete_HIA,Cd_Tp_Moeda,Vlr_Frete_Efet_HIA,SAP_ShipNumber,
					Cd_Tp_Oper,	Job_HIA,TTime_d,Obs_HIA
				)
			Values
				(
					@Processo,'JOB',@Dt_Emis,@MAWB,@HAWB,@Cd_Export_HIA,@Cd_Consig_HIA,
					@Cd_Import_HIA,@Cd_Org_HIA,	@Cd_Dst_HIA,@Voo_HIA,@Cd_Dsp_HIA,@Qtd_Tot_Vol,@Peso_Real,
					@Peso_Bruto,@Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,@SAP_ShipNumber,
					@cd_tp_oper,@Processo,@TTime_d,@Obs
				)
			Set @ProcessoN = @Processo
	End
	Else
		Begin
			Update
				House_Imp_Aer
			Set
				Dt_Emis_HIA	= @Dt_Emis,
				MAWB_HIA	= @MAWB,
				HAWB_HIA	= @HAWB,
				Cd_Export_HIA= @Cd_Export_HIA,
				Cd_Consig_HIA= @Cd_Consig_HIA,
				Cd_Import_HIA= @Cd_Import_HIA,
				Cd_Org_HIA	= @Cd_Org_HIA,
				Cd_Dst_HIA	= @Cd_Dst_HIA,
				Voo_HIA		= @Voo_HIA,
				Cd_Dsp_HIA	= @Cd_Dsp_HIA,
				Qtd_Tot_Vol_HIA	= @Qtd_Tot_Vol,
				Peso_Real_HIA	= @Peso_Real,
				Peso_Bruto_HIA	= @Peso_Bruto,
				Vol_Tot_HIA	= @Vol_Tot,
				Tp_Frete_HIA	= @Tp_Frete,
				Cd_Tp_Moeda	= @cd_tp_Moeda,
				Vlr_Frete_Efet_HIA= @Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper	= @Cd_Tp_Oper,
				Job_HIA		= @Processo,
				TTime_d		= @TTime_d,
				Obs_HIA		= @Obs
			Where
				Num_Proc_HIA	= @Processo
	End

--TRATAMENTO PARA A TABELA JOB_Imp_Aer
	if exists(select num_proc_HIA from job_Imp_Aer where num_proc_HIA=@Processo)
		Begin
			Update
				Job_Imp_Aer
			SET
				Cd_Cia_Aer	= @Cd_Cia_Aer,
				Cd_Agente	= @Cd_Agente,
				Cd_Vendedor	= @Cd_Vendedor,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario)
			WHERE
				num_proc_HIA=@Processo
		END
	ELSE
		BEGIN
			Insert into
				Job_Imp_Aer
				(
					Num_Proc_HIA,Cd_Cia_Aer,Cd_Agente,Cd_Vendedor,Cd_Usuario
				)
			Values
				(
					@Processo,	@Cd_Cia_Aer,@Cd_Agente,@Cd_Vendedor,@Cd_Usuario
				)
			
		END

--TRATAMENTO PARA A TABELA LLP_Imp_MAR
	If  exists (select Num_Proc_LIA from LLP_Imp_Aer where Num_Proc_LIA=@Processo)
		Begin
			Update
				LLP_Imp_Aer
			Set
				ETD_LIA				= @ETD_LIA,
				ATD_LIA				= @ATD_LIA,
				ETA_LIA 			= @ETA_LIA,
				ATA_LIA				= @ATA_LIA,
				Cd_Planta_LIA		= @Cd_Planta_LIA,
				Cd_DstFinal_LIA		= @Cd_DstFinal_LIA,
				Cd_Forwarder		= @Cd_Forwarder,
				Cd_Terminal			= @Cd_Terminal,
				Peso_Cubado_LIA		= @Peso_Cubado_LIA,
				Cd_Order			= @Cd_Order,
				Canal_Lia			= @Canal_Lia,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_Lia 	= @Courier_Number_Lia,
				Dl_Cargo_Lia		= @Dl_Cargo_lia,
				Intl_Ref_LIA		= @Intl_Ref_LIA,
				Cd_Transportadora	= @Cd_Transportadora,
				Original_ETA_Lia 	= @Original_ETA_Lia,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv
			Where
				Num_Proc_LIA	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Imp_Aer
				(
					Num_Proc_LIA,ETD_LIA,ATD_LIA,ETA_LIA,ATA_LIA,Cd_Planta_LIA,Cd_DstFinal_LIA,	Cd_Forwarder,
					Cd_Terminal,Peso_Cubado_LIA,Cd_Order,Canal_Lia,Cd_Courier,Courier_Number_Lia,Dl_Cargo_Lia,
					Intl_Ref_LIA,Cd_Transportadora,	Original_ETA_Lia,Vlr_Invoice,Cd_Moeda_Invoice
				)
			Values
				(
					@Processo,@ETD_LIA,@ATD_LIA,@ETA_LIA,@ATA_LIA,@Cd_Planta_LIA,@Cd_DstFinal_LIA,@Cd_Forwarder,
					@Cd_Terminal,@Peso_Cubado_LIA,@Cd_Order,@Canal_Lia,@Cd_Courier,@Courier_Number_Lia,@Dl_Cargo_Lia,
					@Intl_Ref_LIA,@Cd_Transportadora,@Original_ETA_Lia,@Vlr_Invoice,@Cd_Moeda_Inv
				)
		End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction


/*
ALTER	PROCEDURE 	[dbo].[spATL_HIA_InsUpd]

	@Processo		VarChar(16),
	@Dt_Emis		varchar(10),
	@MAWB			varchar(25),
	@HAWB			varchar(25),
	@Export			varchar(20),
	@Consignee		varchar(20),
	@Import			varchar(20),
	@Origem			varchar(30),
	@Destino		varchar(30), 
	
	@Voo			VarChar(13),
	
	@Qtd_Tot_Vol	Float,
	@Peso_Real		Float,
	@Peso_Bruto		Float,
	@Peso_Cubado	Float,
	
	@Vol_Tot		Float,
	@Tp_Frete		char(1),
	@Moeda 			varchar(30),
	@Vlr_Frete_Efet	Float,
	@Obs			Varchar(2000),

	@CHB			varchar(20),
	@SAP_ShipNumber	varchar(20),
	@Incoterm		varchar(50),
	@Terminal		varchar(50),
	@TTime_d		smallint,

--Job_Imp_Aer
	@Agent			varchar(20),	
	@Sales			varchar(30),	
	@Customer		varchar(30),	
	@CiaAerea		varchar(30),

--LLP_Imp_Aer
	@ETD			Datetime,
	@ATD			Datetime,	
	@ETA			Datetime,
	@ATA			Datetime,

	@Planta			varchar(30),
	@DstFinal	 	varchar(30),	
	@Intl_Ref_LIA	varchar(50),	

	@Canal_Lia		varchar(20), 	
	@DL_Cargo_Lia	Datetime,	
	@Courier		Varchar(50),	
	@Courier_Number_Lia	Varchar(50),
	
	@Order			Varchar(50),	
	@Original_ETA_Lia	Datetime,	
	@Forwarder		varchar(20),
	@Transportadora	varchar(50),

	@Vlr_Invoice	float,
	@Moeda_INV		varchar(30),
	@ProcessoN		VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq			VarChar(10)
		Declare @cd_Export_HIA 		Varchar(10)
		Declare @cd_consig_HIA 		Varchar(10)
		Declare @cd_Import_HIA 		Varchar(10)
		Declare @cd_tp_moeda 		Varchar(3)
		Declare @cd_moeda_INV 		Varchar(3)
		Declare @Cd_Org_HIA 		Varchar(10)
		Declare @cd_dst_HIA 		VarChar(10)
		Declare @cd_Dsp_HIA		VarChar(10)
		Declare @Cd_Cia_Aer		varchar(3)
		Declare @Cd_Planta_LIA		varchar(3)
		Declare @Cd_DstFinal_LIA 	varchar(3)
		Declare @Cd_Agente		varchar(10)
		Declare @Cd_Vendedor		varchar(6)
		Declare @Cd_Forwarder		varchar(10)
		Declare @Cd_Terminal		varchar(10)
		Declare @Cd_Order		Varchar(10)
		Declare	@Cd_Usuario		Varchar(10)
		Declare @Cd_Courier		Varchar(10)
		Declare @cd_tp_oper		Varchar(10)
		Declare	@Cd_Transportadora	Varchar(10)
--Carregando Codigos
		Set @Cd_Export_HIA	=(select cd_pes from pessoa where apelido=@Export)
		Set @Cd_consig_HIA	=(select cd_pes from pessoa where apelido=@Consignee)
		Set @cd_Import_HIA	=(select cd_pes from pessoa where apelido=@Import)
		Set @Cd_Dsp_HIA		=(select cd_pes from pessoa where apelido=@CHB)
		Set @cd_tp_moeda	=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda)
		Set @cd_moeda_INV	=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda_INV)
		Set @cd_org_HIA		=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_dst_HIA		=(select top 1 cd_local from localidade where Nome_Local=@Destino)
		Set @Cd_Planta_LIA	=(select top 1 cd_local from localidade where Nome_Local=@Planta)
		Set @Cd_DstFinal_LIA=(select top 1 cd_local from localidade where Nome_Local=@DstFinal)
		Set @cd_Cia_Aer		=(Select cd_cia_aer from cia_aerea where Nome_Cia_Aer = @CiaAerea)
		Set @cd_Agente		=(Select cd_pes from Pessoa where Apelido = @Agent)
		Set @cd_Forwarder	=(Select cd_pes from Pessoa where Apelido = @Forwarder)
		Set @cd_Vendedor	=(Select top 1 cd_usuario from Usuario where Nome_Usuario = @Sales)
		Set @Cd_Usuario		=(Select top 1 cd_usuario from Usuario where Nome_Usuario = @Customer)
		Set @Cd_Terminal	=(Select Cd_Terminal from Terminal where Nome_Terminal = @Terminal)
		Set @Cd_Order		=(Select cd_pes from Pessoa where Apelido = @Order)
		Set @Cd_Courier		=(Select cd_pes from Pessoa where Apelido = @Courier)
		Set @cd_tp_oper		=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Incoterm)
		Set @Cd_Transportadora = (Select Cd_pes from Pessoa where Apelido = @Transportadora)

	if @Processo is null
		Begin 
			Declare @Grupo	varchar(3)
			Set @Grupo = (select Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_consig_HIA)
			Set @Processo = 'IA' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LIA,14),3)),00)+1 from LLP_Imp_Aer where left(Num_Proc_LIA,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)
			Insert Into 
				House_Imp_Aer
					(
					Num_Proc_HIA,
					Num_Proc_MIA,
					Dt_Emis_HIA,
					MAWB_HIA,
					HAWB_HIA,
					Cd_Export_HIA,
 					Cd_Consig_HIA,
					Cd_Import_HIA,
					Cd_Org_HIA,
					Cd_Dst_HIA,
					Voo_HIA,
					Cd_Dsp_HIA,
					Qtd_Tot_Vol_HIA,
					Peso_Real_HIA,
					Peso_Bruto_HIA,
					Vol_Tot_HIA,
					Tp_Frete_HIA,
					Cd_Tp_Moeda,
				 	Vlr_Frete_Efet_HIA,
					SAP_ShipNumber,
					Cd_Tp_Oper,
					Job_HIA,
					TTime_d,
					Obs_HIA
					)
			Values
				(
				@Processo,
				'JOB',
				@Dt_Emis,
				@MAWB,
				@HAWB,
				@Cd_Export_HIA,
				@Cd_Consig_HIA,
				@Cd_Import_HIA,
				@Cd_Org_HIA,
				@Cd_Dst_HIA,
				@Voo,
				@Cd_Dsp_HIA,
				@Qtd_Tot_Vol,
				@Peso_Real,
				@Peso_Bruto,
				@Vol_Tot,
				@Tp_Frete,
				@cd_tp_Moeda,
				@Vlr_Frete_Efet,
				@SAP_ShipNumber,
				@cd_tp_oper,
				@Processo,
				@TTime_d,
				@Obs
				)
		Set @ProcessoN = @Processo
	End
	Else
		Begin
			Update
				House_Imp_Aer
			Set
				Dt_Emis_HIA	= @Dt_Emis,
				MAWB_HIA	= @MAWB,
				HAWB_HIA	= @HAWB,
				Cd_Export_HIA= @Cd_Export_HIA,
				Cd_Consig_HIA= @Cd_Consig_HIA,
				Cd_Import_HIA= @Cd_Import_HIA,
				Cd_Org_HIA	= @Cd_Org_HIA,
				Cd_Dst_HIA	= @Cd_Dst_HIA,
				Voo_HIA		= @Voo,
				Cd_Dsp_HIA	= @Cd_Dsp_HIA,
				Qtd_Tot_Vol_HIA	= @Qtd_Tot_Vol,
				Peso_Real_HIA	= @Peso_Real,
				Peso_Bruto_HIA	= @Peso_Bruto,
				Vol_Tot_HIA	= @Vol_Tot,
				Tp_Frete_HIA	= @Tp_Frete,
				Cd_Tp_Moeda	= @cd_tp_Moeda,
				Vlr_Frete_Efet_HIA= @Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper	= @Cd_Tp_Oper,
				Job_HIA		= @Processo,
				TTime_d		= @TTime_d,
				Obs_HIA		= @Obs
			Where
				Num_Proc_HIA	= @Processo
	End

--TRATAMENTO PARA A TABELA JOB_Imp_Aer
	if exists(select num_proc_HIA from job_Imp_Aer where num_proc_HIA=@Processo)
		Begin
			Update
				Job_Imp_Aer
			SET
				Cd_Cia_Aer	= @Cd_Cia_Aer,
				Cd_Agente	= @Cd_Agente,
				Cd_Vendedor	= @Cd_Vendedor,
				--Cd_Usuario	= @Cd_Usuario
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario)
			WHERE
				num_proc_HIA=@Processo
		END
	ELSE
		BEGIN
			Insert into
				Job_Imp_Aer
				(
					Num_Proc_HIA,
					Cd_Cia_Aer,
					Cd_Agente,
					Cd_Vendedor,
					Cd_Usuario
				)
			Values
				(
					@Processo,
					@Cd_Cia_Aer,
					@Cd_Agente,
					@Cd_Vendedor,
					@Cd_Usuario
				)
			
		END

--TRATAMENTO PARA A TABELA LLP_Imp_MAR
	If  exists (select Num_Proc_LIA from LLP_Imp_Aer where Num_Proc_LIA=@Processo)
		Begin
			Update
				LLP_Imp_Aer
			Set
				ETD_LIA				= @ETD,
				ATD_LIA				= @ATD,
				ETA_LIA 			= @ETA,
				ATA_LIA				= @ATA,
				Cd_Planta_LIA		= @Cd_Planta_LIA,
				Cd_DstFinal_LIA		= @Cd_DstFinal_LIA,
				Cd_Forwarder		= @Cd_Forwarder,
				Cd_Terminal			= @Cd_Terminal,
				Peso_Cubado_LIA		= @Peso_Cubado,
				Cd_Order			= @Cd_Order,
				Canal_Lia			= @Canal_Lia,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_Lia 	= @Courier_Number_Lia,
				Dl_Cargo_Lia		= @Dl_Cargo_lia,
				Intl_Ref_LIA		= @Intl_Ref_LIA,
				Cd_Transportadora	= @Cd_Transportadora,
				Original_ETA_Lia 	= @Original_ETA_Lia,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv
			Where
				Num_Proc_LIA	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Imp_Aer
				(
					Num_Proc_LIA,
					ETD_LIA,
					ATD_LIA,
					ETA_LIA,
					ATA_LIA,
					Cd_Planta_LIA,
					Cd_DstFinal_LIA,
					Cd_Forwarder,
					Cd_Terminal,
					Peso_Cubado_LIA,
					Cd_Order,
					Canal_Lia,
					Cd_Courier,
					Courier_Number_Lia,
					Dl_Cargo_Lia,
					Intl_Ref_LIA,
					Cd_Transportadora,
					Original_ETA_Lia,
					Vlr_Invoice,
					Cd_Moeda_Invoice
				)
			Values
				(
					@Processo, 
					@ETD,
					@ATD,
					@ETA,
					@ATA,
					@Cd_Planta_LIA,
					@Cd_DstFinal_LIA,
					@Cd_Forwarder,
					@Cd_Terminal,
					@Peso_Cubado,
					@Cd_Order,
					@Canal_Lia,
					@Cd_Courier,
					@Courier_Number_Lia,
					@Dl_Cargo_Lia,
					@Intl_Ref_LIA,
					@Cd_Transportadora,
					@Original_ETA_Lia,
					@Vlr_Invoice,
					@Cd_Moeda_Inv
				)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 


*/














GO
