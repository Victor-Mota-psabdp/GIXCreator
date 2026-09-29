SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado o cd_usuario - 11/4/2017 - cadu

CREATE  PROCEDURE [dbo].[spHIO_InsUpd]

	@Processo		VarChar(16),
	@Dt_Emis		varchar(10),
	@HAWB			varchar(25),
	@Export			varchar(50),
	@Consignee		varchar(50),
	@Notify			varchar(50),
	@Origem			varchar(50),
	@Destino		varchar(50),
	@Voo_HIO		VarChar(10),
	@Qtd_Tot_Vol	Float,
	@Peso_Bruto		Float,
	@Peso_Real		Float,
	@Vol_Tot		Float,
	@Tp_Frete		char(1),
	@Moeda 			varchar(50),
	@Vlr_Frete_Efet	Float,
	@SAP_ShipNumber	varchar(20),
	@Incoterm		varchar(50),
	@Obs			Varchar(2000),

--Variaveis LLP_IMP_OUT
	@ETA_LIO		Datetime,
	@ETD_LIO		Datetime,
	@ATA_LIO		Datetime,
	@ATD_LIO		Datetime,
	@Planta			varchar(50),
	@DstFinal	 	varchar(50),
	@Forwarder		Varchar(50),
	@Carrier		Varchar(50),
	@CHB			varchar(50),
	@Intl_Ref_LIO		Varchar(50),
	@Peso_Cubado_LIO	Float,	
	@DL_Cargo_LIO		Datetime,
	@Vendedor		varchar(50),
	@Agente			varchar(50),
	@Tipo			char(1),
	@Terminal		Varchar(50),
	@TTime_d		smallint,
	@Order			Varchar(50),
	@Customer		Varchar(50),
	@Canal_Lio		Varchar(20),
	@Courier		Varchar(50),
	@Courier_Number_Lio	Varchar(50),
	@Original_ETA_LIO	DateTime,
	@Transportadora	varchar(50),
	@Vlr_Invoice	float,
	@Moeda_INV		varchar(30),
	@ProcessoN		VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq			Varchar(10)	
		Declare @cd_consig_HIO 		Varchar(10)
		Declare @cd_IMPort_HIO 		Varchar(10)
		Declare @cd_Export_HIO 		Varchar(10)
		Declare @cd_tp_moeda 		Varchar(3)
		Declare @cd_moeda_INV 		Varchar(3)
		Declare @Cd_Org_HIO 		Varchar(10)
		Declare @cd_dst_HIO 		VarChar(10)
		Declare @cd_dsp_HIO 		VarChar(10)
		Declare @Cd_tp_oper 		VarChar(3)
--Variaveis LLP_IMP_OUTROS
		Declare @Cd_Planta_LIO		varchar(3)
		Declare @Cd_DstFinal_LIO 	varchar(3)	
		Declare @Cd_Despachante		Varchar(10)	
		Declare @Cd_Forwarder		Varchar(10)
		Declare @Cd_Agente		Varchar(10)
		Declare @Cd_Vendedor		Varchar(30)
		Declare @Cd_Carrier		Varchar(10)
		Declare @Cd_Terminal		Varchar (10)
		Declare @Cd_Order		Varchar(10)
		Declare @Cd_Usuario		Varchar(10)
		Declare @Cd_Courier		Varchar(10)
		Declare	@Cd_Transportadora	Varchar(10)
--Carregando Codigo pessoa
		Set @Cd_consig_HIO=(select cd_pes from pessoa where apelido=@Consignee)
		Set @Cd_Export_HIO=(select cd_pes from pessoa where apelido=@Export)
		Set @cd_Import_HIO=(select cd_pes from pessoa where apelido=@Notify)
		Set @Cd_Despachante=(select cd_pes from pessoa where apelido=@CHB)
		Set @Cd_Forwarder= (select Cd_Pes from pessoa where apelido=@Forwarder)
		Set @Cd_Carrier= (select Cd_Pes from pessoa where apelido=@Carrier)
		Set @Cd_Agente= (select Cd_Pes from pessoa where apelido=@Agente)
		Set @Cd_Order= (select Cd_Pes from pessoa where apelido=@Order)
		Set @Cd_Courier= (select Cd_Pes from pessoa where apelido=@Courier)
		Set @Cd_Transportadora = (Select Cd_pes from Pessoa where Apelido = @Transportadora)
--Carregando Moeda
		Set @cd_tp_moeda=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda)
		Set @cd_moeda_INV	=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda_INV)
--Carregando Localidade
		Set @cd_org_HIO=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_dst_HIO=(select top 1 cd_local from localidade where Nome_Local=@Destino)
		Set @Cd_Planta_LIO = (select top 1 cd_local from localidade where Nome_Local=@Planta)
		Set @Cd_DstFinal_LIO = (select top 1 cd_local from localidade where Nome_Local=@DstFinal)

--Carregando Incoterm
		Set @cd_tp_oper= (Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Incoterm)

--Carregando Usuario
		Set @Cd_Vendedor=(Select top 1 Cd_usuario from Usuario where Nome_Usuario = @Vendedor)
		Set @Cd_Usuario=(Select top 1 Cd_usuario from Usuario where Nome_Usuario = @Customer)

--Carregando Terminal
		Set @Cd_Terminal=(Select Cd_Terminal from Terminal where Nome_Terminal = @Terminal)

 -- Regra Bloqueado Processo NULL (Leandro 19-02-25)
DECLARE @ID_Status INT;

		IF @Processo is null
		BEGIN
			IF EXISTS (
				SELECT LC.Nome_Local 
				FROM Localidade LC WITH (NOLOCK)
				JOIN Pais P WITH (NOLOCK) ON LC.Cd_Pais = P.Cd_Pais 
				WHERE (LC.Nome_Local = @Origem OR LC.Nome_Local = @Planta) 
				  AND LC.Desat_loc = 'N' 
				  AND P.Bloqueado = 1
        
				UNION ALL
        
				SELECT PP.Apelido 
				FROM dbo.Pessoa PP WITH (NOLOCK)
				JOIN dbo.Endereco ED WITH (NOLOCK) ON ED.Cd_Pes = PP.Cd_Pes AND Cd_Tp_End = 'COM'
				JOIN dbo.Pais P WITH (NOLOCK) ON P.Cd_Pais = ED.CD_Pais 
				LEFT OUTER JOIN dbo.Tipo_Atividade TA WITH (NOLOCK) ON PP.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
				LEFT OUTER JOIN dbo.Tipo_Grupo TG WITH (NOLOCK) ON PP.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
				LEFT OUTER JOIN dbo.Usuario US WITH (NOLOCK) ON PP.Cd_Usuario = US.Cd_Usuario 
				WHERE (PP.Apelido = @Export OR PP.Apelido = @Notify) 
				  AND PP.Desat_Pes = 'N' 
				  AND P.Bloqueado = 1 
				  AND P.Ativo = 1
			)
			BEGIN
				SET @ID_Status = 10;
			END
		END
	
	if @Processo is null
		Begin 
			Declare @Grupo	varchar(3)
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_consig_HIO)
			Set @Processo = 'IO' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LIO,14),3)),0)+1 from LLP_IMP_OUT where left(Num_Proc_LIO,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into 
				House_IMP_OUT
					(
					Num_Proc_HIO,
					Dt_Emis_HIO,
					HAWB_HIO,
					Cd_Import_HIO,
 					Cd_Consig_HIO,
					Cd_Export_HIO,
					Cd_Org_HIO,
					Cd_Dst_HIO,
					Voo_HIO,
					Qtd_Tot_Vol_HIO,
					Peso_Bruto_HIO,
					Peso_Real_HIO,
					Vol_Tot_HIO,
					Tp_Frete_HIO,
					Cd_Tp_Moeda,
				 	Vlr_Frete_Efet_HIO,
					SAP_ShipNumber,
					Cd_Tp_Oper,
					TTime_d,
					Obs_HIO
					)
			Values
				(
				@Processo,
				@Dt_Emis,
				@HAWB,
				@Cd_IMPort_HIO,
				@Cd_Consig_HIO,
				@Cd_Export_HIO,
				@Cd_Org_HIO,
				@Cd_Dst_HIO,
				@Voo_HIO,
				@Qtd_Tot_Vol,
				@Peso_Bruto,
				@Peso_Real,
				@Vol_Tot,
				@Tp_Frete,
				@cd_tp_Moeda,
				@Vlr_Frete_Efet,
				@SAP_ShipNumber,
				@cd_tp_oper,
				@TTime_d,
				@Obs
				)
		Set @ProcessoN = @Processo
	End
	Else
		Begin
			Update
				House_IMP_OUT
			Set
				Dt_Emis_HIO	= @Dt_Emis,
				HAWB_HIO	= @HAWB,
				Cd_IMPort_HIO= @Cd_IMPort_HIO,
				Cd_Consig_HIO= @Cd_Consig_HIO,
				Cd_Export_HIO= @Cd_Export_HIO,
				Cd_Org_HIO	= @Cd_Org_HIO,
				Cd_Dst_HIO	= @Cd_Dst_HIO,
				Voo_HIO		= @Voo_HIO,
				Qtd_Tot_Vol_HIO	= @Qtd_Tot_Vol,
				Peso_Bruto_HIO	= @Peso_Bruto,
				Peso_Real_HIO	= @Peso_Real,
				Vol_Tot_HIO	= @Vol_Tot,
				Tp_Frete_HIO	= @Tp_Frete,
				Cd_Tp_Moeda	= @cd_tp_Moeda,
				Vlr_Frete_Efet_HIO=@Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper	= @Cd_Tp_Oper,
				TTime_d		= @TTime_d,
				Obs_HIO		= @Obs
			Where
				Num_Proc_HIO	= @Processo
	End

--TRATAMENTO PARA A TABELA LLP_IMP_OUTROS
	If  exists (select Num_Proc_LIO from LLP_IMP_OUT where Num_Proc_LIO=@Processo)
		Begin
			Update
				LLP_IMP_OUT
			Set
				ETA_LIO 			= @ETA_LIO,
				ETD_LIO				= @ETD_LIO,
				ATA_LIO				= @ATA_LIO,
				ATD_LIO				= @ATD_LIO,
				Cd_Planta_LIO		= @Cd_Planta_LIO,
				Cd_DstFinal_LIO		= @Cd_DstFinal_LIO,
				Cd_Forwarder 		= @Cd_Forwarder,
				Cd_Carrier			= @Cd_Carrier,
				Cd_Despachante		= @Cd_Despachante,
				Intl_Ref_LIO		= @Intl_Ref_LIO,
				Peso_Cubado_LIO		= @Peso_Cubado_LIO,
				DL_Cargo_LIO		= @DL_Cargo_LIO,
				Cd_vendedor			= @cd_vendedor,
				Cd_Agente 			= @Cd_Agente,
				Cd_Terminal			= @Cd_Terminal,
				Cd_Order			= @Cd_Order,
				Tipo_Lio 			= @Tipo,
				Canal_Lio			= @Canal_Lio,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_Lio 	= @Courier_Number_Lio,
				Original_ETA_Lio	= @Original_ETA_Lio,
				Cd_Transportadora	= @Cd_Transportadora,
				--Cd_Usuario			= @cd_usuario,
				Cd_Usuario			= isnull(@Cd_Usuario,cd_usuario),
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv
			Where
				Num_Proc_LIO	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_IMP_OUT
				(
					Num_Proc_LIO,
					ETA_LIO,
					ETD_LIO,
					ATA_LIO,
					ATD_LIO,
					Cd_Planta_LIO,
					Cd_DstFinal_LIO,
					Cd_Forwarder,
					Cd_Carrier,
					Cd_Despachante,
					Intl_Ref_LIO,
					Peso_Cubado_LIO,
					DL_Cargo_LIO,
					Cd_vendedor,
					Cd_Agente,
					Cd_Terminal,
					Cd_Order,
					Tipo_Lio,
					Canal_Lio,
					Cd_Courier,		
					Courier_Number_Lio, 	
					Original_ETA_Lio,
					Cd_Transportadora,
					Cd_Usuario,
					Vlr_Invoice,
					Cd_Moeda_Invoice,
					ID_Status --Regra Bloqueado (Leandro 19-02-25)
				)
			Values
				(
					@Processo, 
					@ETA_LIO,
					@ETD_LIO,
					@ATA_LIO,
					@ATD_LIO,
					@Cd_Planta_LIO,
					@Cd_DstFinal_LIO,
					@Cd_Forwarder,
					@Cd_Carrier,
					@Cd_Despachante,
					@Intl_Ref_LIO,
					@Peso_Cubado_LIO,
					@DL_Cargo_LIO,
					@Cd_vendedor,
					@Cd_Agente,
					@Cd_Terminal,
					@Cd_Order,
					@Tipo,
					@Canal_Lio,
					@Cd_Courier,		
					@Courier_Number_Lio, 	
					@Original_ETA_Lio,
					@Cd_Transportadora,
					@Cd_usuario,
					@Vlr_Invoice,
					@Cd_Moeda_Inv,
					@ID_Status --Regra Bloqueado (Leandro 19-02-25)
				)
		end


		--Regra Bloqueado (Leandro 19-02-25) 
		If not exists (select * from Job_Justificativa_Status where Num_Proc = @Processo) and @ID_Status = 10
			Begin
			 Insert into 
				Job_Justificativa_Status
				(
				Num_Proc,
				ID_Status,
				Justificativa,
				Destino,
				Final_Destino,
				Origem,
				Final_Origem,
				Cliente,
				Notify,
				Desbloqueado,
				Dt_Alter,
				Cd_Usuario,
				Dt_Ins
				)
				Values
				(
				@Processo,
				@ID_Status,
				'JOB Bloqueado Criado',
				@cd_dst_HIO,
				@Cd_DstFinal_LIO,
				@Cd_Org_HIO,
				@Cd_Planta_LIO,
				@cd_consig_HIO,
				@cd_IMPort_HIO,
				0,
				null,
				null,
				getdate()
				)
			End


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
























GO
