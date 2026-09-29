SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwBooking_Request_Sel]
AS
	Select 
			BR.Num_Proc			[JOB],
		
			BR.Cd_Armador		[Carrier Code],
			BR.Name_Armador		[Carrier Name],

			BR.Contract_Number	[Contract Number],

			BR.Cd_Org			[Carrier Office Code],--local do armador									
			BR.Name_Org			[Carrier Office Name],
		
			BR.Cd_Shipper		[Shipper Code],
			BR.Name_Shipper		[Shipper Name],

			BR.Cd_Forwarder		[Forwarder Code],
			BR.Name_Forwarder	[Forwarder Name],

			BR.Cd_Consignee		[Consignee Code],
			BR.Name_Consignee	[Consignee Name],			

			BR.Shipper_Reference_Number,
			BR.Forwarder_Reference_Number,
			BR.Purchase_Order_Number,
			BR.Consignee_Reference_Number,
			
			BR.Cd_Tp_Move		[Move Type Code],
			BR.Name_Tp_Move		[Move Type Name],
					
			BR.Cd_Carrier_Receipt	[Origin Code],
			BR.Name_Carrier_Receipt [Origin Name],

			BR.Dt_Earliest_Departure,

			BR.Cd_Carrier_Delivery	[Final Destination Code],
			BR.Name_Carrier_Delivery[Final Destination Name],

			BR.Dt_Latest_Delivery,

			BR.Cd_Org	[Loading Code],
			BR.Name_Org	[Loading Name],
					
			BR.ETD		[ETD],
						
			BR.Cd_Dst	[Discharge Code],
			BR.Name_Dst [Discharge Name],

			BR.ETA		[ETA],

			BR.Navio	[Vessel Name],
			BR.Name_Navio	[Vessel],		 
						
			--LLP.ID_Viagem			[Voyage Code],
			BR.Viagem	[Voyage Number],			
			BR.Name_Viagem	[Voyage]
			,BR.Notes				[Notes]
		From Booking_Request BR
			
			Left Join Armador		Carrier_BR			with(nolock)	on BR.Cd_Armador	= Carrier_BR.cd_Armador
			Left Join Localidade	Booking_Office		with(nolock)	on BR.Cd_Local		= Booking_Office.Cd_Local
			Left Join Pessoa		Shipper_BR			with(nolock)	on BR.Cd_Shipper	= Shipper_BR.Cd_Pes
			Left Join Pessoa		Forwarder_BR		with(nolock)	on BR.Cd_Forwarder	= Forwarder_BR.Cd_Pes
			Left Join Pessoa		Consignee_BR		with(nolock)	on BR.Cd_Consignee	= Consignee_BR.Cd_Pes 
			Left Join Tipo_Move		Tipo_Move_BR		with(nolock)	on BR.Cd_Tp_Move	= Tipo_Move_BR.Cd_tp_Move 
			Left Join Localidade	Carrier_Receipt		with(nolock)	on BR.Cd_Carrier_Receipt = Carrier_Receipt.cd_local
			Left Join Localidade	Carrier_Delivery	with(nolock)	on BR.Cd_Carrier_Delivery = Carrier_Delivery.cd_local
			Left Join Localidade	Loading_BR			with(nolock)	on BR.Cd_Org		= Loading_BR.Cd_Local 
			Left Join Localidade	Discharge_BR		with(nolock)	on BR.Cd_Dst		= Discharge_BR.Cd_Local
			Left Join Viagem_LLP	Viagem_BR			with(nolock)	on BR.ID_Viagem		= Viagem_BR.ID_Viagem
			Left Join Navio_LLP		Navio_BR			with(nolock)	on Viagem_BR.ID_Navio = Navio_BR.Id_Navio			
			Left Join Usuario		US					with(nolock)	on Us.cd_usuario = BR.cd_usuario

GO
