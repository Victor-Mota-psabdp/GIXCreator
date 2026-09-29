SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HIO_InsUpd]

	@Processo		VarChar(16),
	@Dt_Emis		varchar(10),
	@HAWB			varchar(25),	
	@cd_Export_HIO 		Varchar(10),
	@cd_consig_HIO 		Varchar(10),
	@cd_IMPort_HIO 		Varchar(10),
	@Cd_Org_HIO 		Varchar(10),
	@cd_dst_HIO 		VarChar(10),
	@Voo_HIO		VarChar(10),
	@Qtd_Tot_Vol	Float,
	@Peso_Bruto		Float,
	@Peso_Real		Float,
	@Vol_Tot		Float,
	@Tp_Frete		char(1),
	@cd_tp_moeda 		Varchar(3),
	@Vlr_Frete_Efet	Float,
	@Obs			Varchar(2000),
	@Cd_Despachante		Varchar(10),	
	@SAP_ShipNumber	varchar(20),
	@Cd_tp_oper 		VarChar(3),
--LLP_IMP_OUT
	@Canal_Lio		Varchar(20),
	@TTime_d		smallint,
	@Cd_Agente		Varchar(10),
	@Cd_Vendedor	Varchar(10),
	@Cd_Usuario		Varchar(10),
	@Cd_Carrier		Varchar(10),
	@Cd_Planta_LIO		varchar(3),
	@Cd_DstFinal_LIO 	varchar(3),
	@ETD_LIO		Datetime,
	@ATD_LIO		Datetime,
	@ETA_LIO		Datetime,	
	@ATA_LIO		Datetime,
	@Cd_Forwarder		Varchar(10),
	@Cd_Terminal		Varchar (10),
	@Intl_Ref_LIO		Varchar(50),
	@Cd_Order		Varchar(10),
	@DL_Cargo_LIO		Datetime,	
	@Cd_Courier		Varchar(10),
	@Courier_Number_Lio	Varchar(50),
	@Original_ETA_LIO	DateTime,
	@Cd_Transportadora	Varchar(10),
	@Vlr_Invoice	float,
	@cd_moeda_INV 		Varchar(3),
	@Peso_Cubado_LIO	Float,	
	@Tipo			char(1),
	@ProcessoN		VarChar(16) OUTPUT

 AS

Begin Transaction

		Declare @Seq			Varchar(10)
		Declare @cd_dsp_HIO 		VarChar(10)
		
	if @Processo is null
		Begin
						
			--Declare @Grupo	varchar(3)
			--Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_consig_HIO)
			--Set @Processo = 'IO' + @Grupo + right(cast(year(getdate()) as Varchar),2)
			--Set @Processo=@Processo+Right('000' + cast(month(getdate()) as VarChar),2)
			--Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LIO,14),5)),0)+1 from LLP_IMP_OUT where left(Num_Proc_LIO,9)=@Processo)
			--Set @Seq='00000'+@Seq
			--Set @Seq=right(@Seq,5)
			--Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)


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
						Num_Proc_HIO,Dt_Emis_HIO,HAWB_HIO,--MAWB_HIO,
						Cd_Import_HIO,Cd_Consig_HIO,Cd_Export_HIO,Cd_Org_HIO,Cd_Dst_HIO,Voo_HIO,Qtd_Tot_Vol_HIO,
						Peso_Bruto_HIO,	Peso_Real_HIO,Vol_Tot_HIO,Tp_Frete_HIO,Cd_Tp_Moeda,	Vlr_Frete_Efet_HIO,
						SAP_ShipNumber,Cd_Tp_Oper,TTime_d,Obs_HIO
					)
			Values
				(
					@Processo,@Dt_Emis,@HAWB,--@MAWB,
					@Cd_IMPort_HIO,	@Cd_Consig_HIO,	@Cd_Export_HIO,@Cd_Org_HIO,	@Cd_Dst_HIO,@Voo_HIO,
					@Qtd_Tot_Vol,@Peso_Bruto,@Peso_Real,@Vol_Tot,@Tp_Frete,@cd_tp_Moeda,@Vlr_Frete_Efet,
					@SAP_ShipNumber,@cd_tp_oper,@TTime_d,@Obs
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
				--MAWB_HIO = @MAWB,
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
				--Cd_Tp_Oper	= @Cd_Tp_Oper,
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
				--Cd_Forwarder 		= @Cd_Forwarder,
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
				Cd_Usuario			= @cd_usuario,
				Vlr_Invoice			= @Vlr_Invoice,
				Cd_Moeda_Invoice	= @cd_moeda_inv
				--cd_cliente			= @cd_cliente,
				--cd_office			= @CD_Office
			Where
				Num_Proc_LIO	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_IMP_OUT
				(
					Num_Proc_LIO,ETA_LIO,ETD_LIO,ATA_LIO,ATD_LIO,Cd_Planta_LIO,Cd_DstFinal_LIO,Cd_Forwarder,
					Cd_Carrier,Cd_Despachante,Intl_Ref_LIO,	Peso_Cubado_LIO,DL_Cargo_LIO,Cd_vendedor,
					Cd_Agente,Cd_Terminal,Cd_Order,Tipo_Lio,Canal_Lio,Cd_Courier,Courier_Number_Lio, 	
					Original_ETA_Lio,Cd_Transportadora,Cd_Usuario,Vlr_Invoice,Cd_Moeda_Invoice
					--cd_cliente,
					--cd_office
				)
			Values
				(
					@Processo,@ETA_LIO,@ETD_LIO,@ATA_LIO,@ATD_LIO,@Cd_Planta_LIO,@Cd_DstFinal_LIO,@Cd_Forwarder,
					@Cd_Carrier,@Cd_Despachante,@Intl_Ref_LIO,@Peso_Cubado_LIO,@DL_Cargo_LIO,@Cd_vendedor,
					@Cd_Agente,@Cd_Terminal,@Cd_Order,@Tipo,@Canal_Lio,@Cd_Courier,@Courier_Number_Lio, 	
					@Original_ETA_Lio,@Cd_Transportadora,@Cd_usuario,@Vlr_Invoice,@Cd_Moeda_Inv
					--@cd_cliente,
					--@CD_Office
				)
		end


		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
