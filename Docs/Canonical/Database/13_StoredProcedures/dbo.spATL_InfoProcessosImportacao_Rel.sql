SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spATL_InfoProcessosImportacao_Rel]--[spATL_InfoProcessosImportacao_Rel] 'Grupo FMC','2012-04-01','2012-04-30'

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)

	set @grupo = (select grupo from grupo with(nolock) where cd_pes_grupo = @cd_pes_grupo)

select
	P.num_pedido														[PO],
	PD.Item																[ITEM],
	left(datename(month,T13.dt_conclusao),3)+ '/' + datename(year,T13.dt_conclusao)	[Mês de Entrada],
	PC.cd_proc_cliente													[Item],
	PC.Produto_Descr													[Descrição],
	PS.qty																[pc],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%FOB%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido) 	[Fatura FOB],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Frete%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido) [Frete Internacional],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Seguro%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[Seguro],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Imposto de Importa%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[Impostos],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[Frete Nacional],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%')*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[Armazenagem],
	dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Siscomex%') + dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%VALOR DOS ACRÉSCIMOS (DI)%')[Outras Despesas NFE],
	dbo.fCalculoNFC(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto)*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)  [Outras Despesas NFC],
	(dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%FOB%') + dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Frete%')+dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Seguro%')+dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Imposto de Importa%')+dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%')+dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%')+dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%Siscomex%') + dbo.fBusca_Custo(Ps.num_proc,PS.CD_Pedido, PS.Cd_Produto,'%VALOR DOS ACRÉSCIMOS (DI)%'))*[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	 [Total],
	[dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido) [%]
from
	pedido_ship PS				with(nolock)
	Join Produto_Cliente PC		with(nolock) on PC.cd_prod=Ps.cd_produto
	Join Pedido_DET PD			with(nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido and PS.item = PD.Item
	Join Pedido P				with(nolock) on P.cd_pedido=PS.cd_pedido	
	left join tarefas_processos T13 with(nolock) on T13.num_proc = Ps.num_proc and id_task = 13
	join llp_imp_mar LIM		with(nolock)on LIM.num_proc_lim = Ps.num_proc

where
	dt_conclusao between @DtInicial and @DtFinal
	and right(left(PS.num_proc,5),3) = @grupo
	AND ISNULL(LIM.ID_STATUS,0) <> 9
	




GO
