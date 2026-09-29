SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spPedido_Temp_New_Sel '32','D' 
--select Cd_USERID,Cd_CSRID,PO_Responsible from Pedido_Temp_New
--select * from Usuario_Cliente where Cd_Usuario = 'U646406'
CREATE procedure [dbo].[spPedido_Temp_New_Sel]--'9','','R'
(
	@ID				bigint,
	@Num_Pedido		varchar(200),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			replace(HOU.vlr_pedido,'.',',')		[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)							[Incoterm Code],
			ISNULL(Incoterm.Nome_Tp_Oper,House_Temp_Incoterm.Nome_Tp_Oper)		[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],			
		
			ISNULL(Hou.Cd_Tp_Moeda,House_Temp.Cd_Tp_Moeda)						[Currency Code],
			ISNULL(Currency.Nome_Tp_Moeda,House_Temp_Currency.Nome_Tp_Moeda)	[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			ISNULL(Hou.Status,'O')				[Status Code],
			ISNULL(Status.Nome_Tp_Status_Pedido,'Opened') [Status Name],
			Hou.Name_Status						[Status XML],
			
			ISNULL(Hou.Cd_Seller,House_Temp.Cd_Export)					[Seller Code],
			ISNULL(Seller.Apelido,House_Temp_Seller.Apelido)			[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			ISNULL(Hou.Cd_Shipper,House_Temp.Cd_Export)					[Shipper Code],
			ISNULL(Shipper.Apelido,House_Temp_Shipper.Apelido) 			[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)					[Shipper XML],	
			
			ISNULL(Hou.Cd_Buyer,House_Temp.Cd_Consig)					[Buyer Code],
			ISNULL(Buyer.Apelido,House_Temp_Buyer.Apelido) 				[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			ISNULL(Hou.Cd_Consignee,House_Temp.Cd_Consig) 				[Consignee Code],
			ISNULL(Consignee.Apelido,House_Temp_Consignee.Apelido) 	 	[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			isnull(Grupo.Apelido,PLLPGrupo.Apelido)						[Group Name],
			HOU.Name_Grupo												[Group XML],
			
			isnull(HOU.Cd_Pais_Org,House_Temp.OriginCountryCode)						[Origin Code],
			ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,House_Temp.DestinationCountryCode)			[Destination Code],
			ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			ISNULL(HOU.Cd_Modal,HOUSE_TEMP.CD_TP_MODAL)		[Modal Code],
			ISNULL(Modal.Modal,House_Temp_Modal.Modal)		[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU with(nolock)
			left join Tipo_Pedido			Type_Order	with(nolock) on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock) on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock) on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock) on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock) on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock) on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock) on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		with(nolock) on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock) on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		with(nolock) on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		with(nolock) on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			with(nolock) on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	with(nolock) on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			with(nolock) on Modal.Id  = HOU.Cd_Modal
			
			
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = HOU.ID_House_Temp
			left join Tipo_Oper				House_Temp_Incoterm	with(nolock) on House_Temp_Incoterm.Cd_Tp_Oper = House_Temp.Cd_Tp_Oper
			LEFT JOIN Pessoa_LLP			PLLP with(nolock) On PLLP.Cd_Pes = House_Temp.Cd_Consig
			LEFT JOIN Pessoa				PLLPGrupo with(nolock) On PLLP.Cd_Pes_Grupo = PLLPGrupo.Cd_Pes
			left Join Localidade			Origin with(nolock) on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination with(nolock) on Destination.Cd_Local = House_Temp.Cd_Dst
			--left join Pais	House_Temp_Origin_Country on House_Temp_Origin_Country.Cd_Pais = Origin.Cd_Pais
			--left join Pais	House_Temp_Destination_Country on House_Temp_Destination_Country.Cd_Pais = Destination.Cd_Pais
			left join Pais	House_Temp_Origin_Country with(nolock) on House_Temp_Origin_Country.Cd_Pais = House_Temp.OriginCountryCode
			left join Pais	House_Temp_Destination_Country with(nolock) on House_Temp_Destination_Country.Cd_Pais = House_Temp.DestinationCountryCode
			
			left join Tipo_Modal			House_Temp_Modal with(nolock) on House_Temp_Modal.Id  = House_Temp.Cd_TP_Modal
			
			left join Pessoa				House_Temp_Seller		with(nolock) on House_Temp_Seller.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Buyer		with(nolock) on House_Temp_Buyer.Cd_Pes = House_Temp.Cd_Consig
			left join Pessoa				House_Temp_Shipper		with(nolock) on House_Temp_Shipper.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Consignee	with(nolock) on House_Temp_Consignee.Cd_Pes = House_Temp.Cd_Consig
			left join Tipo_Moeda			House_Temp_Currency		with(nolock) on House_Temp_Currency.Cd_Tp_Moeda  = House_Temp.Cd_Tp_Moeda			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			replace(HOU.vlr_pedido,'.',',')		[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)							[Incoterm Code],
			ISNULL(Incoterm.Nome_Tp_Oper,House_Temp_Incoterm.Nome_Tp_Oper)		[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],			
		
			ISNULL(Hou.Cd_Tp_Moeda,House_Temp.Cd_Tp_Moeda)						[Currency Code],
			ISNULL(Currency.Nome_Tp_Moeda,House_Temp_Currency.Nome_Tp_Moeda)	[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			ISNULL(Hou.Status,'O')				[Status Code],
			ISNULL(Status.Nome_Tp_Status_Pedido,'Opened') [Status Name],
			Hou.Name_Status						[Status XML],
			
			ISNULL(Hou.Cd_Seller,House_Temp.Cd_Export)					[Seller Code],
			ISNULL(Seller.Apelido,House_Temp_Seller.Apelido)			[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			ISNULL(Hou.Cd_Shipper,House_Temp.Cd_Export)					[Shipper Code],
			ISNULL(Shipper.Apelido,House_Temp_Shipper.Apelido) 			[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)					[Shipper XML],	
			
			ISNULL(Hou.Cd_Buyer,House_Temp.Cd_Consig)					[Buyer Code],
			ISNULL(Buyer.Apelido,House_Temp_Buyer.Apelido) 				[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			ISNULL(Hou.Cd_Consignee,House_Temp.Cd_Consig) 				[Consignee Code],
			ISNULL(Consignee.Apelido,House_Temp_Consignee.Apelido) 	 	[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			isnull(Grupo.Apelido,PLLPGrupo.Apelido)						[Group Name],
			HOU.Name_Grupo												[Group XML],
			
			--isnull(HOU.Cd_Pais_Org,Origin.cd_pais)						[Origin Code],
			--ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			--HOU.Name_Pais_Org					[Origin XML],
			
			--isnull(HOU.Cd_Pais_Dst,Destination.Cd_Pais)			[Destination Code],
			--ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			--hou.Name_Pais_Dst					[Destination XML],
			
			isnull(HOU.Cd_Pais_Org,House_Temp.OriginCountryCode)						[Origin Code],
			ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,House_Temp.DestinationCountryCode)			[Destination Code],
			ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			ISNULL(Hou.Dt_Pedido,House_Temp.ETD)	[Order Date],
			--HOU.Dt_Pedido						[Order Date],
			ISNULL(Hou.DL_Chegada,House_Temp.ETA)	[PO Req. Deliv.],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			ISNULL(HOU.Cd_Modal,HOUSE_TEMP.CD_TP_MODAL)		[Modal Code],
			ISNULL(Modal.Modal,House_Temp_Modal.Modal)		[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU with(nolock) 
			left join Tipo_Pedido			Type_Order	with(nolock) on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock) on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock) on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock) on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock) on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock) on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock) on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		with(nolock) on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock) on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		with(nolock) on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		with(nolock) on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			with(nolock) on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	with(nolock) on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			with(nolock) on Modal.Id  = HOU.Cd_Modal
			
			
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = HOU.ID_House_Temp
			left join Tipo_Oper				House_Temp_Incoterm	with(nolock) on House_Temp_Incoterm.Cd_Tp_Oper = House_Temp.Cd_Tp_Oper
			LEFT JOIN Pessoa_LLP			PLLP with(nolock) On PLLP.Cd_Pes = House_Temp.Cd_Consig
			LEFT JOIN Pessoa				PLLPGrupo with(nolock) On PLLP.Cd_Pes_Grupo = PLLPGrupo.Cd_Pes
			left Join Localidade			Origin with(nolock) on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination with(nolock) on Destination.Cd_Local = House_Temp.Cd_Dst
			left join Pais	House_Temp_Origin_Country with(nolock) on House_Temp_Origin_Country.Cd_Pais = House_Temp.OriginCountryCode
			left join Pais	House_Temp_Destination_Country with(nolock) on House_Temp_Destination_Country.Cd_Pais = House_Temp.DestinationCountryCode
			left join Tipo_Modal			House_Temp_Modal with(nolock) on House_Temp_Modal.Id  = House_Temp.Cd_TP_Modal
			
			left join Pessoa				House_Temp_Seller		with(nolock) on House_Temp_Seller.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Buyer		with(nolock) on House_Temp_Buyer.Cd_Pes = House_Temp.Cd_Consig
			left join Pessoa				House_Temp_Shipper		with(nolock) on House_Temp_Shipper.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Consignee	with(nolock) on House_Temp_Consignee.Cd_Pes = House_Temp.Cd_Consig
			left join Tipo_Moeda			House_Temp_Currency		with(nolock) on House_Temp_Currency.Cd_Tp_Moeda  = House_Temp.Cd_Tp_Moeda
		Where
			HOU.ID = @ID
			--[ID_Batch] = @ID_Batch
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			replace(HOU.vlr_pedido,'.',',')		[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)							[Incoterm Code],
			ISNULL(Incoterm.Nome_Tp_Oper,House_Temp_Incoterm.Nome_Tp_Oper)		[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],			
		
			ISNULL(Hou.Cd_Tp_Moeda,House_Temp.Cd_Tp_Moeda)						[Currency Code],
			ISNULL(Currency.Nome_Tp_Moeda,House_Temp_Currency.Nome_Tp_Moeda)	[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			ISNULL(Hou.Status,'O')				[Status Code],
			ISNULL(Status.Nome_Tp_Status_Pedido,'Opened') [Status Name],
			Hou.Name_Status						[Status XML],
			
			ISNULL(Hou.Cd_Seller,House_Temp.Cd_Export)					[Seller Code],
			ISNULL(Seller.Apelido,House_Temp_Seller.Apelido)			[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			ISNULL(Hou.Cd_Shipper,House_Temp.Cd_Export)					[Shipper Code],
			ISNULL(Shipper.Apelido,House_Temp_Shipper.Apelido) 			[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)					[Shipper XML],	
			
			ISNULL(Hou.Cd_Buyer,House_Temp.Cd_Consig)					[Buyer Code],
			ISNULL(Buyer.Apelido,House_Temp_Buyer.Apelido) 				[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			ISNULL(Hou.Cd_Consignee,House_Temp.Cd_Consig) 				[Consignee Code],
			ISNULL(Consignee.Apelido,House_Temp_Consignee.Apelido) 	 	[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			isnull(Grupo.Apelido,PLLPGrupo.Apelido)						[Group Name],
			HOU.Name_Grupo												[Group XML],
			
			isnull(HOU.Cd_Pais_Org,House_Temp.OriginCountryCode)						[Origin Code],
			ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,House_Temp.DestinationCountryCode)			[Destination Code],
			ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			ISNULL(HOU.Cd_Modal,HOUSE_TEMP.CD_TP_MODAL)		[Modal Code],
			ISNULL(Modal.Modal,House_Temp_Modal.Modal)		[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU with(nolock) 
			left join Tipo_Pedido			Type_Order	with(nolock) on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock) on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock) on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock) on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock) on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock) on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock) on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		with(nolock) on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock) on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		with(nolock) on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		with(nolock) on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			with(nolock) on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	with(nolock) on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			with(nolock) on Modal.Id  = HOU.Cd_Modal
			
			
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = HOU.ID_House_Temp
			left join Tipo_Oper				House_Temp_Incoterm	with(nolock) on House_Temp_Incoterm.Cd_Tp_Oper = House_Temp.Cd_Tp_Oper
			LEFT JOIN Pessoa_LLP			PLLP with(nolock) On PLLP.Cd_Pes = House_Temp.Cd_Consig
			LEFT JOIN Pessoa				PLLPGrupo with(nolock) On PLLP.Cd_Pes_Grupo = PLLPGrupo.Cd_Pes
			left Join Localidade			Origin with(nolock) on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination with(nolock) on Destination.Cd_Local = House_Temp.Cd_Dst
			left join Pais	House_Temp_Origin_Country with(nolock) on House_Temp_Origin_Country.Cd_Pais = House_Temp.OriginCountryCode
			left join Pais	House_Temp_Destination_Country with(nolock) on House_Temp_Destination_Country.Cd_Pais = House_Temp.DestinationCountryCode
			left join Tipo_Modal			House_Temp_Modal with(nolock) on House_Temp_Modal.Id  = House_Temp.Cd_TP_Modal
			
			left join Pessoa				House_Temp_Seller		with(nolock) on House_Temp_Seller.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Buyer		with(nolock) on House_Temp_Buyer.Cd_Pes = House_Temp.Cd_Consig
			left join Pessoa				House_Temp_Shipper		with(nolock) on House_Temp_Shipper.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Consignee	with(nolock) on House_Temp_Consignee.Cd_Pes = House_Temp.Cd_Consig
			left join Tipo_Moeda			House_Temp_Currency		with(nolock) on House_Temp_Currency.Cd_Tp_Moeda  = House_Temp.Cd_Tp_Moeda
		Where
			--HOU.ID = @ID
			--[ID_Batch] = @ID_Batch
			HOU.Num_Pedido = @Num_Pedido
			--HOU.Intl_Reference = @Num_Pedido
	End
	

if @Tipo = 'P'  or @Tipo = 'Q'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			replace(HOU.vlr_pedido,'.',',')		[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)							[Incoterm Code],
			ISNULL(Incoterm.Nome_Tp_Oper,House_Temp_Incoterm.Nome_Tp_Oper)		[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],			
		
			ISNULL(Hou.Cd_Tp_Moeda,House_Temp.Cd_Tp_Moeda)						[Currency Code],
			ISNULL(Currency.Nome_Tp_Moeda,House_Temp_Currency.Nome_Tp_Moeda)	[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			ISNULL(Hou.Status,'O')				[Status Code],
			ISNULL(Status.Nome_Tp_Status_Pedido,'Opened') [Status Name],
			Hou.Name_Status						[Status XML],
			
			ISNULL(Hou.Cd_Seller,House_Temp.Cd_Export)					[Seller Code],
			ISNULL(Seller.Apelido,House_Temp_Seller.Apelido)			[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			ISNULL(Hou.Cd_Shipper,House_Temp.Cd_Export)					[Shipper Code],
			ISNULL(Shipper.Apelido,House_Temp_Shipper.Apelido) 			[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)					[Shipper XML],	
			
			ISNULL(Hou.Cd_Buyer,House_Temp.Cd_Consig)					[Buyer Code],
			ISNULL(Buyer.Apelido,House_Temp_Buyer.Apelido) 				[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			ISNULL(Hou.Cd_Consignee,House_Temp.Cd_Consig) 				[Consignee Code],
			ISNULL(Consignee.Apelido,House_Temp_Consignee.Apelido) 	 	[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			isnull(Grupo.Apelido,PLLPGrupo.Apelido)						[Group Name],
			HOU.Name_Grupo												[Group XML],
			
			isnull(HOU.Cd_Pais_Org,House_Temp.OriginCountryCode)						[Origin Code],
			ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,House_Temp.DestinationCountryCode)			[Destination Code],
			ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			ISNULL(HOU.Cd_Modal,HOUSE_TEMP.CD_TP_MODAL)		[Modal Code],
			ISNULL(Modal.Modal,House_Temp_Modal.Modal)		[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU with(nolock) 
			left join Tipo_Pedido			Type_Order	with(nolock) on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock) on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock) on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock) on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock) on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock) on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock) on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		with(nolock) on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock) on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		with(nolock) on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		with(nolock) on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			with(nolock) on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	with(nolock) on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			with(nolock) on Modal.Id  = HOU.Cd_Modal
			
			
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = HOU.ID_House_Temp
			left join Tipo_Oper				House_Temp_Incoterm	with(nolock) on House_Temp_Incoterm.Cd_Tp_Oper = House_Temp.Cd_Tp_Oper
			LEFT JOIN Pessoa_LLP			PLLP with(nolock) On PLLP.Cd_Pes = House_Temp.Cd_Consig
			LEFT JOIN Pessoa				PLLPGrupo with(nolock) On PLLP.Cd_Pes_Grupo = PLLPGrupo.Cd_Pes
			left Join Localidade			Origin with(nolock) on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination with(nolock) on Destination.Cd_Local = House_Temp.Cd_Dst
			left join Pais	House_Temp_Origin_Country with(nolock) on House_Temp_Origin_Country.Cd_Pais = House_Temp.OriginCountryCode
			left join Pais	House_Temp_Destination_Country with(nolock) on House_Temp_Destination_Country.Cd_Pais = House_Temp.DestinationCountryCode
			left join Tipo_Modal			House_Temp_Modal with(nolock) on House_Temp_Modal.Id  = House_Temp.Cd_TP_Modal
			
			left join Pessoa				House_Temp_Seller		with(nolock) on House_Temp_Seller.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Buyer		with(nolock) on House_Temp_Buyer.Cd_Pes = House_Temp.Cd_Consig
			left join Pessoa				House_Temp_Shipper		with(nolock) on House_Temp_Shipper.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Consignee	with(nolock) on House_Temp_Consignee.Cd_Pes = House_Temp.Cd_Consig
			left join Tipo_Moeda			House_Temp_Currency		with(nolock) on House_Temp_Currency.Cd_Tp_Moeda  = House_Temp.Cd_Tp_Moeda
		Where
			HOU.ID_House_Temp = @ID
	End
	
if @Tipo = 'R'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			replace(HOU.vlr_pedido,'.',',')		[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)							[Incoterm Code],
			ISNULL(Incoterm.Nome_Tp_Oper,House_Temp_Incoterm.Nome_Tp_Oper)		[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],			
		
			ISNULL(Hou.Cd_Tp_Moeda,House_Temp.Cd_Tp_Moeda)						[Currency Code],
			ISNULL(Currency.Nome_Tp_Moeda,House_Temp_Currency.Nome_Tp_Moeda)	[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			ISNULL(Hou.Status,'O')				[Status Code],
			ISNULL(Status.Nome_Tp_Status_Pedido,'Opened') [Status Name],
			Hou.Name_Status						[Status XML],
			
			ISNULL(Hou.Cd_Seller,House_Temp.Cd_Export)					[Seller Code],
			ISNULL(Seller.Apelido,House_Temp_Seller.Apelido)			[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			ISNULL(Hou.Cd_Shipper,House_Temp.Cd_Export)					[Shipper Code],
			ISNULL(Shipper.Apelido,House_Temp_Shipper.Apelido) 			[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)					[Shipper XML],	
			
			ISNULL(Hou.Cd_Buyer,House_Temp.Cd_Consig)					[Buyer Code],
			ISNULL(Buyer.Apelido,House_Temp_Buyer.Apelido) 				[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			ISNULL(Hou.Cd_Consignee,House_Temp.Cd_Consig) 				[Consignee Code],
			ISNULL(Consignee.Apelido,House_Temp_Consignee.Apelido) 	 	[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			isnull(Grupo.Apelido,PLLPGrupo.Apelido)						[Group Name],
			HOU.Name_Grupo												[Group XML],
			
			isnull(HOU.Cd_Pais_Org,House_Temp.OriginCountryCode)						[Origin Code],
			ISNULL(Origin_Country.Nome_Pais,House_Temp_Origin_Country.Nome_Pais)	[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,House_Temp.DestinationCountryCode)			[Destination Code],
			ISNULL(Destination_Country.Nome_Pais,House_Temp_Destination_Country.Nome_Pais)	[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			ISNULL(HOU.Cd_Modal,HOUSE_TEMP.CD_TP_MODAL)		[Modal Code],
			ISNULL(Modal.Modal,House_Temp_Modal.Modal)		[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU with(nolock) 
			left join Tipo_Pedido			Type_Order	with(nolock) on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock) on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock) on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock) on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock) on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock) on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock) on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		with(nolock) on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock) on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		with(nolock) on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		with(nolock) on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			with(nolock) on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	with(nolock) on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			with(nolock) on Modal.Id  = HOU.Cd_Modal
			
			
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = HOU.ID_House_Temp
			left join Tipo_Oper				House_Temp_Incoterm	with(nolock) on House_Temp_Incoterm.Cd_Tp_Oper = House_Temp.Cd_Tp_Oper
			LEFT JOIN Pessoa_LLP			PLLP with(nolock) On PLLP.Cd_Pes = House_Temp.Cd_Consig
			LEFT JOIN Pessoa				PLLPGrupo with(nolock) On PLLP.Cd_Pes_Grupo = PLLPGrupo.Cd_Pes
			left Join Localidade			Origin with(nolock) on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination with(nolock) on Destination.Cd_Local = House_Temp.Cd_Dst
			left join Pais	House_Temp_Origin_Country with(nolock) on House_Temp_Origin_Country.Cd_Pais = House_Temp.OriginCountryCode
			left join Pais	House_Temp_Destination_Country with(nolock) on House_Temp_Destination_Country.Cd_Pais = House_Temp.DestinationCountryCode
			left join Tipo_Modal			House_Temp_Modal with(nolock) on House_Temp_Modal.Id  = House_Temp.Cd_TP_Modal
			
			left join Pessoa				House_Temp_Seller		with(nolock) on House_Temp_Seller.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Buyer		with(nolock) on House_Temp_Buyer.Cd_Pes = House_Temp.Cd_Consig
			left join Pessoa				House_Temp_Shipper		with(nolock) on House_Temp_Shipper.Cd_Pes = House_Temp.Cd_Export
			left join Pessoa				House_Temp_Consignee	with(nolock) on House_Temp_Consignee.Cd_Pes = House_Temp.Cd_Consig
			left join Tipo_Moeda			House_Temp_Currency		with(nolock) on House_Temp_Currency.Cd_Tp_Moeda  = House_Temp.Cd_Tp_Moeda
		Where
			HOU.SystemCode = @ID and HOU.Cd_pedido is null
	End

/*
--if @Tipo = 'N'  or @Tipo = 'O'
--	Begin
--		select
--			HOU.ID								[ID],						
--			HOU.ID_Batch						[ID Integration],--[ID_Batch],
--			Cd_pedido							[ID Order],--[Cd_pedido],
--			Num_Pedido							[Number],						
--			HOU.vlr_pedido						[Order Value],
			
--			HOU.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
--			HOU.Name_Tipo						[Type XML],
			
--			Hou.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
--			Hou.Name_Incoterm					[Incoterm XML],
			
--			Hou.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
--			Hou.Name_Moeda						[Currency XML],
			
--			Hou.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
--			Hou.Name_Status						[Status XML],
			
--			HOU.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
--			HOU.Name_Seller						[Seller XML],
			
--			HOU.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
--			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)	[Shipper XML],	
			
----			Seller = Shipper
----Buyer = Consignee			
				
--			HOU.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		
--			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
--			HOU.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
--			HOU.Name_Consignee					[Consignee XML],
			
--			HOU.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
--			HOU.Name_Grupo						[Group XML],
			
--			HOU.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
--			HOU.Name_Pais_Org					[Origin XML],
			
--			HOU.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],		
--			hou.Name_Pais_Dst					[Destination XML],
			
--			HOU.Num_PO							[PO],
--			HOU.Customer_PO						[Customer PO],
			
--			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
--			HOU.Dt_Pedido						[Order Date],
--			HOU.DL_Chegada						[PO Req. Deliv.],
--			HOU.Selling_SAP						[Selling SAP],
--			HOU.Planta							[Plant ID],
--			HOU.Cd_Pes_CTT						[Contact],
			
--			HOU.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
--			hou.Name_CSRID						[CSR Name XML],
			
--			HOU.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
--			hou.Name_USERID						[USER ID XML],
			
--			HOU.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
--			hou.Name_Responsible				[Responsible PO XML],
			
--			HOU.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name],		
--				hou.Name_Modal						[Modal XML]	,
			
--			HOU.ID_House_Temp,
--			HOU.ID_Req,
--			HOU.Intl_Reference,
--			HOU.Id_TP_House_Temp,
--			HOU.SystemCode,		
--			House_Temp.Num_Proc					[JOB]
			
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R

--		from Pedido_Temp_New HOU
--			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
--			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
--			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
--			left join Tipo_Status_Pedido	Status		on Status.Cd_Tp_Status_Pedido  = HOU.Status
--			left join Pessoa				Seller		on Seller.Cd_Pes = HOU.Cd_Seller
--			left join Pessoa				Buyer		on Buyer.Cd_Pes = HOU.Cd_Buyer
--			left join Pessoa				Shipper		on Shipper.Cd_Pes = HOU.Cd_Shipper
--			left join Pessoa				Consignee	on Consignee.Cd_Pes = HOU.Cd_Consignee
--			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
--			left join Pais					Destination_Country on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
--			left join Pessoa				Grupo		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
--			left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
--			left join House_Temp			House_Temp on House_Temp.ID = HOU.ID_House_Temp
--		Where
--			--HOU.ID = @ID
--			--[ID_Batch] = @ID_Batch
--			HOU.Num_Pedido = @Num_Pedido
--	End
	

--if @Tipo = 'P'  or @Tipo = 'Q'
if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			Hou.Name_Status						[Status XML],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)	[Shipper XML],	
			
--			Seller = Shipper
--Buyer = Consignee			
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			HOU.Name_Grupo						[Group XML],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R

		from Pedido_Temp_New HOU
			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		on Grupo.Cd_Pes = HOU.Cd_Grupo			
			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
			left join House_Temp			House_Temp on House_Temp.ID = HOU.ID_House_Temp
			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			Hou.Name_Status						[Status XML],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)	[Shipper XML],	
			
--			Seller = Shipper
--Buyer = Consignee			
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			HOU.Name_Grupo						[Group XML],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name],		
				hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
			
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R

		from Pedido_Temp_New HOU
			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
			left join House_Temp			House_Temp on House_Temp.ID = HOU.ID_House_Temp
		Where
			HOU.ID = @ID
			--[ID_Batch] = @ID_Batch
	End
	
	
--if @Tipo = 'N'  or @Tipo = 'O'
--	Begin
--		select
--			HOU.ID								[ID],						
--			HOU.ID_Batch						[ID Integration],--[ID_Batch],
--			Cd_pedido							[ID Order],--[Cd_pedido],
--			Num_Pedido							[Number],						
--			HOU.vlr_pedido						[Order Value],
			
--			HOU.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
--			HOU.Name_Tipo						[Type XML],
			
--			Hou.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
--			Hou.Name_Incoterm					[Incoterm XML],
			
--			Hou.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
--			Hou.Name_Moeda						[Currency XML],
			
--			Hou.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
--			Hou.Name_Status						[Status XML],
			
--			HOU.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
--			HOU.Name_Seller						[Seller XML],
			
--			HOU.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
--			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)	[Shipper XML],	
			
----			Seller = Shipper
----Buyer = Consignee			
				
--			HOU.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		
--			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
--			HOU.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
--			HOU.Name_Consignee					[Consignee XML],
			
--			HOU.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
--			HOU.Name_Grupo						[Group XML],
			
--			HOU.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
--			HOU.Name_Pais_Org					[Origin XML],
			
--			HOU.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],		
--			hou.Name_Pais_Dst					[Destination XML],
			
--			HOU.Num_PO							[PO],
--			HOU.Customer_PO						[Customer PO],
			
--			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
--			HOU.Dt_Pedido						[Order Date],
--			HOU.DL_Chegada						[PO Req. Deliv.],
--			HOU.Selling_SAP						[Selling SAP],
--			HOU.Planta							[Plant ID],
--			HOU.Cd_Pes_CTT						[Contact],
			
--			HOU.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
--			hou.Name_CSRID						[CSR Name XML],
			
--			HOU.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
--			hou.Name_USERID						[USER ID XML],
			
--			HOU.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
--			hou.Name_Responsible				[Responsible PO XML],
			
--			HOU.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name],		
--				hou.Name_Modal						[Modal XML]	,
			
--			HOU.ID_House_Temp,
--			HOU.ID_Req,
--			HOU.Intl_Reference,
--			HOU.Id_TP_House_Temp,
--			HOU.SystemCode,		
--			House_Temp.Num_Proc					[JOB]
			
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R

--		from Pedido_Temp_New HOU
--			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
--			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
--			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
--			left join Tipo_Status_Pedido	Status		on Status.Cd_Tp_Status_Pedido  = HOU.Status
--			left join Pessoa				Seller		on Seller.Cd_Pes = HOU.Cd_Seller
--			left join Pessoa				Buyer		on Buyer.Cd_Pes = HOU.Cd_Buyer
--			left join Pessoa				Shipper		on Shipper.Cd_Pes = HOU.Cd_Shipper
--			left join Pessoa				Consignee	on Consignee.Cd_Pes = HOU.Cd_Consignee
--			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
--			left join Pais					Destination_Country on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
--			left join Pessoa				Grupo		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
--			left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
--			left join House_Temp			House_Temp on House_Temp.ID = HOU.ID_House_Temp
--		Where
--			--HOU.ID = @ID
--			--[ID_Batch] = @ID_Batch
--			HOU.Num_Pedido = @Num_Pedido
--	End
	

--if @Tipo = 'P'  or @Tipo = 'Q'

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select
			HOU.ID								[ID],						
			HOU.ID_Batch						[ID Integration],--[ID_Batch],
			Cd_pedido							[ID Order],--[Cd_pedido],
			Num_Pedido							[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
			HOU.Name_Tipo						[Type XML],
			
			ISNULL(Hou.Incoterm,House_Temp.CD_TP_OPER)	[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			Hou.Name_Incoterm					[Incoterm XML],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			Hou.Name_Moeda						[Currency XML],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			Hou.Name_Status						[Status XML],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
			HOU.Name_Seller						[Seller XML],
			
			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			ISNULL(HOU.Name_Shipper,HOU.Name_Seller)	[Shipper XML],	
			
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		
			ISNULL(HOU.Name_Buyer,HOU.Name_Consignee)	[Buyer XML],					
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			HOU.Name_Consignee					[Consignee XML],
			
			isnull(HOU.Cd_Grupo,PLLP.cd_pes_grupo)						[Group Code],
			Grupo.Apelido						[Group Name],
			HOU.Name_Grupo						[Group XML],
			
			isnull(HOU.Cd_Pais_Org,Origin.cd_pais)		[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			HOU.Name_Pais_Org					[Origin XML],
			
			isnull(HOU.Cd_Pais_Dst,Destination.Cd_Pais)			[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			hou.Name_Pais_Dst					[Destination XML],
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			--convert(datetime,HOU.dt_Pedido,101)	[Order Date],
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
			hou.Name_CSRID						[CSR Name XML],
			
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			hou.Name_USERID						[USER ID XML],
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			hou.Name_Responsible				[Responsible PO XML],
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name],		
			hou.Name_Modal						[Modal XML]	,
			
			HOU.ID_House_Temp,
			HOU.ID_Req,
			HOU.Intl_Reference,
			HOU.Id_TP_House_Temp,
			HOU.SystemCode,		
			House_Temp.Num_Proc					[JOB]
		from Pedido_Temp_New HOU
			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID AND CSR_Name.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID AND USERID.Cd_Cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible AND Responsible_PO.Cd_Cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
			left join House_Temp			House_Temp on House_Temp.ID = HOU.ID_House_Temp
			LEFT JOIN Pessoa_LLP			PLLP On PLLP.Cd_Pes = House_Temp.Cd_Consig
			left Join Localidade			Origin on Origin.Cd_Local = House_Temp.Cd_Org
			left Join Localidade			Destination on Destination.Cd_Local = House_Temp.Cd_Dst
		Where
			--HOU.ID = @ID
			--[ID_Batch] = @ID_Batch
			HOU.Num_Pedido = @Num_Pedido
			--HOU.Intl_Reference = @Num_Pedido
	End
	*/
GO
