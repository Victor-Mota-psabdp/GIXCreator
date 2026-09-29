SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].House_Temp add [cd_tp_modal] [varchar](200) NULL
--alter table [dbo].House_Temp add [SystemCode] [varchar](200) NULL
--alter table [dbo].House_Temp add DT_INS_House_Temp Datetime NULL
--select * from House_Temp where Intl_Reference = '3121056238'
--[spATL_House_Temp_Sel]'2','5728','3121056238','D'
--alter table [dbo].[House_Temp] add [Peso_Cubado] [varchar](200) NULL
CREATE Procedure [dbo].[spATL_House_Temp_Sel]--'2','','','D'
(
	@SystemCode				varchar(200),
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Tipo					char(1)
)

as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos

sp_help House_Temp
*/

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select ID,ID_Req,Intl_Reference,Dt_Emis,HAWB,MAWB,Num_Proc,Cd_Export,Name_Export,Cd_Consig,Name_Consig,
			Cd_Import,Name_Import,Cd_planta,Name_planta,Cd_Org,Name_Org,Cd_Dst,Name_Dst,Cd_DstFinal,Name_DstFinal,
			Cd_Armador,Name_Armador,Navio,Name_Navio,Viagem,Name_Viagem,Id_Viagem,ETA,ETD,ATA,ATD,Cd_Tp_Carga,
			Name_Tp_Carga,Qtd_Tot_Vol,Vol_Tot,Peso_Liquido,Peso_Bruto,Tp_Frete,Cd_Tp_Moeda,Name_Tp_Moeda,Vlr_Frete_Efet,
			Original_ETA,Obs,Modal,Id_TP_House_Temp,cd_tp_modal,SystemCode,DT_INS_House_Temp
			,DestinationCountryCode,Cd_Tp_Oper,Name_Incoterm,Peso_Cubado,Booking_Number,OriginCountryCode	
		from 
			House_Temp with(nolock)
		where
			[DT_INS_House_Temp] is null
			and [SystemCode] = @SystemCode
			AND [ID_Req] = @ID_Req
	End
	
if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		select ID,ID_Req,Intl_Reference,Dt_Emis,HAWB,MAWB,Num_Proc,Cd_Export,Name_Export,Cd_Consig,Name_Consig,
			Cd_Import,Name_Import,Cd_planta,Name_planta,Cd_Org,Name_Org,Cd_Dst,Name_Dst,Cd_DstFinal,Name_DstFinal,
			Cd_Armador,Name_Armador,Navio,Name_Navio,Viagem,Name_Viagem,Id_Viagem,ETA,ETD,ATA,ATD,Cd_Tp_Carga,
			Name_Tp_Carga,Qtd_Tot_Vol,Vol_Tot,Peso_Liquido,Peso_Bruto,Tp_Frete,Cd_Tp_Moeda,Name_Tp_Moeda,Vlr_Frete_Efet,
			Original_ETA,Obs,Modal,Id_TP_House_Temp,cd_tp_modal,SystemCode,DT_INS_House_Temp
			,DestinationCountryCode,Cd_Tp_Oper,Name_Incoterm,Peso_Cubado,Booking_Number,OriginCountryCode	
		from 
			House_Temp with(nolock)
		where
			--[DT_INS_House_Temp] is null	and 
			[SystemCode] = @SystemCode
			AND [Intl_Reference] = @Intl_Reference
	End
	
if @Tipo = 'P'  --usado no PDF2ATL 
	Begin
		select ID,ID_Req,Intl_Reference,Dt_Emis,HAWB,MAWB,Num_Proc,Cd_Export,Name_Export,Cd_Consig,Name_Consig,
			Cd_Import,Name_Import,Cd_planta,Name_planta,Cd_Org,Name_Org,Cd_Dst,Name_Dst,Cd_DstFinal,Name_DstFinal,
			Cd_Armador,Name_Armador,Navio,Name_Navio,Viagem,Name_Viagem,Id_Viagem,ETA,ETD,ATA,ATD,Cd_Tp_Carga,
			Name_Tp_Carga,Qtd_Tot_Vol,Vol_Tot,Peso_Liquido,Peso_Bruto,Tp_Frete,Cd_Tp_Moeda,Name_Tp_Moeda,Vlr_Frete_Efet,
			Original_ETA,Obs,Modal,Id_TP_House_Temp,cd_tp_modal,SystemCode,DT_INS_House_Temp
			,DestinationCountryCode,Cd_Tp_Oper,Name_Incoterm,Peso_Cubado,Booking_Number,OriginCountryCode	
		from 
			House_Temp with(nolock)
		where
			--[DT_INS_House_Temp] is null	and 
			[SystemCode] = @SystemCode
			--AND [Intl_Reference] = @Intl_Reference
			and Num_Proc= @Intl_Reference
	End


GO
