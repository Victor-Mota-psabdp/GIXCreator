SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_MIM_InsUpd]
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
	@Cd_Armador		varchar(3), --@Armador		varchar(30),
	@Viagem			VarChar(10),
	@Qtd_Tot_Vol	Float,
	@Peso_Liquido	Float, --LLP
	@Peso_Bruto		Float,
	@Vol_Tot			Float,
	@Tp_Frete		char(1),
	@cd_tp_moeda	Varchar(3), --@Moeda 			varchar(50),
	@Vlr_Frete		Float,
	@Obs			Varchar(2000),
	@Cd_Tp_Carga	int, --@Tp_Carga		varchar(30), --LLP
	@Navio			VarChar(50),
	@ETD			Datetime,	--LLP
	@ATD			Datetime,	--LLP
	@ETA			Datetime,	--LLP
	@ATA			Datetime,	--LLP
	@Original_ETA	Datetime, --LLP		
	@Cd_Usuario		Varchar(10), --@Customer		varchar(30), --LLP
	@Tipo			char(1), --LLP: 'B'= BDP , 'C' = Cliente
	@Status			char(1), --LLP: 'A'= Ativo , 'C'= Cancelado , 'E'= Encerrado
	@ProcessoN		VarChar(16) OUTPUT
)

AS

Begin Transaction

	Declare @Seq			VarChar(10)

	if @Processo is null
		Begin 
			if @Tipo = 'B'
				Begin
					Set @Processo = 'IM' + upper(@Cd_Dst) + cast(year(getdate()) as Varchar)
				End
			Else
				if @Tipo = 'C'
					Begin
						Set @Processo = 'IM' + 'CLI' + cast(year(getdate()) as Varchar)
					End

			Set @Processo = @Processo + Right('000' + cast(month(getdate()) as VarChar),2)
			Set @Seq =(Select ISNULL(max(right(left(Num_Proc_MIM,14),3)),000)+1 from Master_Imp_Mar where left(Num_Proc_MIM,11)=@Processo)
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
					Cd_Tp_Carga,Cd_Notify,Peso_Liquido,Cd_Usuario,Tipo,Status
				)
			Values
				(
					@Processo,@ETD,@ATD,@ETA,@ATA,@Original_ETA,
					@Cd_Tp_Carga,@Cd_Notify,@Peso_Liquido,@Cd_Usuario,@Tipo,@Status
				)

			Set @ProcessoN = @Processo
		end

--TRATAMENTO PARA A TABELA Master_Imp_Mar
	If  exists (select Num_Proc_MIM from Master_Imp_Mar where Num_Proc_MIM=@Processo)
		Begin
			Update
				Master_Imp_Mar
			Set
				Dt_Emis_MIM			= @Dt_Emis,
				MAWB_MIM			= @MAWB,
				Qtd_HAWB_MIM		= @Qtd_HOUs,
				Cd_Consig_MIM		= @Cd_Consig,
				Cd_Export_MIM		= @Cd_Export,
				Cd_Org_MIM			= @Cd_Org,
				Cd_Dst_MIM			= @Cd_Dst,
				Cd_Armador			= @Cd_Armador,
				Navio_MIM			= @Navio,
				Viagem_MIM			= @Viagem,
				Qtd_Tot_Vol_MIM		= @Qtd_Tot_Vol,
				Vol_Tot_MIM			= @Vol_Tot,
				Peso_Bruto_MIM		= @Peso_Bruto,
				Tp_Frete_MIM		= @Tp_Frete,
				Cd_Tp_Moeda			= @Cd_Tp_Moeda,
				Vlr_Frete_MIM		= @Vlr_Frete,
				Obs_MIM				= @Obs
			Where
				Num_Proc_MIM = @Processo
		end
	Else
		Begin
			Insert Into
				Master_Imp_Mar
				(
					Num_Proc_MIM,Dt_Emis_MIM,MAWB_MIM,Qtd_HAWB_MIM,Cd_Consig_MIM,Cd_Export_MIM,
					Cd_Org_MIM,Cd_Dst_MIM,Cd_Armador,Navio_MIM,Viagem_MIM,Qtd_Tot_Vol_MIM,Vol_Tot_MIM,
					Peso_Bruto_MIM,Tp_Frete_MIM,Cd_Tp_Moeda,Vlr_Frete_MIM,Obs_MIM
				)
			Values
				(
					@Processo,@Dt_Emis,@MAWB,@Qtd_HOUs,@Cd_Consig,@Cd_Export,
					@Cd_Org,@Cd_Dst,@Cd_Armador,@Navio,@Viagem,@Qtd_Tot_Vol,@Vol_Tot,
					@Peso_Bruto,@Tp_Frete,@Cd_Tp_Moeda,@Vlr_Frete,@Obs
				)
		end
		
		
		--Update pra Navio X Viagem
		Begin		
			update LLP_Master set id_viagem = (
				select V.ID_Viagem from viagem_llp V with(nolock)
					join Navio_LLP N with(nolock) on N.Id_Navio = V.ID_Navio
				where V.Cd_Dst = @Cd_Dst and V.NR_Viagem = @Viagem and N.Nome_Navio = @Navio and Modal = 'I')  
				where Num_Proc_Master = @Processo 
		End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 







































GO
