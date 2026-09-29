SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido
--[spATLDN_Pedido_Sel]NULL,'503494','P21128','','','O'
Create procedure [dbo].[spATLDN_Pedido_Country_Sel]
(
	@Cd_Pedido			int,
	@Num_Pedido			varchar(30),
	@Cd_Grupo			varchar(25),
	@Cd_Buyer			Varchar(10),
	@Cd_Seller			Varchar(10),
	@Cd_Pais_Org		Varchar(10),
	@Tipo				char(1)
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select			
			hou.Cd_pedido						[ID],			
			HOU.Num_Pedido						[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
		
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		

			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],	
			Destination_Country.Nome_Pais		[Destination Name],		
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
		
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name]		
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R
		from Pedido HOU with(nolock)	
			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID
			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID
			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible
			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select			
			hou.Cd_pedido						[ID],			
			HOU.Num_Pedido						[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
		
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		

			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			Destination_Country.Nome_Pais		[Destination Name],	
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
		
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name]		
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R

		from Pedido HOU with(nolock)	
			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			left join Pessoa				Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID
			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID
			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible
			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal		
		where
			HOU.Cd_Pedido = @Cd_Pedido

	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select			
			hou.Cd_pedido						[ID],			
			HOU.Num_Pedido						[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
		
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		

			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			Destination_Country.Nome_Pais		[Destination Name],		
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
		
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name]		
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R

	    from Pedido HOU with(nolock)	
			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			join Pessoa						Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID and CSR_Name.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID and USERID.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible and Responsible_PO.cd_cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
		where	
			HOU.Num_Pedido = @Num_Pedido and HOU.cd_grupo = @Cd_Grupo
			and DatePart(year,HOU.Dt_Pedido) > DatePart(year, getdate()) - 5
			
	End

if @Tipo = 'P' or @Tipo = 'Q'
	Begin
		select			
			hou.Cd_pedido						[ID],			
			HOU.Num_Pedido						[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
		
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		

			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			Destination_Country.Nome_Pais		[Destination Name],		
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
		
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name]		
			
--Obs_PC
--cd_tp_cont
--Payment
--Order_Type
--Status_Entrega
--Pedido_Retorno
--Pedido_Invoice_Only
--Cd_Vendor
--DN_R

	    from Pedido HOU with(nolock)	
			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			join Pessoa						Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID and CSR_Name.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID and USERID.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible and Responsible_PO.cd_cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
		where	
			HOU.Num_Pedido = @Num_Pedido and HOU.cd_grupo = @Cd_Grupo
			and HOU.Cd_Seller=@Cd_Seller and HOU.Cd_Buyer=@Cd_Buyer		
	End

if @Tipo = 'R' --pelo: Grupo + Pais de Origem + Numero Pedido (dos ultimo 365 dias)
	Begin
		select			
			hou.Cd_pedido						[ID],			
			HOU.Num_Pedido						[Number],						
			HOU.vlr_pedido						[Order Value],
			
			HOU.Cd_Tipo							[Type Code],
			Type_Order.Nome_Tp_Pedido			[Type Name],
		
			Hou.Incoterm						[Incoterm Code],
			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
			Hou.Cd_Tp_Moeda						[Currency Code],
			Currency.Nome_Tp_Moeda				[Currency Name],
			
			Hou.Status							[Status Code],
			Status.Nome_Tp_Status_Pedido		[Status Name],
			
			HOU.Cd_Seller						[Seller Code],
			Seller.Apelido						[Seller Name],
				
			HOU.Cd_Buyer						[Buyer Code],
			Buyer.Apelido						[Buyer Name],		

			HOU.Cd_Shipper						[Shipper Code],
			Shipper.Apelido						[Shipper Name],		
			
			HOU.Cd_Consignee					[Consignee Code],
			Consignee.Apelido					[Consignee Name],
			
			HOU.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			
			HOU.Cd_Pais_Org						[Origin Code],
			Origin_Country.Nome_Pais			[Origin Name],		
			
			HOU.Cd_Pais_Dst						[Destination Code],
			Destination_Country.Nome_Pais		[Destination],		
			Destination_Country.Nome_Pais		[Destination Name],		
			
			HOU.Num_PO							[PO],
			HOU.Customer_PO						[Customer PO],
			
			HOU.Dt_Pedido						[Order Date],
			HOU.DL_Chegada						[PO Req. Deliv.],
			HOU.Selling_SAP						[Selling SAP],
			HOU.Planta							[Plant ID],
			HOU.Cd_Pes_CTT						[Contact],
			
			HOU.Cd_CSRID						[CSR Name Code],
			CSR_Name.Nome_Usuario				[CSR Name],		
		
			HOU.Cd_USERID						[USER ID Code],
			USERID.Nome_Usuario					[USER ID Name],		
			
			HOU.PO_Responsible					[Responsible PO Code],
			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
			HOU.Cd_Modal						[Modal Code],
			Modal.Modal							[Modal Name]		
			
	    from Pedido HOU with(nolock)	
			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
			join Pessoa						Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID and CSR_Name.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID and USERID.cd_cliente = HOU.Cd_Grupo
			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible and Responsible_PO.cd_cliente = HOU.Cd_Grupo
			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
		where	
			HOU.Num_Pedido = @Num_Pedido and HOU.cd_grupo = @Cd_Grupo
			and DatePart(year,HOU.Dt_Pedido) >= DatePart(year, getdate()) - 2
			and HOU.Cd_Pais_Org = @Cd_Pais_Org
	End

--sp_help Pedido
--ALTER procedure [dbo].[spATLDN_Pedido_Sel]
--(
--	@Cd_Pedido			int,
--	@Num_Pedido			varchar(30),
--	@Cd_Grupo			varchar(25),
--	@Tipo char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--*/

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin	
--		select			
--			hou.Cd_pedido						[ID],			
--			HOU.Num_Pedido						[Number],						
--			HOU.vlr_pedido						[Order Value],
			
--			HOU.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
		
--			Hou.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
--			Hou.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
			
--			Hou.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
			
--			HOU.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
				
--			HOU.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		

--			HOU.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
			
--			HOU.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
			
--			HOU.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
			
--			HOU.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
			
--			HOU.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],	
--			Destination_Country.Nome_Pais		[Destination Name],		
			
--			HOU.Num_PO							[PO],
--			HOU.Customer_PO						[Customer PO],
			
--			HOU.Dt_Pedido						[Order Date],
--			HOU.DL_Chegada						[PO Req. Deliv.],
--			HOU.Selling_SAP						[Selling SAP],
--			HOU.Planta							[Plant ID],
--			HOU.Cd_Pes_CTT						[Contact],
			
--			HOU.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
		
--			HOU.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
			
--			HOU.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
--			HOU.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name]		
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R
--		from Pedido HOU with(nolock)	
--			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
--			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
--			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
--			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
--			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
--			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
--			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
--			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
--			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
--			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
--			left join Pessoa				Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID
--			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID
--			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible
--			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
--	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin	
--		select			
--			hou.Cd_pedido						[ID],			
--			HOU.Num_Pedido						[Number],						
--			HOU.vlr_pedido						[Order Value],
			
--			HOU.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
		
--			Hou.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
--			Hou.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
			
--			Hou.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
			
--			HOU.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
				
--			HOU.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		

--			HOU.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
			
--			HOU.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
			
--			HOU.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
			
--			HOU.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
			
--			HOU.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],		
--			Destination_Country.Nome_Pais		[Destination Name],	
			
--			HOU.Num_PO							[PO],
--			HOU.Customer_PO						[Customer PO],
			
--			HOU.Dt_Pedido						[Order Date],
--			HOU.DL_Chegada						[PO Req. Deliv.],
--			HOU.Selling_SAP						[Selling SAP],
--			HOU.Planta							[Plant ID],
--			HOU.Cd_Pes_CTT						[Contact],
			
--			HOU.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
		
--			HOU.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
			
--			HOU.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
--			HOU.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name]		
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R

--		from Pedido HOU with(nolock)	
--			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
--			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
--			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
--			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
--			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
--			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
--			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
--			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
--			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
--			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
--			left join Pessoa				Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID
--			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID
--			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible
--			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal		
--		where
--			HOU.Cd_Pedido = @Cd_Pedido

--	End
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select			
--			hou.Cd_pedido						[ID],			
--			HOU.Num_Pedido						[Number],						
--			HOU.vlr_pedido						[Order Value],
			
--			HOU.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
		
--			Hou.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
			
--			Hou.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
			
--			Hou.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
			
--			HOU.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
				
--			HOU.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		

--			HOU.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
			
--			HOU.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
			
--			HOU.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
			
--			HOU.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
			
--			HOU.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],		
--			Destination_Country.Nome_Pais		[Destination Name],		
			
--			HOU.Num_PO							[PO],
--			HOU.Customer_PO						[Customer PO],
			
--			HOU.Dt_Pedido						[Order Date],
--			HOU.DL_Chegada						[PO Req. Deliv.],
--			HOU.Selling_SAP						[Selling SAP],
--			HOU.Planta							[Plant ID],
--			HOU.Cd_Pes_CTT						[Contact],
			
--			HOU.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
		
--			HOU.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
			
--			HOU.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
			
--			HOU.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name]		
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R

--	    from Pedido HOU with(nolock)	
--			left join Tipo_Pedido			Type_Order with(nolock)	on Type_Order.cd_Tp_Pedido = HOU.Cd_Tipo
--			left join Tipo_Oper				Incoterm	with(nolock)	on Incoterm.Cd_Tp_Oper = HOU.Incoterm
--			left join Tipo_Moeda			Currency	with(nolock)	on Currency.Cd_Tp_Moeda  = HOU.Cd_Tp_Moeda
--			left join Tipo_Status_Pedido	Status		with(nolock)	on Status.Cd_Tp_Status_Pedido  = HOU.Status
--			left join Pessoa				Seller		with(nolock)	on Seller.Cd_Pes = HOU.Cd_Seller
--			left join Pessoa				Buyer		with(nolock)	on Buyer.Cd_Pes = HOU.Cd_Buyer
--			left join Pessoa				Shipper		with(nolock)	on Shipper.Cd_Pes = HOU.Cd_Shipper
--			left join Pessoa				Consignee	with(nolock)	on Consignee.Cd_Pes = HOU.Cd_Consignee
--			left join Pais					Origin_Country	with(nolock)		on Origin_Country.Cd_Pais = HOU.Cd_Pais_Org
--			left join Pais					Destination_Country with(nolock)	on Destination_Country.Cd_Pais = HOU.Cd_Pais_Dst
--			join Pessoa						Grupo	with(nolock)		on Grupo.Cd_Pes = HOU.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name	with(nolock)		on CSR_Name.Cd_Cliente = HOU.Cd_CSRID and CSR_Name.cd_cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		USERID		with(nolock)		on USERID.Cd_Cliente = HOU.Cd_USERID and USERID.cd_cliente = HOU.Cd_Grupo
--			left join Usuario_Cliente		Responsible_PO with(nolock)		on Responsible_PO.Cd_Cliente = HOU.PO_Responsible and Responsible_PO.cd_cliente = HOU.Cd_Grupo
--			left join Tipo_Modal			Modal		with(nolock)		on Modal.Id  = HOU.Cd_Modal			
--		where	
--			HOU.Num_Pedido = @Num_Pedido and HOU.cd_grupo = @Cd_Grupo
	
			
--	End

GO
