SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAP2Aprov_Sel]
(
@ID bigint
)
as
select  
Qty_Item  [Qty Item],
Cod_Currency_Order  [Cod. Currency(Order)],
Currency_Order [Currency(Order)],
Order_Value [Order Value],
Cod_Currency_Freight  [Cod. Currency(Freight)],
Currency_Freight [Currency(Freight)],
Freight_Value [Freight Value],
Freight_Type [Freight Type],
Incoterm  [Incoterm],
Incoterm_Descr [Incoterm Descr],
Cod_Currency_Invoice [Cod. Currency(Invoice)],
Currency_Invoice [Currency(Invoice)],
Invoice_Value [Invoice Value]
 from
IBROKER_CAP2_V2
where 
ID = @ID
GO
