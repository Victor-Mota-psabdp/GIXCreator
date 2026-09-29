SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado o cd_usuario - 11/4/2017 - cadu

CREATE	PROCEDURE [dbo].[spHEO_InsUpd]

	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@HAWB				varchar(25),
	@Export				varchar(50),
	@Consignee			varchar(50),
	@Notify				varchar(50),
	@Origem				varchar(50),
	@Destino			varchar(50),
	@Voo_HEO			VarChar(10),
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Real			Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Moeda 				varchar(50),
	@Vlr_Frete_Efet		Float,
	@SAP_ShipNumber		varchar(20),
	@Incoterm			varchar(50),
	@Obs				Varchar(2000),
--Variaveis LLP_EXP_OUTROS
	@ETA_LEO			Datetime,
	@ETD_LEO			Datetime,
	@ATA_LEO			Datetime,
	@ATD_LEO			Datetime,
	@Planta				varchar(50),
	@DstFinal			varchar(50),
	@Forwarder			Varchar(50),
	@Carrier			Varchar(50),
	@CHB				varchar(50),
	@Intl_Ref_LEO		Varchar(50),
	@Peso_Cubado_LEO	Float,	
	@DL_Cargo_LEO		Datetime,
	@Vendedor			varchar(50),
	@Agente				varchar(50),
	@Tipo				char(1),
	@Terminal			Varchar(50),
	@TTime_d			smallint,
	@Order				Varchar(50),
	@Customer			Varchar(50),
	@Canal_Leo			Varchar(20),
	@Courier			Varchar(50),
	@Courier_Number_Leo	Varchar(50),
	@Original_ETA_Leo	Datetime,
	@Transportadora		varchar(50),
	@Notify_2			varchar(50),
	@Vlr_Invoice		float,
	@Moeda_INV			varchar(30),
	@Comissao_Agente_Leo	float,
	@ProcessoN			VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq				Varchar(10)	
		Declare @cd_consig_HEO 		Varchar(10)
		Declare @cd_Notify_HEO 		Varchar(10)
		Declare @cd_Export_HEO 		Varchar(10)
		Declare @cd_tp_moeda 		Varchar(3)
		Declare @cd_moeda_INV 		Varchar(3)
		Declare @Cd_Org_HEO 		Varchar(10)
		Declare @cd_dst_HEO 		VarChar(10)
		Declare @cd_dsp_HEO 		VarChar(10)		
		Declare @Cd_Usuario 		VarChar(25)
		Declare @Cd_tp_oper 		VarChar(3)
--Variaveis LLP_EXP_OUTROS
		Declare @Cd_Planta_LEO		varchar(3)
		Declare @Cd_DstFinal_LEO 	varchar(3)	
		Declare @Cd_Despachante		Varchar(10)	
		Declare @Cd_Forwarder		Varchar(10)
		Declare @Cd_Agente			Varchar(10)
		Declare @Cd_Vendedor		Varchar(30)
		Declare @Cd_Carrier			Varchar(10)
		Declare @Cd_Terminal		Varchar(10)
		Declare @Cd_Order			Varchar(10)
		Declare @Cd_Courier			Varchar(10)
		Declare	@Cd_Transportadora	Varchar(10)
		Declare	@Cd_Notify_2		Varchar(10)

--Carregando Codigo pessoa
		Set @Cd_consig_HEO=(select cd_pes from pessoa where apelido=@Consignee)
		Set @Cd_Export_HEO=(select cd_pes from pessoa where apelido=@Export)
		Set @Cd_Notify_HEO=(select cd_pes from pessoa where apelido=@Notify)
		Set @Cd_Despachante=(select cd_pes from pessoa where apelido=@CHB)
		Set @Cd_Forwarder= (select Cd_Pes from pessoa where apelido=@Forwarder)
		Set @Cd_Carrier= (select Cd_Pes from pessoa where apelido=@Carrier)
		Set @Cd_Agente= (select Cd_Pes from pessoa where apelido=@Agente)
		Set @Cd_Order = (select Cd_Pes from pessoa where apelido=@Order)
		Set @Cd_Courier = (select Cd_Pes from pessoa where apelido=@Courier)
		Set @Cd_Transportadora = (Select Cd_pes from Pessoa where Apelido = @Transportadora)
		Set @Cd_Notify_2 = (Select Cd_pes from Pessoa where Apelido = @Notify_2)

--Carregando Moeda
		Set @cd_tp_moeda=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda)
		Set @cd_moeda_INV	=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Moeda_INV)

--Carregando Localidade
		Set @cd_org_HEO=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_dst_HEO=(select top 1 cd_local from localidade where Nome_Local=@Destino)
		Set @Cd_Planta_LEO = (select top 1 cd_local from localidade where Nome_Local=@Planta)
		Set @Cd_DstFinal_LEO = (select top 1 cd_local from localidade where Nome_Local=@DstFinal)

--Carregando Incoterm
		Set @cd_tp_oper= (Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Incoterm)

--Carregando Usuario
		Set @Cd_Vendedor=(Select top 1 Cd_usuario from Usuario where Nome_Usuario = @Vendedor)
		Set @Cd_Usuario=(Select  top 1 Cd_usuario from Usuario where Nome_Usuario = @Customer)
--Carregando Terminal
		Set @Cd_Terminal =(Select Cd_Terminal from Terminal where Nome_Terminal = @Terminal)
-- Regra Bloqueado Processo NULL
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
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Export_HEO)
			Set @Processo = 'EO' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LEO,14),3)),0)+1 from LLP_EXP_OUT where left(Num_Proc_LEO,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into 
				House_EXP_OUT
					(
					Num_Proc_HEO,
					Dt_Emis_HEO,
					HAWB_HEO,
					Cd_Notify_HEO,
 					Cd_Consig_HEO,
					Cd_Export_HEO,
					Cd_Org_HEO,
					Cd_Dst_HEO,
					Voo_HEO,
					Qtd_Tot_Vol_HEO,
					Peso_Bruto_HEO,
					Peso_Real_HEO,
					Vol_Tot_HEO,
					Tp_Frete_HEO,
					Cd_Tp_Moeda,
				 	Vlr_Frete_Efet_HEO,
					SAP_ShipNumber,
					Cd_Tp_Oper,
					TTime_d,
					Obs_HEO
					)
			Values
				(
				@Processo,
				@Dt_Emis,
				@HAWB,
				@Cd_Notify_HEO,
				@Cd_Consig_HEO,
				@Cd_Export_HEO,
				@Cd_Org_HEO,
				@Cd_Dst_HEO,
				@Voo_HEO,
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
				House_EXP_OUT
			Set
				Dt_Emis_HEO		= @Dt_Emis,
				HAWB_HEO		= @HAWB,
				Cd_Notify_HEO	= @Cd_Notify_HEO,
				Cd_Consig_HEO	= @Cd_Consig_HEO,
				Cd_Export_HEO	= @Cd_Export_HEO,
				Cd_Org_HEO		= @Cd_Org_HEO,
				Cd_Dst_HEO		= @Cd_Dst_HEO,
				Voo_HEO			= @Voo_HEO,
				Qtd_Tot_Vol_HEO	= @Qtd_Tot_Vol,
				Peso_Bruto_HEO	= @Peso_Bruto,
				Peso_Real_HEO	= @Peso_Real,
				Vol_Tot_HEO		= @Vol_Tot,
				Tp_Frete_HEO	= @Tp_Frete,
				Cd_Tp_Moeda		= @cd_tp_Moeda,
				Vlr_Frete_Efet_HEO=@Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper		= @Cd_Tp_Oper,
				TTime_d			= @TTime_d,
				Obs_HEO			= @Obs
			Where
				Num_Proc_HEO	= @Processo
	End

--TRATAMENTO PARA A TABELA LLP_EXP_OUTROS
	If  exists (select Num_Proc_LEO from LLP_EXP_OUT where Num_Proc_LEO=@Processo)
		Begin
			Update
				LLP_EXP_OUT
			Set
				ETA_LEO 			= @ETA_LEO,
				ETD_LEO				= @ETD_LEO,
				ATA_LEO				= @ATA_LEO,
				ATD_LEO				= @ATD_LEO,
				Cd_Planta_LEO		= @Cd_Planta_LEO,
				Cd_DstFinal_LEO		= @Cd_DstFinal_LEO,
				Cd_Forwarder 		= @Cd_Forwarder,
				Cd_Carrier			= @Cd_Carrier,
				Cd_Despachante		= @Cd_Despachante,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_LEO	= @Courier_Number_LEO,	
				Intl_Ref_LEO		= @Intl_Ref_LEO,
				Peso_Cubado_LEO		= @Peso_Cubado_LEO,
				DL_Cargo_LEO		= @DL_Cargo_LEO,
				Cd_vendedor			= @cd_vendedor,
				Cd_Agente 			= @Cd_Agente,
				Cd_Terminal			= @Cd_Terminal,
				Tipo_LEO 			= @Tipo,
				Cd_Order			= @Cd_Order,
				Canal_Leo			= @Canal_Leo,
				Cd_Transportadora	= @Cd_Transportadora,
				Cd_Notify_2			= @Cd_Notify_2,
				Original_ETA_Leo	= @Original_ETA_Leo,
				--Cd_Usuario			= @Cd_Usuario,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario),
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv,
				Comissao_Agente_Leo	= @Comissao_Agente_Leo
			Where
				Num_Proc_LEO	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_EXP_OUT
				(
					Num_Proc_LEO,
					ETA_LEO,
					ETD_LEO,
					ATA_LEO,
					ATD_LEO,
					Cd_Planta_LEO,
					Cd_DstFinal_LEO,
					Cd_Forwarder,
					Cd_Carrier,
					Cd_Despachante,
					Cd_Courier,
					Courier_Number_LEO,	
					Intl_Ref_LEO,
					Peso_Cubado_LEO,
					DL_Cargo_LEO,
					Cd_vendedor,
					Cd_Agente,
					Cd_Terminal,
					Tipo_LEO,
					Cd_Order,
					Canal_Leo,
					Original_ETA_Leo,
					Cd_Transportadora,
					Cd_Notify_2,
					Cd_Usuario,
					Vlr_Invoice,
					Cd_Moeda_Invoice,
					Comissao_Agente_Leo,
					ID_Status
				)
			Values
				(
					@Processo, 
					@ETA_LEO,
					@ETD_LEO,
					@ATA_LEO,
					@ATD_LEO,
					@Cd_Planta_LEO,
					@Cd_DstFinal_LEO,
					@Cd_Forwarder,
					@Cd_Carrier,
					@Cd_Despachante,
					@Cd_Courier,
					@Courier_Number_LEO,	
					@Intl_Ref_LEO,
					@Peso_Cubado_LEO,
					@DL_Cargo_LEO,
					@Cd_vendedor,
					@Cd_Agente,
					@Cd_Terminal,
					@Tipo,
					@Cd_Order,
					@Canal_Leo,
					@Original_ETA_Leo,
					@Cd_Transportadora,
					@Cd_Notify_2,
					@Cd_Usuario,
					@Vlr_Invoice,
					@Cd_Moeda_Inv,
					@Comissao_Agente_Leo,
					@ID_Status
				)
		end

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
				@cd_dst_HEO,
				@Cd_DstFinal_LEO,
				@Cd_Org_HEO,
				@Cd_Planta_Leo,
				@cd_consig_HEO,
				@cd_Notify_HEO,
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
