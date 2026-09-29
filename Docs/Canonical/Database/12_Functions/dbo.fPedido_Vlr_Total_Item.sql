SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fPedido_Vlr_Total_Item]--(92874)
(
@cd_pedido	int
)
RETURNS float
AS  
	BEGIN 
		Declare @Vlr_Total_Item as float
		declare @nVlr_Total_Item as float

	Begin
		Declare Cur_VlrTotalItem cursor for 
			select 
				sum(PD.Vlr_Total_Item)
			from
				Pedido_det PD
			join pedido P with(nolock) on PD.cd_pedido = P.cd_pedido
			left Join Pedido_Ship PS with(nolock) on ps.item=PD.Item and PS.cd_pedido=PD.cd_pedido
			where P.cd_pedido = @cd_pedido
		open Cur_VlrTotalItem
			Fetch Next From Cur_VlrTotalItem Into @Vlr_Total_Item
			While @@FETCH_STATUS = 0
			Begin
				if @nVlr_Total_Item='' or @nVlr_Total_Item is Null
					Begin
						Set @nVlr_Total_Item=@Vlr_Total_Item
					end
				else
					begin
						set @nVlr_Total_Item=@nVlr_Total_Item +  @Vlr_Total_Item
					end
				
				Fetch Next From Cur_VlrTotalItem Into @Vlr_Total_Item
			end
		close Cur_VlrTotalItem
		deallocate Cur_VlrTotalItem
	
	End

	return @nVlr_Total_Item
		
	END















GO
