SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spATL_MIA_InsUpd]
(
	@Processo		VarChar(14),
	@Dt_Emis		varchar(10),
	@MAWB			varchar(25),
	@Qtd_HOUs		int,
	@Cd_Export 		Varchar(10),--@Shipper		varchar(20),
	@Cd_Consig		Varchar(10), --@Consignee		varchar(20),
	@Cd_Notify		Varchar(10), --@Notify			varchar(20), --LLP
	@Cd_Org 		Varchar(10), --@Origem			varchar(30),
	@Cd_Dst			VarChar(10), --@Destino		varchar(30),
	@Cd_Cia_Aer		varchar(3), --@Carrier		varchar(30),
	@Voo			VarChar(10),
	@Qtd_Tot_Vol	Float,
	@Peso_Liquido	Float, --LLP
	@Peso_Bruto		Float,
	@Peso_Cubado	Float,
	@Vol_Tot		Float,
	@Tp_Frete		char(1),
	@cd_tp_moeda	Varchar(3), --@Moeda 			varchar(50),
	@Vlr_Frete		Float,
	@Obs			Varchar(2000),
	@Cd_Tp_Carga	int,--@Tp_Carga		varchar(30), --LLP
	@ETD			Datetime,	--LLP
	@ATD			Datetime,	--LLP
	@ETA			Datetime,	--LLP
	@ATA			Datetime,	--LLP
	@Original_ETA	Datetime, --LLP	
	@Cd_Usuario		Varchar(10),--@Customer		varchar(30), --LLP	
	@Tipo			char(1), --LLP: 'B'= BDP , 'C' = Cliente
	@Status			char(1), --LLP: 'A'= Ativo , 'C'= Cancelado , 'E'= Encerrado
	@ProcessoN		VarChar(16) OUTPUT
)

 AS

Begin Transaction

		Declare @Seq			VarChar(10)
		Set @cd_tp_carga = NULL--(Select cd_tp_carga from Tipo_Carga where Nome_tp_Carga = @Tp_Carga)


	if @Processo is null
		Begin 
			if @Tipo = 'B'
				Begin
					Set @Processo = 'IA' + upper(@Cd_Dst) + cast(year(getdate()) as Varchar)
				End
			Else
				if @Tipo = 'C'
					Begin
						Set @Processo = 'IA' + 'CLI' + cast(year(getdate()) as Varchar)
					End

			Set @Processo = @Processo + Right('000' + cast(month(getdate()) as VarChar),2)
			Set @Seq =(Select ISNULL(max(right(left(Num_Proc_MIA,14),3)),000)+1 from Master_Imp_Aer where left(Num_Proc_MIA,11)=@Processo)
			Set @Seq = '000' + @Seq
			Set @Seq = right(@Seq,3)
			Set @Processo = @Processo + @Seq
		end

--TRATAMENTO PARA A TABELA LLP_Master
	If  exists (select Num_Proc_Master from LLP_Master where Num_Proc_Master=@Processo)
		Begin
			Update
				LLP_Master
			Set
				ETD_Master			= @ETD,
				ATD_Master			= @ATD,
				ETA_Master			= @ETA,
				ATA_Master			= @ATA,
				Original_ETA_Master	= @Original_ETA,
				Cd_Tp_Carga			= @Cd_Tp_Carga,
				Cd_Notify			= @Cd_Notify,
				Peso_Liquido		= @Peso_Liquido,
				Peso_Cubado			= @Peso_Cubado,
				Cd_Usuario			= @Cd_Usuario,
				Tipo				= @Tipo,
				Status				= @Status
			Where
				Num_Proc_Master	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_Master
				(
					Num_Proc_Master,ETD_Master,ATD_Master,ETA_Master,ATA_Master,Original_ETA_Master,
					Cd_Tp_Carga,Cd_Notify,Peso_Liquido,Peso_Cubado,Cd_Usuario,Tipo,Status
				)
			Values
				(
					@Processo,@ETD,@ATD,@ETA,@ATA,@Original_ETA,
					@Cd_Tp_Carga,@Cd_Notify,@Peso_Liquido,@Peso_Cubado,@Cd_Usuario,@Tipo,@Status
				)
			Set @ProcessoN = @Processo
		end

--TRATAMENTO PARA A TABELA Master_Imp_Aer
	If  exists (select Num_Proc_MIA from Master_Imp_Aer where Num_Proc_MIA=@Processo)
		Begin
			Update
				Master_Imp_Aer
			Set
				Dt_Emis_MIA			= @Dt_Emis,
				MAWB_MIA			= @MAWB,
				Qtd_HAWB_MIA		= @Qtd_HOUs,
				Cd_Consig_MIA		= @Cd_Consig,
				Cd_Export_MIA		= @Cd_Export,
				Cd_Org_MIA			= @Cd_Org,
				Cd_Dst_MIA			= @Cd_Dst,
				Cd_Cia_Aer			= @Cd_Cia_Aer,
				Voo_MIA				= @Voo,
				Qtd_Tot_Vol_MIA		= @Qtd_Tot_Vol,
--				Vol_Tot_MIA			= @Vol_Tot,
				Peso_Bruto_MIA		= @Peso_Bruto,
				Tp_Frete_MIA		= @Tp_Frete,
				Cd_Tp_Moeda			= @Cd_Tp_Moeda,
				Vlr_Frete_MIA		= @Vlr_Frete,
				Obs_MIA				= @Obs,
				Dt_Cheg_MIA			= convert(varchar(10),@ATA,103)
			Where
				Num_Proc_MIA = @Processo
		end
	Else
		Begin
			Insert Into
				Master_Imp_Aer
				(
					Num_Proc_MIA,Dt_Emis_MIA,MAWB_MIA,Qtd_HAWB_MIA,Cd_Consig_MIA,Cd_Export_MIA,Cd_Org_MIA,
					Cd_Dst_MIA,Dt_Cheg_MIA,Cd_Cia_aer,Voo_MIA,Qtd_Tot_Vol_MIA,--Vol_Tot_MIA,
					Peso_Bruto_MIA,Tp_Frete_MIA,Cd_Tp_Moeda,Vlr_Frete_MIA,Obs_MIA
				)
			Values
				(
					@Processo,@Dt_Emis,@MAWB,@Qtd_HOUs,@Cd_Consig,@Cd_Export,@Cd_Org,
					@Cd_Dst,convert(varchar(10),@ATA,103),@Cd_Cia_Aer,@Voo,@Qtd_Tot_Vol,--@Vol_Tot,
					@Peso_Bruto,@Tp_Frete,@Cd_Tp_Moeda,@Vlr_Frete,@Obs
				)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 










































GO
