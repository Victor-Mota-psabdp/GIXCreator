SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spPedidoItem_Sel
	
	@Buyer 	    	VarChar(20),
	@Seller		varchar(20)

AS

select 
	Num_Pedido
from 
	pedido
	Join Pessoa BB on BB.cd_pes=cd_buyer
	Join Pessoa SS on SS.cd_pes=cd_seller
Where
	bb.apelido like @buyer and ss.apelido like @seller

	




GO
