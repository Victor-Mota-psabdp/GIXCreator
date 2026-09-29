SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select convert(varchar(10),dt_leitura,103),dt_leitura ,* from PEDIDO_TEMP where num_pedido = '517531'  order by dt_insert desc
CREATE procedure [dbo].[spATL_Pedido_Temp_Sel]-- '2014-04-09','2014-04-10'
	@DataInicial datetime,
	@DataFinal datetime
	
AS
select
	num_pedido		[Order Reference],
	Seller			[Seller],
	Incoterm		[Incoterm],
	Produto			[Produto],	
	(case when Erro is Null then
		'Integrado'
		else
		'Não Integrado' end)[Status],
	isnull(Erro,'')[Erro] 
from PEDIDO_TEMP With(nolock)
	where 
--convert(varchar(10),dt_leitura,103) between convert(varchar(10),@dataInicial,103) and convert(varchar(10),@dataFinal,103)
		dt_leitura between @dataInicial and @dataFinal
GO
