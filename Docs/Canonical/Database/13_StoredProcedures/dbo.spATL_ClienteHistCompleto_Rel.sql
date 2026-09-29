SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_ClienteHistCompleto_Rel 'Grupo Givaudan', '2015-06-01','2015-06-05'
CREATE procedure [dbo].[spATL_ClienteHistCompleto_Rel]
(
	@NomeGrupo varchar(50),
	@DataInicial Datetime,
	@DataFinal Datetime
)
as

Declare @Cd_Pes_Grupo varchar(10)

set @Cd_Pes_Grupo =(select cd_Pes from pessoa with (nolock) where apelido = @NomeGrupo)
 print @Cd_Pes_Grupo

select 
	VWC.num_proc [JOB], REPLACE(dbo.FHistoricoLinhas(VWC.num_proc),';', CHAR(10)) [Hist. Completo]
from 
vwCliente VWC  with (nolock)
join Pessoa_LLP PLLP with (nolock)on VWC.cd_cliente = PLLP.Cd_Pes and PLLP.Cd_Pes_Grupo = @Cd_Pes_Grupo
join Pedido_Ship PS with (nolock) on VWC.num_proc = PS.Num_Proc
join Pedido PD with (nolock) on PS.cd_pedido = PD.Cd_pedido
Where 
	 PD.Dt_Pedido between @DataInicial and @DataFinal 
group by VWC.num_proc
OPTION(HASH JOIN)
--order by hsgdata desc

GO
