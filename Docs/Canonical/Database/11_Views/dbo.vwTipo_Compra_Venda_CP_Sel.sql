SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Compra_Venda_CP_Sel]
AS
select 
	Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
from Tipo_Compra_Venda_CP T with(nolock)

GO
