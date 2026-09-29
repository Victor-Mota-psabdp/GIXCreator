SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spRateioDespachante_Rel 'IMSUN201203019BR'


CREATE procedure [dbo].[spRateioDespachante_Rel]  
	@JOB varchar(16)
as

	declare @Tab table (cd_tp_tx varchar(5), [Despesas - BDP] varchar(100), [Produto] varchar(100), [Cód. Produto] varchar(100), [Valor Realizado] float, [Valor Previsto] float )

	Begin
		insert @Tab -- Taxas da Custo_Cliente q tenham fatura e tirando os impostos
		select distinct C.cd_tp_tx, 
			T.nome_tp_tx [Despesas - BDP], produto_descr [Produto], PROD.cd_proc_cliente [Cód. Produto], convert(float,vlr_item_custo) [Valor Realizado], 
			Isnull((
					SELECT sum(valor*paridade) Valor from adiantamento_cliente AC with (nolock)
					Join adiantamento_cliente_Det ACD with(nolock) on ACD.id=AC.id
					Where
						num_proc=@JOB
						And ACD.cd_tp_Tx = C.cd_tp_Tx
						and conta = 'B'
					),0) --* dbo.fBuscaPorcentagem_CdProduto(@JOB,C.cd_produto) [Valor Previsto]
		from 
			custo_cliente C
			join tipo_taxa T with(nolock) on T.cd_tp_tx = C.cd_tp_tx
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = C.cd_produto
			join fatura_chb_item FCI with(nolock) on left(FCI.fatura_cc,16)=C.num_proc and FCI.cd_tp_tx = C.cd_tp_tx and FCI.tp_pgto = 'B'
		where 
			C.num_proc=@JOB	and C.cd_tp_tx NOT in 
			(select cd_tp_tx from tipo_taxa where /*nome_tp_tx like 'Adiant%' or*/ nome_tp_tx like '%Imp%Imp%' or nome_tp_tx like 'Adiant%' or 
				nome_tp_tx like '%Imp%Imp%' or	nome_tp_tx like 'IPI - CHB%' or nome_tp_tx like 'IPI Compl%' or nome_tp_tx like '%SISCOMEX%' or 
				nome_tp_tx like 'PIS%' or nome_tp_tx like 'Cofins%' or nome_tp_tx like 'IRRF%' or nome_tp_tx like 'CSLL%' or nome_tp_tx like 'IR s/ Armaz. e Transp' or
				(nome_tp_tx like 'ICMS%' and dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') = 0)
			)
				
		order by
			2,3
	End

	Begin
		declare @TabPREVISTO table (cd_tp_tx varchar(5), [Despesas - BDP] varchar(100), [Produto] varchar(100), [Cód. Produto] varchar(100), [Valor Realizado] float, [Valor Previsto] float )
		insert @TabPREVISTO -- Taxas que estao no Adiantamento, mas nao na Custo_Cliente
		select distinct -- Tirar o cartesiano causado pelo Lote/delivery note
			ACD.cd_tp_tx, TT.nome_tp_tx , produto_descr, PROD.cd_proc_cliente, 0, sum(valor*paridade) * dbo.fBuscaPorcentagem_CdProduto(PS.num_proc,PS.cd_produto)
		from
			Pedido_Ship PS with(nolock) 
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = PS.cd_produto
			join adiantamento_cliente AC with (nolock) on AC.num_proc = PS.num_proc
			Join adiantamento_cliente_Det ACD with(nolock) on ACD.id=AC.id
			Join Tipo_taxa TT with (nolock) on tt.cd_tp_tx=ACD.cd_tp_Tx
		Where
			PS.num_proc=@Job and conta = 'B' and ACD.cd_tp_tx NOT in (select cd_tp_tx from @Tab)
			--Estava comentado em 14/05/2012, retirado o comentário "--and ACD.cd_tp_tx NOT in (select cd_tp_tx from @Tab)"
		group by
			PS.num_proc, TT.nome_tp_tx , produto_descr, PROD.cd_proc_cliente,PS.cd_produto,ACD.cd_tp_tx, PS.lote
		order by
			2,3
	End

	Begin
		insert @Tab
		select cd_tp_tx, [Despesas - BDP], [Produto], [Cód. Produto], [Valor Realizado] , (select sum([Valor Previsto]) from @TabPREVISTO where cd_tp_tx = T.cd_tp_tx ) [Valor Previsto] from @TabPREVISTO T
	End

	Begin 
		insert @Tab -- Taxas de Adiantamento da Custo_Cliente
		select
			C.cd_tp_tx, T.nome_tp_tx, produto_descr , PROD.cd_proc_cliente , 0, convert(float,vlr_item_custo)
		from 
			custo_cliente C
			join tipo_taxa T with(nolock) on T.cd_tp_tx = C.cd_tp_tx
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = C.cd_produto
		where 
			num_proc = @JOB and T.nome_tp_tx like 'Adiant%'
		order by
			2,3
	End

	select [Despesas - BDP] Taxa, [Cód. Produto] Prod, [Valor Realizado] vlrRealizado, [Valor Previsto] vlrPrevisto from @Tab






GO
