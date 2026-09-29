SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ATL_INT.dbo.[Tipo_House_Temp]
--sp_help Tipo_House_Temp
CREATE PROCEDURE [dbo].[spTipo_House_Temp_InsUpd]
(
	@Id_TP_House_Temp	bigint,
	@HAWB			varchar(200),
	@MAWB			varchar(200),
	@Intl_Reference	varchar(200),
	@Num_Proc		varchar(200),
	@Cd_Export		varchar(200),
	@Cd_Consig		varchar(200),
	@Cd_Import		varchar(200),
	@Cd_planta		varchar(200),
	@Cd_Org			varchar(200),
	@Cd_Dst			varchar(200),
	@Cd_DstFinal	varchar(200),
	@Cd_Armador		varchar(200),
	@Navio			varchar(200),
	@Viagem			varchar(200),
	@ETA			varchar(200),
	@ETD			varchar(200),
	@ATA			varchar(200),
	@ATD			varchar(200),
	@Cd_Tp_Carga	varchar(200),
	@Qtd_Tot_Vol	varchar(200),
	@Vol_Tot		varchar(200),
	@Peso_Liquido	varchar(200),
	@Peso_Bruto		varchar(200),
	@Tp_Frete		varchar(200),
	@Cd_Tp_Moeda	varchar(200),
	@Vlr_Frete_Efet	varchar(200),
	@Original_ETA	varchar(200),
	@Obs			varchar(200),
	@Modal			varchar(200),
	@LEGTYPE		varchar(200),
	@Id_TP_House_TempN	bigint OUTPUT
)

AS

Begin Transaction

if not exists(select Id_TP_House_Temp from ATL_INT.dbo.[Tipo_House_Temp] where Id_TP_House_Temp= @Id_TP_House_Temp)
	BEGIN
		SET @Id_TP_House_Temp=(select Isnull(max(Id_TP_House_Temp),0)+1 from ATL_INT.dbo.[Tipo_House_Temp])		
		
		Insert into ATL_INT.dbo.[Tipo_House_Temp] 
		(
			Id_TP_House_Temp,HAWB,MAWB,Intl_Reference,Num_Proc,Cd_Export,Cd_Consig,Cd_Import,Cd_planta,Cd_Org,
			Cd_Dst,Cd_DstFinal,Cd_Armador,Navio,Viagem,ETA,ETD,ATA,ATD,Cd_Tp_Carga,Qtd_Tot_Vol,Vol_Tot,Peso_Liquido,
			Peso_Bruto,Tp_Frete,Cd_Tp_Moeda,Vlr_Frete_Efet,Original_ETA,Obs,Modal,LEGTYPE
		)
		Values
		(
			@Id_TP_House_Temp,@HAWB,@MAWB,@Intl_Reference,@Num_Proc,@Cd_Export,@Cd_Consig,@Cd_Import,
			@Cd_planta,@Cd_Org,@Cd_Dst,@Cd_DstFinal,@Cd_Armador,@Navio,@Viagem,@ETA,@ETD,@ATA,@ATD,
			@Cd_Tp_Carga,@Qtd_Tot_Vol,@Vol_Tot,@Peso_Liquido,@Peso_Bruto,@Tp_Frete,@Cd_Tp_Moeda,@Vlr_Frete_Efet,
			@Original_ETA,@Obs,@Modal,@LEGTYPE
		)
	END
ELSE
	BEGIN
			Update
				ATL_INT.dbo.[Tipo_House_Temp]
			Set
				HAWB=@HAWB,
				MAWB=@MAWB,
				Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				Cd_Export=@Cd_Export,
				Cd_Consig=@Cd_Consig,
				Cd_Import=@Cd_Import,
				Cd_planta=@Cd_planta,
				Cd_Org=@Cd_Org,
				Cd_Dst=@Cd_Dst,
				Cd_DstFinal=@Cd_DstFinal,
				Cd_Armador=@Cd_Armador,
				Navio=@Navio,
				Viagem=@Viagem,
				ETA=@ETA,
				ETD=@ETD,
				ATA=@ATA,
				ATD=@ATD,
				Cd_Tp_Carga=@Cd_Tp_Carga,
				Qtd_Tot_Vol=@Qtd_Tot_Vol,
				Vol_Tot=@Vol_Tot,
				Peso_Liquido=@Peso_Liquido,
				Peso_Bruto=@Peso_Bruto,
				Tp_Frete=@Tp_Frete,
				Cd_Tp_Moeda=@Cd_Tp_Moeda,
				Vlr_Frete_Efet=@Vlr_Frete_Efet,
				Original_ETA=@Original_ETA,
				Obs=@Obs,
				Modal=@Modal,
				LEGTYPE=@LEGTYPE	
			where 
				Id_TP_House_Temp= @Id_TP_House_Temp
	END

set @Id_TP_House_TempN = @Id_TP_House_Temp

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
