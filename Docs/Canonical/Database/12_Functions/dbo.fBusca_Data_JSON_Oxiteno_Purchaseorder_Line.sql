SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line]
(
	@ID_Purchaseorder BigInt,
	@type Varchar(25)
)
RETURNS datetime 
AS
BEGIN 
	Declare @data datetime	
	
	if	@type = 'data_requisicao'	
		Begin			
			set @data = (select max(data_requisicao) from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line  with(nolock) where ID_Purchaseorder=@ID_Purchaseorder)
		End
	if	@type = 'data_promessa'	
		Begin			
			set @data = (select max(data_promessa) from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line  with(nolock) where ID_Purchaseorder=@ID_Purchaseorder)
		End
	
return @data
	
END


GO
