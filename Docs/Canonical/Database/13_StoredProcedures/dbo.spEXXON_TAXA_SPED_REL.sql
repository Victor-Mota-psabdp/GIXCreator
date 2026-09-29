SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[spEXXON_TAXA_SPED_REL]-- '2018-01-01','2018-12-12'
	--@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	
AS
select 
	p.Num_CPF_CNPJ									[Planta],
	YEAR(TP4.Dt_Conclusao)							[Ano],
	MONTH(TP4.Dt_Conclusao)							[Mês],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')		[DI],
	dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5')		[Data],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')		[Nº PO],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')		[DANFE],
	dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5')		[Emissão],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Cód.SAP],
	PC.Produto_Descr								[Descrição],
	dbo.fNCM(HOU.Num_Proc)							[NCM],
	--NFD.CIF											[Valor Aduaneiro],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%FOB CHARGES%') [Valor Aduaneiro],
	--NFD.VL_BASE_II												[Base Calculo II],
	--NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + Vlr_Siscomex 	[Despesas Acessorias],
	--NFD.VL_BASE_IPI												[Base IPI],
	--NFD.VL_BASE_II	+ NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + Vlr_Siscomex + NFD.VL_BASE_IPI [Total DANFE],
	(case when NFD.CIF IS NULL  then
		NFD.VL_IPI  + NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + NFD.Vlr_Siscomex
	Else
	(Case when NFD.CIF is not null then
		NFD.CIF + NFD.VL_IPI  + NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + NFD.Vlr_Siscomex end)end) [Total DANFE],	
	--Soma do Base Calculo II + Despesas Acessórias + Valor do IPI 
	--NFD.VL_BASE_PIS												[PIS],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%PIS%') [PIS],
	--NFD.VL_IMPOSTO_COFINS										[COFINS],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%COFINS%') [COFINS],
	--NFD.VL_II													[I.I.],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%imposto de importacao%') [I.I.],
	NFD.VL_BASE_ICMS											[B.C.ICMS],
	HOU.Peso_Liquido											[QTD/KG],
	--NFD.VL_BASE_ICMS											[ICMS],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%icms%') [ICMS],
	--NFD.VL_BASE_IPI												[IPI],
	dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%IPI%') [IPI],
	HOU.Vessel													[Embarcação],
	HOU.Num_Proc												[JOB]

from vwhouse_imp HOU					with(nolock)
Left join Pedido_Ship PS				with(nolock) on HOU.num_proc = PS.Num_Proc
Left join Produto_Cliente PC			with(nolock) on PS.cd_produto = PC.cd_prod 
Left join Nota_Fiscal_Cliente_Det NFD	with(nolock) on PS.cd_produto = NFD.Cd_Produto and PS.cd_pedido = NFD.Cd_Pedido
Left Join Tarefas_Processos TP4			with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Left Join Pessoa P						with(nolock) on HOU.Cd_Consig = P.Cd_Pes
Left join Pessoa_LLP	PL				with(nolock) on HOU.Cd_Consig = PL.Cd_Pes
Left Join  Grupo		G				with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
Left Join  pessoa		PG				with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
where	
	--HOU.Num_Proc = 'IMEXO201712008BR'	and 
	TP4.dt_conclusao between @DtInicial and @DtFinal
	and PG.Apelido = 'Grupo Exxon'
	--and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
order by TP4.dt_conclusao

GO
