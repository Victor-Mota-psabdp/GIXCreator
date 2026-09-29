SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--select dbo.fBusca_PedidoDet_PesoLiq('3218','362')

CREATE		FUNCTION fBusca_PedidoDet_PesoLiq
(
@Cd_Pedido	int,
@Cd_Produto	int
)
RETURNS Float
AS  
BEGIN 
	Declare @Resultado Float
	Declare @Acumulador Float

	Declare Cur_PED cursor for
			select 
				(sum(Qty)*Peso_Item) PESO
			from
				pedido_det
			Where
				cd_pedido=@Cd_Pedido and cd_produto=@Cd_Produto
			group by
				Peso_Item
----------------------------------------------------------------------------
		open Cur_PED
			Fetch Next From Cur_PED Into @Resultado
			While @@FETCH_STATUS = 0
			Begin
				if @Acumulador='' or @Acumulador is Null
					Begin
						Set @Acumulador=@Resultado
					end
				else
					begin
						set @Acumulador=@Acumulador + @Resultado
					end
				
				Fetch Next From Cur_PED Into @Resultado
			end
		close Cur_PED
		deallocate Cur_PED 

	If (select top 1 Peso_UOM from pedido_det where cd_pedido=@Cd_Pedido and cd_produto=@Cd_Produto) = 'LB'
	Begin
		Set @Acumulador = @Acumulador * 0.4536
	end

	return @Acumulador
	
END






GO
