SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado o cd_usuario - 11/4/2017 - cadu


CREATE	PROCEDURE [dbo].[spHEA_InsUpd]

	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@MAWB				varchar(25),
	@HAWB				varchar(25),
	@Export				varchar(50),
	@Consignee			varchar(50),
	@Notify				varchar(50),
	@Origem				varchar(50),
	@Destino			varchar(50),
	@Voo_HEA			VarChar(10),
	@CHB				varchar(50),
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Real			Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Moeda 				varchar(50),
	@Vlr_Frete_Efet		Float,
	@SAP_ShipNumber		varchar(20),
	@Incoterm			varchar(50),
	@TTime_d			smallint,
	@Tx_Refer_Hea		float,
	@Obs				Varchar(2000),
--Variaveis Job_Exp_Aer
	@Nr_Reserva			varchar(20),
	@Agente				varchar(50),
	@Vendedor			varchar(50),
	@Customer			varchar(50),
--Variaveis LLP_Exp_Aer
	@ETA_Lea			Datetime,
	@ETD_Lea			Datetime,
	@ATA_Lea			Datetime,
	@ATD_Lea			Datetime,
	@CiaAerea			varchar(50),
	@Planta				varchar(50),
	@DstFinal			varchar(50),
	@Courier			Varchar(50),
	@Courier_Number_Lea	Varchar(50),	
	@Forwarder			Varchar(50),
	@Intl_Ref_Lea		Varchar(50),
	@Net_Rates_Lea		Float,
	@Selling_Rates_Lea	Float,
	@Peso_Cubado_Lea	Float,	
	@DL_Cargo_Lea		Datetime,
	@Order				Varchar(50),
	@Terminal			Varchar(50),
	@Canal_Lea			Varchar(20),
	@Original_ETA_Lea	Datetime,
	@Transportadora		varchar(50),
	@Notify_2			varchar(50),
	@Vlr_Invoice		float,
	@Moeda_INV			varchar(30),
	@Comissao_Agente_Lea float,
	@ProcessoN		VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq				Varchar(10)	
		Declare @cd_consig_HEA 		Varchar(10)
		Declare @cd_export_HEA 		Varchar(10)
		Declare @cd_Notify_HEA 		Varchar(10)
		Declare @cd_tp_moeda 		Varchar(3)
		Declare @cd_moeda_INV 		Varchar(3)
		Declare @Cd_Org_HEA 		Varchar(10)
		Declare @cd_dst_HEA 		VarChar(10)
		Declare @cd_dsp_HEA 		VarChar(10)
		Declare @Cd_tp_oper 		VarChar(3)
--Variaveis Job_Exp_Aer
		Declare @Job				VarChar(16)
		Declare @Cd_Agente			Varchar(10)
		Declare @Cd_Vendedor		Varchar(30)
		Declare @Cd_Usuario			Varchar(30)
--Variaveis LLP_Exp_Aer
		Declare @Cd_CiaAerea_Lea	varchar(3)
		Declare @Cd_Planta_LEA		varchar(3)
		Declare @Cd_DstFinal_LEA 	varchar(3)	
		Declare @Cd_Courier			Varchar(10)	
		Declare @Cd_Forwarder		Varchar(10)
		Declare @Cd_Order			Varchar(10)
		Declare @Cd_Terminal		Varchar(10)
		Declare	@Cd_Transportadora	Varchar(10)
		Declare	@Cd_Notify_2		Varchar(10)

--Carregando Codigo pessoa
		Set @Cd_consig_HEA=(select cd_pes from pessoa where apelido=@Consignee)
		Set @Cd_export_HEA=(select cd_pes from pessoa where apelido=@Export)
		Set @cd_Notify_HEA=(select cd_pes from pessoa where apelido=@Notify)
		Set @Cd_Dsp_HEA=(select cd_pes from pessoa where apelido=@CHB)
		Set @Cd_Courier= (select Cd_Pes from pessoa where apelido=@Courier)
		Set @Cd_Forwarder= (select Cd_Pes from pessoa where apelido=@Forwarder)
		Set @Cd_Agente= (select Cd_Pes from pessoa where apelido=@Agente)
		Set @Cd_Order = (select Cd_Pes from pessoa where apelido=@Order)
		Set @Cd_Transportadora = (Select Cd_pes from Pessoa where Apelido = @Transportadora)
		Set @Cd_Notify_2 = (Select Cd_pes from Pessoa where Apelido = @Notify_2)

--Carregando Moeda
		Set @cd_tp_moeda=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda)
		Set @cd_moeda_INV	=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda_INV)

--Carregando Localidade
		Set @cd_org_HEA=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_dst_HEA=(select top 1 cd_local from localidade where Nome_Local=@Destino)
		Set @Cd_Planta_LEA = (select top 1 cd_local from localidade where Nome_Local=@Planta)
		Set @Cd_DstFinal_LEA = (select top 1 cd_local from localidade where Nome_Local=@DstFinal)

--Carregando Cia Aerea
		Set @Cd_CiaAerea_Lea=(Select cd_cia_aer from Cia_aerea where Nome_Cia_Aer = @CiaAerea)	

--Carregando Incoterm
		Set @cd_tp_oper= (Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Incoterm)

--Carregando Usuario
		Set @Cd_Vendedor=(Select top 1 Cd_usuario from Usuario where Nome_Usuario = @Vendedor)
		Set @Cd_Usuario=(Select top 1 Cd_usuario from Usuario where Nome_Usuario = @Customer)
--Carregando Terminal	
		Set @Cd_Terminal=(Select Cd_Terminal from Terminal where Nome_Terminal = @Terminal)-- Regra Bloqueado Processo NULL (Leandro 19-02-25)
DECLARE @ID_Status INT;

		IF @Processo is null
		BEGIN
			IF EXISTS (
				SELECT LC.Nome_Local 
				FROM Localidade LC WITH (NOLOCK)
				JOIN Pais P WITH (NOLOCK) ON LC.Cd_Pais = P.Cd_Pais 
				WHERE (LC.Nome_Local = @Destino OR LC.Nome_Local = @DstFinal) 
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
				WHERE (PP.Apelido = @Consignee OR PP.Apelido = @Notify) 
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
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Export_HEA)
			Set @Processo = 'EA' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LEA,14),3)),0)+1 from LLP_exp_Aer where left(Num_Proc_LEA,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into 
				House_exp_Aer
					(
					Num_Proc_HEA,
					Num_Proc_MEA,
					Dt_Emis_HEA,
					MAWB_HEA,
					HAWB_HEA,
					Cd_Export_HEA,
 					Cd_Consig_HEA,
					Cd_Notify_HEA,
					Cd_Org_HEA,
					Cd_Dst_HEA,
					Voo_HEA,
					Cd_Dsp_HEA,
					Qtd_Tot_Vol_HEA,
					Peso_Bruto_HEA,
					Peso_Real_HEA,
					Vol_Tot_HEA,
					Tp_Frete_HEA,
					Cd_Tp_Moeda,
				 	Vlr_Frete_Tot_HEA,
					SAP_ShipNumber,
					Cd_Tp_Oper,
					TTime_d,
					Tx_Refer_HEA,
					Obs_HEA
					)
			Values
				(
				@Processo,
				'JOB',
				@Dt_Emis,
				@MAWB,
				@HAWB,
				@Cd_Export_HEA,
				@Cd_Consig_HEA,
				@Cd_Notify_HEA,
				@Cd_Org_HEA,
				@Cd_Dst_HEA,
				@Voo_HEA,
				@Cd_Dsp_HEA,
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
				@Tx_Refer_HEA,
				@Obs
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
				--Cd_Usuario=@cd_usuario,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario),
				Cd_Agente = @Cd_Agente,
				Cd_vendedor=@cd_vendedor,
				Mawb_HEA=@Mawb
			WHERE
				num_proc_HEA=@Processo
		END
	ELSE
		BEGIN
			Insert into
				Job_exp_Aer
				(
					Num_Proc_HEA,
					Cd_Usuario,
					Cd_Agente,
					MAWB_HEA,
					Cd_Vendedor
				)
			Values
				(
					@Processo,
					@Cd_Usuario,
					@Cd_Agente,
					@MAWB,
					@Cd_Vendedor
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
					Num_Proc_LEA,
					ETA_LEA,
					ETD_LEA,
					ATA_LEA,
					ATD_LEA,
					Cd_CiaAerea_Lea,
					Cd_Planta_LEA,
					Cd_DstFinal_LEA,
					Cd_Courier,
					Courier_Number_LEA,
					Intl_Ref_LEA,
					Net_Rates_LEA,
					Selling_Rates_LEA,	
					Peso_Cubado_LEA,
					Cd_Order,
					DL_Cargo_Lea,
					Canal_Lea,
					Cd_Transportadora,
					Cd_Notify_2,
					Original_ETA_Lea,
					Vlr_Invoice,
					Cd_Moeda_Invoice,
					Comissao_Agente_Lea,
					ID_Status --Regra Bloqueado (Leandro 19-02-25)
				)
			Values
				(
					@Processo, 
					@ETA_LEA,
					@ETD_LEA,
					@ATA_LEA,
					@ATD_LEA,
					@Cd_CiaAerea_Lea,
					@Cd_Planta_LEA,
					@Cd_DstFinal_LEA,
					@Cd_Courier,
					@Courier_Number_LEA,
					@Intl_Ref_LEA,
					@Net_Rates_LEA,
					@Selling_Rates_LEA,
					@Peso_Cubado_LEA,
					@Cd_Order,
					@DL_Cargo_Lea,
					@Canal_Lea,
					@Cd_Transportadora,
					@Cd_Notify_2,
					@Original_ETA_Lea,
					@Vlr_Invoice,
					@Cd_Moeda_Inv,
					@Comissao_Agente_Lea,
					@ID_Status  --Regra Bloqueado (Leandro 19-02-25)
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
				@cd_dst_HEA,
				@Cd_DstFinal_LEA,
				@Cd_Org_HEA,
				@Cd_Planta_LEA,
				@cd_consig_HEA,
				@cd_Notify_HEA,
				0,
				null,
				null,
				getdate()
				)
			End


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION	RETURN -1
			END

Commit Transaction 




































GO
