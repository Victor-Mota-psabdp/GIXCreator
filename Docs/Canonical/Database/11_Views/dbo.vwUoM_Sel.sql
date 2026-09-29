SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UoM do Pedido
--Select distinct UoM from pedido_det where UoM is not null order by UoM
CREATE VIEW [dbo].[vwUoM_Sel]
AS
Select distinct UoM from pedido_det with(nolock) where (UoM is not null and UoM <>'')
-- order by UoM

GO
