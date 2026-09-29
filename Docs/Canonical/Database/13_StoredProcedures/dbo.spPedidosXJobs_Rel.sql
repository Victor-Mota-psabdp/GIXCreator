SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPedidosXJobs_Rel] --'car','2010-02-01', '2010-02-28'
(
@grupo varchar(3),
@dtinicial datetime,
@dtfinal datetime
)
as

declare @cd_pes varchar(10)

set @cd_pes = (select cd_pes_grupo from grupo with(nolock) where grupo=@grupo)

select 
      Num_Pedido, Dt_Pedido , isnull(num_proc,'') JOB
from 
      pedido P with(nolock)
      left join pedido_ship PS with(nolock) on PS.cd_pedido=P.cd_pedido
where 
      cd_grupo=@cd_pes and Dt_Pedido between @dtinicial and @dtfinal
order by
      Dt_Pedido

GO
