SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HIM_InsUpd]
(
	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@MAWB				varchar(25),
	@HAWB				varchar(25),
	@Cd_Export_HIM		varchar(10), --@Export
	@Cd_Consig_HIM		varchar(10),--@Consignee
	@Cd_Import_HIM		varchar(10),--@Import
	@Cd_Org_HIM			varchar(10),--@Origem
	@Cd_Dst_HIM			varchar(10),--@Destino
	@Viagem				VarChar(10),
	@Navio				VarChar(50),
	@Qtd_Tot_Vol		Float,
	@Peso_Liquido		Float,
	@Peso_Bruto			Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@Cd_Tp_Moeda		Varchar(3), --@Moeda
	@Vlr_Frete_Efet		Float,
	@Obs				Varchar(2000),
	@Cd_Despachante		VarChar(10), --@CHB			varchar(20),
	@SAP_ShipNumber		varchar(20),
	@Cd_Tp_Oper			Varchar(10), --@Incoterm		varchar(50),
	@Canal_Lim			Varchar(20),
	@TTime_d			smallint,
	@Nr_Reserva			varchar(50),
	--Job_Imp_Mar
	@Cd_Agente			varchar(10), --@Agent			varchar(20),	
	@Cd_Vendedor		varchar(6), --@Sales			varchar(30),	
	@Cd_Usuario			Varchar(10), --@Customer		varchar(30),	
	@Cd_Armador			varchar(3), --@Armador		varchar(30),
	
--LLP_Imp_Mar
	@Cd_Planta_Lim		varchar(3), --@Planta			varchar(30),	
	@Cd_DstFinal_Lim 	varchar(3), --@DstFinal	 	varchar(30),	
	@ETD_Lim			Datetime,	
	@ATD				Datetime,	
	@ETA_Lim			Datetime,	
	@Arrival			Datetime,	
	@Cd_Tp_Carga		int, --@Tp_Carga		varchar(30),	
	@Cd_Forwarder		varchar(10), --@Forwarder		varchar(20),	
	@Cd_Terminal		varchar(10)	, --@Terminal		Varchar(50), 	
	@Intl_Ref_Lim		Varchar(50),	
	@Cd_Order			Varchar(10)	, --@Order			Varchar(50),	
	@DL_Cargo_Lim		Datetime,	
	@Cd_Courier			Varchar(10), --@Courier		Varchar(50),	
	@Courier_Number_Lim	Varchar(50),	
	@Original_ETA_Lim	Datetime,
	@Cd_Transportadora	Varchar(10), --@Transportadora	varchar(50),
	@Vlr_Invoice		float,
	@Cd_Moeda_Inv 		Varchar(3)	, --@Moeda_INV		varchar(30),
	@ProcessoN			VarChar(16) OUTPUT
)
 AS

Begin Transaction

	Declare @Seq VarChar(10)	

	if @Processo is null
		Begin
			Declare @Grupo	varchar(3)
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL with(nolock) Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_consig_HIM)
			Set @Processo = 'IM' + @Grupo +cast(year(getdate()) as Varchar)	
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LIM,14),3)),000)+1 from LLP_Imp_Mar where left(Num_Proc_LIM,11)=@Processo)
--Pegar na tabela Hist_Geral_Sistema
--			Set @Seq=(Select iSNULL(max(right(left(HSGProcesso,14),3)),0)+1 from vwHist_Geral_Sistema where left(HSGProcesso,11)=@Processo)			
			Set @Seq='000'+@Seq
			Set @Seq=right(@Seq,3)
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)

			Insert Into 
				House_Imp_Mar
					(
					Num_Proc_HIM,Num_Proc_MIM,Dt_Emis_HIM,MAWB_HIM,HAWB_HIM,Cd_Export_HIM,
 					Cd_Consig_HIM,Cd_Import_HIM,Cd_Org_HIM,Cd_Dst_HIM,Viagem_HIM,Navio_HIM,
					Cd_Despachante,Qtd_Tot_Vol_HIM,Peso_Liquido_HIM,Peso_Bruto_HIM,
					Vol_Tot_HIM,Tp_Frete_HIM,Cd_Tp_Moeda,Vlr_Frete_Efet_HIM,
					SAP_ShipNumber,Cd_Tp_Oper,Job_HIM,TTime_d,Obs_HIM
					)
			Values
				(
					@Processo,'JOB',@Dt_Emis,@MAWB,@HAWB,@Cd_Export_HIM,
					@Cd_Consig_HIM,	@Cd_Import_HIM,@Cd_Org_HIM,@Cd_Dst_HIM,@Viagem,@Navio,
					@Cd_Despachante,@Qtd_Tot_Vol,@Peso_Liquido,@Peso_Bruto,
					@Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,
					@SAP_ShipNumber,@Cd_Tp_Oper,@Processo,@TTime_d,@Obs
				)
		Set @ProcessoN = @Processo
	End
	Else
		Begin
			Update
				House_Imp_Mar
			Set
				--Dt_Emis_HIM	= @Dt_Emis,
				MAWB_HIM	= @MAWB,
				HAWB_HIM	= @HAWB,
				Cd_Export_HIM= @Cd_Export_HIM,
				Cd_Consig_HIM= @Cd_Consig_HIM,
				Cd_Import_HIM= @Cd_Import_HIM,
				Cd_Org_HIM	= @Cd_Org_HIM,
				Cd_Dst_HIM	= @Cd_Dst_HIM,
				Viagem_HIM	= @Viagem,
				Navio_HIM	= @Navio,
				Cd_Despachante	= @Cd_Despachante,
				Qtd_Tot_Vol_HIM	= @Qtd_Tot_Vol,
				Peso_Liquido_HIM = @Peso_Liquido,
				Peso_Bruto_HIM	= @Peso_Bruto,
				Vol_Tot_HIM	= @Vol_Tot,
				Tp_Frete_HIM	= @Tp_Frete,
				Cd_Tp_Moeda	= @cd_tp_Moeda,
				Vlr_Frete_Efet_HIM= @Vlr_Frete_Efet,
				SAP_ShipNumber	= @SAP_ShipNumber,
				Cd_Tp_Oper	= @Cd_Tp_Oper,
				Job_HIM		= @Processo,
				TTime_d		= @TTime_d,
				Obs_HIM		= @Obs
			Where
				Num_Proc_HIM	= @Processo
	End

--TRATAMENTO PARA A TABELA JOB_Imp_Mar

	if exists(select num_proc_HIM from job_Imp_mar with(nolock) where num_proc_HIM=@Processo)
		Begin
			Update
				Job_Imp_mar
			SET
				Cd_Armador	= @Cd_Armador,
				Cd_Agente	= @Cd_Agente,
				cd_Vendedor	= @Cd_Vendedor,
				Cd_Usuario	= isnull(@Cd_Usuario,cd_usuario)
				
			WHERE
				num_proc_HIM=@Processo
		END
	ELSE
		BEGIN
			Insert into
				Job_Imp_mar
				(
					Num_Proc_HIM,Cd_Armador,Cd_Agente,Cd_Vendedor,Cd_Usuario
				)
			Values
				(
					@Processo,@Cd_Armador,@Cd_Agente,@Cd_Vendedor,@Cd_Usuario
				)
			

		END

--TRATAMENTO PARA A TABELA LLP_Imp_MAR
	If  exists (select Num_Proc_Lim from LLP_Imp_Mar with(nolock) where Num_Proc_Lim=@Processo)
		Begin
			Update
				LLP_Imp_Mar
			Set
				ATD_Lim				= @ATD,
				ATA_Lim				= @Arrival,
				ETA_Lim 			= @ETA_Lim,
				ETD_Lim				= @ETD_Lim,
				cd_tp_carga			= @cd_tp_carga,
				Cd_Planta_Lim		= @Cd_Planta_Lim,
				Cd_DstFinal_Lim		= @Cd_DstFinal_Lim,
				Cd_Forwarder		= @Cd_Forwarder,
				Canal_Lim			= @Canal_Lim,
				Cd_Terminal			= @Cd_Terminal,
				Nr_Reserva			= @Nr_Reserva,
				Cd_Order			= @Cd_Order,
				Cd_Courier			= @Cd_Courier,
				Courier_Number_Lim 	= @Courier_Number_Lim,
				Dl_Cargo_Lim		= @Dl_Cargo_lim,
				Original_ETA_Lim	= @Original_ETA_lim,
				Cd_Transportadora	= @Cd_Transportadora,
				Intl_Ref_Lim		= @Intl_Ref_Lim,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv
			Where
				Num_Proc_Lim	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Imp_Mar
				(
					Num_Proc_Lim,
					ETA_Lim,
					ETD_Lim,
					ATD_Lim,
					ATA_Lim,
					cd_tp_carga,
					Cd_Planta_Lim,
					Cd_DstFinal_Lim,
					Cd_Forwarder,
					Canal_LiM,
					Cd_Terminal,
					Nr_Reserva,
					Cd_Order,
					Cd_Courier,
					Courier_Number_Lim,
					Dl_Cargo_Lim,
					Intl_Ref_lim,
					Cd_Transportadora,
					Original_ETA_Lim,
					Vlr_Invoice,
					Cd_Moeda_Invoice
				)
			Values
				(
					@Processo, 
					@ETA_Lim,
					@ETD_Lim,
					@ATD,
					@Arrival,
					@cd_tp_carga,
					@Cd_Planta_Lim,
					@Cd_DstFinal_Lim,
					@Cd_Forwarder,
					@Canal_Lim,
					@Cd_Terminal,
					@Nr_Reserva,
					@Cd_Order,
					@Cd_Courier,
					@Courier_Number_Lim,
					@Dl_Cargo_Lim,
					@Intl_Ref_Lim,
					@Cd_Transportadora,
					@Original_ETA_Lim,
					@Vlr_Invoice,
					@Cd_Moeda_Inv
				)
		end
		
		--Update pra Navio X Viagem
		Begin
			update LLP_Imp_Mar set id_viagem = (
				select V.ID_Viagem from viagem_llp V with(nolock)
					join Navio_LLP N with(nolock) on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @cd_dst_HIM and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'I' and Ativo = 1)				  
				where Num_Proc_Lim = @Processo 
		End


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
