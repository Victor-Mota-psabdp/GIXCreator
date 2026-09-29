SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado o cd_usuario - 11/4/2017 - cadu
CREATE	PROCEDURE [dbo].[spHEM_InsUpd]

	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@MAWB				varchar(25),
	@HAWB				varchar(25),
	@Export				varchar(50),
	@Consignee			varchar(50),
	@Notify				varchar(50),
	@Origem				varchar(50),
	@Destino			varchar(50),
	@Viagem				VarChar(25),
	@Navio				VarChar(50),
	@CHB				varchar(50),
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Liquido		Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Moeda 				varchar(50),
	@Vlr_Frete_Efet		Float,
	@SAP_ShipNumber		varchar(20),
	@Incoterm			varchar(50),
	@TTime_d			smallint,
	@Obs				Varchar(2000),
--Variaveis Job_Exp_Mar
	@Nr_Reserva			varchar(30),
	@Agente				varchar(50),
	@Vendedor			varchar(50),
	@Customer			varchar(50),
--Variaveis LLP_Exp_Mar
	@ETA_Lem			Datetime,
	@ETD_Lem			Datetime,
	@ATA_Lem			Datetime,
	@ATD_Lem			Datetime,
	@Armador			varchar(50),
	@Tp_Carga			varchar(50),
	@Planta				varchar(50),
	@DstFinal	 		varchar(50),
	@Courier			Varchar(50),
	@Courier_Number_Lem	Varchar(50),	
	@Forwarder			Varchar(50),
	@Intl_Ref_Lem		Varchar(50),
	@Net_Rates_Lem		Float,
	@Selling_Rates_Lem	Float,
	@Canal_Lem			Varchar(20),
	@Terminal			Varchar(50),
	@Order				Varchar(50),
	@Original_ETA_Lem	Datetime,
	@Transportadora		varchar(50),
	@Notify_2			varchar(50),
	@Dt_BL				Datetime,
	@Vlr_Invoice		float,
	@Moeda_INV			varchar(30),
	@Comissao_Agente_Lem	float,
	@ProcessoN			VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq				Varchar(10)	
		Declare @cd_consig_HEM 		Varchar(10)
		Declare @cd_export_HEM 		Varchar(10)
		Declare @cd_Notify_HEM 		Varchar(10)
		Declare @cd_tp_moeda 		Varchar(3)
		Declare @cd_moeda_INV 		Varchar(3)
		Declare @Cd_Org_HEM 		Varchar(10)
		Declare @cd_dst_HEM 		VarChar(10)
		Declare @cd_dsp_HEM 		VarChar(10)
		Declare @Cd_tp_oper 		VarChar(3)
--Variaveis Job_Exp_Mar
		Declare @Job				VarChar(16)
		Declare @Cd_Agente			Varchar(10)
		Declare @Cd_Vendedor		Varchar(30)
		Declare	@Cd_Usuario			Varchar(20)
--Variaveis LLP_Exp_Mar
		Declare @Cd_Armador_Lem		varchar(3)
		Declare @cd_tp_carga		int
		Declare @Cd_Planta_Lem		varchar(3)
		Declare @Cd_DstFinal_Lem 	varchar(3)	
		Declare @Cd_Courier			Varchar(10)	
		Declare @Cd_Forwarder		Varchar(10)
		Declare @Cd_Terminal		Varchar(10)
		Declare @Cd_Order			Varchar(10)
		Declare	@Cd_Transportadora	Varchar(10)
		Declare	@Cd_Notify_2		Varchar(10)

--Carregando Codigo pessoa
		Set @Cd_consig_HEM=(select top 1 cd_pes from pessoa with(nolock) where apelido=@Consignee)
		Set @Cd_export_HEM=(select top 1 cd_pes from pessoa with(nolock) where apelido=@Export)
		Set @cd_Notify_HEM=(select top 1 cd_pes from pessoa with(nolock) where apelido=@Notify)
		Set @Cd_Dsp_HEM=(select top 1 cd_pes from pessoa with(nolock) where apelido=@CHB)
		Set @Cd_Courier= (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Courier)
		Set @Cd_Forwarder= (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Forwarder)
		Set @Cd_Agente= (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Agente)
		Set @Cd_Order= (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Order)
		Set @Cd_Transportadora = (Select top 1  Cd_pes from Pessoa with(nolock) where Apelido = @Transportadora)
		Set @Cd_Notify_2 = (Select top 1 Cd_pes from Pessoa with(nolock) where Apelido = @Notify_2)

--Carregando Moeda
		Set @cd_tp_moeda=(select top 1 cd_tp_moeda from tipo_moeda with(nolock) where nome_tp_moeda=@Moeda)
		Set @cd_moeda_INV	=(select top 1 cd_tp_moeda from tipo_moeda with(nolock) where nome_tp_moeda=@Moeda_INV)

--Carregando Localidade
		Set @cd_org_HEM=(select top 1 cd_local from localidade with(nolock) where Nome_Local=@Origem and Porto = 'S')
		Set @cd_dst_HEM=(select top 1 cd_local from localidade with(nolock) where Nome_Local=@Destino and Porto = 'S')
		Set @Cd_Planta_Lem = (select top 1 cd_local from localidade with(nolock) where Nome_Local=@Planta)
		Set @Cd_DstFinal_Lem = (select top 1 cd_local from localidade with(nolock) where Nome_Local=@DstFinal)

--Carregando Tipo_Carga
		Set @cd_tp_carga=(Select top 1 cd_tp_carga from Tipo_Carga with(nolock) where Nome_tp_Carga = @Tp_Carga)

--Carregando Armador
		Set @cd_armador_lem=(Select top 1 cd_armador from armador with(nolock) where Nome_Armador = @Armador)	

--Carregando Incoterm
		Set @cd_tp_oper= (Select top 1  cd_tp_oper from tipo_oper with(nolock) where Nome_tp_oper = @Incoterm)

--Carregando Usuario
		Set @Cd_Vendedor=(Select top 1  Cd_usuario from Usuario with(nolock) where Nome_Usuario = @Vendedor)
		Set @Cd_Usuario=(Select top 1 Cd_usuario from Usuario with(nolock) where Nome_Usuario = @Customer)

--Carregando Terminal
		Set @Cd_Terminal=(Select top 1 Cd_Terminal from Terminal with(nolock) where Nome_Terminal = @Terminal)
-- Regra Bloqueado Processo NULL (Leandro 19-02-25)
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
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Export_HEM)
			Set @Processo = 'EM' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LEM,14),3)),0)+1 from LLP_exp_Mar where left(Num_Proc_LEM,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into 
				House_exp_Mar
					(
					Num_Proc_HEM,
					Num_Proc_mem,
					Dt_Emis_HEM,
					MAWB_HEM,
					HAWB_HEM,
					Cd_Export_HEM,
 					Cd_Consig_HEM,
					Cd_Notify_HEM,
					Cd_Org_HEM,
					Cd_Dst_HEM,
					Viagem_HEM,
					Navio_HEM,
					Cd_Dsp_HEM,
					Qtd_Tot_Vol_HEM,
					Peso_Bruto_HEM,
					Peso_Liquido_HEM,
					Vol_Tot_HEM,
					Tp_Frete_HEM,
					Cd_Tp_Moeda,
				 	Vlr_Frete_Tot_HEM,
					SAP_ShipNumber,
					Cd_Tp_Oper,
					TTime_d,
					Obs_HEM
					)
			Values
				(
				@Processo,
				'JOB',
				@Dt_Emis,
				@MAWB,
				@HAWB,
				@Cd_Export_HEM,
				@Cd_Consig_HEM,
				@Cd_Notify_HEM,
				@Cd_Org_HEM,
				@Cd_Dst_HEM,
				@Viagem,
				@Navio,
				@Cd_Dsp_HEM,
				@Qtd_Tot_Vol,
				@Peso_Bruto,
				@Peso_Liquido,
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
				House_exp_Mar
			Set
				Dt_Emis_HEM		= @Dt_Emis,
				MAWB_HEM		= @MAWB,
				HAWB_HEM		= @HAWB,
				Cd_Export_HEM	= @Cd_Export_HEM,
				Cd_Consig_HEM	= @Cd_Consig_HEM,
				Cd_Notify_HEM	= @Cd_Notify_HEM,
				Cd_Org_HEM		= @Cd_Org_HEM,
				Cd_Dst_HEM		= @Cd_Dst_HEM,
				Viagem_HEM		= @Viagem,
				Navio_HEM		= @Navio,
				Cd_Dsp_HEM		= @Cd_Dsp_HEM,
				Qtd_Tot_Vol_HEM	= @Qtd_Tot_Vol,
				Peso_Bruto_HEM	= @Peso_Bruto,
				Peso_Liquido_HEM= @Peso_Liquido,
				Vol_Tot_HEM		= @Vol_Tot,
				Tp_Frete_HEM	= @Tp_Frete,
				Cd_Tp_Moeda		= @cd_tp_Moeda,
				Vlr_Frete_Tot_HEM= @Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper		= @cd_tp_oper,
				TTime_d			= @TTime_d,
				Obs_HEM			= @Obs
			Where
				Num_Proc_HEM	= @Processo
			
		
	End

--TRATAMENTO PARA A TABELA JOB_exp_AER
	if exists(select num_proc_HEM from job_exp_mar where num_proc_HEM=@Processo)
		Begin
			Update
				Job_exp_mar
			SET
				
				Nr_Reserva = @Nr_Reserva,
				--Cd_Usuario=@cd_usuario,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario),
				Cd_Agente = @Cd_Agente,
				Cd_vendedor=@cd_vendedor,
				Mawb_HEM=@Mawb
			WHERE
				num_proc_HEM=@Processo
		END
	ELSE
		BEGIN
			Insert into
				Job_exp_mar
				(
					Num_Proc_HEM,
					Cd_Usuario,
					Nr_Reserva,
					Cd_Agente,
					MAWB_hem,
					Cd_Vendedor
				)
			Values
				(
					@Processo,
					@Cd_Usuario,
					@Nr_Reserva,
					@Cd_Agente,
					@MAWB,
					@Cd_Vendedor
				)
			

		END

--TRATAMENTO PARA A TABELA LLP_EXP_MAR
	If  exists (select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Processo)
		Begin
			Update
				LLP_Exp_Mar
			Set
				ETA_Lem 			= @ETA_Lem,
				ETD_Lem				= @ETD_Lem,
				ATA_Lem				= @ATA_Lem,
				ATD_Lem				= @ATD_Lem,
				Cd_Armador_Lem		= @Cd_Armador_Lem,
				cd_tp_carga			= @cd_tp_carga,
				Cd_Planta_Lem		= @Cd_Planta_Lem,
				Cd_DstFinal_Lem		= @Cd_DstFinal_Lem,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_Lem	= @Courier_Number_Lem,	
				Cd_Forwarder 		= @Cd_Forwarder,
				Intl_Ref_Lem		= @Intl_Ref_Lem,
				Net_Rates_Lem		= @Net_Rates_Lem,
				Canal_Lem			= @Canal_Lem,
				Cd_Terminal			= @Cd_Terminal,
				Cd_Order			= @Cd_Order,
				Selling_Rates_Lem	= @Selling_Rates_Lem,
				Cd_Transportadora	= @Cd_Transportadora,
				Cd_Notify_2			= @Cd_Notify_2,
				Original_ETA_Lem	= @Original_ETA_Lem,
				Dt_BL_Lem			= @Dt_BL,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv,
				Comissao_Agente_Lem	= @Comissao_Agente_Lem
			Where
				Num_Proc_LEM	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Exp_Mar
				(
					Num_Proc_Lem,
					ETA_Lem,
					ETD_Lem,
					ATA_Lem,
					ATD_Lem,
					Cd_Armador_Lem,
					cd_tp_carga,
					Cd_Planta_Lem,
					Cd_DstFinal_Lem,
					Cd_Courier,
					Courier_Number_Lem,
					Intl_Ref_Lem,
					Net_Rates_Lem,
					Canal_Lem,
					Cd_Terminal,
					Cd_Order,	
					Selling_Rates_Lem,
					Cd_Transportadora,
					Cd_Notify_2,
					Original_ETA_Lem,
					Dt_BL_Lem,
					Vlr_Invoice,
					Cd_Moeda_Invoice,
					Comissao_Agente_Lem,
					ID_Status
				)
			Values
				(
					@Processo, 
					@ETA_Lem,
					@ETD_Lem,
					@ATA_Lem,
					@ATD_Lem,
					@Cd_Armador_Lem,
					@cd_tp_carga,
					@Cd_Planta_Lem,
					@Cd_DstFinal_Lem,
					@Cd_Courier,
					@Courier_Number_Lem,
					@Intl_Ref_Lem,
					@Net_Rates_Lem,
					@Canal_Lem,
					@Cd_Terminal,
					@Cd_Order,
					@Selling_Rates_Lem,
					@Cd_Transportadora,
					@Cd_Notify_2,
					@Original_ETA_Lem,
					@Dt_BL,
					@Vlr_Invoice,
					@Cd_Moeda_Inv,
					@Comissao_Agente_Lem,
					@ID_Status
				)
		end
		
		--Update pra Navio X Viagem
		Begin
			update LLP_Exp_Mar set id_viagem = (
				select V.ID_Viagem from viagem_llp V with(nolock)
					join Navio_LLP N with(nolock) on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @Cd_Org_HEM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'E' and Ativo = 1)  
				where Num_Proc_Lem = @Processo 
		End
		
		-- Só atualiza o Job se o terminal for diferente de NULL na tela Vessel Control.	
		If  exists (select V.Id_Terminal from viagem_llp V with(nolock)
					join Navio_LLP N with(nolock) on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @Cd_Org_HEM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'E'and Ativo = 1 and V.Id_Terminal is not null)	
				
		Begin
			update LLP_Exp_Mar set Cd_Terminal = (
				select V.Id_Terminal from viagem_llp V with(nolock)
					join Navio_LLP N with(nolock) on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @Cd_Org_HEM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'E' and Ativo = 1)  
				where Num_Proc_Lem = @Processo 
		End

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
				@cd_dst_HEM,
				@Cd_DstFinal_Lem,
				@Cd_Org_HEM,
				@Cd_Planta_Lem,
				@cd_consig_HEM,
				@cd_Notify_HEM,
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
