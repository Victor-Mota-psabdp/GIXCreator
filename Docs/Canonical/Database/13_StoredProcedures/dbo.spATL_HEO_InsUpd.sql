SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HEO_InsUpd]
(
	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@HAWB				varchar(25),
	@cd_Export_HEO 		Varchar(10),
	@cd_consig_HEO 		Varchar(10),
	@cd_Notify_HEO 		Varchar(10),
	@Cd_Org_HEO 		Varchar(10),
	@cd_dst_HEO 		VarChar(10),
	@Voo_HEO			VarChar(10),
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Real			Float,
	@Vol_Tot			Float,
	@Tp_Frete			char(1),
	@cd_tp_moeda 		Varchar(3),
	@Vlr_Frete_Efet		Float,
	@Obs				Varchar(2000),
	@Cd_Despachante		Varchar(10)	,
	@SAP_ShipNumber		varchar(20),
	@Cd_tp_oper 		VarChar(3),

	@Canal_Leo			Varchar(20),
	@TTime_d			smallint,
	@Cd_Agente			Varchar(10),
	@Cd_Vendedor		Varchar(30),
	@Cd_Usuario 		VarChar(25),
	@Cd_Carrier			Varchar(10),
	@Cd_Planta_LEO		varchar(3),
	@Cd_DstFinal_LEO 	varchar(3),
	@ETD_LEO			Datetime,
	@ATD_LEO			Datetime,
	@ETA_LEO			Datetime,
	@ATA_LEO			Datetime,	
	@Cd_Forwarder		Varchar(10),	
	@Cd_Terminal		Varchar(10),	
	@Intl_Ref_LEO		Varchar(50),
	@Cd_Order			Varchar(10),
	@DL_Cargo_LEO		Datetime,
	@Cd_Courier			Varchar(10),
	@Courier_Number_Leo	Varchar(50),	
	@Original_ETA_Leo	Datetime,
	@Cd_Transportadora	Varchar(10),	
	@Vlr_Invoice		float,
	@cd_moeda_INV 		Varchar(3),
	@Tipo				char(1),	
	
	@Peso_Cubado_LEO	Float,
	@Cd_Notify_2		Varchar(10),	
	@Comissao_Agente_Leo	float,
	@ProcessoN			VarChar(16) OUTPUT
)

 AS

Begin Transaction

	Declare @Seq				Varchar(10)	
	
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
					Num_Proc_HEO,Dt_Emis_HEO,HAWB_HEO,Cd_Notify_HEO,Cd_Consig_HEO,Cd_Export_HEO,
					Cd_Org_HEO,	Cd_Dst_HEO,	Voo_HEO,Qtd_Tot_Vol_HEO,Peso_Bruto_HEO,	Peso_Real_HEO,
					Vol_Tot_HEO,Tp_Frete_HEO,Cd_Tp_Moeda,Vlr_Frete_Efet_HEO,SAP_ShipNumber,Cd_Tp_Oper,
					TTime_d,Obs_HEO
					)
			Values
				(
					@Processo,@Dt_Emis,@HAWB,@Cd_Notify_HEO,@Cd_Consig_HEO,@Cd_Export_HEO,
					@Cd_Org_HEO,@Cd_Dst_HEO,@Voo_HEO,@Qtd_Tot_Vol,@Peso_Bruto,@Peso_Real,
					@Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,@SAP_ShipNumber,@cd_tp_oper,
					@TTime_d,@Obs
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
					Num_Proc_LEO,ETA_LEO,ETD_LEO,ATA_LEO,ATD_LEO,Cd_Planta_LEO,Cd_DstFinal_LEO,Cd_Forwarder,
					Cd_Carrier,Cd_Despachante,Cd_Courier,Courier_Number_LEO,Intl_Ref_LEO,Peso_Cubado_LEO,
					DL_Cargo_LEO,Cd_vendedor,Cd_Agente,Cd_Terminal,Tipo_LEO,Cd_Order,Canal_Leo,Original_ETA_Leo,
					Cd_Transportadora,Cd_Notify_2,Cd_Usuario,Vlr_Invoice,Cd_Moeda_Invoice,Comissao_Agente_Leo
				)
			Values
				(
					@Processo,@ETA_LEO,@ETD_LEO,@ATA_LEO,@ATD_LEO,@Cd_Planta_LEO,@Cd_DstFinal_LEO,@Cd_Forwarder,
					@Cd_Carrier,@Cd_Despachante,@Cd_Courier,@Courier_Number_LEO,@Intl_Ref_LEO,@Peso_Cubado_LEO,
					@DL_Cargo_LEO,@Cd_vendedor,@Cd_Agente,@Cd_Terminal,@Tipo,@Cd_Order,@Canal_Leo,@Original_ETA_Leo,
					@Cd_Transportadora,@Cd_Notify_2,@Cd_Usuario,@Vlr_Invoice,@Cd_Moeda_Inv,	@Comissao_Agente_Leo
				)
		end


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
