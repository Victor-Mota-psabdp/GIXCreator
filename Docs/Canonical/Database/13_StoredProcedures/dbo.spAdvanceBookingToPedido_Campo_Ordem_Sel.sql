SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAdvanceBookingToPedido_Campo_Ordem_Sel] 
(
	@ID_ABH bigint   
)

as 

select
	Date.ID_ABH,
	Date.Type,
	Date.Value
from ATL_INT.[dbo].[AdvanceBookingHeader] Header
	Left join ATL_INT.[dbo].[AdvanceBookingBodyDate] Date on Date.ID_ABH = Header.ID_ABH	
	Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Header.ID_ABH
Where
	Header.ID_ABH = @ID_ABH

Union ALL
	select distinct
		Header.ID_ABH,
		'EquipmentNumber' Type,
		ProductDetail.ContainerNumber Value
	from ATL_INT.[dbo].[AdvanceBookingHeader] Header
		Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Header.ID_ABH
	Where
		Header.ID_ABH = @ID_ABH

UNION ALL
	select distinct
		Header.ID_ABH,
		'EquipmentQuantity' Type,
		replace(ProductDetail.ContainerNumber,'TBNU','') Value
		
	from ATL_INT.[dbo].[AdvanceBookingHeader] Header
		Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Header.ID_ABH
	Where
		Header.ID_ABH = @ID_ABH

UNION ALL
	select distinct
		Header.ID_ABH,
		'EquipmentSize' Type,
		ProductDetail.ContainerType Value
	from ATL_INT.[dbo].[AdvanceBookingHeader] Header
		Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Header.ID_ABH
	Where
		Header.ID_ABH = @ID_ABH

UNION ALL
	select distinct
		Header.ID_ABH,
		'EquipmentType' Type,
		ProductDetail.ContainerType Value
	from ATL_INT.[dbo].[AdvanceBookingHeader] Header
		Left join ATL_INT.[dbo].[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Header.ID_ABH
	Where
		Header.ID_ABH = @ID_ABH

UNION ALL
	select distinct
		Header.ID_ABH,
		'IncotermsLocation' Type,
		Item.Value Value
	from ATL_INT.[dbo].[AdvanceBookingHeader] Header
		Left join ATL_INT.[dbo].[AdvanceBookingBodyIncotermsLocation] Item on Item.ID_ABH = Header.ID_ABH
	Where
		Header.ID_ABH = @ID_ABH


GO
