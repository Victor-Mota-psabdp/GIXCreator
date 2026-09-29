SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spNFToNota_Cliente_PorcentagemPedido_Sel]

		@Num_Proc	Varchar(16),
		@Cd_Produto int

AS

Declare @TotalQty Float

Set @TotalQty=(select sum(ps.qty) from pedido_ship PS where num_proc=@num_proc and cd_produto=@cd_produto)
if @TotalQty=0 
	begin
		set @TotalQty=1
	end
Select cd_pedido, sum(ps.qty)/@TotalQty Porcentagem from pedido_ship PS
Where num_proc=@Num_Proc and cd_produto=@cd_produto
group by cd_pedido






GO
