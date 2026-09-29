SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwBDP_Produto_Sel]
AS

	select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
			ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
		from BDP_Produto T with(nolock)
		
--SELECT 
--	tp.ID_PD AS ID, 
--	tp.Nome_BDP_Produto AS Description
--FROM dbo.BDP_Produto AS tp 









GO
