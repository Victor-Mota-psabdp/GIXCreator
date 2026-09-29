SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Pedido_Temp_New
--select * from [vwPedido_Temp_New_Sel]
CREATE VIEW [dbo].[vwPedido_Temp_New_Sel]
AS
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
			
		HOU.Cd_Buyer						[Buyer Code],
		Buyer.Apelido						[Buyer Name],		
		HOU.Name_Buyer						[Buyer XML],

		HOU.Cd_Shipper						[Shipper Code],
		Shipper.Apelido						[Shipper Name],		
		HOU.Name_Shipper					[Shipper XML],			
		
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
		hou.Name_Modal						[Modal XML]	

		,hou.SystemCode						[SystemCode]
		
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
		
		left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Usuario = HOU.Cd_CSRID
		left join Usuario_Cliente		USERID			on USERID.Cd_Usuario = HOU.Cd_USERID
		left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Usuario = HOU.PO_Responsible
		left join Tipo_Modal			Modal			on Modal.Id  = HOU.Cd_Modal
	where
		isnull(hou.SystemCode,'9') <> '2'


GO
