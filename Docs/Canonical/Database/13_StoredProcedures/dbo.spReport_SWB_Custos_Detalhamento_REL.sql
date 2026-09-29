SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spReport_SWB_Custos_Detalhamento_REL]'IMSWB201905074BR'
--select * from Custo_Cliente where Num_Proc = 'IMSWB201905074BR'
CREATE PROCEDURE  [dbo].[spReport_SWB_Custos_Detalhamento_REL]--'IMSWB201905074BR'
	@Num_Proc varchar(16)

AS	


declare @TAB table
	(
		[BDP Ref.]				varchar(16),
		[Ref]					varchar(200),
		[Liberação de BL]		float,--	
		[Desconsolidação]		float,--
		[Armazenagem]			float,--
		[AFRMM]					float,--
		[Inspeção de Madeira]		float,--	
		[Transp. Rodoviário]		float,--		
		[Capatazias (Dif cambial)]			float,--
		[Lavagem de container]				float,--
		[Despesas c/ LI]					float,--
		[Outras despesas]					float,--
		--[SDA]								float,--
		[Frete Internacional (Dif cambial)]	float,--	
		[Taxa SISCOMEX]						float,--
		
		[Dif. Imposto Acrescimo (1%)]	float,--
		[Comissão Despachante]				float,--
		[OUTROS]							float,--
		[Impostos não creditados (IPI / PIS / COFINS)]	float,--	
		[Total]						float,--	
		
		CD_Pedido int, 
		Cd_Produto int,
		[Frete_BL]					varchar(200),
		[Tipo_Frete]				varchar(200),
		[Vlr Frete Reintegra]		float,
		[ALIQ_COFINS]				float,
		[Nota_Fiscal]				varchar(200),	
		[Ref_Acesso]				varchar(200),
		[Impostos]					float,
		--[C01]					float,
		--[CF1]					float,
		--[IRR]					float,
		--[P01]					float,
		[VALOR DOS ACRÉSCIMOS (DI)]	float,
		[THC - CHB]					float
)	


insert into
	@TAB (
			[BDP Ref.],
			[Ref],		
			[Frete_BL],	[Tipo_Frete],			
			[Liberação de BL],[Desconsolidação],[Armazenagem],[AFRMM],
			[Inspeção de Madeira],[Transp. Rodoviário],[Capatazias (Dif cambial)],
			[Lavagem de container],[Despesas c/ LI]	,[Outras despesas],
			[Frete Internacional (Dif cambial)]	,
			[Taxa SISCOMEX],[Impostos não creditados (IPI / PIS / COFINS)],
			[Impostos],[VALOR DOS ACRÉSCIMOS (DI)],[THC - CHB]
			--,			[C01],[CF1],[IRR],[P01]
		)
		select
			HOU.Num_Proc,
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Ref],				
			Frete_BL,Tipo_Frete,
			sum(CCXAG.Vlr_Item_Custo)						[Liberação de BL] ,
			sum(CCXAF.Vlr_Item_Custo)						[Desconsolidação],
			sum(CCXAH.Vlr_Item_Custo)						[Armazenagem],
			sum(CCXAM.Vlr_Item_Custo)						[AFRMM],
			sum(CCXAT.Vlr_Item_Custo)						[Inspeção de Madeira],
			sum(CCXTM.Vlr_Item_Custo)						[Transp. Rodoviário],
			NULL												[Capatazias (Dif cambial)],
			sum(CCXLN.Vlr_Item_Custo)						[Lavagem de container],
			sum(CCXAU.Vlr_Item_Custo)						[Despesas c/ LI],
			NULL												[Outras despesas],
			sum(CCYDI.Vlr_Item_Custo)						[Frete Internacional (Dif cambial)],
			sum(CCXAD.Vlr_Item_Custo)						[Taxa SISCOMEX],
			sum(CCXAB.Vlr_Item_Custo)						[Impostos não creditados (IPI / PIS / COFINS)],
			C01.Vlr_Org_HIA+CF1.Vlr_Org_HIA	+IRR.Vlr_Org_HIA+P01.Vlr_Org_HIA	[Impostos],
			
			sum(CCXDU.Vlr_Item_Custo)						[VALOR DOS ACRÉSCIMOS (DI)],
			sum(CCXTH.Vlr_Item_Custo)						[THC - CHB]
			--C01.Vlr_Org_HIA							[C01],
			--CF1.Vlr_Org_HIA							[CF1],
			--IRR.Vlr_Org_HIA							[IRR],
			--P01.Vlr_Org_HIA							[P01]				
		from vwHouse_Imp HOU with(nolock)
			Left Join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			left Join Pedido_Det PD	 with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
			left Join Pedido P	with(nolock) on PD.cd_pedido = P.Cd_pedido					
			Left Outer Join Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' 
				and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto	
			LEFT JOIN Custo_Cliente CCXAG with(nolock)on HOU.Num_Proc = CCXAG.Num_Proc and CCXAG.Cd_tp_tx = 'XAG' 
				and CCXAG.Cd_Pedido = PS.Cd_pedido and CCXAG.Cd_Produto = PS.cd_produto
			LEFT JOIN Custo_Cliente CCXAF with(nolock)on HOU.Num_Proc = CCXAF.Num_Proc and CCXAF.Cd_tp_tx = 'XAF' 
				and CCXAF.Cd_Pedido = PS.Cd_pedido and CCXAF.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAH with(nolock)on HOU.Num_Proc = CCXAH.Num_Proc and CCXAH.Cd_tp_tx = 'XAH' 
				and CCXAH.Cd_Pedido = PS.Cd_pedido and CCXAH.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAM with(nolock)on HOU.Num_Proc = CCXAM.Num_Proc and CCXAM.Cd_tp_tx = 'XAM' 
				and CCXAM.Cd_Pedido = PS.Cd_pedido and CCXAM.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAT with(nolock)on HOU.Num_Proc = CCXAT.Num_Proc and CCXAT.Cd_tp_tx = 'XAT'
				and CCXAT.Cd_Pedido = PS.Cd_pedido and CCXAT.Cd_Produto = PS.cd_produto 
			LEFT OUTER JOIN Custo_Cliente CCXTM with(nolock)on HOU.Num_Proc = CCXTM.Num_Proc and CCXTM.Cd_tp_tx = 'XTM'
				and CCXTM.Cd_Pedido = PS.Cd_pedido and CCXTM.Cd_Produto = PS.cd_produto 
			LEFT OUTER JOIN Custo_Cliente CCXLN with(nolock)on HOU.Num_Proc = CCXLN.Num_Proc and CCXLN.Cd_tp_tx = 'XLN'
				and CCXLN.Cd_Pedido = PS.Cd_pedido and CCXLN.Cd_Produto = PS.cd_produto 
			LEFT OUTER JOIN Custo_Cliente CCXAU with(nolock)on HOU.Num_Proc = CCXAU.Num_Proc and CCXAU.Cd_tp_tx = 'XAU'
				and CCXAU.Cd_Pedido = PS.Cd_pedido and CCXAU.Cd_Produto = PS.cd_produto 
			LEFT OUTER JOIN Custo_Cliente CCYDI with(nolock)on HOU.Num_Proc = CCYDI.Num_Proc and CCYDI.Cd_tp_tx = 'YDI' 
				and CCYDI.Cd_Pedido = PS.Cd_pedido and CCYDI.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAB with(nolock)on HOU.Num_Proc = CCXAB.Num_Proc and CCXAB.Cd_tp_tx = 'XAB' 
				and CCXAB.Cd_Pedido = PS.Cd_pedido and CCXAB.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXDU with(nolock)on HOU.Num_Proc = CCXDU.Num_Proc and CCXDU.Cd_tp_tx = 'XDU' 
				and CCXDU.Cd_Pedido = PS.Cd_pedido and CCXDU.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXTH with(nolock)on HOU.Num_Proc = CCXTH.Num_Proc and CCXTH.Cd_tp_tx = 'XTH' 
				and CCXTH.Cd_Pedido = PS.Cd_pedido and CCXTH.Cd_Produto = PS.cd_produto
			
			LEFT OUTER JOIN vwcta_cte C01	with(nolock)on C01.num_proc_hia=HOU.num_proc and C01.dc_hia='D' and C01.cd_tp_tx = 'C01'
			LEFT OUTER JOIN vwcta_cte CF1	with(nolock)on CF1.num_proc_hia=HOU.num_proc and CF1.dc_hia='D' and CF1.cd_tp_tx = 'CF1'
			LEFT OUTER JOIN vwcta_cte IRR	with(nolock)on IRR.num_proc_hia=HOU.num_proc and IRR.dc_hia='D' and IRR.cd_tp_tx = 'IRR'
			LEFT OUTER JOIN vwcta_cte P01	with(nolock)on P01.num_proc_hia=HOU.num_proc and P01.dc_hia='D' and P01.cd_tp_tx = 'P01'

		where 
			HOU.Num_Proc=@Num_Proc -- 'IMSWB201907088BR'
		group by
			HOU.Num_Proc,Frete_BL,Tipo_Frete,C01.Vlr_Org_HIA,CF1.Vlr_Org_HIA,IRR.Vlr_Org_HIA,P01.Vlr_Org_HIA
			
			
	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set
			[Vlr Frete Reintegra]= vlr_frete,
			[ALIQ_COFINS] = VL_ALIQ_COFINS
		from 
			@TAB T
			join
				(Select	
					VL_ALIQ_COFINS VL_ALIQ_COFINS,
					vlr_frete vlr_frete,
					Num_Proc
					--,Cd_Produto						
				from nota_fiscal_cliente_det NFCD
				join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				group by 
					vlr_frete,VL_ALIQ_COFINS
					--,Cd_Produto
					,num_proc
			) A on A.num_proc = T.[BDP Ref.] --and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End
	
	Begin
		Update @TAB
		set
			[Nota_Fiscal] = (select distinct Numero from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv')),
			[Ref_Acesso] = (select distinct Ref_Accesso_Arg from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv'))		
	End
	
	Begin
		Update @TAB
		set
			[Comissão Despachante] = (select SUM(Valor_Org) from [dbo].[vwFaturasValidasArg] 
				where Num_Proc = [BDP Ref.] and Numero =[Nota_Fiscal] and Ref_Accesso_Arg =[Ref_Acesso])
		
	End
	
		
	Begin
		--Update com base na CUSTO_CLIENTE
		Update 
			@TAB
		set		
			[OUTROS] = [Impostos] + ([VALOR DOS ACRÉSCIMOS (DI)] -[THC - CHB])
	End


	Begin
		--Update com base na CUSTO_CLIENTE
		Update 
			@TAB
		set		
			[TOTAL] = 
			ISNULL([Liberação de BL],0)+		
			ISNULL([Desconsolidação],0)+		
			ISNULL([Armazenagem],0)+			
			ISNULL([AFRMM],0)+				
			ISNULL([Inspeção de Madeira],0)+		
			ISNULL([Transp. Rodoviário],0)+		
			ISNULL([Capatazias (Dif cambial)],0)+	
			ISNULL([Lavagem de container],0)+		
			ISNULL([Despesas c/ LI],0)+		
			ISNULL([Outras despesas],0)+		
			ISNULL([Frete Internacional (Dif cambial)],0)+	
			ISNULL([Taxa SISCOMEX],0)+				
			ISNULL([Dif. Imposto Acrescimo (1%)],0)+
			ISNULL([Comissão Despachante],0)+			
			ISNULL([OUTROS],0)+							
			ISNULL([Impostos não creditados (IPI / PIS / COFINS)],0)
	End
	
	--OUTROS = 
	--Informação das deduções no conta corrente (Cofins , CSLL, PIS, IRRF RETIDO 4 ) + 
	--(Valor dos acréscimos (DI) - Valor THC-CHB do campo custo) Deduzir o total dos demais valores.  
	--(Ex. Cofins 22,47,CSLL 7,49,PIS 4,87,IRRF RETIDO 4  11,24)R$ 46,07 
	--+ (Valos dos acréscimos (DI) 761,77 - THC-CHB 667,00) 94,77)
	
	--select Nome_Tp_Tx,* from vwcta_Cte c
	--	join Tipo_Taxa t on t.Cd_Tp_Tx = c.Cd_Tp_Tx
	--where
	--	Num_Proc_HIA = 'IMSWB201905074BR'
	
	select
		--[BDP Ref.],
		--[Impostos],[VALOR DOS ACRÉSCIMOS (DI)],[THC - CHB],
		--,[C01],[CF1],[IRR],[P01],
		[Ref],
		[Liberação de BL],
		[Desconsolidação],
		[Armazenagem]	,
		[AFRMM]			,
		[Inspeção de Madeira],	
		[Transp. Rodoviário],		
		[Capatazias (Dif cambial)],
		[Lavagem de container]		,
		[Despesas c/ LI]			,
		[Outras despesas],						
		[Frete Internacional (Dif cambial)],
		[Taxa SISCOMEX]				,
		
		[Dif. Imposto Acrescimo (1%)],
		[Comissão Despachante],
		null [DOC/TEC realiz. pelo despach.],
		[OUTROS]					,
		[Impostos não creditados (IPI / PIS / COFINS)]	,
		[Total]	
		
		--CD_Pedido,
		--Cd_Produto ,
		--[Frete_BL],
		--[Tipo_Frete],
		--[Vlr Frete Reintegra],
		--[ALIQ_COFINS]
	from @tab
	
		


/*
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
--[spReport_SWB_Custos_Detalhamento_REL]'IMSWB201905074BR'
ALTER PROCEDURE  [dbo].[spReport_SWB_Custos_Detalhamento_REL]--'IMSWB201905074BR'
	@Num_Proc varchar(16)

AS	


declare @TAB table
	(
		[BDP Ref.]				varchar(16),
		[Ref]					varchar(200),
		[Liberação de BL]		float,--	
		[Desconsolidação]		float,--
		[Armazenagem]			float,--
		[AFRMM]					float,--
		[Inspeção de Madeira]		float,--	
		[Transp. Rodoviário]		float,--
		
		[Demurrage]							float,--
		[Lavagem de container]				float,--
		[Despesas c/ LI]					float,--
		[SDA]								float,--
		[Frete Internacional (Dif cambial)]	float,--	
		[Taxa SISCOMEX]						float,--
		
		[Dif. Imposto Acrescimo (1%)]	float,--
		[Comissão Despachante]				float,--
		[DOC/TEC realiz. pelo despach.]		float,--
		[OUTROS]							float,--
		[Impostos não creditados (IPI / PIS / COFINS)]	float,--	
		[Total]						float,--	
		
		CD_Pedido int, 
		Cd_Produto int,
		[Frete_BL]					varchar(200),
		[Tipo_Frete]				varchar(200),
		[Vlr Frete Reintegra]		float,
		[ALIQ_COFINS]		float
)	


insert into
	@TAB (
			[BDP Ref.],
			[Ref],			
			[Taxa SISCOMEX],--Taxa Siscomex CHB da aba custos do job			
			CD_Pedido, 
			Cd_Produto,
			[Frete_BL],	[Tipo_Frete]
			
		)
		select
			HOU.Num_Proc,
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Ref],				
			CCXAD.Vlr_Item_Custo * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido) [Vlr Siscomex],			
			PS.cd_pedido,
			PS.cd_produto,Frete_BL,Tipo_Frete			
		from vwHouse_Imp HOU with(nolock)
			Left Join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			left Join Pedido_Det PD	 with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
			left Join Pedido P	with(nolock) on PD.cd_pedido = P.Cd_pedido					
			Left Outer Join Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' 
				and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto	
		where 
			HOU.Num_Proc=@Num_Proc -- 'IMSWB201907088BR'


	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set
			[Vlr Frete Reintegra]= vlr_frete,
			[ALIQ_COFINS] = VL_ALIQ_COFINS
		from 
			@TAB T
			join
				(Select	
					VL_ALIQ_COFINS VL_ALIQ_COFINS,
					vlr_frete vlr_frete,
					Num_Proc,Cd_Produto						
				from nota_fiscal_cliente_det NFCD
				join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				group by 
					vlr_frete,VL_ALIQ_COFINS
					,Cd_Produto,num_proc
			) A on A.num_proc = T.[BDP Ref.] and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set	
			[Liberação de BL] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%LIBERACAO%CHB%'),
			[Desconsolidação] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Desconsolidação%CHB%'),
			[Armazenagem] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Armazenagem%CHB%'),
			[AFRMM] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[Inspeção de Madeira] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Inspeção de madeira%'),
			[Transp. Rodoviário] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Transp. Rodoviário%CHB%'),
			
			[Demurrage] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Demurrage%'),
			[Lavagem de container] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Lavage%CHB%'),
			[Despesas c/ LI] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%LI%CHB%'),
			[SDA] = 0
	End
		
	Begin
		--Update com base na CUSTO_CLIENTE
		Update 
			@TAB
		set		
		[Frete Internacional (Dif cambial)] = (CASE WHEN Tipo_Frete = 'PREPAID' THEN 
													'' ELSE 
										(CASE WHEN Tipo_Frete = 'COLLECT'  THEN 
									[Vlr Frete Reintegra] + [Frete_BL] 	ELSE NULL END)END)
	End
	
	select
		--[BDP Ref.],
		[Ref],
		[Liberação de BL],
		[Desconsolidação],
		[Armazenagem]	,
		[AFRMM]			,
		[Inspeção de Madeira],	
		[Transp. Rodoviário],
		
		[Demurrage]					,
		[Lavagem de container]		,
		[Despesas c/ LI]			,
		[SDA]						,
		[Frete Internacional (Dif cambial)],
		[Taxa SISCOMEX]				,
		
		[Dif. Imposto Acrescimo (1%)],
		[Comissão Despachante]		,
		[DOC/TEC realiz. pelo despach.],
		[OUTROS]					,
		[Impostos não creditados (IPI / PIS / COFINS)]	,
		[Total]	
		
		--CD_Pedido,
		--Cd_Produto ,
		--[Frete_BL],
		--[Tipo_Frete],
		--[Vlr Frete Reintegra],
		--[ALIQ_COFINS]
	from @tab
	
		*/
GO
