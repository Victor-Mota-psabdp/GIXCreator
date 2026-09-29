SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view vwUltimaParidade

as

select * from paridade with(nolock)
where convert(Datetime,dt_par,105) =(select top 1 convert(datetime,dt_par,105) from paridade with(nolock) order by 1 desc )
GO
