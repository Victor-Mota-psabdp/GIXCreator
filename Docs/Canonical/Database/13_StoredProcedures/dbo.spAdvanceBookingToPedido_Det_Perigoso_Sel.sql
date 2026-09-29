SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAdvanceBookingToPedido_Det_Perigoso_Sel] 
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

	replace(HazardousDetail.uNNumber,'UN','')	[HAZMAT_CD], 
	--HazardousDetail.hazardousDesc		[HAZMAT_DESC], 
	HazardousDetail.iMOClass			[HAZMAT_CLASS_CD], 
	HazardousDetail.hazDescription		[HAZMAT_DESC],
	
	NULL HAZMAT_CONTACT,
	NULL HAZMAT_PAGE,
	NULL HAZMAT_FPOINT,
	NULL HAZMAT_FPOINT_CD,
	NULL HAZMAT_PULL_DESC_FRM_BDP,
	NULL HAZMAT_ORG_DESC,
	NULL HAZMAT_DESC_QUAL

	--HazardousDetail.subsidiaryRisk			[Item], 
	--HazardousDetail.hazPackageGroup			[Item], 
	--HazardousDetail.flashPoint			[Item], 
	--HazardousDetail.flashPointUnit			[Item], 
	--HazardousDetail.hazProperName			[Item], 
	--HazardousDetail.accordDangereuxRoutier			[Item],
	--HazardousDetail.secondaryHazDescription			[Item], 
	--HazardousDetail.additonalHazInformation			[Item], 
	--HazardousDetail.marinePollutant			[Item]	
from ATL_INT.[dbo].[AdvanceBookingHeader] Header
	Left join ATL_INT.[dbo].[AdvanceBookingBody] Body on Body.ID_ABH = Header.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Body.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetailHazardousDetail] HazardousDetail on HazardousDetail.ID_ABH = ProductDetail.ID_ABH and HazardousDetail.ID_ABBPDT = ProductDetail.ID_ABBPDT
Where
	Header.ID_ABH = @ID_ABH


GO
