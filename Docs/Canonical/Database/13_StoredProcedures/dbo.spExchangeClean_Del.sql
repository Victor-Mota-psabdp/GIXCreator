SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spExchangeClean_Del
As

delete exchange where excid in (
select top 10000 excid   from exchange with(nolock) where ExcDataAlt <=getdate()-120 order by 1 
)

GO
