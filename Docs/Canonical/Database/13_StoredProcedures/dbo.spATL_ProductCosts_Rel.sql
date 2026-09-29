SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_ProductCosts_Rel '2','GRUPO AKZO DECORATIV','2011-06-01','2011-06-30'


CREATE Procedure [dbo].[spATL_ProductCosts_Rel]
(
	@Tipo char(1),		--	1=Reais(BRL) / 2=Dolar(USD)
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS

	declare @TAB table
	(
	[BDP Job] char(16),
	[JOB Date] datetime,
	[Consignee] varchar(50),
	[CNPJ] varchar(20),
	[PO Number] varchar(50),
	[Item] varchar(6),
	[Cod. Produto] varchar(50),
	[Descrição do Produto] varchar(200),
	[Incoterm] varchar(10),
	[Modal] varchar(20),
	[Invoice Date] datetime,
	[Invoice Number] varchar(50),
	[DI Number] varchar(50),
	[DI Date] datetime,
	[ATD Date] datetime,
	[ATA Date] datetime,
	[NF Number] varchar(50),
	[NF Date] datetime,
	[Quantity] float,
	[UOM] varchar(10),
	[Currency] varchar(3),
	[Paridade D.I. Value] float,
	[CIF Total Item Value] float,
	[FOB Total Item Value] float,
	[CFR Total Item Value] float,
	[KG/Unit (FOB) Value] float,
	[Freight Value] float,
	[Insurance Value] float,
	[% II] float,
	[II (Imposto) Value] float,
	[% IPI] float,
	[IPI (Imposto) Value] float,
	[PIS (Imposto) Value] float,
	[COFINS (Imposto) Value] float,
	[ICMS (Imposto) Value] float,
	[AFRMM (Custo) Value] float,
	[Add. Freight (Custo) Value] float,
	[Armazenagem (Custo) Value] float,
	[Demurrage (Custo) Value] float,
	[THC (Custo) Value] float,
	[BAF (Custo) Value] float,
	[Transp. Interno Value] float,
	[Despachante (Custo) Value] float,
	[Lib. B/L (Custo) Value] float,
	[SISCOMEX (Custo) Value] float,
	[ISPS (Custo) Value] float,
	[Desconsolidação (Custo) Value] float,
	[Lavagem Container (Custo) Value] float,
	[Gestão Processo (Custo) Value] float,
	[ISS (Custo) Value] float,
	[Taxa Siscarga (Custo) Value] float,
	[Licença Importação (Custo) Value] float,
	[SDA (Custo) Value] float,
	[Total Despesas Value] float,
	[Total Custos Value] float,
	[Custo/Qtd Value] float,
	[Custo Final/Qtd Value] float,
	[Prest. Contas Date] datetime,
	[Entr. Planta Date] datetime,
	CD_Pedido int, 
	Cd_Produto int,
	NCM Varchar(20)
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Begin
		insert into
			@TAB ([BDP Job],[JOB Date],[Consignee],[CNPJ],[PO Number],[Item],[Cod. Produto],[Descrição do Produto],[Incoterm],[Modal],[Invoice Date],[Invoice Number],[DI Number],[DI Date],[ATD Date],[ATA Date],[NF Number],[NF Date],[Quantity],[UOM],[Currency],[Paridade D.I. Value],[Prest. Contas Date],[Entr. Planta Date],CD_Pedido, Cd_Produto)
		select
			HOU.Num_Proc_HIM, convert(datetime,HOU.Dt_Emis_Him,105),CNS.apelido, CNS.Num_CPF_CNPJ, PO.numero_po_him,PS.item, PC.cd_proc_cliente, PC.Produto_Descr, HOU.cd_tp_oper, 'Sea Import', INV.data_po_him, INV.numero_po_him, DI.numero_po_him, DI.data_po_him, LLP.atd_lim, LLP.ata_lim, NF.numero_po_him, NF.data_po_him, PS.qty, PD.UOM,(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,1), TP40.dt_conclusao, TP13.dt_conclusao, PS.CD_Pedido, PS.Cd_Produto
		from
			House_IMP_Mar HOU with(nolock)
			join llp_imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_him
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_him and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_him = PS.num_proc
			join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP13 with(nolock) on HOU.num_proc_him = TP13.num_proc and TP13.id_task = 13
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_him = TP40.num_proc and TP40.id_task = 40
			left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
			left join po_him INV with(nolock) on INV.num_proc_him = HOU.num_proc_him and INV.id_dc = 2
			left join po_him DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
			left join po_him NF with(nolock) on NF.num_proc_him = HOU.num_proc_him and NF.id_dc = 10
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_him and PAR.id_campo = 31
		where
	--		HOU.Num_Proc_Him = 'IMDEC201105043BR'
			TP13.dt_conclusao between @DtInicial and @DtFinal
		UNION ALL
		select
			HOU.Num_Proc_HIA, convert(datetime,HOU.Dt_Emis_HiA,105),CNS.apelido, CNS.Num_CPF_CNPJ, PO.numero_po_hia,PS.item, PC.cd_proc_cliente, PC.Produto_Descr, HOU.cd_tp_oper, 'Air Import', INV.data_po_hia, INV.numero_po_hia, DI.numero_po_hia, DI.data_po_hia, LLP.atd_lia, LLP.ata_lia, NF.numero_po_hia, NF.data_po_hia, PS.qty, PD.UOM,(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,0), TP40.dt_conclusao, TP13.dt_conclusao, PS.CD_Pedido, PS.Cd_Produto
		from
			House_IMP_aer HOU with(nolock)
			join llp_imp_aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_hia
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_hia and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_hia = PS.num_proc
			join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP13 with(nolock) on HOU.num_proc_hia = TP13.num_proc and TP13.id_task = 13
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_hia = TP40.num_proc and TP40.id_task = 40
			left join po_hia PO with(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc = 1
			left join po_hia INV with(nolock) on INV.num_proc_hia = HOU.num_proc_hia and INV.id_dc = 2
			left join po_hia DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5
			left join po_hia NF with(nolock) on NF.num_proc_hia = HOU.num_proc_hia and NF.id_dc = 10
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_hia and PAR.id_campo = 31
		where
	--		HOU.Num_Proc_Him = 'IMDEC201105043BR'
			TP13.dt_conclusao between @DtInicial and @DtFinal
	End

	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			[CIF Total Item Value] = totCIF, [FOB Total Item Value] = totFOB, [KG/Unit (FOB) Value] = totFOB / totLIQ, [Freight Value] = totFrete, [Insurance Value] = totSeguro,
			[% II] = pII, [II (Imposto) Value] = totII, [% IPI] = pIPI, [IPI (Imposto) Value] = totIPI,
			[NCM]=NNCM
		from 
			@TAB T
			join
			(
			Select 
				sum(CIF) totCIF, sum(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) totFOB, sum(Peso_Liquido) totLIQ, sum(Vlr_FRETE) totFrete, sum(vlr_Seguro) totSeguro,
				max(ALIQ_II) pII, sum(VL_II) totII, max(ALIQ_IPI) pIPI, sum(VL_IPI) totIPI,
				Cd_Produto, num_proc,MAX(NCM) NNCM
			from nota_fiscal_cliente_det NFCD
			join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			group by Cd_Produto, num_proc
			) A on A.num_proc = T.[BDP Job] and A.cd_produto = T.cd_produto
	End

	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
		[PIS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%PIS%'),
		[COFINS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%COFINS%'),
		[ICMS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%ICMS%'),
		[AFRMM (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%AFRMM%'),
		[Add. Freight (Custo) Value] = dbo.fBusca_Custo([BDP Job], CD_Pedido, Cd_Produto,'Adic%Frete%'),
		[Armazenagem (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Armazenagem%'),
		[Demurrage (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Demurrage%'),
		[THC (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'THC%') + dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Capatazia%'),
		[BAF (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'BAF%'),
		[Transp. Interno Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Frete Int%'),
		[Despachante (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Serv%Desp%'),
		[Lib. B/L (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lib%BL%'),
		[SISCOMEX (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%SISCO%'),
		[ISPS (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'ISPS%'),
		[Desconsolidação (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Desconso%'),
		[Lavagem Container (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lavagem CNTR%'),
		[Gestão Processo (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Gestão%'),
		[ISS (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'ISS %'),
		[Taxa Siscarga (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Siscarga%'),
		[Licença Importação (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'LI %') + dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%licen%'),
		[SDA (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'SDA%')
	End

	Begin
		Update @TAB
		set
			[CFR Total Item Value]= [CIF Total Item Value] - [Insurance Value] - [THC (Custo) Value],

			[Total Custos Value] =	[AFRMM (Custo) Value] + [Add. Freight (Custo) Value] + [Armazenagem (Custo) Value] + [Demurrage (Custo) Value] + [THC (Custo) Value] + [BAF (Custo) Value] + --[Transp. Interno Value] + 
									[Despachante (Custo) Value] + [Lib. B/L (Custo) Value] + [SISCOMEX (Custo) Value] + [ISPS (Custo) Value] + [Desconsolidação (Custo) Value] + [Lavagem Container (Custo) Value] + 
									[Gestão Processo (Custo) Value] + [ISS (Custo) Value] + [Taxa Siscarga (Custo) Value] + [Licença Importação (Custo) Value] + [SDA (Custo) Value],

			[Total Despesas Value]= [II (Imposto) Value] + [IPI (Imposto) Value] + [PIS (Imposto) Value] + [COFINS (Imposto) Value] + [ICMS (Imposto) Value] +
									[AFRMM (Custo) Value] + [Add. Freight (Custo) Value] + [Armazenagem (Custo) Value] + [Demurrage (Custo) Value] + [THC (Custo) Value] + [BAF (Custo) Value] + --[Transp. Interno Value] + 
									[Despachante (Custo) Value] + [Lib. B/L (Custo) Value] + [SISCOMEX (Custo) Value] + [ISPS (Custo) Value] + [Desconsolidação (Custo) Value] + [Lavagem Container (Custo) Value] + 
									[Gestão Processo (Custo) Value] + [ISS (Custo) Value] + [Taxa Siscarga (Custo) Value] + [Licença Importação (Custo) Value] + [SDA (Custo) Value]
	End

	Begin
		Update @TAB
		set
			[Custo/Qtd Value] = ([II (Imposto) Value] + [Total Custos Value] + [CIF Total Item Value]) / [Quantity] / (case when [UOM] = 'MT' then 1000 else 1 end),
			[Custo Final/Qtd Value] = ([Total Despesas Value] + [CIF Total Item Value] + [Transp. Interno Value] ) / [Quantity] / (case when [UOM] = 'MT' then 1000 else 1 end),
			[Paridade D.I. Value] = (case when [Paridade D.I. Value] = 0 then 1 when [Paridade D.I. Value] is null then 1 else [Paridade D.I. Value] end)
	End

	If @Tipo = '2' -- em Dolar(USD)
		Begin
			Update @TAB
			set
				[CIF Total Item Value]	=	isnull([CIF Total Item Value],0)	/	isnull([Paridade D.I. Value],1),
				[FOB Total Item Value]	=	isnull([FOB Total Item Value],0)	/	isnull([Paridade D.I. Value],1),
				[CFR Total Item Value]	=	isnull([CFR Total Item Value],0)	/	isnull([Paridade D.I. Value],1),
				[KG/Unit (FOB) Value]	=	isnull([KG/Unit (FOB) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Freight Value]	=	isnull([Freight Value],0)	/	isnull([Paridade D.I. Value],1),
				[Insurance Value]	=	isnull([Insurance Value],0)	/	isnull([Paridade D.I. Value],1),
				[II (Imposto) Value]	=	isnull([II (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[IPI (Imposto) Value]	=	isnull([IPI (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[PIS (Imposto) Value]	=	isnull([PIS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[COFINS (Imposto) Value]	=	isnull([COFINS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[ICMS (Imposto) Value]	=	isnull([ICMS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[AFRMM (Custo) Value]	=	isnull([AFRMM (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Add. Freight (Custo) Value]	=	isnull([Add. Freight (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Armazenagem (Custo) Value]	=	isnull([Armazenagem (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Demurrage (Custo) Value]	=	isnull([Demurrage (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[THC (Custo) Value]	=	isnull([THC (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[BAF (Custo) Value]	=	isnull([BAF (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Transp. Interno Value]	=	isnull([Transp. Interno Value],0)	/	isnull([Paridade D.I. Value],1),
				[Despachante (Custo) Value]	=	isnull([Despachante (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Lib. B/L (Custo) Value]	=	isnull([Lib. B/L (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[SISCOMEX (Custo) Value]	=	isnull([SISCOMEX (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[ISPS (Custo) Value]	=	isnull([ISPS (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Desconsolidação (Custo) Value]	=	isnull([Desconsolidação (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Lavagem Container (Custo) Value]	=	isnull([Lavagem Container (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Gestão Processo (Custo) Value]	=	isnull([Gestão Processo (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[ISS (Custo) Value]	=	isnull([ISS (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Taxa Siscarga (Custo) Value]	=	isnull([Taxa Siscarga (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Licença Importação (Custo) Value]	=	isnull([Licença Importação (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[SDA (Custo) Value]	=	isnull([SDA (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Total Despesas Value]	=	isnull([Total Despesas Value],0)	/	isnull([Paridade D.I. Value],1),
				[Total Custos Value]	=	isnull([Total Custos Value],0)	/	isnull([Paridade D.I. Value],1),
				[Custo/Qtd Value]	=	isnull([Custo/Qtd Value],0)	/	isnull([Paridade D.I. Value],1),
				[Custo Final/Qtd Value]	=	isnull([Custo Final/Qtd Value],0)	/	isnull([Paridade D.I. Value],1)
		End


	select
		[BDP Job],[JOB Date],[Consignee],[CNPJ],[PO Number],[Item],[Cod. Produto],[Descrição do Produto],[Incoterm],[Modal],[Invoice Date],[Invoice Number],[DI Number],[DI Date],[ATD Date],[ATA Date],[NF Number],[NF Date],[Quantity],[UOM],[Currency],
		[Paridade D.I. Value],[CIF Total Item Value],[FOB Total Item Value],[CFR Total Item Value],[KG/Unit (FOB) Value],[Freight Value],[Insurance Value],[% II],[II (Imposto) Value],[% IPI],[IPI (Imposto) Value],[PIS (Imposto) Value],[COFINS (Imposto) Value],[ICMS (Imposto) Value],
		[AFRMM (Custo) Value],[Add. Freight (Custo) Value],[Armazenagem (Custo) Value],[Demurrage (Custo) Value],[THC (Custo) Value],[BAF (Custo) Value],[Transp. Interno Value],[Despachante (Custo) Value],[Lib. B/L (Custo) Value],[SISCOMEX (Custo) Value],[ISPS (Custo) Value],[Desconsolidação (Custo) Value],[Lavagem Container (Custo) Value],[Gestão Processo (Custo) Value],[ISS (Custo) Value],[Taxa Siscarga (Custo) Value],[Licença Importação (Custo) Value],[SDA (Custo) Value],[Total Despesas Value],[Total Custos Value],[Custo/Qtd Value],[Custo Final/Qtd Value],[Prest. Contas Date],[Entr. Planta Date],
		[NCM]
	from 
		@TAB

GO
