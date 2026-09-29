SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLDLL_House_Temp_Sel]--'55959','D'
(	
	@ID						bigint,
	@SystemCode				varchar(200),
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Tipo					char(1)
)
as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			H.ID								[ID],
			H.ID_Req							[ID Req],
			H.Intl_Reference					[Intl Reference],
			H.DT_EMIS							[Register Date],
			H.Id_TP_House_Temp					[ID Type Aut. Def.]	,
			H.HAWB								[AWB/BL Number],
			H.MAWB								[MAWB/BL Number],
			HOU.Num_Proc						[JOB],				
			
			H.Cd_Export							[Shipper Code],
			HOU_Shipper.Apelido					[Shipper],		
			H.Name_Export						[Shipper XML],
			
			H.Cd_Consig							[Consignee Code],
			HOU_Consignee.Apelido				[Consignee],
			H.Name_Consig						[Consignee XML],

			H.Cd_Import							[Notify Code],
			HOU_Import.Apelido					[Notify],
			H.Name_Import						[Notify_XML],
			
			H.Cd_planta							[Origin Code],
			HOU_Planta.Nome_Local				[Origin],		
			H.Name_planta						[Origin XML],
					
			H.Cd_Org							[Loading Code],
			HOU_Loading.Nome_Local				[Loading],	
			H.Name_Org							[Loading XML],
			
			H.Cd_Dst							[Discharge Code],
			HOU_Discharge.Nome_Local			[Discharge],
			H.Name_Dst							[Discharge XML],	
			
			H.Cd_DstFinal						[FinalDestination Code],
			HOU_FinalDestination.Nome_Local		[FinalDestination],
			H.Name_DstFinal						[FinalDestination XML],
					
			H.Cd_Armador			 		[Carrier Code],
			
			(CASE WHEN H.cd_tp_modal = 'T' or H.cd_tp_modal = 'R' THEN 
				HOU_Carrier_Others.Apelido 
			ELSE
				isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)
			END)							[Carrier],
			--isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)	[Carrier],
			H.Name_Armador						[Carrier XML],

			(case when HOU_Vessel.Nome_Navio is null then NULL else H.Navio end) [Vessel Code],
			--H.Navio							[Vessel Code],
			HOU_Vessel.Nome_Navio			[Vessel],
			H.Name_Navio					[Vessel XML],
			
			H.Viagem						[Voyage Code],
			HOU_Voyage.NR_Viagem			[Voyage],
			H.Name_Viagem					[Voyage XML],
			H.Id_Viagem						Id_Viagem,
			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETD,103),103)	[ETD],		
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)	[ETA],
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATD,103),103)	[ATD],			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATA,103),103)	[ATA],
		
			--H.Cd_Tp_Carga					[Type Of Cargo Code],
			(case when HOU_TypeOfCargo.Nome_Tp_Carga is null then NULL else H.Cd_Tp_Carga end) [Type Of Cargo Code],
			HOU_TypeOfCargo.Nome_Tp_Carga	[Type Of Cargo],
			H.Name_Tp_Carga					[Type Of Cargo XML],
			
			
			--Convert(Decimal(8,2),H.Vol_Tot)						[Volume(m3)],
			--Convert(Decimal(8,2), H.Qtd_Tot_Vol)					[Nº of Pieces],
			--Convert(Decimal(8,2),H.Peso_Liquido)					[Net Weight (KG)],
			--Convert(Decimal(8,2),H.Peso_Bruto)					[Gross Weight (KG)],
			
			Replace(H.Vol_Tot,'.',',')						[Volume(m3)],
			Replace(H.Qtd_Tot_Vol,'.',',')					[Nº of Pieces],
			Replace(H.Peso_Liquido,'.',',')					[Net Weight (KG)],
			Replace(H.Peso_Bruto,'.',',')					[Gross Weight (KG)],
			
			H.Tp_Frete						[Freight Term],
			
			H.Cd_Tp_Moeda					[Currency Code],
			HOU_Currency.Nome_Tp_Moeda		[Currency],
			H.Name_Tp_Moeda					[Currency XML],
			
			Replace(H.Vlr_Frete_Efet,'.',',') [Freight Value],
			
			H.Obs							[Nature and Quality of Goods],
				(CASE WHEN H.Original_ETA IS null  THEN 
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)
			ELSE
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.Original_ETA,103),103)
			END)										[Original ETA],
			--isnull(CONVERT(VARCHAR(10),CONVERT(DATETIME,H.Original_ETA,103)),
			--	CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103)))	[Original ETA],
			--H.Original_ETA					[Original ETA],
			
			H.cd_tp_modal					[Modal Code],
			HOU_Modal.Modal					[Modal],
			H.Modal							[Modal XML],
			
			H.DestinationCountryCode		[Destination Country Code],
			H.Cd_Tp_Oper					[Incoterm Code],
			HOU_Incoterm.Nome_Tp_Oper		[Incoterm],
			H.Name_Incoterm					[Incoterm XML],
			
			Replace(H.Peso_Cubado,'.',',')	[Charg. Weight (KG)],
			
			H.Booking_Number				[Booking Number]
			
			
			--SystemCode
			--DT_INS_House_Temp		
		from House_Temp H with(nolock)
			LEFT jOIN House_Temp HOU with(nolock) ON HOU.ID_REQ = H.ID_REQ
			left join Pessoa HOU_Shipper with(nolock) on HOU_Shipper.Cd_Pes = HOU.Cd_Export	
			left join Pessoa HOU_Consignee with(nolock) on HOU_Consignee.Cd_Pes = HOU.Cd_Consig
			left join Pessoa HOU_Import with(nolock) on HOU_Import.Cd_Pes = HOU.Cd_Import
			left join Localidade HOU_Planta with(nolock) on HOU_Planta.Cd_Local = HOU.Cd_planta
			left join Localidade HOU_Loading with(nolock) on HOU_Loading.Cd_Local = HOU.Cd_Org
			left join Localidade HOU_Discharge with(nolock) on HOU_Discharge.Cd_Local = HOU.Cd_Dst
			left join Localidade HOU_FinalDestination with(nolock) on HOU_FinalDestination.Cd_Local = HOU.Cd_DstFinal
			left join Armador HOU_Carrier with(nolock) on HOU_Carrier.Cd_Armador = HOU.Cd_Armador
			left join Cia_Aerea HOU_CarrierAir with(nolock) on HOU_CarrierAir.Cd_Cia_Aer = HOU.Cd_Armador
			left join Pessoa HOU_Carrier_Others with(nolock) on HOU_Carrier_Others.Cd_Pes = HOU.Cd_Armador
			--left join Navio_LLP HOU_Vessel	with(nolock) on HOU_Vessel.Id_Navio  = H.Navio
			left join Navio_LLP HOU_Vessel	on convert(varchar(10),HOU_Vessel.Id_Navio)  = H.Navio
			left join Viagem_LLP HOU_Voyage with(nolock) on HOU_Voyage.NR_Viagem  = HOU.Viagem and HOU_Vessel.Id_Navio = HOU_Voyage.ID_Navio
				
			left join Tipo_Carga HOU_TypeOfCargo with(nolock) on convert(varchar(10),HOU_TypeOfCargo.Cd_Tp_Carga) = HOU.Cd_Tp_Carga	
			
			left join Tipo_Moeda HOU_Currency with(nolock) on HOU_Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda	
			left join Tipo_Modal HOU_Modal with(nolock) on HOU_Modal.Id  = HOU.cd_tp_modal
			left join Tipo_Oper HOU_Incoterm with(nolock) on HOU_Incoterm.Cd_Tp_Oper  = HOU.Cd_Tp_Oper
		--where
		--	h.SystemCode = @SystemCode
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			H.ID								[ID],
			H.ID_Req							[ID Req],
			H.Intl_Reference					[Intl Reference],
			H.DT_EMIS							[Register Date],
			H.Id_TP_House_Temp					[ID Type Aut. Def.]	,
			H.HAWB								[AWB/BL Number],
			H.MAWB								[MAWB/BL Number],
			HOU.Num_Proc						[JOB],				
			
			H.Cd_Export							[Shipper Code],
			HOU_Shipper.Apelido					[Shipper],		
			H.Name_Export						[Shipper XML],
			
			H.Cd_Consig							[Consignee Code],
			HOU_Consignee.Apelido				[Consignee],
			H.Name_Consig						[Consignee XML],

			H.Cd_Import							[Notify Code],
			HOU_Import.Apelido					[Notify],
			H.Name_Import						[Notify_XML],
			
			H.Cd_planta							[Origin Code],
			HOU_Planta.Nome_Local				[Origin],		
			H.Name_planta						[Origin XML],
					
			H.Cd_Org							[Loading Code],
			HOU_Loading.Nome_Local				[Loading],	
			H.Name_Org							[Loading XML],
			
			H.Cd_Dst							[Discharge Code],
			HOU_Discharge.Nome_Local			[Discharge],
			H.Name_Dst							[Discharge XML],	
			
			H.Cd_DstFinal						[FinalDestination Code],
			HOU_FinalDestination.Nome_Local		[FinalDestination],
			H.Name_DstFinal						[FinalDestination XML],
					
			H.Cd_Armador			 			[Carrier Code],
			(CASE WHEN H.cd_tp_modal = 'T' or H.cd_tp_modal = 'R' THEN 
				HOU_Carrier_Others.Apelido 
			ELSE
				isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)
			END)							[Carrier],
			--isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)	[Carrier],
			H.Name_Armador						[Carrier XML],

			(case when HOU_Vessel.Nome_Navio is null then NULL else H.Navio end) [Vessel Code],
			--H.Navio							[Vessel Code],
			HOU_Vessel.Nome_Navio			[Vessel],
			H.Name_Navio					[Vessel XML],
			
			H.Viagem						[Voyage Code],
			HOU_Voyage.NR_Viagem			[Voyage],
			H.Name_Viagem					[Voyage XML],
			H.Id_Viagem						Id_Viagem,
			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETD,103),103)	[ETD],		
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)	[ETA],
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATD,103),103)	[ATD],			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATA,103),103)	[ATA],
		
			--H.Cd_Tp_Carga					[Type Of Cargo Code],
					(case when HOU_TypeOfCargo.Nome_Tp_Carga is null then NULL else H.Cd_Tp_Carga end) [Type Of Cargo Code],
			HOU_TypeOfCargo.Nome_Tp_Carga	[Type Of Cargo],
			H.Name_Tp_Carga					[Type Of Cargo XML],
			
			Replace(H.Vol_Tot,'.',',')						[Volume(m3)],
			Replace(H.Qtd_Tot_Vol,'.',',')					[Nº of Pieces],
			Replace(H.Peso_Liquido,'.',',')					[Net Weight (KG)],
			Replace(H.Peso_Bruto,'.',',')					[Gross Weight (KG)],
			
			H.Tp_Frete						[Freight Term],
			
			H.Cd_Tp_Moeda					[Currency Code],
			HOU_Currency.Nome_Tp_Moeda		[Currency],
			H.Name_Tp_Moeda					[Currency XML],
			
			Replace(H.Vlr_Frete_Efet,'.',',') [Freight Value],
			
			H.Obs							[Nature and Quality of Goods],
			(CASE WHEN H.Original_ETA IS null  THEN 
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)
			ELSE
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.Original_ETA,103),103)
			END)										[Original ETA],
			--isnull(H.Original_ETA,CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103)))	[Original ETA],
			--H.Original_ETA					[Original ETA],
			
			H.cd_tp_modal					[Modal Code],
			HOU_Modal.Modal					[Modal],
			H.Modal							[Modal XML],
			
			H.DestinationCountryCode		[Destination Country Code],
			H.Cd_Tp_Oper					[Incoterm Code],
			HOU_Incoterm.Nome_Tp_Oper		[Incoterm],
			H.Name_Incoterm					[Incoterm XML],
			
			Replace(H.Peso_Cubado,'.',',')					[Charg. Weight (KG)],
			H.Booking_Number				[Booking Number]
			
			--Id_TP_House_Temp		
			--SystemCode
			--DT_INS_House_Temp		
		from House_Temp H with(nolock) 
			LEFT jOIN House_Temp HOU with(nolock) ON HOU.ID_REQ = H.ID_REQ
			left join Pessoa HOU_Shipper with(nolock) on HOU_Shipper.Cd_Pes = HOU.Cd_Export	
			left join Pessoa HOU_Consignee with(nolock) on HOU_Consignee.Cd_Pes = HOU.Cd_Consig
			left join Pessoa HOU_Import with(nolock) on HOU_Import.Cd_Pes = HOU.Cd_Import
			left join Localidade HOU_Planta with(nolock) on HOU_Planta.Cd_Local = HOU.Cd_planta
			left join Localidade HOU_Loading with(nolock) on HOU_Loading.Cd_Local = HOU.Cd_Org
			left join Localidade HOU_Discharge with(nolock) on HOU_Discharge.Cd_Local = HOU.Cd_Dst
			left join Localidade HOU_FinalDestination with(nolock) on HOU_FinalDestination.Cd_Local = HOU.Cd_DstFinal
			left join Armador HOU_Carrier with(nolock) on HOU_Carrier.Cd_Armador = HOU.Cd_Armador
			left join Cia_Aerea HOU_CarrierAir with(nolock) on HOU_CarrierAir.Cd_Cia_Aer = HOU.Cd_Armador
			left join Pessoa HOU_Carrier_Others with(nolock) on HOU_Carrier_Others.Cd_Pes = HOU.Cd_Armador
			--left join Navio_LLP HOU_Vessel	with(nolock) on HOU_Vessel.Id_Navio  = H.Navio
			left join Navio_LLP HOU_Vessel	on convert(varchar(10),HOU_Vessel.Id_Navio)  = H.Navio
			left join Viagem_LLP HOU_Voyage	with(nolock) on HOU_Voyage.NR_Viagem  = HOU.Viagem and HOU_Vessel.Id_Navio = HOU_Voyage.ID_Navio
				
			--left join Tipo_Carga HOU_TypeOfCargo with(nolock)on HOU_TypeOfCargo.Cd_Tp_Carga  = HOU.Cd_Tp_Carga	
			left join Tipo_Carga HOU_TypeOfCargo with(nolock) on convert(varchar(10),HOU_TypeOfCargo.Cd_Tp_Carga) = HOU.Cd_Tp_Carga	
			left join Tipo_Moeda HOU_Currency	with(nolock) on HOU_Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda	
			left join Tipo_Modal HOU_Modal	with(nolock) on HOU_Modal.Id  = HOU.cd_tp_modal
			left join Tipo_Oper HOU_Incoterm	with(nolock) on HOU_Incoterm.Cd_Tp_Oper  = HOU.Cd_Tp_Oper
		where
			--H.SystemCode = @SystemCode and
			H.ID= @ID
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			H.ID								[ID],
			H.ID_Req							[ID Req],
			H.Intl_Reference					[Intl Reference],
			H.DT_EMIS							[Register Date],
			H.Id_TP_House_Temp					[ID Type Aut. Def.]	,
			H.HAWB								[AWB/BL Number],
			H.MAWB								[MAWB/BL Number],
			HOU.Num_Proc						[JOB],				
			
			H.Cd_Export							[Shipper Code],
			HOU_Shipper.Apelido					[Shipper],		
			H.Name_Export						[Shipper XML],
			
			H.Cd_Consig							[Consignee Code],
			HOU_Consignee.Apelido				[Consignee],
			H.Name_Consig						[Consignee XML],

			H.Cd_Import							[Notify Code],
			HOU_Import.Apelido					[Notify],
			H.Name_Import						[Notify_XML],
			
			H.Cd_planta							[Origin Code],
			HOU_Planta.Nome_Local				[Origin],		
			H.Name_planta						[Origin XML],
					
			H.Cd_Org							[Loading Code],
			HOU_Loading.Nome_Local				[Loading],	
			H.Name_Org							[Loading XML],
			
			H.Cd_Dst							[Discharge Code],
			HOU_Discharge.Nome_Local			[Discharge],
			H.Name_Dst							[Discharge XML],	
			
			H.Cd_DstFinal						[FinalDestination Code],
			HOU_FinalDestination.Nome_Local		[FinalDestination],
			H.Name_DstFinal						[FinalDestination XML],
					
			H.Cd_Armador			 			[Carrier Code],
			(CASE WHEN H.cd_tp_modal = 'T' or H.cd_tp_modal = 'R' THEN 
				HOU_Carrier_Others.Apelido 
			ELSE
				isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)
			END)							[Carrier],
			--isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)	[Carrier],
			H.Name_Armador						[Carrier XML],

			(case when HOU_Vessel.Nome_Navio is null then NULL else H.Navio end) [Vessel Code],
			--H.Navio							[Vessel Code],
			HOU_Vessel.Nome_Navio			[Vessel],
			H.Name_Navio					[Vessel XML],
			
			H.Viagem						[Voyage Code],
			HOU_Voyage.NR_Viagem			[Voyage],
			H.Name_Viagem					[Voyage XML],
			H.Id_Viagem						Id_Viagem,
			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETD,103),103)	[ETD],		
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)	[ETA],
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATD,103),103)	[ATD],			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATA,103),103)	[ATA],
		
			--H.Cd_Tp_Carga					[Type Of Cargo Code],
					(case when HOU_TypeOfCargo.Nome_Tp_Carga is null then NULL else H.Cd_Tp_Carga end) [Type Of Cargo Code],
			HOU_TypeOfCargo.Nome_Tp_Carga	[Type Of Cargo],
			H.Name_Tp_Carga					[Type Of Cargo XML],
			
			Replace(H.Vol_Tot,'.',',')						[Volume(m3)],
			Replace(H.Qtd_Tot_Vol,'.',',')					[Nº of Pieces],
			Replace(H.Peso_Liquido,'.',',')					[Net Weight (KG)],
			Replace(H.Peso_Bruto,'.',',')					[Gross Weight (KG)],
			
			H.Tp_Frete						[Freight Term],
			
			H.Cd_Tp_Moeda					[Currency Code],
			HOU_Currency.Nome_Tp_Moeda		[Currency],
			H.Name_Tp_Moeda					[Currency XML],
			
			Replace(H.Vlr_Frete_Efet,'.',',') [Freight Value],
			
			H.Obs							[Nature and Quality of Goods],
			(CASE WHEN H.Original_ETA IS null  THEN 
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)
			ELSE
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.Original_ETA,103),103)
			END)										[Original ETA],
			--isnull(H.Original_ETA,CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103)))	[Original ETA],
			--H.Original_ETA					[Original ETA],
			
			H.cd_tp_modal					[Modal Code],
			HOU_Modal.Modal					[Modal],
			H.Modal							[Modal XML],
			
			H.DestinationCountryCode		[Destination Country Code],
			H.Cd_Tp_Oper					[Incoterm Code],
			HOU_Incoterm.Nome_Tp_Oper		[Incoterm],
			H.Name_Incoterm					[Incoterm XML],
			
			Replace(H.Peso_Cubado,'.',',')					[Charg. Weight (KG)],
			H.Booking_Number				[Booking Number]
			
			--Id_TP_House_Temp		
			--SystemCode
			--DT_INS_House_Temp		
		from House_Temp H with(nolock) 
			LEFT jOIN House_Temp HOU with(nolock) ON HOU.ID_REQ = H.ID_REQ
			left join Pessoa HOU_Shipper with(nolock) on HOU_Shipper.Cd_Pes = HOU.Cd_Export	
			left join Pessoa HOU_Consignee with(nolock) on HOU_Consignee.Cd_Pes = HOU.Cd_Consig
			left join Pessoa HOU_Import with(nolock) on HOU_Import.Cd_Pes = HOU.Cd_Import
			left join Localidade HOU_Planta with(nolock) on HOU_Planta.Cd_Local = HOU.Cd_planta
			left join Localidade HOU_Loading with(nolock) on HOU_Loading.Cd_Local = HOU.Cd_Org
			left join Localidade HOU_Discharge with(nolock) on HOU_Discharge.Cd_Local = HOU.Cd_Dst
			left join Localidade HOU_FinalDestination with(nolock) on HOU_FinalDestination.Cd_Local = HOU.Cd_DstFinal
			left join Armador HOU_Carrier with(nolock) on HOU_Carrier.Cd_Armador = HOU.Cd_Armador
			left join Cia_Aerea HOU_CarrierAir with(nolock) on HOU_CarrierAir.Cd_Cia_Aer = HOU.Cd_Armador
			left join Pessoa HOU_Carrier_Others with(nolock) on HOU_Carrier_Others.Cd_Pes = HOU.Cd_Armador
			--left join Navio_LLP HOU_Vessel	with(nolock) on HOU_Vessel.Id_Navio  = H.Navio
			left join Navio_LLP HOU_Vessel	on convert(varchar(10),HOU_Vessel.Id_Navio)  = H.Navio
			left join Viagem_LLP HOU_Voyage	with(nolock) on HOU_Voyage.NR_Viagem  = HOU.Viagem and HOU_Vessel.Id_Navio = HOU_Voyage.ID_Navio
				
			--left join Tipo_Carga HOU_TypeOfCargo with(nolock)on HOU_TypeOfCargo.Cd_Tp_Carga  = HOU.Cd_Tp_Carga	
			left join Tipo_Carga HOU_TypeOfCargo with(nolock) on convert(varchar(10),HOU_TypeOfCargo.Cd_Tp_Carga) = HOU.Cd_Tp_Carga	
			left join Tipo_Moeda HOU_Currency	with(nolock) on HOU_Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda	
			left join Tipo_Modal HOU_Modal	with(nolock) on HOU_Modal.Id  = HOU.cd_tp_modal
			left join Tipo_Oper HOU_Incoterm	with(nolock) on HOU_Incoterm.Cd_Tp_Oper  = HOU.Cd_Tp_Oper
		where
			H.DT_INS_House_Temp is null
			and H.SystemCode = @SystemCode
			AND H.ID_Req = @ID_Req
	End

if @Tipo = 'P' 
	Begin
		select 
			H.ID								[ID],
			H.ID_Req							[ID Req],
			H.Intl_Reference					[Intl Reference],
			H.DT_EMIS							[Register Date],
			H.Id_TP_House_Temp					[ID Type Aut. Def.]	,
			H.HAWB								[AWB/BL Number],
			H.MAWB								[MAWB/BL Number],
			HOU.Num_Proc						[JOB],				
			
			H.Cd_Export							[Shipper Code],
			HOU_Shipper.Apelido					[Shipper],		
			H.Name_Export						[Shipper XML],
			
			H.Cd_Consig							[Consignee Code],
			HOU_Consignee.Apelido				[Consignee],
			H.Name_Consig						[Consignee XML],

			H.Cd_Import							[Notify Code],
			HOU_Import.Apelido					[Notify],
			H.Name_Import						[Notify_XML],
			
			H.Cd_planta							[Origin Code],
			HOU_Planta.Nome_Local				[Origin],		
			H.Name_planta						[Origin XML],
					
			H.Cd_Org							[Loading Code],
			HOU_Loading.Nome_Local				[Loading],	
			H.Name_Org							[Loading XML],
			
			H.Cd_Dst							[Discharge Code],
			HOU_Discharge.Nome_Local			[Discharge],
			H.Name_Dst							[Discharge XML],	
			
			H.Cd_DstFinal						[FinalDestination Code],
			HOU_FinalDestination.Nome_Local		[FinalDestination],
			H.Name_DstFinal						[FinalDestination XML],
					
			H.Cd_Armador			 			[Carrier Code],
			(CASE WHEN H.cd_tp_modal = 'T' or H.cd_tp_modal = 'R' THEN 
				HOU_Carrier_Others.Apelido 
			ELSE
				isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)
			END)							[Carrier],
			--isnull(HOU_Carrier.Nome_Armador,HOU_CarrierAir.Nome_Cia_Aer)	[Carrier],
			H.Name_Armador						[Carrier XML],

			(case when HOU_Vessel.Nome_Navio is null then NULL else H.Navio end) [Vessel Code],
			--H.Navio							[Vessel Code],
			HOU_Vessel.Nome_Navio			[Vessel],
			H.Name_Navio					[Vessel XML],
			
			H.Viagem						[Voyage Code],
			HOU_Voyage.NR_Viagem			[Voyage],
			H.Name_Viagem					[Voyage XML],
			H.Id_Viagem						Id_Viagem,
			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETD,103),103)	[ETD],		
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)	[ETA],
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATD,103),103)	[ATD],			
			CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ATA,103),103)	[ATA],
		
			--H.Cd_Tp_Carga					[Type Of Cargo Code],
					(case when HOU_TypeOfCargo.Nome_Tp_Carga is null then NULL else H.Cd_Tp_Carga end) [Type Of Cargo Code],
			HOU_TypeOfCargo.Nome_Tp_Carga	[Type Of Cargo],
			H.Name_Tp_Carga					[Type Of Cargo XML],
			
			Replace(H.Vol_Tot,'.',',')						[Volume(m3)],
			Replace(H.Qtd_Tot_Vol,'.',',')					[Nº of Pieces],
			Replace(H.Peso_Liquido,'.',',')					[Net Weight (KG)],
			Replace(H.Peso_Bruto,'.',',')					[Gross Weight (KG)],
			
			H.Tp_Frete						[Freight Term],
			
			H.Cd_Tp_Moeda					[Currency Code],
			HOU_Currency.Nome_Tp_Moeda		[Currency],
			H.Name_Tp_Moeda					[Currency XML],
			
			Replace(H.Vlr_Frete_Efet,'.',',') [Freight Value],
			
			H.Obs							[Nature and Quality of Goods],
			(CASE WHEN H.Original_ETA IS null  THEN 
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103),103)
			ELSE
				CONVERT(VARCHAR(10),CONVERT(DATETIME,H.Original_ETA,103),103)
			END)										[Original ETA],
			--isnull(H.Original_ETA,CONVERT(VARCHAR(10),CONVERT(DATETIME,H.ETA,103)))	[Original ETA],
			--H.Original_ETA					[Original ETA],
			
			H.cd_tp_modal					[Modal Code],
			HOU_Modal.Modal					[Modal],
			H.Modal							[Modal XML],
			
			H.DestinationCountryCode		[Destination Country Code],
			H.Cd_Tp_Oper					[Incoterm Code],
			HOU_Incoterm.Nome_Tp_Oper		[Incoterm],
			H.Name_Incoterm					[Incoterm XML],
			
			Replace(H.Peso_Cubado,'.',',')					[Charg. Weight (KG)],
			H.Booking_Number				[Booking Number]
			
			--Id_TP_House_Temp		
			--SystemCode
			--DT_INS_House_Temp		
		from House_Temp H with(nolock) 
			LEFT jOIN House_Temp HOU with(nolock) ON HOU.ID_REQ = H.ID_REQ
			left join Pessoa HOU_Shipper with(nolock) on HOU_Shipper.Cd_Pes = HOU.Cd_Export	
			left join Pessoa HOU_Consignee with(nolock) on HOU_Consignee.Cd_Pes = HOU.Cd_Consig
			left join Pessoa HOU_Import with(nolock) on HOU_Import.Cd_Pes = HOU.Cd_Import
			left join Localidade HOU_Planta with(nolock) on HOU_Planta.Cd_Local = HOU.Cd_planta
			left join Localidade HOU_Loading with(nolock) on HOU_Loading.Cd_Local = HOU.Cd_Org
			left join Localidade HOU_Discharge with(nolock) on HOU_Discharge.Cd_Local = HOU.Cd_Dst
			left join Localidade HOU_FinalDestination with(nolock) on HOU_FinalDestination.Cd_Local = HOU.Cd_DstFinal
			left join Armador HOU_Carrier with(nolock) on HOU_Carrier.Cd_Armador = HOU.Cd_Armador
			left join Cia_Aerea HOU_CarrierAir with(nolock) on HOU_CarrierAir.Cd_Cia_Aer = HOU.Cd_Armador
			left join Pessoa HOU_Carrier_Others with(nolock) on HOU_Carrier_Others.Cd_Pes = HOU.Cd_Armador
			--left join Navio_LLP HOU_Vessel	with(nolock) on HOU_Vessel.Id_Navio  = H.Navio
			left join Navio_LLP HOU_Vessel	on convert(varchar(10),HOU_Vessel.Id_Navio)  = H.Navio
			left join Viagem_LLP HOU_Voyage	with(nolock) on HOU_Voyage.NR_Viagem  = HOU.Viagem and HOU_Vessel.Id_Navio = HOU_Voyage.ID_Navio
				
			--left join Tipo_Carga HOU_TypeOfCargo with(nolock)on HOU_TypeOfCargo.Cd_Tp_Carga  = HOU.Cd_Tp_Carga	
			left join Tipo_Carga HOU_TypeOfCargo with(nolock) on convert(varchar(10),HOU_TypeOfCargo.Cd_Tp_Carga) = HOU.Cd_Tp_Carga	
			left join Tipo_Moeda HOU_Currency	with(nolock) on HOU_Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda	
			left join Tipo_Modal HOU_Modal	with(nolock) on HOU_Modal.Id  = HOU.cd_tp_modal
			left join Tipo_Oper HOU_Incoterm	with(nolock) on HOU_Incoterm.Cd_Tp_Oper  = HOU.Cd_Tp_Oper
		where			
			H.SystemCode = @SystemCode		
			and H.Num_Proc= @Intl_Reference			
	End
	
	

	

	
GO
