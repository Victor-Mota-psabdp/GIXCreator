SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from vwHouse_Imp where Num_Proc = 'IMSWB201907088BR'
--select * from Tarefas_Processos where Num_Proc = 'IMSWB201907088BR' and ID_Task = '4'
--convert(Datetime,HOU.dt_emis,105) 
--select * from report where Stored like '%Dados_Mensais%'
--select * from Pessoa where Cd_Pes = 'P000031841'
--select * from Pessoa_LLP where Cd_Pes = 'P000031841'
--select * from Pessoa where Cd_Pes = 'P000031844'
--[spReport_SWB_Custos_REL] 'IMSWB201907088BR'
--select * from Tipo_Campo_Cliente where Descr_Campo like	'%serie%'
--select * from Pessoa where Cd_Pes in ('P000000450','P000003779','P000004208','P000006403','P000031844','P21128')
--select * from Campo_Processo where Id_Campo = '112'

--Se frete inter. Collect = (frete da DI R$ + Capatazias R$); Se frete inter. prepaid = capatazias R$
--spReport_SWB_Custos_REL 'IMSWB201905074BR'
--select * from Solicitacao_LI where Num_Proc = 'IMSWB201905074BR'
--select * from Solicitacao_LI_Produto where Num_Solicitacao= 'SLI2019070444'
--select * from Pedido_Ship where Num_Proc= 'IMSWB201907088BR'
--[spReport_SWB_Custos_REL]'IMSWB201905074BR'
CREATE PROCEDURE  [dbo].[spReport_SWB_Custos_REL]--'IMSWB201905074BR'
	@Num_Proc varchar(16)

AS	


declare @TAB table
	(
		[BDP Ref.]			varchar(16),
		[Ref]				varchar(200),
		[Nº NF]				varchar(200),--Nota fiscal na aba referências do cliente do job
		[Serie]				varchar(200),--Série da NF (a ser criada) na aba referência do cliente do job	
		[Dt Emissão]		varchar(200),--Data da NF na aba referências do cliente do job	
		[nº]				varchar(200),--Sequência do item  na aba Order Items do  Order Management	
		[Pais]				varchar(200),--Origin Country do Order Management	
		[Moeda]				varchar(200),--Invoice currency da aba Ref. Adicionais do job	
		[Tx. Dolar]			varchar(200),--Paridade Dolar DI  dos campos adicionais do job
		[Vlr Siscomex]				float,--Taxa Siscomex CHB da aba custos do job
		[Vlr Origem/]				float,--Total Price da aba Order Items do Order Management	
				
		[Incoterm]					varchar(200),--Incoterm da aba Ref. Adicionais do job
		[Moeda Reintegra]			varchar(200),--Invoice currency da aba Ref. Adicionais do job	
		[Moeda Frete Reintegra]		varchar(200),--Moeda do frete da aba BL do job		
		[Moeda Seguro Reintegra]	varchar(200),--Invoice currency da aba Ref. Adicionais do job
		[Cd Material]				varchar(200),--Product ID da aba Order Items do Order Management
		[Cd Transportadora]			varchar(200),--Checar em Ref. Adicionais qual é o Inland Trucker e então considerar:
		
		[Tx. II]					float,--Aliq. II de Itens da página Nota Fiscal	
		[Vlr CIF/VA]				float,--Base Cof da pág Nota Fiscal/Itens.
		[Vlr Seguro]				float,--Seguro da pág Nota Fiscal/tens
		[Vlr II]					float,--II da pág Nota Fiscal/Itens	
		[Vlr Frete Reintegra]		float,--Valor Frete da pág. Nota Fiscal/Itens	
		[Vlr Seguro Reintegra]		float,--Seguro da pág Nota Fiscal/Itens
		
		
		[Nº NFServiço]				varchar(200),--BDP NF  da aba referências do cliente do job
		[Vlr Despesas]				float,--Buscar na planilha 2, rateando pelo valor coluna Y.
		[Vlr Frete Local Capatazias] float, --Checar na aba BL do job o tipo de frete.
											--Se frete colletct, pegar frete pág Nota Fiscal/Itens e somar com 
											--o THC-CHB da aba conta corrente do job rateada por item.
											--Se frere prepaid, considerar apenas o THC-CHB rateado por item.
		[Vlr AFRMM] float,
		
		CD_Pedido int, 
		Cd_Produto int,
		
		[Ato Concessório]			varchar(200),
		[SLP_Cd_Produto]			int,
		[THC-CHB]					float,
		[Frete_BL]					varchar(200),
		[Tipo_Frete]				varchar(200)


)	


insert into
	@TAB (
			[BDP Ref.],
			[Ref],
			[Nº NF],--Nota fiscal na aba referências do cliente do job
			[Serie],--Série da NF (a ser criada) na aba referência do cliente do job	
			[Dt Emissão],--Data da NF na aba referências do cliente do job	
			[nº],--Sequência do item  na aba Order Items do  Order Management	
			[Pais],--Origin Country do Order Management	
			[Moeda],--Invoice currency da aba Ref. Adicionais do job	
			[Tx. Dolar],--Paridade Dolar DI  dos campos adicionais do job
			[Vlr Siscomex],--Taxa Siscomex CHB da aba custos do job
			[Vlr Origem/],--Total Price da aba Order Items do Order Management	
			[Incoterm],--Incoterm da aba Ref. Adicionais do job	
			[Moeda Reintegra],--Invoice currency da aba Ref. Adicionais do job
			[Moeda Frete Reintegra],--Moeda do frete da aba BL do job		
			[Moeda Seguro Reintegra],--Invoice currency da aba Ref. Adicionais do job
			--[Cd Material],--Deixar em branco
			--[Cd Transportadora],--Deixar em branco
			CD_Pedido, 
			Cd_Produto,
			[Nº NFServiço],
			[Ato Concessório],
			[SLP_Cd_Produto],
			[Frete_BL],	[Tipo_Frete]
		)
		select
			HOU.Num_Proc,
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Ref],	
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')		[Nº NF],
			CP112.Campo_Dados								[Serie],			
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		[Dt Emissão],
			PS.Item											[nº],
			Origin.Nome_Pais								[Pais],
			P.cd_tp_moeda									[Moeda],
			replace(CP31.Campo_Dados,'.',',')				[Tx. Dolar],
			CCXAD.Vlr_Item_Custo * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido) [Vlr Siscomex],
			PD.Vlr_Total_Item								[Vlr Origem/],		
			hou.Cd_Tp_Oper									[Incoterm],
			hou.Moeda_invoice								[Moeda Reintegra],
			hou.Moeda_Frete									[Moeda Frete Reintegra],
			hou.Moeda_invoice								[Moeda Seguro Reintegra],
			--PC.cd_Proc_Cliente								[Cd Material], 
			--PLL.Cd_Vendor									[Cd Transportadora],
			PS.cd_pedido,
			PS.cd_produto,
			NF.RPS_NFE,
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'24')		[Ato Concessório],
			SLP.Cd_Produto [SLP_Cd_Produto],
			Frete_BL,Tipo_Frete
		from vwHouse_Imp HOU with(nolock)
			Left Outer Join Campo_Processo CP31	with(nolock) on HOU.Num_Proc = CP31.Num_Proc AND CP31.Id_Campo = '31' 
			Left Outer Join Campo_Processo CP112	with(nolock) on HOU.Num_Proc = CP112.Num_Proc AND CP112.Id_Campo = '112' 
			Left Join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			left Join Pedido_Det PD	 with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
			left Join Pedido P	with(nolock) on PD.cd_pedido = P.Cd_pedido
			left Join Pais Origin with(nolock) on Origin.Cd_Pais = P.Cd_Pais_Org
			--left Join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod		
			Left Outer Join Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' 
				and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto				
			--Left Outer Join Pessoa_LLP PLL	with(nolock) on HOU.Cd_Transportadora = PLL.Cd_Pes
			Left Join vwcta_cte cta on cta.num_proc_hia=HOU.num_proc and cta.dc_hia='C' and cta.cd_tp_tx='SRV'
			Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia	
			
			Left Join Solicitacao_LI SLI with(nolock) on HOU.Num_Proc = SLI.Num_Proc
			Left Join Solicitacao_LI_Produto SLP with(nolock) on SLI.Num_Solicitacao = SLP.Num_Solicitacao and PS.cd_produto = slp.Cd_Produto
		where 
			HOU.Num_Proc=@Num_Proc -- 'IMSWB201907088BR'

	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			[Tx. II] = ALIQ_II,	
			[Vlr CIF/VA] = vl_base_cofins,
			[Vlr Seguro] = vlr_seguro,
			[Vlr II] = vl_II,
			[Vlr Frete Reintegra]= vlr_frete,
			[Vlr Seguro Reintegra] = vlr_seguro			
		from 
			@TAB T
			join
				(Select 
					ALIQ_II ALIQ_II,
					vl_base_cofins	 vl_base_cofins,
					vlr_seguro vlr_seguro,
					vl_II vl_II,
					vlr_frete vlr_frete,--vlr_seguro vlr_seguro,
					Num_Proc,Cd_Produto						
				from nota_fiscal_cliente_det NFCD
				join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				group by 
					ALIQ_II,vl_base_cofins,vl_II,vlr_frete,vlr_seguro
					,Cd_Produto,num_proc
			) A on A.num_proc = T.[BDP Ref.] and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End

	
	--	[Vlr Despesas]				float,--Trazer a somatória por item do detalhamento das depesas
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set	
			[Vlr AFRMM] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[THC-CHB] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%THC%CHB%')
	End
	
		--[Drawnback] varchar(200),--Drawback - Para os itens com solicitação de LI 
		--e que tenha referências do cliente o item 024 - Drawback - ato concessório)
		--se não for drawback = 0,00, se for = 1
	
	
	--	[Vlr Frete Local Capatazias] float,Se frete collect, 
	--pegar frete da Nota Fiscal no ATL/Itens e somar com o THC-CHB da aba custo do Job rateada por item.
	--Se frere prepaid, considerar apenas o THC-CHB rateado por item."
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update 
			@TAB
		set		
		[Vlr Frete Local Capatazias] = (CASE WHEN Tipo_Frete = 'PREPAID' THEN 
													[THC-CHB] ELSE 
										(CASE WHEN Tipo_Frete = 'COLLECT'  THEN 
									[Vlr Frete Reintegra] + [THC-CHB] 	ELSE NULL END)END)
	End



	Begin
		
		DECLARE @Vlr_Despesas float
		DECLARE @NOTA_FISCAL VARCHAR(30)
		DECLARE @Ref_Acesso VARCHAR(1)

		--Update com base na CUSTO_CLIENTE
		select @Vlr_Despesas =			
		SUM(
		--[Liberação de BL] -- CCXAG
		ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Liberação de BL 1 - CHB%'),0)
		--[Desconsolidação] -- CCXAF
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Desconsolidação - CHB%'),0)
		--[Armazenagem] -- CCXAH
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Armazenagem 1 - CHB%'),0)
		--[AFRMM] -- CCXAM
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM - CHB%'),0)
		--[Inspeção de Madeira]-- CCXAT
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Inspeção de Madeira - CHB%'),0)
		--[Transp. Rodoviário] -- CCXTM
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Transporte Mercadoria - CHB%'),0)
		--[Capatazias (Dif cambial)]
		-- null
		--[Lavagem de container] - CCXLN
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Lavagem CNTR 1 - CHB%'),0)
		--[Despesas c/ LI] - CCXAU
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%LI - CHB%'),0)
		--[Frete Internacional (Dif cambial)] - CCYDI
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Frete (consta na DI)%'),0)
		-- [Taxa SISCOMEX] - CCXAD
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Taxas Siscomex - CHB%'),0)
		
	
		--[OUTROS] = [Impostos] + ([VALOR DOS ACRÉSCIMOS (DI)] -[THC - CHB])
		--([VALOR DOS ACRÉSCIMOS (DI)] -[THC - CHB])
		+	(
			--[VALOR DOS ACRÉSCIMOS (DI)]
			ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%VALOR DOS ACRÉSCIMOS (DI)%'),0)
			--[THC - CHB]
			-ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%THC - CHB%'),0)
			)

		--[Impostos não creditados (IPI / PIS / COFINS)] - CCXAB
		+ISNULL(dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%IPI - CHB%'),0)
		)
		FROM @TAB T



		SELECT @NOTA_FISCAL = (select distinct Numero from [dbo].[vwFaturasValidasArg] where Num_Proc = @Num_Proc and Cd_Tp_Tx in ('BRO','srv'))
		SELECT @Ref_Acesso = (select distinct Ref_Accesso_Arg from [dbo].[vwFaturasValidasArg] where Num_Proc = @Num_Proc and Cd_Tp_Tx in ('BRO','srv'))		

		--[Comissão Despachante]
		select @Vlr_Despesas = 
		@Vlr_Despesas
		+ISNULL((select SUM(Valor_Org) 
		from [dbo].[vwFaturasValidasArg] 
		where Num_Proc = @Num_Proc 
		and Numero =@NOTA_FISCAL 
		and Ref_Accesso_Arg =@Ref_Acesso),0)

		
		--[OUTROS] = [Impostos] + ([VALOR DOS ACRÉSCIMOS (DI)] -[THC - CHB])
		--[Impostos]
		select @Vlr_Despesas = 
		@Vlr_Despesas
		+  (SELECT SUM(ISNULL(C01.Vlr_Org_HIA,0)) FROM vwcta_cte C01	with(nolock) WHERE C01.num_proc_hia=@Num_Proc and C01.dc_hia='D' and C01.cd_tp_tx = 'C01')
		+  (SELECT SUM(ISNULL(CF1.Vlr_Org_HIA,0)) FROM vwcta_cte CF1	with(nolock) WHERE CF1.num_proc_hia=@Num_Proc and CF1.dc_hia='D' and CF1.cd_tp_tx = 'CF1')
		+  (SELECT SUM(ISNULL(IRR.Vlr_Org_HIA,0)) FROM vwcta_cte IRR	with(nolock) WHERE IRR.num_proc_hia=@Num_Proc and IRR.dc_hia='D' and IRR.cd_tp_tx = 'IRR')
		+  (SELECT SUM(ISNULL(P01.Vlr_Org_HIA,0)) FROM vwcta_cte P01	with(nolock) WHERE P01.num_proc_hia=@Num_Proc and P01.dc_hia='D' and P01.cd_tp_tx = 'P01')
	
		DECLARE @sum_Vlr_CIF DECIMAL(20,2)
		SELECT @sum_Vlr_CIF = (SELECT SUM([Vlr CIF/VA]) FROM @TAB)

		Update 
			@TAB
		set		
		[Vlr Despesas] = ROUND(@Vlr_Despesas * ( [Vlr CIF/VA] / @sum_Vlr_CIF),2)
End




	
	select
		[Ref],''[Filial],[Nº NF],[Serie],''[Dt Entrada],
		convert(datetime,[Dt Emissão],103)[Dt Emissão],
		''[Cd Fornecedor],[nº],[Pais],
		(case when [Ato Concessório] is not null and [SLP_Cd_Produto]  is not null then '1' else '0' end) [Drawnback],
		[Moeda],[Tx. Dolar],
		''[Produtivo Improdutivo],
		
		(case when [Ato Concessório] is not null and [SLP_Cd_Produto]  is not null then [Ato Concessório] else '' end) [Ato Concessório],
		[Nº NFServiço],''[Cd Despachante],
		''[Vlr CIF abatido de ICMS?],
		(case when [Ato Concessório] is not null and [SLP_Cd_Produto]  is not null then null else convert(varchar(10),convert(int,[Tx. II])) + '%' end) [Tx. II],
		--convert(varchar(10),convert(int,[Tx. II])) + '%' [Tx. II],
		[Vlr Frete Local Capatazias] ,
		0 [Vlr Frete Marítimo],[Vlr Siscomex],[Vlr Despesas],[Vlr Origem/],[Vlr CIF/VA],
		[Vlr Seguro],[Vlr II],
		
		(case when [Ato Concessório] is not null and [SLP_Cd_Produto]  is not null then 
			convert(varchar(10),convert(int,[Tx. II])) + '%' 
		else '' end)  [Tx. II Drawnback],
		--convert(varchar(10),convert(int,[Tx. II])) + '%' [Tx. II Drawnback],
		(case when [Ato Concessório] is not null and [SLP_Cd_Produto]  is not null then 
			'Preenchimento Manual' 
		else '' end)  [Vlr II Drawnback],
		--''[Vlr II Drawnback],
		[Vlr AFRMM],[Incoterm],
		[Moeda Reintegra],[Vlr Frete Reintegra],[Moeda Frete Reintegra],[Vlr Seguro Reintegra],[Moeda Seguro Reintegra],
		[Cd Material],[Cd Transportadora]
		
		--,[Ato Concessório], [SLP_Cd_Produto]
	from @tab
	order by [nº]
	
		--[Vlr AFRMM]					float,--Incluir o valor da aba custo AFRMM.
		--[Vlr Frete Marítimo]		float,--sempre = zero
		--[Ato Concessório]			varchar(200),--Manter coluna vazia (será preenchida pelo cliente)
		--[Produtivo Improdutivo]	varchar(200),--Manter coluna vazia (será preenchida pelo cliente)
		--[Cd Fornecedor]		varchar(200),--Manter coluna vazia (será preenchida pelo cliente)	
		--[Dt Entrada]		varchar(200),--Manter coluna vazia (será preenchida pelo cliente)	
		--[Filial]			varchar(200),--Manter coluna vazia (será preenchida pelo cliente)	
		--[Cd Despachante]			varchar(200),--Manter coluna vazia (será preenchida pelo cliente)
		--[Vlr CIF abatido de ICMS?]	varchar(200),--Manter coluna vazia (será preenchida pelo cliente)
		--[Tx. II Drawnback]			float,--Manter coluna vazia (será preenchida pelo cliente)
		--[Vlr II Drawnback]			float,--Preenchimento manual, pois a informação não sobe para o ATL.
		

GO
