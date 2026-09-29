SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from House_exp_mar where convert(datetime,dt_emis_hem, 103) > getdate() -10
--sp_help Booking_Request
--select * from House_exp_mar where num_proc_hem = 'EMCSR201901001BR'
		--Declare @Num_Proc	VarChar(16)
		--set @Num_proc = 'EMCSR201901001BR'
--[spATL_Booking_Request_Sel]'EMARC202108001BR','A'
CREATE PROCEDURE [dbo].[spATL_Booking_Request_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

if @tipo = 'A' or @Tipo = 'B'
	BEGIN
		Select 
			HOU.Num_Proc_HEM		[JOB],
		
			isnull(BR.Cd_Armador,LLP.cd_armador_Lem)		[Carrier Code],
			isnull(BR.Name_Armador,Carrier.Nome_Armador)	[Carrier Name],

			BR.Contract_Number								[Contract Number],

			--isnull(BR.Cd_Org,BR.Cd_Local)					[Carrier Office Code],--local do armador									
			--isnull(BR.Name_Org,Booking_Office.Nome_Local)  [Carrier Office Name],

			isnull(BR.Cd_Local,HOU.Cd_Org_HeM)				[Carrier Office Code],--local do armador									
			isnull(BR.Name_Org,Loading.Nome_Local)			[Carrier Office Name],

		
			isnull(BR.Cd_Shipper,HOU.Cd_Export_HEM)			[Shipper Code],
			isnull(BR.Name_Shipper,Ship.Apelido)			[Shipper Name],

			isnull(BR.Cd_Forwarder,Forwarder.Cd_Pes)		[Forwarder Code],
			isnull(BR.Name_Forwarder,Forwarder.Apelido)		[Forwarder Name],

			isnull(BR.Cd_Consignee,Hou.Cd_Consig_HEM)		[Consignee Code],
			isnull(BR.Name_Consignee,Consig.Apelido)		[Consignee Name],			

			isnull(BR.Shipper_Reference_Number,dbo.fBusca_Docs_PO_Modal_Semicolon_COALESCE(HOU.Num_Proc_HEM,2))	Shipper_Reference_Number,
			isnull(BR.Forwarder_Reference_Number,HOU.Num_Proc_HEM)	Forwarder_Reference_Number,
			isnull(BR.Purchase_Order_Number,isnull(dbo.fBusca_Docs_PO_Modal_Semicolon_COALESCE(HOU.Num_Proc_HEM,1),dbo.fBusca_Docs_PO_Modal_Semicolon_COALESCE(HOU.Num_Proc_HEM,9))) Purchase_Order_Number,
			BR.Consignee_Reference_Number,
			
			--isnull(BR.Cd_Tp_Move,'PP')							
			BR.Cd_Tp_Move									[Move Type Code],
			BR.Name_Tp_Move									[Move Type Name],
					
			--isnull(BR.Cd_Carrier_Receipt,LLP.Cd_Planta_Lem)		[Origin Code],
			--isnull(BR.Name_Carrier_Receipt,Origin.Nome_Local) 	[Origin Name],

			isnull(BR.Cd_Carrier_Receipt,HOU.Cd_Org_HeM)			[Origin Code],
			isnull(BR.Name_Carrier_Receipt,Loading.Nome_Local) 		[Origin Name],

			BR.Dt_Earliest_Departure,

			--isnull(BR.Cd_Carrier_Delivery,llp.Cd_DstFinal_Lem)		[Final Destination Code],
			--isnull(BR.Name_Carrier_Delivery,DstFinal.Nome_Local)	[Final Destination Name],

			isnull(BR.Cd_Carrier_Delivery,hou.Cd_Dst_HEM)			[Final Destination Code],
			isnull(BR.Name_Carrier_Delivery,Discharge.Nome_Local)	[Final Destination Name],

			BR.Dt_Latest_Delivery,

			isnull(BR.Cd_Org,HOU.Cd_Org_HeM)			[Loading Code],
			isnull(BR.Name_Org,Loading.Nome_Local)		[Loading Name],
					
			isnull(BR.ETD,LLP.ETD_Lem)					[ETD],
						
			isnull(BR.Cd_Dst,hou.Cd_Dst_HEM)			[Discharge Code],
			isnull(BR.Name_Dst,Discharge.Nome_Local) 	[Discharge Name],

			isnull(BR.ETA,LLP.ETA_Lem)					[ETA],
		
			isnull(BR.Navio,Viagem_LLP.ID_Navio)		[Vessel Code],
			--isnull(BR.Name_Navio,Navio_LLP.Nome_Navio)	[Vessel Name],
			isnull(BR.Name_Navio,HOU.Navio_HEM)			[Vessel Name],		 
						
			LLP.ID_Viagem			[Voyage Code],
			isnull(BR.Viagem,Viagem_LLP.NR_Viagem)		[Voyage Number],			
			isnull(BR.Name_Viagem,HOU.Viagem_HEM)		[Voyage],
		
			PLLP.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name],
			BR.cd_usuario			[User Code],
			US.Nome_usuario			[User Name],
			US.Email				[User Email],

			isnull(BR.Cd_Tp_Carga,LLP.Cd_Tp_Carga)						[Type Of Cargo Code],
			isnull(TC_BR.Nome_Tp_Carga,TC.Nome_Tp_Carga)				[Type Of Cargo Name],
			isnull(BR.Cd_Tp_Frete,HOU.Tp_Frete_HEM)						[Freight Term Code],
			isnull(FreteType_BR.Nome_Tp_Frete, FreteType.Nome_Tp_Frete)	[Freight Term Name],

			HOU.MAWB_HeM			[MAWB Number],
			
			BR.Notes				[Notes],
			BR.Nr_Reserva			[Reservation Number],
			isnull(BR.DL_Cargo_Lem,LLP.DL_Cargo_Lem)	[DL_Cargo_Lem],
			isnull(BR.DL_Draft_Lem,LLP.DL_Draft_Lem)	[DL_Draft_Lem],
			isnull(BR.DL_VGM_Lem,LLP.DL_VGM_Lem)		[DL_VGM_Lem],
			BR.INTTRA_Ref
		From House_exp_Mar HOU 
			Left Join Booking_Request BR				with(nolock)	on BR.Num_proc		= HOU.Num_proc_hem 
			Left Join Armador		Carrier_BR			with(nolock)	on BR.Cd_Armador	= Carrier_BR.cd_Armador
			Left Join Localidade	Booking_Office		with(nolock)	on BR.Cd_Local		= Booking_Office.Cd_Local
			Left Join Pessoa		Shipper_BR			with(nolock)	on BR.Cd_Shipper	= Shipper_BR.Cd_Pes
			Left Join Pessoa		Forwarder_BR		with(nolock)	on BR.Cd_Forwarder	= Forwarder_BR.Cd_Pes
			Left Join Pessoa		Consignee_BR		with(nolock)	on BR.Cd_Consignee	= Consignee_BR.Cd_Pes 
			--Left Join Tipo_Move		Tipo_Move_BR		with(nolock)	on isnull(BR.Cd_Tp_Move,'PP')= Tipo_Move_BR.Cd_tp_Move 
			Left Join Tipo_Move		Tipo_Move_BR		with(nolock)	on BR.Cd_Tp_Move= Tipo_Move_BR.Cd_tp_Move 
			Left Join Localidade	Carrier_Receipt		with(nolock)	on BR.Cd_Carrier_Receipt = Carrier_Receipt.cd_local
			Left Join Localidade	Carrier_Delivery	with(nolock)	on BR.Cd_Carrier_Delivery = Carrier_Delivery.cd_local
			Left Join Localidade	Loading_BR			with(nolock)	on BR.Cd_Org		= Loading_BR.Cd_Local 
			Left Join Localidade	Discharge_BR		with(nolock)	on BR.Cd_Dst		= Discharge_BR.Cd_Local
			Left Join Viagem_LLP	Viagem_BR			with(nolock)	on BR.ID_Viagem		= Viagem_BR.ID_Viagem
			Left Join Navio_LLP		Navio_BR			with(nolock)	on Viagem_BR.ID_Navio = Navio_BR.Id_Navio			
			Left Join Usuario		US					with(nolock)	on Us.cd_usuario = BR.cd_usuario
			Left Join Tipo_Carga	TC_BR				with(nolock)	on BR.cd_tp_carga = TC_BR.cd_tp_Carga 
			Left Join Tipo_Frete	FreteType_BR		with(nolock)	on BR.cd_tp_frete =	FreteType_BR.cd_tp_frete
	
			Left Join LLP_Exp_mar	LLP with(nolock)		on HOU.Num_proc_hem		= LLP.Num_proc_LEM
			Left Join Job_Exp_Mar	JOB with(nolock)		on HOU.Num_proc_hem		= JOB.Num_Proc_HEM	
			Left Join Pessoa		Consig	with(nolock)	on HOU.Cd_Consig_HEM	= Consig.Cd_Pes 
			Left Join Pessoa		Ship with(nolock)		on HOU.Cd_Export_HEM	= Ship.Cd_Pes
			Left Join Pessoa_llp	PLLP with(nolock)		on HOU.Cd_Export_HEM	= PLLP.Cd_Pes
			Left Join Pessoa		PG with(nolock)			on PG.Cd_Pes			= PLLP.Cd_Pes_grupo
			Left Join Localidade	Origin with(nolock)		on LLP.cd_Planta_Lem	= Origin.cd_local
			Left Join Localidade	DstFinal with(nolock)	on LLP.cd_dstfinal_lem	= Dstfinal.cd_local
			Left Join Armador		Carrier with(nolock)	on LLP.cd_armador_lem	= Carrier.cd_Armador			
			
			Left Join Localidade	Loading with(nolock)	on HOU.Cd_Org_HEM		= Loading.Cd_Local 
			Left Join Localidade	Discharge with(nolock)	on HOU.Cd_Dst_HEM		= Discharge.Cd_Local							
			Left Join Viagem_LLP	Viagem_LLP with(nolock)	on LLP.ID_Viagem		= Viagem_LLP.ID_Viagem
			Left Join Navio_LLP		Navio_LLP with(nolock)	on Viagem_LLP.ID_Navio	= Navio_LLP.Id_Navio
			
			Left Join Tipo_Carga	TC			with(nolock) on LLP.cd_tp_carga = TC.cd_tp_Carga 
			Left Join Tipo_Frete	FreteType	with(nolock) on FreteType.cd_tp_frete	=HOU.Tp_Frete_HEM

			left join Master_Exp_Mar MAS with(nolock)		on HOU.num_proc_mem		= MAS.num_proc_mem
			Left Join Pessoa		Forwarder with(nolock)	on isnull(MAS.Cd_Export_MEM,'P000015744')= Forwarder.Cd_Pes
			
		Where
			HOU.Num_proc_hem = @Num_Proc

	END


GO
