SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spPedidoDouble_Sel]
	@pedido		varchar(20),
	@Buyer 	    VarChar(20),
	@Seller		varchar(20)

AS

select 
	*
from 
	pedido
	Join Pessoa BB on BB.cd_pes=cd_buyer
	Join Pessoa SS on SS.cd_pes=cd_seller
Where
	bb.apelido like @buyer and ss.apelido like @seller and num_pedido = @pedido
GO
