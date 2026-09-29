SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spATL_HEM_InsUpd]

	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@HAWB				varchar(25),
	@MAWB				varchar(25),
	@cd_export_HEM 		Varchar(10),
	@cd_consig_HEM 		Varchar(10),
	@cd_Notify_HEM 		Varchar(10),
	@Cd_Org_HEM 		Varchar(10),
	@cd_dst_HEM 		VarChar(10),
	@Viagem				VarChar(25),
	@Navio				VarChar(50),
	@Qtd_Tot_Vol		Float,
	@Peso_Liquido		Float,
	@Peso_Bruto			Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@cd_tp_moeda 		Varchar(3),
	@Vlr_Frete_Efet		Float,
	@Obs				Varchar(2000),	
	@cd_dsp_HEM 		VarChar(10),
	@SAP_ShipNumber		varchar(20),
	@Cd_tp_oper 		VarChar(3),
	@Canal_Lem			Varchar(20),	
	@TTime_d			smallint,

	@Nr_Reserva			varchar(30),
	@Cd_Agente			Varchar(10),
	@Cd_Vendedor		Varchar(30),
	@Cd_Usuario			Varchar(20),

	@Cd_Armador_Lem		varchar(3),
	@Cd_Planta_Lem		varchar(3),
	@Cd_DstFinal_Lem 	varchar(3),
	@ETD_Lem			Datetime,
	@ATD_Lem			Datetime,
	@ETA_Lem			Datetime,	
	@ATA_Lem			Datetime,	
	@cd_tp_carga		int,
	@Cd_Forwarder		Varchar(10),
	@Cd_Terminal		Varchar(10),
	@Intl_Ref_Lem		Varchar(50),
	@Cd_Order			Varchar(10),
	
	@Cd_Courier			Varchar(10),
	@Courier_Number_Lem	Varchar(50),	
	@Original_ETA_Lem	Datetime,
	@Cd_Transportadora	Varchar(10),
	@Vlr_Invoice		float,
	@cd_moeda_INV 		Varchar(3),
	
	@Net_Rates_Lem		Float,
	@Selling_Rates_Lem	Float,
	@Cd_Notify_2		Varchar(10),
	@Dt_BL				Datetime,	
	@Comissao_Agente_Lem	float,
	@ProcessoN			VarChar(16) OUTPUT

 AS

Begin Transaction

	Declare @Seq Varchar(10)	
	
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
					Num_Proc_HEM,Num_Proc_mem,Dt_Emis_HEM,MAWB_HEM,HAWB_HEM,Cd_Export_HEM,Cd_Consig_HEM,Cd_Notify_HEM,
					Cd_Org_HEM,Cd_Dst_HEM,Viagem_HEM,Navio_HEM,Cd_Dsp_HEM,Qtd_Tot_Vol_HEM,Peso_Bruto_HEM,Peso_Liquido_HEM,
					Vol_Tot_HEM,Tp_Frete_HEM,Cd_Tp_Moeda,Vlr_Frete_Tot_HEM,SAP_ShipNumber,Cd_Tp_Oper,TTime_d,Obs_HEM
					)
			Values
                    (
                        @Processo,'JOB',@Dt_Emis,@MAWB,@HAWB,@Cd_Export_HEM,@Cd_Consig_HEM,@Cd_Notify_HEM,
                        @Cd_Org_HEM,@Cd_Dst_HEM,@Viagem,@Navio,@Cd_Dsp_HEM,@Qtd_Tot_Vol,@Peso_Bruto,@Peso_Liquido,
                        @Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,@SAP_ShipNumber,@cd_tp_oper,@TTime_d,@Obs
                    )
		    Set @ProcessoN = @Processo
	End
	Else
		Begin
			Update
				House_exp_Mar
			Set
				--Dt_Emis_HEM		= @Dt_Emis,
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
					Num_Proc_HEM,Cd_Usuario,Nr_Reserva,Cd_Agente,MAWB_hem,Cd_Vendedor
				)
			Values
				(
					@Processo,@Cd_Usuario,@Nr_Reserva,@Cd_Agente,@MAWB,@Cd_Vendedor
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
					Num_Proc_Lem,ETA_Lem,ETD_Lem,ATA_Lem,ATD_Lem,Cd_Armador_Lem,cd_tp_carga,Cd_Planta_Lem,Cd_DstFinal_Lem,
					Cd_Courier,Courier_Number_Lem,Intl_Ref_Lem,Net_Rates_Lem,Canal_Lem,Cd_Terminal,Cd_Order,Selling_Rates_Lem,
					Cd_Transportadora,Cd_Notify_2,Original_ETA_Lem,Dt_BL_Lem,Vlr_Invoice,Cd_Moeda_Invoice,Comissao_Agente_Lem
				)
			Values
				(
					@Processo, @ETA_Lem,@ETD_Lem,@ATA_Lem,@ATD_Lem,@Cd_Armador_Lem,@cd_tp_carga,@Cd_Planta_Lem,@Cd_DstFinal_Lem,
                    @Cd_Courier,@Courier_Number_Lem,@Intl_Ref_Lem,@Net_Rates_Lem,@Canal_Lem,@Cd_Terminal,@Cd_Order,@Selling_Rates_Lem,
                    @Cd_Transportadora,@Cd_Notify_2,@Original_ETA_Lem,@Dt_BL,@Vlr_Invoice,@Cd_Moeda_Inv,@Comissao_Agente_Lem
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


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
