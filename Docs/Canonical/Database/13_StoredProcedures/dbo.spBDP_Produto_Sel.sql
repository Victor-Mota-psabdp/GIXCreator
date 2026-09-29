SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBDP_Produto_Sel]
	@Nome_BDP_Produto as varchar(50)
as

select 
	ID_PD 
from 
	BDP_Produto 
where
	Nome_BDP_Produto = @Nome_BDP_Produto


GO
