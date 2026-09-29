SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select [dbo].[fPedido_Det_Temp_New_Vlr_Total_Item](16)

CREATE FUNCTION [dbo].[fPedido_Det_Temp_New_Vlr_Total_Item]
(
	@ID bigint
)
RETURNS float
AS  
	BEGIN 
		Declare @Vlr_Total_Item as float
		declare @nVlr_Total_Item as float

	Begin
		--select Vlr_Total_Item from Pedido_Det_Temp_New where Vlr_Total_Item is not null
		
		Declare Cur_VlrTotalItem cursor for 
			select 
				sum(convert(float,replace(PD.Vlr_Total_Item,',','.')))
			from
				Pedido_Det_Temp_New PD
			join Pedido_Temp_New P with(nolock) on PD.ID = P.ID
			where 
				P.ID = @ID and 
				PD.Vlr_Total_Item is not null
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
