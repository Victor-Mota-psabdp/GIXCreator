SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAdvanceBookingToPedido_Det_Sel] 
(
	@ID_ABH bigint   
)

as 

select
	NULL								[Cd_Pedido],
	NULL								[Cd_Produto],
	ProductDetail.ProductID				[Product Code],
	ProductDetail.ProductDescription	[Product Description],

	'UN'								[2ª Ref. (Delivery Note)],
	ProductDetail.LineItemNo			[Item],          
	NULL								[Requeriment],		
	convert(decimal(18,2),ProductDetail.NumberOfPackages)		[Qty],
	1									[Unit Price],
	1									[Total Price],
	ProductDetail.PackageType			[UoM Product],
	NULL								[UoM Weight],
	NULL								[Unit Weight],
	convert(decimal(18,2),GrossWeight.Value)	[Gross Weight],
	convert(decimal(18,2),NetWeight.Value)		[Net Weight],
	NULL								[Invoice Weight],
	NULL								[Contract],
	NULL								[NATOP],
	NULL								[Purpose],		
	NULL								[PO Group],
	NULL								[In Progress],
	NULL								[Requisition],	
	--ProductDetail.HarmonizedCode		[NCM],
	NULL								[NCM],
	NULL								[Freight],
	NULL								[FOB Value],	
	
	ProductDetail.PackageType			[UoM],
	
	NULL								[Country of Manufact. Code],
	NULL								[Country of Manufact. Name],

	NULL								[Manufacturer Code],
	NULL								[Manufacturer Name],
		
	convert(decimal(18,2),ProductDetail.NumberOfPackages)	[Qty Packet],
	ProductDetail.PackageType			[Type Packet Code],
	NULL								[Type Packet Name],
	
	NULL								[Agreement Code],
	NULL								[Agreement Name]		

from ATL_INT.[dbo].[AdvanceBookingHeader] Header
	Left join ATL_INT.[dbo].[AdvanceBookingBody] Body on Body.ID_ABH = Header.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Body.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetailGrossWeight] GrossWeight on GrossWeight.ID_ABH = ProductDetail.ID_ABH and GrossWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetailNetWeight] NetWeight on NetWeight.ID_ABH = ProductDetail.ID_ABH and NetWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
Where
	Header.ID_ABH = @ID_ABH

GO
