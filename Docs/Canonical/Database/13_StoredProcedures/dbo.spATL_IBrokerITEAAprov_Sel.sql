SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerITEAAprov_Sel](
@ID bigint
)
as
select 
Product_ID [Product ID],
ID_Item [ID Item],
Qty [Qty],
UOM_Siscomex [UOM - Siscomex],
UOM [UOM],
Net_Weight [Net Weight],
Unit_Price [Unit Price],
NCM [NCM],
ID_RM [ID (RM)],
Item [Item],
Num_pedido [Order Reference],
Full_Description [Full Description]
from IBROKER_Item_V2
where ID = @ID
GO
