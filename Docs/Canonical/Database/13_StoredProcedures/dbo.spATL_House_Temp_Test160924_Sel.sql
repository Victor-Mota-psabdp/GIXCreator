SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_House_Temp_Test160924_Sel]--'2','','','D'
(
	@SystemCode				varchar(200),
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Tipo					char(1)
)

as

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
			AND [Intl_Reference] = 'US10020487281'
	End
GO
