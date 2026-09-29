SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--23-9-202 - cadu - Included convert
--sp_help House_Temp
CREATE VIEW [dbo].[vwHouse_Temp_Sel]
AS
	select 
		HOU.ID								[ID],
		HOU.ID_Req							[ID Req],
		HOU.Intl_Reference					[Intl Reference],
		HOU.DT_EMIS							[Register Date],
		HOU.HAWB								[AWB/BL Number],
		HOU.MAWB								[MAWB/BL Number],
		HOU.Num_Proc						[JOB],				
		
		HOU.Cd_Export							[Shipper Code],
		HOU_Shipper.Apelido					[Shipper],		
		HOU.Name_Export						[Shipper XML],
		
		HOU.Cd_Consig							[Consignee Code],
		HOU_Consignee.Apelido				[Consignee],
		HOU.Name_Consig						[Consignee XML],

		HOU.Cd_Import							[Notify Code],
		HOU_Import.Apelido					[Notify],
		HOU.Name_Import						[Notify_XML],
		
		HOU.Cd_planta							[Origin Code],
		HOU_Planta.Nome_Local				[Origin],		
		HOU.Name_planta						[Origin XML],
				
		HOU.Cd_Org							[Loading Code],
		HOU_Loading.Nome_Local				[Loading],	
		HOU.Name_Org							[Loading XML],
		
		HOU.Cd_Dst							[Discharge Code],
		HOU_Discharge.Nome_Local			[Discharge],
		HOU.Name_Dst							[Discharge XML],	
		
		HOU.Cd_DstFinal						[FinalDestination Code],
		HOU_FinalDestination.Nome_Local		[FinalDestination],
		HOU.Name_DstFinal						[FinalDestination XML],
				
		HOU.Cd_Armador			 		[Carrier Code],
		isnull(HOU_Carrier.Nome_Armador,
			HOU_CarrierAir.Nome_Cia_Aer)	[Carrier],
		HOU.Name_Armador						[Carrier XML],

		(case when HOU_Vessel.Nome_Navio is null then NULL else HOU.Navio end) [Vessel Code],
		--HOU.Navio							[Vessel Code],
		HOU_Vessel.Nome_Navio			[Vessel],
		HOU.Name_Navio					[Vessel XML],
		
		HOU.Viagem						[Voyage Code],
		HOU_Voyage.NR_Viagem			[Voyage],
		HOU.Name_Viagem					[Voyage XML],
		HOU.Id_Viagem						Id_Viagem,
		
		CONVERT(VARCHAR(10),CONVERT(DATETIME,HOU.ETD,103),103)	[ETD],		
		CONVERT(VARCHAR(10),CONVERT(DATETIME,HOU.ETA,103),103)	[ETA],
		CONVERT(VARCHAR(10),CONVERT(DATETIME,HOU.ATD,103),103)	[ATD],			
		CONVERT(VARCHAR(10),CONVERT(DATETIME,HOU.ATA,103),103)	[ATA],
	
		--HOU.Cd_Tp_Carga					[Type Of Cargo Code],
		(case when HOU_TypeOfCargo.Nome_Tp_Carga is null then NULL else HOU.Cd_Tp_Carga end) [Type Of Cargo Code],
		HOU_TypeOfCargo.Nome_Tp_Carga	[Type Of Cargo],
		HOU.Name_Tp_Carga					[Type Of Cargo XML],
		
		
		HOU.Vol_Tot						[Volume(m3)],
		HOU.Qtd_Tot_Vol					[Nº of Pieces],
		HOU.Peso_Liquido					[Net Weight (KG)],
		HOU.Peso_Bruto					[Gross Weight (KG)],
		HOU.Tp_Frete						[Freight Term],
		
		HOU.Cd_Tp_Moeda					[Currency Code],
		HOU_Currency.Nome_Tp_Moeda		[Currency],
		HOU.Name_Tp_Moeda					[Currency XML],
		
		HOU.Vlr_Frete_Efet				[Freight Value],
		
		HOU.Obs							[Nature and Quality of Goods],
		HOU.Original_ETA					[Original ETA],
		
		HOU.cd_tp_modal					[Modal Code],
		HOU_Modal.Modal					[Modal],
		HOU.Modal							[Modal XML],
		HOU.DestinationCountryCode		[Destination Country Code],
		HOU.Cd_Tp_Oper					[Incoterm Code],
		HOU.Name_Incoterm					[Incoterm XML],
		
		PO.Numero_PO_Temp				[PurchaseOrderNumber],
		
		HOU.Peso_Cubado					[Charg. Weight (KG)],
		HOU.Booking_Number							[Booking Number]
		--Id_TP_House_Temp		
		--SystemCode
		--DT_INS_House_Temp		
from House_Temp HOU 
	left join Pessoa HOU_Shipper on HOU_Shipper.Cd_Pes = HOU.Cd_Export	
	left join Pessoa HOU_Consignee on HOU_Consignee.Cd_Pes = HOU.Cd_Consig
	left join Pessoa HOU_Import on HOU_Import.Cd_Pes = HOU.Cd_Import
	left join Localidade HOU_Planta on HOU_Planta.Cd_Local = HOU.Cd_planta
	left join Localidade HOU_Loading on HOU_Loading.Cd_Local = HOU.Cd_Org
	left join Localidade HOU_Discharge on HOU_Discharge.Cd_Local = HOU.Cd_Dst
	left join Localidade HOU_FinalDestination on HOU_FinalDestination.Cd_Local = HOU.Cd_DstFinal
	left join Armador HOU_Carrier on HOU_Carrier.Cd_Armador = HOU.Cd_Armador
	left join Cia_Aerea HOU_CarrierAir on HOU_CarrierAir.Cd_Cia_Aer = HOU.Cd_Armador
	--left join Viagem_LLP HOU_Voyage	on HOU_Voyage.ID_Viagem  = HOU.Id_Viagem
	--left join Navio_LLP HOU_Vessel	on HOU_Vessel.Id_Navio  = HOU_Voyage.ID_Navio	
	left join Navio_LLP HOU_Vessel	on convert(varchar(10),HOU_Vessel.Id_Navio)  = HOU.Navio
	left join Viagem_LLP HOU_Voyage with(nolock) on HOU_Voyage.NR_Viagem  = HOU.Viagem and HOU_Vessel.Id_Navio = HOU_Voyage.ID_Navio
	left join Tipo_Carga HOU_TypeOfCargo	on  convert(varchar(10),HOU_TypeOfCargo.Cd_Tp_Carga) = HOU.Cd_Tp_Carga	
	left join Tipo_Moeda HOU_Currency	on HOU_Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda	
	left join PO_temp PO on HOU.ID  = PO.ID  and Name_Reference = 'PurchaseOrderNumber'
	left join Tipo_Modal HOU_Modal	on HOU_Modal.Id  = HOU.cd_tp_modal
where
	HOU.SystemCode = '2'






GO
