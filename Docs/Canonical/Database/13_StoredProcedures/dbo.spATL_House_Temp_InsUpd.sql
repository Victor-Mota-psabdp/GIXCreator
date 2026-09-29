SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[House_Temp] alter column	[Name_Export] [varchar](1000) NULL
--alter table [dbo].[House_Temp] alter column	[Name_Consig] [varchar](1000) NULL
--alter table [dbo].[House_Temp] alter column	[Name_Import] [varchar](1000) NULL

--alter table [dbo].[House_Temp] add [DestinationCountryCode] [varchar](200) NULL
--alter table [dbo].[House_Temp] add [Cd_Tp_Oper] [varchar](200) NULL
--alter table [dbo].[House_Temp] add [Name_Incoterm] [varchar](200) NULL
--alter table House_Temp add [OriginCountryCode] [varchar](200) NULL

--sp_help House_Temp
--select * from House_Temp

CREATE PROCEDURE [dbo].[spATL_House_Temp_InsUpd]
(
	@ID				bigint,
	@ID_Req			bigint,
	@Intl_Reference	varchar(200),
	@Dt_Emis		varchar(200),
	@HAWB			varchar(200),
	@MAWB			varchar(200),
	@Num_Proc		varchar(200),
	@Cd_Export		varchar(200),
	@Name_Export	varchar(1000),
	@Cd_Consig		varchar(200),
	@Name_Consig	varchar(1000),
	@Cd_Import		varchar(200),
	@Name_Import	varchar(1000),
	@Cd_planta		varchar(200),
	@Name_planta	varchar(200),
	@Cd_Org			varchar(200),
	@Name_Org		varchar(200),
	@Cd_Dst			varchar(200),
	@Name_Dst		varchar(200),
	@Cd_DstFinal	varchar(200),
	@Name_DstFinal	varchar(200),
	@Cd_Armador		varchar(200),
	@Name_Armador	varchar(200),
	@Navio			varchar(200),
	@Name_Navio		varchar(200),
	@Viagem			varchar(200),
	@Name_Viagem	varchar(200),
	@Id_Viagem		varchar(200),
	@ETA			varchar(200),
	@ETD			varchar(200),
	@ATA			varchar(200),
	@ATD			varchar(200),
	@Cd_Tp_Carga	varchar(200),
	@Name_Tp_Carga	varchar(200),
	@Qtd_Tot_Vol	varchar(200),
	@Vol_Tot		varchar(200),
	@Peso_Liquido	varchar(200),
	@Peso_Bruto		varchar(200),
	@Tp_Frete		varchar(200),
	@Cd_Tp_Moeda	varchar(200),
	@Name_Tp_Moeda	varchar(200),
	@Vlr_Frete_Efet	varchar(200),
	@Original_ETA	varchar(200),
	@Obs			varchar(200),
	@Modal			varchar(200),
	@Id_TP_House_Temp	varchar(200),
	@cd_tp_modal		varchar(200),
	@SystemCode			varchar(200),
	@DT_INS_House_Temp	datetime,
	@DestinationCountryCode 	varchar(200),
	@Cd_Tp_Oper 	varchar(200),
	@Name_Incoterm 	varchar(200),
	@Peso_Cubado	varchar(200),
	@Booking_Number	varchar(200),
	@OriginCountryCode	varchar(200)
)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help House_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select Intl_Reference from House_Temp with(nolock) where ID = @ID) -- Intl_Reference = @Intl_Reference)
		BEGIN
			Insert into House_Temp 
			(
				ID_Req,Intl_Reference,Dt_Emis,HAWB,MAWB,Num_Proc,Cd_Export,Name_Export,Cd_Consig,Name_Consig,Cd_Import,
				Name_Import,Cd_planta,Name_planta,Cd_Org,Name_Org,Cd_Dst,Name_Dst,Cd_DstFinal,Name_DstFinal,Cd_Armador,
				Name_Armador,Navio,Name_Navio,Viagem,Name_Viagem,Id_Viagem,ETA,ETD,ATA,ATD,Cd_Tp_Carga,Name_Tp_Carga,
				Qtd_Tot_Vol,Vol_Tot,Peso_Liquido,Peso_Bruto,Tp_Frete,Cd_Tp_Moeda,Name_Tp_Moeda,Vlr_Frete_Efet,
				Original_ETA,Obs,Modal,Id_TP_House_Temp,cd_tp_modal,SystemCode,DT_INS_House_Temp,
				DestinationCountryCode,Cd_Tp_Oper,Name_Incoterm,Peso_Cubado,Booking_Number,OriginCountryCode
			)
			Values
			(
				@ID_Req,@Intl_Reference,@Dt_Emis,@HAWB,@MAWB,@Num_Proc,@Cd_Export,@Name_Export,@Cd_Consig,@Name_Consig,@Cd_Import,
				@Name_Import,@Cd_planta,@Name_planta,@Cd_Org,@Name_Org,@Cd_Dst,@Name_Dst,@Cd_DstFinal,@Name_DstFinal,@Cd_Armador,
				@Name_Armador,@Navio,@Name_Navio,@Viagem,@Name_Viagem,@Id_Viagem,@ETA,@ETD,@ATA,@ATD,@Cd_Tp_Carga,@Name_Tp_Carga,
				@Qtd_Tot_Vol,@Vol_Tot,@Peso_Liquido,@Peso_Bruto,@Tp_Frete,@Cd_Tp_Moeda,@Name_Tp_Moeda,@Vlr_Frete_Efet,
				@Original_ETA,@Obs,@Modal,
				@Id_TP_House_Temp,@cd_tp_modal,@SystemCode,@DT_INS_House_Temp,
				@DestinationCountryCode,@Cd_Tp_Oper,@Name_Incoterm,@Peso_Cubado,@Booking_Number,@OriginCountryCode
			)
			set @ID_New = @@IDENTITY;
			
		END
	else
		BEGIN
			update
				House_Temp
			set
				ID_Req=@ID_Req,Intl_Reference=@Intl_Reference,Dt_Emis=@Dt_Emis,HAWB=@HAWB,MAWB=@MAWB,
				--Num_Proc=@Num_Proc,
				Cd_Export=@Cd_Export,Name_Export=@Name_Export,Cd_Consig=@Cd_Consig,
				Name_Consig=@Name_Consig,
				Cd_Import=@Cd_Import,Name_Import=@Name_Import,Cd_planta=@Cd_planta,Name_planta=@Name_planta,
				Cd_Org=@Cd_Org,
				Name_Org=@Name_Org,Cd_Dst=@Cd_Dst,Name_Dst=@Name_Dst,Cd_DstFinal=@Cd_DstFinal,
				Name_DstFinal=@Name_DstFinal,
				Cd_Armador=@Cd_Armador,Name_Armador=@Name_Armador,Navio=@Navio,Name_Navio=@Name_Navio,
				Viagem=@Viagem,Name_Viagem=@Name_Viagem,
				Id_Viagem=@Id_Viagem,ETA=@ETA,ETD=@ETD,ATA=@ATA,ATD=@ATD,Cd_Tp_Carga=@Cd_Tp_Carga,
				Name_Tp_Carga=@Name_Tp_Carga,
				Qtd_Tot_Vol=@Qtd_Tot_Vol,Vol_Tot=@Vol_Tot,Peso_Liquido=@Peso_Liquido,Peso_Bruto=@Peso_Bruto,
				Tp_Frete=@Tp_Frete,
				Cd_Tp_Moeda=@Cd_Tp_Moeda,Name_Tp_Moeda=@Name_Tp_Moeda,Vlr_Frete_Efet=@Vlr_Frete_Efet,
				Original_ETA=@Original_ETA,
				Obs=@Obs,Modal=@Modal,Id_TP_House_Temp=@Id_TP_House_Temp,cd_tp_modal=@cd_tp_modal,
				SystemCode=@SystemCode,
				DT_INS_House_Temp=@DT_INS_House_Temp,
				DestinationCountryCode=@DestinationCountryCode,
				Cd_Tp_Oper = @Cd_Tp_Oper,
				Name_Incoterm = @Name_Incoterm,
				Peso_Cubado = @Peso_Cubado,
				Booking_Number = @Booking_Number,
				OriginCountryCode =@OriginCountryCode
			where
				ID=@ID
				--Intl_Reference= @Intl_Reference
				
			set @ID_New = @ID
		
		END
		
	
	Select @ID_New as Retorno;

		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
