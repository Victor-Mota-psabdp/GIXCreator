SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_ProductCosts_V3_Rel]'Grupo SOLUTIA','2017-05-09','2017-05-09'
CREATE Procedure [dbo].[spATL_ProductCosts_V3_Rel]--'Grupo FMC','2016-02-24','2016-02-24'
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
exec dbo.spATL_CalculaPercentual_Ins @Cd_Grupo


	declare @TAB table
	(
		[BDP Job]					char(16),
		[CNPJ]						varchar(20),
		[PO]						varchar(50),
		[Codigo Mercadoria]			varchar(50),
		[Descrição da Mercadoria]	varchar(500),
		[Modal]						varchar(20),
		[ATD Date]					Datetime,
		[ETA Date]					Datetime,
		[ATA Date]					Datetime,
		[Dt da DI]					Datetime,
		[N° da DI]					varchar(50),
		[Canal]						varchar(50),
		[Dt desemb]					Datetime,
		[Last Historic]				varchar(1000),
		[Peso Liq]					decimal(18,3),
		[Peso Brut]					decimal(18,3),
		[Loc desemb]				varchar(50),
		[Destination]				varchar(50),
		[Exportador]				varchar(200),
		[Incoterm]					varchar(10),		
		[Inland trucker]			varchar(100),
		[Vessel]					varchar(100),
		[N° Conhec]					varchar(100),
		[N° CE]						varchar(200),
		[VALOR TOTAL INVOICE (NA MOEDA)]		float, 
		[FOB Total Item Value] float,
		[MLE Moeda]					varchar(200),
		[MLE Tx]					varchar(200),
		[VALOR TOTAL INVOICE (R$)]				float, 
		[CIF Total Item Value]		float, 		
		[Frete $]					float,
		[Moeda Frete]				varchar(200),
		[Frete (R$)]				float,		
		[Tx Frete]					float,		
		[Freight Value]				float,
		[Insurance Value]			float,
		[Seguro $]					float,
		[Moeda Seguro]				varchar(200),
		[Tx Seguro]					float,		
		[Seg. (R$)]					float,	
		[SISCOMEX (Custo) Value]	float,	
		[Paridade D.I. Value]		decimal(18,4),
		[II (Imposto) Value]		float, 
		[IPI (Imposto) Value]		float,
		[PIS (Imposto) Value]		float,
		[COFINS (Imposto) Value]	float,
		[ICMS (Imposto) Value]		float,		
		[SISCOMEX (Imposto) Value]	float,
		[AFRMM (Custo) Value]		float,
		[THC (Custo) Value]			float,
		[Armazenagem (Custo) Value] float,
		[Demurrage (Custo) Value]	float,
		[Lib. B/L (Custo) Value]	float,
		[Multa de LI]				float,			
		[Lavagem Container (Custo) Value] float,
		[Emissao LI] float,
		[Inspecao Madeira] float,
		[Outras despesas]			float,
		[Quantity] float,				
		CD_Pedido int, 
		Cd_Produto int,
		[FOB CHARGES (Custo)]			float,				
		[FRETE (CONSTA NA DI)]			float,			
		[VALOR DOS ACRÉSCIMOS (DI)]			float,
		[Imposto de Importação - CHB] float,
		[Seguro]float,
		[Emissao de NFE] float,
		[Serviços Prestados] float,
		[Valores BDP]float,
		[Item] varchar(6),
		[Percentual]float,
		[FRETE Moeda(BL)] varchar(50),
		[FRETE Valor(BL)] float,
		[Custo Total] float
	)

	Begin
		insert into
			@TAB (
					[BDP Job],[CNPJ],[PO],[Codigo Mercadoria],[Descrição da Mercadoria],[Incoterm],[Modal],
					[N° da DI],[Dt da DI],[ATD Date],[ETA Date],[ATA Date],
					[Quantity],[Paridade D.I. Value],CD_Pedido, Cd_Produto,					
					[Canal],[Dt desemb],[Last Historic],[Peso Liq],[Peso Brut],[Loc desemb],
					[Destination],[Exportador],[Inland trucker],[Vessel],[N° Conhec],[N° CE],
					[VALOR TOTAL INVOICE (NA MOEDA)],
					[MLE Moeda],[Moeda Frete],
					[FRETE Moeda(BL)],[FRETE Valor(BL)],
					[Item],[Percentual]	
				)
		select
				HOU.Num_Proc_HIM,CNS.Num_CPF_CNPJ,P.Num_Pedido,PC.cd_Proc_Cliente, PC.Produto_Descr, 
				HOU.cd_tp_oper, 'Sea Import',DI.numero_po_him, DI.data_po_him, LLP.atd_lim,LLP.ETA_Lim, LLP.ata_lim,
				PS.qty,
				cast( replace(isnull(PAR.campo_dados,1),',','.') as decimal(18,4)),								
				PS.CD_Pedido, PS.Cd_Produto,				
				LLP.Canal_Lim, TP4.Dt_Conclusao,
				--[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc_HIM),	
				HC.HSDDescricao [Last Historic],			
				cast(PD.Peso_Liquido_TOT as decimal(18,3)),
				cast(PD.Peso_Bruto_Tot as decimal(18,3)),					
				DLoc.Nome_Local ,
				DST.Nome_Local,SHI.Nome_Raz_Soc,TRA.Nome_Raz_Soc,HOU.Navio_HIM,
				'HBL:' + isnull(HOU.HAWB_HIM,''),
				cast(CE.Numero_PO_HIM as varchar(50)),
				PD.Vlr_Total_Item,
				TM.Nome_Tp_Moeda,
				'DOLAR AMERICANO',
				T.Nome_Tp_Moeda,
				HOU.Vlr_Frete_Efet_HIM [FRETE Valor(BL)],
				PD.Item,PP.Percentual
				
		from
			House_IMP_Mar			HOU	with(nolock)
			join llp_imp_mar		LLP	with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
			left join Tipo_Moeda	T 	with(nolock) on HOU.Cd_Tp_Moeda = T.Cd_Tp_Moeda
			left join Tipo_Moeda	TM 	with(nolock) on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
			join pessoa				CNS	with(nolock) on CNS.cd_pes = HOU.cd_consig_him
			join pessoa				SHI	with(nolock) on SHI.cd_pes = HOU.Cd_Export_HIM
			join Localidade			ORG	with(nolock) on Org.Cd_Local = HOU.Cd_Org_HIM
			join Localidade			DST	with(nolock) on Dst.Cd_Local = HOU.Cd_Dst_HIM
			
			join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.cd_consig_him and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship		PS with(nolock) on HOU.num_proc_him = PS.num_proc
			join Pedido				P  with(nolock) on P.Cd_Pedido = PS.Cd_Pedido 
			join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP4 with(nolock) on HOU.num_proc_him = TP4.num_proc and TP4.id_task = 4
			
			left join po_him		DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5		
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_him and PAR.id_campo = 31			
			left join campo_processo DEB with(nolock) on DEB.num_proc = HOU.Num_Proc_HIM and DEB.id_campo = 25
			left join Localidade DLOC with(nolock) on DEB.Campo_Dados = DLOC.Cd_Local
			left join pessoa		TRA with(nolock) on TRA.cd_pes = LLP.Cd_Transportadora
			left join po_him		CE with(nolock) on CE.num_proc_him = HOU.num_proc_him and CE.id_dc = 29
			join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
			left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=HOU.num_proc_him
	
			
		where	
			TP4.dt_conclusao between @DtInicial and @DtFinal
			
		UNION ALL
		
		select
			HOU.Num_Proc_HIA,CNS.Num_CPF_CNPJ,P.Num_Pedido,PC.cd_Proc_Cliente,PC.Produto_Descr,
			HOU.cd_tp_oper, 'Air Import',DI.numero_po_hia, DI.data_po_hia, LLP.atd_lia,llp.ETA_LIA, LLP.ata_lia,
			PS.qty,
			cast( replace(isnull(PAR.campo_dados,1),',','.') as decimal(18,4)),
			PS.CD_Pedido, PS.Cd_Produto,
			LLP.Canal_Lia, TP4.Dt_Conclusao,
			--[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc_HIA),		
			HC.HSDDescricao [Last Historic],	
			cast(PD.Peso_Liquido_TOT as decimal(18,3)),
			cast(PD.Peso_Bruto_Tot as decimal(18,3)),	
			DLoc.Nome_Local,
			DST.Nome_Local,SHI.Nome_Raz_Soc,TRA.Nome_Raz_Soc,HOU.Voo_HIA,
			'HBL:' + isnull(HOU.HAWB_HIA,''),
			cast(CE.Numero_PO_HIA as varchar(50)),
			PD.Vlr_Total_Item,
			TM.Nome_Tp_Moeda,
			'DOLAR AMERICANO',
			T.Nome_Tp_Moeda,
			HOU.Vlr_Frete_Efet_HIA [FRETE Valor(BL)],
			PD.Item,PP.Percentual
		from
			House_IMP_aer			HOU	with(nolock)
			join llp_imp_aer		LLP	with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
			left join Tipo_Moeda	T 	with(nolock) on HOU.Cd_Tp_Moeda = T.Cd_Tp_Moeda
			left join Tipo_Moeda	TM 	with(nolock) on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
			join pessoa				CNS	with(nolock) on CNS.cd_pes = HOU.cd_consig_hia
			join pessoa				SHI	with(nolock) on SHI.cd_pes = HOU.Cd_Export_HIA
			join Localidade			ORG	with(nolock) on Org.Cd_Local = HOU.Cd_Org_HIA
			join Localidade			DST	with(nolock) on Dst.Cd_Local = HOU.Cd_Dst_HIA
			join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.cd_consig_hia and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship		PS with(nolock) on HOU.num_proc_hia = PS.num_proc
			join Pedido				P  with(nolock) on P.Cd_Pedido = PS.Cd_Pedido 
			join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP4 with(nolock) on HOU.Num_Proc_HIA = TP4.num_proc and TP4.id_task = 4
						
			left join po_hia		PO with(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc = 1
			left join po_hia		DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_hia and PAR.id_campo = 31
			left join campo_processo DEB with(nolock) on DEB.num_proc = HOU.num_proc_hia and DEB.id_campo = 25
			left join Localidade DLOC with(nolock) on DEB.Campo_Dados = DLOC.Cd_Local
			left join pessoa		TRA with(nolock) on TRA.cd_pes = LLP.Cd_Transportadora
			left join PO_HIA		CE with(nolock) on CE.Num_Proc_HIA = HOU.Num_Proc_HIA and CE.id_dc = 29
			join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
			left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=HOU.num_proc_hia
		where
			TP4.dt_conclusao between @DtInicial and @DtFinal
			
		UNION ALL
		
		select
			HOU.Num_Proc_HIO,CNS.Num_CPF_CNPJ,P.Num_Pedido,PC.cd_Proc_Cliente,PC.Produto_Descr,
			HOU.cd_tp_oper, 'Others Import',DI.numero_po_hia, DI.data_po_hia, LLP.ATD_Lio,llp.ETA_Lio, LLP.ATA_Lio,
			PS.qty,
			cast( replace(isnull(PAR.campo_dados,1),',','.') as decimal(18,4)),
			PS.CD_Pedido, PS.Cd_Produto,
			LLP.Canal_Lio, TP4.Dt_Conclusao,
			--[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc_HIO),			
			HC.HSDDescricao [Last Historic],
			cast(PD.Peso_Liquido_TOT as decimal(18,3)),
			cast(PD.Peso_Bruto_Tot as decimal(18,3)),			
			DLoc.Nome_Local,
			DST.Nome_Local,SHI.Nome_Raz_Soc,TRA.Nome_Raz_Soc,HOU.Voo_HIO,
			'HBL:' + isnull(HOU.HAWB_HIO,''),
			cast(CE.Numero_PO_HIO as varchar(50)),
			PD.Vlr_Total_Item,
			TM.Nome_Tp_Moeda,
			'DOLAR AMERICANO',
			T.Nome_Tp_Moeda,
			HOU.Vlr_Frete_Efet_HIO [FRETE Valor(BL)],
			PD.Item,PP.Percentual
		from
			House_Imp_Out			HOU with(nolock)
			join LLP_Imp_Out		LLP with(nolock) on LLP.Num_Proc_Lio = HOU.Num_Proc_HIO
			left join Tipo_Moeda	T 	with(nolock) on HOU.Cd_Tp_Moeda = T.Cd_Tp_Moeda
			left join Tipo_Moeda	TM 	with(nolock) on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
			join pessoa				CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HIO
			join pessoa				SHI	with(nolock) on SHI.cd_pes = HOU.Cd_Export_HIO
			join Localidade			ORG	with(nolock) on Org.Cd_Local = HOU.Cd_Org_HIO
			join Localidade			DST	with(nolock) on Dst.Cd_Local = HOU.Cd_Dst_HIO
			join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.Cd_Consig_HIO and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship		PS with(nolock) on HOU.Num_Proc_HIO = PS.num_proc
			join Pedido				P  with(nolock) on P.Cd_Pedido = PS.Cd_Pedido 
			join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP4 with(nolock) on HOU.Num_Proc_HIO = TP4.num_proc and TP4.id_task = 4

			left join po_hia		PO with(nolock) on PO.num_proc_hia = HOU.Num_Proc_HIO and PO.id_dc = 1
			left join po_hia		DI with(nolock) on DI.num_proc_hia = HOU.Num_Proc_HIO and DI.id_dc = 5
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.Num_Proc_HIO and PAR.id_campo = 31
			left join campo_processo DEB with(nolock) on DEB.num_proc = HOU.num_proc_hio and DEB.id_campo = 25
			left join Localidade DLOC with(nolock) on DEB.Campo_Dados = DLOC.Cd_Local
			left join pessoa		TRA with(nolock) on TRA.cd_pes = LLP.Cd_Transportadora
			left join PO_HIO		CE with(nolock) on CE.Num_Proc_HIO = HOU.Num_Proc_HIO and CE.id_dc = 29
			join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
			left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=HOU.num_proc_hio
		where
			TP4.dt_conclusao between @DtInicial and @DtFinal
	End

	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			[CIF Total Item Value] = totCIF,
			[Freight Value] = totFrete, 
			[FOB Total Item Value] = totFOB,
			[Insurance Value] = totSeguro,
			[II (Imposto) Value] = totII,
			[IPI (Imposto) Value] = totIPI,
			[PIS (Imposto) Value] = totPis,
			[COFINS (Imposto) Value] =totCofins,
			[ICMS (Imposto) Value] = totICMS,
			[SISCOMEX (Imposto) Value]= totSiscomex
			
		from 
			@TAB T
			join
			(	
			Select 
				CIF totCIF, 
				(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) totFOB,
				Vlr_FRETE totFrete,
				vlr_Seguro totSeguro,
				VL_II totII, 
				VL_IPI totIPI,
				VL_IMPOSTO_PIS totPis,
				VL_IMPOSTO_COFINS totCofins,
				VL_ICMS totICMS,
				Vlr_Siscomex totSiscomex,							
				Cd_Produto,
				cd_pedido, 
				num_proc,
				ID_Item	
			from nota_fiscal_cliente_det NFCD
			join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			) A on A.num_proc = T.[BDP Job] and A.cd_produto = T.cd_produto and A.cd_pedido=T.CD_Pedido and A.ID_Item = T.Item
	End

	Begin
		Update @TAB
		set
			[AFRMM (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[Armazenagem (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Armazenagem%'),
			[Demurrage (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Demurrage%') ,
			[THC (Custo) Value] =(dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'THC%') 
				+ dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Capatazia%')) ,
			[Lib. B/L (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lib%BL%'),
			[Multa de LI] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Multa%'),
			[Lavagem Container (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lavagem%CNTR%'),							
			[FOB CHARGES (Custo)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'FOB%CHARGES%'),		
			[FRETE (CONSTA NA DI)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'FRETE%'),	
			[VALOR DOS ACRÉSCIMOS (DI)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%') ,
			[Imposto de Importação - CHB]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') ,
			[Seguro]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Seguro%') ,
			[Outras despesas]= dbo.fBusca_Custo_OutrasDespesas([BDP Job],CD_Pedido, Cd_Produto),
			[Emissao de NFE] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Serviços%Prestados%','C') ,
			[Serviços Prestados] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%de%nfe%','C'),
			[Emissao LI]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%LI%','C'),
			[Inspecao Madeira]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Inspeção%Madeira%','C')
					
	End

	Begin
		Update @TAB
		set
			[Paridade D.I. Value] = (case when [Paridade D.I. Value] = 0 then 1 when [Paridade D.I. Value] is null then 1 else [Paridade D.I. Value] end)
	End
	
	Begin
			Update @TAB
			set				
				[VALOR TOTAL INVOICE (R$)]	=	isnull([VALOR TOTAL INVOICE (NA MOEDA)],0) * isnull([Paridade D.I. Value],1),
				[Seguro $] = isnull([Insurance Value],0)	/	isnull([Paridade D.I. Value],1),
				[Valores BDP] = isnull([Emissao de NFE],0) + isnull([Serviços Prestados],0) + isnull([Inspecao Madeira],0)+ isnull([Emissao LI],0),
				[Frete $] = isnull([Freight Value],0)	/	isnull([Paridade D.I. Value],1)
				
		End

	select
		[BDP Job],[CNPJ],[PO],[Codigo Mercadoria],[Item][NR], [Descrição da Mercadoria],[Modal],[ATD Date],[ETA Date],[ATA Date],[Dt da DI],
		[N° da DI],[Canal],[Dt desemb],[Last Historic],
		replace([Peso Liq],'.',',') [Peso Liq],
		replace([Peso Brut],'.',',')[Peso Brut],
		[Loc desemb],[Destination],
		[Exportador],[Incoterm],[Inland trucker],[Vessel],[N° Conhec],[N° CE],[FRETE Moeda(BL)],cast([FRETE Valor(BL)]* DBO.fBuscaPorcentagem_CdPedido_Transf([BDP Job],[ITEM],[cd_pedido])*dbo.fBuscaPorcentagem_Pedido_Prod([BDP Job] ,[cd_pedido],[cd_produto])*dbo.[fBuscaPorcentagem_CdProduto_Transf]([BDP Job],[Cd_Produto]) as decimal(18,2))[FRETE Valor(BL)],
		cast([VALOR TOTAL INVOICE (NA MOEDA)] as decimal(18,2))[VALOR TOTAL INVOICE (NA MOEDA)],
		[MLE Moeda],
		replace([Paridade D.I. Value],'.',',')		[MLE Tx],
		cast([VALOR TOTAL INVOICE (R$)] as decimal(18,2)) [VALOR TOTAL INVOICE (R$)],
		[CIF Total Item Value]		[CIF (R$)],		
		cast([Frete $] as decimal(18,2)) [Frete $],
		[Moeda Frete],		
		replace([Paridade D.I. Value],'.',',')		[Tx Frete],
		cast([Freight Value] as decimal(18,2))				[Frete (R$)],		
		cast([Seguro $] as decimal(18,2)) [Seguro $],
		[MLE Moeda]					[Moeda Seguro],
		replace([Paridade D.I. Value],'.',',')		[Tx Seguro],		
		[Insurance Value]			[Seg. (R$)],		
		
		[SISCOMEX (Imposto) Value]	[TxSisc (R$)],	
		replace([Paridade D.I. Value],'.',',')		[Tx dolar],
		
		[II (Imposto) Value]			[II (R$)] ,
		[IPI (Imposto) Value]			[IPI (R$)],
		[PIS (Imposto) Value]			[PIS (R$)],
		[COFINS (Imposto) Value]		[COFINS (R$)],
		[ICMS (Imposto) Value]			[ICMS (R$)],
		cast([AFRMM (Custo) Value] * [Percentual] as decimal(18,2))	[AFRMM (R$)],		
		cast([THC (Custo) Value]	* [Percentual] as decimal(18,2))			[THC],		
		cast([Armazenagem (Custo) Value]	 * [Percentual] as decimal(18,2))	[ARMAZENAGEM(R$)],
		cast([Demurrage (Custo) Value]	* [Percentual] as decimal(18,2))	[DEMURRAGE(R$)],
		cast([Lib. B/L (Custo) Value]* [Percentual]	 as decimal(18,2))	[Liberação de BL],
		cast([Multa de LI] * [Percentual] as decimal(18,2)) [Multa de LI],
		cast([Lavagem Container (Custo) Value] * [Percentual] as decimal(18,2)) [Lavagem de container],
		cast([Outras despesas]* [Percentual] as decimal(18,2)) [Outras despesas],
		cast([Valores BDP]* DBO.fBuscaPorcentagem_CdPedido_Transf([BDP Job],[ITEM],[cd_pedido])*dbo.fBuscaPorcentagem_Pedido_Prod([BDP Job] ,[cd_pedido],[cd_produto])*dbo.[fBuscaPorcentagem_CdProduto_Transf]([BDP Job],[Cd_Produto]) as decimal(18,2))[Valores BDP]
	from 
		@TAB
	



GO
