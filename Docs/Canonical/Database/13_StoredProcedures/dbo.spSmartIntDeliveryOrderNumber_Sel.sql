SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSmartIntDeliveryOrderNumber_Sel]
	@Num_Proc Varchar(16)
	
	as

select distinct lote from pedido_Ship with(nolock)
Where num_proc=@Num_PRoc

GO
