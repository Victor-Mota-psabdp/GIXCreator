SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_ProductCosts_Por_JOB_Rel]'1=Reais(BRL', 'IMAMZ201602003BR'
CREATE Procedure [dbo].[spATL_ProductCosts_Por_JOB_Rel]--'1=Reais(BRL)','GRUPO FMC', '2016-01-01', '2016-06-30'
(
	@Tipo	char(1),		--	1=Reais(BRL) / 2=Dolar(USD)
	--@JOB	varchar(16),
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime	
)
AS

	declare @TAB table
	(
		[BDP Job]			char(16),	
		CD_Pedido			int, 
		Cd_Produto			int,	
		
		[Currency]				varchar(3),	
		[DI Number]				varchar(50),
		
		[PO Number]				varchar(100),
		[Consignee]				varchar(200),
		[CNPJ]					varchar(20),
		[SHIPPER]				varchar(200),
		[Incoterm]				varchar(10),
		[ORIGIN]				varchar(100),
		[DESTINATION]			varchar(100),
		[TIPO DE FRETE]			varchar(50),
		[DI Date]				datetime,		
		[FOB Total Item Value]	float,
		[FRETE BL]				float,
		[Insurance Value]		float,
		[Paridade D.I. Value]	float,	
		
		[AFRMM (Custo) Value] float,	
		[Licença Importação (Custo) Value] float,
		[Lib. B/L (Custo) Value] float,
		[ISPS (Custo) Value] float,
		[Taxa Siscarga (Custo) Value] float,
		[THC (Custo) Value] float,
		
		[HANDLING (Custo) Value]	float,
		[DEPOSITO DE CONTAINER(Custo) Value]	float,
		[PESAGEM DE CONTAINER (Custo) Value] float,
		[POSICIONAMENTO DE CONTANER (Custo) Value] float,					
		[Desconsolidação (Custo) Value] float,			
		[DEVOLUCAO DE CONTAINER (Custo) Value] float,		
		[Lavagem Container (Custo) Value] float,
				
		[Custos totais antes da nacionalização]float,
		
		[TotaldeCustos] float,
		[VALOR DA MERCADORIA] float,
		--[CUSTOS CIF (R$)] float,
		
		[II (Imposto) Value] float,	
		[IPI (Imposto) Value] float,
		[PIS (Imposto) Value] float,
		[COFINS (Imposto) Value] float,
		[SISCOMEX (Custo) Value] float,		
		[DIREITOS ANTIDUMPING(Custo) Value] float,		
		[MULTAS(Custo) Value] float,
		[ICMS (Imposto) Value] float,	
		
		[Custos de Nacionalização] float,
		
		[LABAMA (Custo) Value] float,
		[TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value] float,
		[Armazenagem (Custo) Value] float,
		[Demurrage (Custo) Value] float,	
		[Transp. Interno Value] float,
		
		[OUTROS CUSTOS DO PROCESSO]	float,
		[CUSTOS LOGÍSTICOS TOTAIS]float,		
		
		[Despachante (Custo) Value] float,
		[Gestão Processo (Custo) Value] float,
		
		[INSPECAO DE MADEIRA (Custo) Value] float,
		[TAXA DE EMISSÃO DA LI (Custo) Value] float,
		[EMISSÃO DANFE (Custo) Value] float,
		[EXONERAÇÃO ICMS (Custo) Value] float,	
		
		[TOTAL DAS DESPESAS + SERVIÇOS BDP]	float,
		[VALOR DOS ACRÉSCIMOS (DI)]		float,
			
		[Freight Value] float,
		[CIF Total Item Value] float,		
		[CFR Total Item Value] float
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Begin
		insert into
			@TAB ([BDP Job],CD_Pedido,Cd_Produto,
			[PO Number],[SHIPPER],[Consignee],[CNPJ],[Incoterm],
			[ORIGIN],[DESTINATION],
			[TIPO DE FRETE],[DI Date],			
			[Currency],[Paridade D.I. Value],[DI Number]			
			)
		select distinct
			HOU.Num_Proc_HIM,PS.CD_Pedido,PS.Cd_Produto,
			PO.numero_po_him,SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc,CNS.Num_CPF_CNPJ,HOU.cd_tp_oper,			 			
			ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIM ='P' then 'Prepaid' else 'Collect' end),DI.data_po_him,	
			(case when 1 = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,1),
			DI.numero_po_him
		from
			House_IMP_Mar HOU with(nolock)
			join llp_imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_him
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_him			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HIM	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HIM	= DST.cd_local
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_him and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_him = PS.num_proc
			left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
			left join po_him DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_him and PAR.id_campo = 31
			
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_him = TP40.num_proc and TP40.id_task = 76
		where
			--HOU.Num_Proc_Him = @JOB	
			TP40.dt_conclusao between @DtInicial and @DtFinal
			and LLP.Id_status = 8	
		
	UNION ALL
		select distinct 
			HOU.Num_Proc_HIA, PS.CD_Pedido, 
			PS.Cd_Produto,
			PO.numero_po_hia,SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc, CNS.Num_CPF_CNPJ, HOU.cd_tp_oper,			
			ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIA ='P' then 'Prepaid' else 'Collect' end),DI.data_po_hia,
			(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,0),
			DI.numero_po_hia
		from
			House_IMP_aer HOU with(nolock)
			join llp_imp_aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_hia
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_HIA			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HIA	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HIA	= DST.cd_local			
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_hia and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_hia = PS.num_proc
			left join po_hia PO with(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc = 1			
			left join po_hia DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5			
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_hia and PAR.id_campo = 31
			
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_hia = TP40.num_proc and TP40.id_task = 76
		where
			--HOU.Num_Proc_HIA = @JOB
			TP40.dt_conclusao between @DtInicial and @DtFinal
			and LLP.Id_status = 8
	UNION ALL
		select distinct 
			HOU.Num_Proc_HIO, PS.CD_Pedido, 
			PS.Cd_Produto,
			PO.numero_po_hio,SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc, CNS.Num_CPF_CNPJ, HOU.cd_tp_oper,			
			ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIO ='P' then 'Prepaid' else 'Collect' end),DI.data_po_hio,
			(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,0),
			DI.numero_po_hio
		from
			House_Imp_Out HOU with(nolock)
			join llp_imp_Out LLP with(nolock) on LLP.num_proc_lio = HOU.num_proc_hio
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HIO
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_HIO			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HIO	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HIO	= DST.cd_local			
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.Cd_Consig_HIO and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIO = PS.num_proc
			left join PO_HIO PO with(nolock) on PO.Num_Proc_HIO = HOU.Num_Proc_HIO and PO.id_dc = 1			
			left join PO_HIO DI with(nolock) on DI.Num_Proc_HIO = HOU.Num_Proc_HIO and DI.id_dc = 5			
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.Num_Proc_HIO and PAR.id_campo = 31
			
			join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc_HIO = TP40.num_proc and TP40.id_task = 76
		where
			--HOU.Num_Proc_HIA = @JOB
			TP40.dt_conclusao between @DtInicial and @DtFinal
			and LLP.Id_status = 8
			
	End	
	
	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			[II (Imposto) Value] = totII,[IPI (Imposto) Value] = totIPI,
			[FOB Total Item Value] = totFOB, [Freight Value] = totFrete, 
			[Insurance Value] = totSeguro,[CIF Total Item Value] = totCIF
			--[KG/Unit (FOB) Value] = totFOB / totLIQ, 
			--[% II] = pII,  
			--[% IPI] = pIPI
		from 
			@TAB T
			join
			(
			Select 
				sum(VL_II) totII,sum(VL_IPI) totIPI,				
				sum(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) totFOB,
				sum(Vlr_FRETE) totFrete,
				sum(vlr_Seguro) totSeguro,sum(CIF) totCIF,
				--max(ALIQ_II) pII,  max(ALIQ_IPI) pIPI, sum(Peso_Liquido) totLIQ, 
				Cd_Produto,num_proc
			from nota_fiscal_cliente_det NFCD with(nolock)
			join nota_cliente NC with(nolock) on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			group by Cd_Produto, num_proc
			) A on A.num_proc = T.[BDP Job] and A.cd_produto = T.cd_produto
	End

	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
		[AFRMM (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%AFRMM%'),
		[Licença Importação (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'LI %') + dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%licen%'),
		[Lib. B/L (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lib%BL%'),
		[ISPS (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'ISPS%'),
		[Taxa Siscarga (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Siscarga%'),
		[THC (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'THC%') + dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Capatazia%'),
		[HANDLING (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'HANDLING%'),
		[DEPOSITO DE CONTAINER(Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Deposito%container%'),
		[PESAGEM DE CONTAINER (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'PESAGEM%CTNR%'),
		[POSICIONAMENTO DE CONTANER (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'Posicionamento%CNTR%'),
		[Desconsolidação (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Desconso%'),
		[DEVOLUCAO DE CONTAINER (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'DEVOLUCAO%CNTR%'),
		[Lavagem Container (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lavagem CNTR%'),
		
		[PIS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%PIS%'),
		[COFINS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%COFINS%'),
		[SISCOMEX (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%SISCO%'),
		[DIREITOS ANTIDUMPING(Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Direitos%'),
		[MULTAS(Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'MULTAS%'),
		[ICMS (Imposto) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%ICMS%'),
		[LABAMA (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Exame%Laboratorial%'),	
		[TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%FUMIGACAO%'),
		[Armazenagem (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Armazenagem%'),
		[Demurrage (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Demurrage%'),
		[Transp. Interno Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Frete Int%'),
		[Despachante (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Serv%Desp%'),		
		[Gestão Processo (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Serviços de Gestão%'),
		[INSPECAO DE MADEIRA (Custo) Value]	= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%INSPECAO%Madeira%'),
		[TAXA DE EMISSÃO DA LI (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'EMISSÃO%LI%'),
		[EMISSÃO DANFE (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Emissão%NFE%'),
		[EXONERAÇÃO ICMS (Custo) Value]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%EXONERAÇÃO%'),
		[VALOR DOS ACRÉSCIMOS (DI)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, '%ACRÉSCIMOS%'),
		
		[OUTROS CUSTOS DO PROCESSO] = 	dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%')		
			
	End
	
	BEGIN
		Update @TAB
		set	
		[VALOR DA MERCADORIA] = isnull([FOB Total Item Value],0) + isnull([Freight Value],0) + isnull([Insurance Value],0)
	END
	
	Begin
		Update @TAB
		set			
			[Paridade D.I. Value] = (case when [Paridade D.I. Value] = 0 then 1 when [Paridade D.I. Value] is null then 1 else [Paridade D.I. Value] end)
	End
		
	Begin
		Update @TAB
		set	
			[Custos totais antes da nacionalização] = 
			isnull([VALOR DA MERCADORIA],0) +
			isnull([AFRMM (Custo) Value],0) +
			isnull([Licença Importação (Custo) Value],0) +
			isnull([Lib. B/L (Custo) Value] ,0) +	
			isnull([ISPS (Custo) Value] ,0) +
			isnull([Taxa Siscarga (Custo) Value],0) +
			isnull([THC (Custo) Value],0) +
			isnull([HANDLING (Custo) Value] ,0) +
			isnull([DEPOSITO DE CONTAINER(Custo) Value] ,0) +
			isnull([PESAGEM DE CONTAINER (Custo) Value] ,0) +
			isnull([POSICIONAMENTO DE CONTANER (Custo) Value],0) +
			isnull([Desconsolidação (Custo) Value] ,0) +
			isnull([DEVOLUCAO DE CONTAINER (Custo) Value],0) +
			isnull([Lavagem Container (Custo) Value],0)
	End
	
	Begin
		Update @TAB
		set
			[Custos de Nacionalização] = (
					isnull([Custos totais antes da nacionalização],0) +				
					isnull([II (Imposto) Value] ,0) +	
					isnull([IPI (Imposto) Value] ,0) +
					isnull([PIS (Imposto) Value] ,0) +
					isnull([COFINS (Imposto) Value],0) +
					isnull([SISCOMEX (Custo) Value] ,0) +
					isnull([DIREITOS ANTIDUMPING(Custo) Value] ,0) +
					isnull([MULTAS(Custo) Value] ,0) +
					isnull([ICMS (Imposto) Value],0))			
	End	
	
	
		
	Begin
		Update @TAB
		set	
			[CUSTOS LOGÍSTICOS TOTAIS] = (
							isnull([Custos de Nacionalização] ,0) + 
							isnull([LABAMA (Custo) Value] ,0) + 
							isnull([TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value] ,0) + 
							isnull([Armazenagem (Custo) Value] ,0) +  
							isnull([Demurrage (Custo) Value] ,0) + 	
							isnull([Transp. Interno Value],0))
	End
	
	Begin
		Update @TAB
		set	
			[TOTAL DAS DESPESAS + SERVIÇOS BDP] = isnull([CUSTOS LOGÍSTICOS TOTAIS],0)
				+isnull([Despachante (Custo) Value],0)
				+isnull([Gestão Processo (Custo) Value],0)
				+isnull([INSPECAO DE MADEIRA (Custo) Value],0)
				+isnull([TAXA DE EMISSÃO DA LI (Custo) Value],0)
				+isnull([EMISSÃO DANFE (Custo) Value],0)
				+isnull([EXONERAÇÃO ICMS (Custo) Value]	,0)
				+isnull([VALOR DOS ACRÉSCIMOS (DI)],0)	
	End
	
	
	Begin
		Update @TAB
		set	
			[OUTROS CUSTOS DO PROCESSO]	= isnull([OUTROS CUSTOS DO PROCESSO],0)  - isnull([TOTAL DAS DESPESAS + SERVIÇOS BDP],0)			
	End
	
	Begin
		Update @TAB
		set 
			[TotaldeCustos] = [OUTROS CUSTOS DO PROCESSO] + [TOTAL DAS DESPESAS + SERVIÇOS BDP]
	End	


	If @Tipo = '2' -- em Dolar(USD)
		Begin
			Update @TAB
			set
				[FOB Total Item Value]	=	isnull([FOB Total Item Value],0)	/	isnull([Paridade D.I. Value],1),
				[Insurance Value]		=	isnull([Insurance Value],0)	/	isnull([Paridade D.I. Value],1),
				
				[AFRMM (Custo) Value]	=	isnull([AFRMM (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Licença Importação (Custo) Value]	=	isnull([Licença Importação (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Lib. B/L (Custo) Value]	=	isnull([Lib. B/L (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[ISPS (Custo) Value]	=	isnull([ISPS (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Taxa Siscarga (Custo) Value]	=	isnull([Taxa Siscarga (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[THC (Custo) Value]		=	isnull([THC (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[HANDLING (Custo) Value]		=	isnull([HANDLING (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[DEPOSITO DE CONTAINER(Custo) Value] = isnull([DEPOSITO DE CONTAINER(Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[PESAGEM DE CONTAINER (Custo) Value] = isnull([PESAGEM DE CONTAINER (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[POSICIONAMENTO DE CONTANER (Custo) Value] = isnull([POSICIONAMENTO DE CONTANER (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Desconsolidação (Custo) Value]	=	isnull([Desconsolidação (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[DEVOLUCAO DE CONTAINER (Custo) Value] = isnull([DEVOLUCAO DE CONTAINER (Custo) Value],0)/isnull([Paridade D.I. Value],1),	
				[Lavagem Container (Custo) Value]	=	isnull([Lavagem Container (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[II (Imposto) Value]	=	isnull([II (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[IPI (Imposto) Value]	=	isnull([IPI (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[PIS (Imposto) Value]	=	isnull([PIS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[COFINS (Imposto) Value] =	isnull([COFINS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),
				[SISCOMEX (Custo) Value]	=	isnull([SISCOMEX (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[DIREITOS ANTIDUMPING(Custo) Value] =isnull([DIREITOS ANTIDUMPING(Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[MULTAS(Custo) Value]  =isnull([MULTAS(Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[ICMS (Imposto) Value]	=	isnull([ICMS (Imposto) Value],0)	/	isnull([Paridade D.I. Value],1),	
				[LABAMA (Custo) Value] = isnull([LABAMA (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value]= isnull([TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Armazenagem (Custo) Value]	=	isnull([Armazenagem (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Demurrage (Custo) Value]	=	isnull([Demurrage (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[Transp. Interno Value]	= isnull([Transp. Interno Value],0)	/	isnull([Paridade D.I. Value],1),
				[Despachante (Custo) Value]	= isnull([Despachante (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),				
				[Gestão Processo (Custo) Value]	= isnull([Gestão Processo (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[INSPECAO DE MADEIRA (Custo) Value]	= isnull([INSPECAO DE MADEIRA (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[TAXA DE EMISSÃO DA LI (Custo) Value] = isnull([TAXA DE EMISSÃO DA LI (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[EMISSÃO DANFE (Custo) Value] = isnull([EMISSÃO DANFE (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
				[EXONERAÇÃO ICMS (Custo) Value] = isnull([EXONERAÇÃO ICMS (Custo) Value],0)	/	isnull([Paridade D.I. Value],1),
									
				[Custos totais antes da nacionalização] = isnull([Custos totais antes da nacionalização],0)	/	isnull([Paridade D.I. Value],1),
				[Custos de Nacionalização] = isnull([Custos de Nacionalização],0)	/	isnull([Paridade D.I. Value],1),
				[OUTROS CUSTOS DO PROCESSO]	= isnull([OUTROS CUSTOS DO PROCESSO],0)	/	isnull([Paridade D.I. Value],1),
				[CUSTOS LOGÍSTICOS TOTAIS]= isnull([CUSTOS LOGÍSTICOS TOTAIS],0)	/	isnull([Paridade D.I. Value],1),
				[TOTAL DAS DESPESAS + SERVIÇOS BDP] = isnull([TOTAL DAS DESPESAS + SERVIÇOS BDP],0)	/	isnull([Paridade D.I. Value],1),
				[TotaldeCustos] = isnull([TotaldeCustos],0)	/	isnull([Paridade D.I. Value],1),
				[CIF Total Item Value]	=	isnull([CIF Total Item Value],0)	/	isnull([Paridade D.I. Value],1),				
				[CFR Total Item Value]	=	isnull([CFR Total Item Value],0)	/	isnull([Paridade D.I. Value],1),
				[Freight Value]			=	isnull([Freight Value],0)	/	isnull([Paridade D.I. Value],1)
					
		End


	select
		datename(month,[DI Date]) + ' - ' + convert(varchar(10),datepart(year,[DI Date])) [MONTH],		
		[PO Number],
		[SHIPPER],
		[Consignee],
		[CNPJ],
		[Incoterm],
		[ORIGIN],
		[DESTINATION],
		[TIPO DE FRETE],
		replace(CONVERT(varchar(10),[Paridade D.I. Value]),'.',',')		[Exchange Rate],			
		sum([FOB Total Item Value])								[VALOR FOB],
		sum([Freight Value])									[FRETE BL],
		sum([Insurance Value])									[SEGURO],		
		sum([VALOR DA MERCADORIA])								[VALOR DA MERCADORIA],
		sum([AFRMM (Custo) Value])									[MARINHA MERCANTE (AFRMM)],
		sum([Licença Importação (Custo) Value])						[TAXA DE LI],		
		sum([Lib. B/L (Custo) Value])								[LIBERAÇÃO BL],
		sum([ISPS (Custo) Value])									[ISPS],
		sum([Taxa Siscarga (Custo) Value])							[TAXA SISCARGA],
		sum([THC (Custo) Value]	)									[CAPATAZIA (THC)],
		sum([HANDLING (Custo) Value])								[HANDLING],
		sum([DEPOSITO DE CONTAINER(Custo) Value])					[DEPÓSITO CTNR],
		sum([PESAGEM DE CONTAINER (Custo) Value])					[PESAGEM DE CONTAINER],
		sum([POSICIONAMENTO DE CONTANER (Custo) Value])				[POSICIONAMENTO DE CONTAINER],
		sum([Desconsolidação (Custo) Value])						[DESCONSOLIDAÇÃO],
		SUM([DEVOLUCAO DE CONTAINER (Custo) Value])					[DEVOLUÇÃO CTNR],
		sum([Lavagem Container (Custo) Value])						[LAVAGEM DE CONTAINER],					
		
		sum([Custos totais antes da nacionalização])				[Custos antes da nacionalização],
		
		sum([II (Imposto) Value])									[I.I.],
		sum([IPI (Imposto) Value])									[I.P.I.],
		sum([PIS (Imposto) Value])									[PIS],
		sum([COFINS (Imposto) Value])								[COFINS],
		sum([SISCOMEX (Custo) Value])								[TAXA SISCOMEX],
		sum([DIREITOS ANTIDUMPING(Custo) Value])					[DIREITOS ANTIDUMPING],
		SUM([MULTAS(Custo) Value])									[MULTAS],
		sum([ICMS (Imposto) Value])									[ICMS],
				
		sum([CUSTOS DE NACIONALIZAÇÃO])								[CUSTOS DE NACIONALIZAÇÃO],
		
		sum([LABAMA (Custo) Value])									[LABAMA],
		SUM([TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value])			[FUMIGAÇÃO],
		sum([Armazenagem (Custo) Value]	)							[ARMAZENAGEM],
		sum([Demurrage (Custo) Value])								[DEMURRAGE],
		sum([Transp. Interno Value]	)								[FRETE INTERNO (INLAND)],
		
		sum([CUSTOS LOGÍSTICOS TOTAIS])								[CUSTOS LOGÍSTICOS],
				
		sum([Despachante (Custo) Value])							[CUSTOS DE DESEMBARAÇO (BDP)],
		sum([Gestão Processo (Custo) Value])						[GESTÃO DE IMPORTAÇÃO (BDP)],
		sum([INSPECAO DE MADEIRA (Custo) Value])					[INSPEÇÃO DE MADEIRA (BDP)],
		SUM([TAXA DE EMISSÃO DA LI (Custo) Value])					[TAXA DE EMISSÃO DA LI],
		SUM([EMISSÃO DANFE (Custo) Value])							[EMISSÃO DANFE],
		SUM([EXONERAÇÃO ICMS (Custo) Value])						[EXONERAÇÃO ICMS],
		
		sum([TOTAL DAS DESPESAS + SERVIÇOS BDP])					[TOTAL DAS DESPESAS + SERVIÇOS BDP], 
		
		sum([OUTROS CUSTOS DO PROCESSO])							[OUTROS CUSTOS DO PROCESSO],
		sum([VALOR DOS ACRÉSCIMOS (DI)])							[VALOR DOS ACRÉSCIMOS (DI)],
				
		SUM([TotaldeCustos])										[CUSTOS TOTAIS DO PROCESSO],
						
		[BDP Job]													[BDP REFERENCE]		
	from 
		@TAB
		
	GRoup by
		[DI Date],[PO Number],[Consignee],[CNPJ],[Incoterm],[SHIPPER],[ORIGIN],[DESTINATION],[TIPO DE FRETE],
		--[Freight Value],
		[BDP Job],[Paridade D.I. Value]
		
		
		
		
		
		
		
		/*
		
		[MONTH] - Mês e Ano da DI	
[PO Number] - PO amarrado ao JOB
[SHIPPER] - Shipper do JOB
[Consignee] - Consignatario do JOB
[CNPJ]- CNPJ do Consignatario do JOB
[Incoterm] - Incoterm do JOB
[ORIGIN] - Porto de Embarque
[DESTINATION]  - Porto de Descarga
[TIPO DE FRETE] - Tipo de Frete do JOB
[VALOR FOB] - (CIF - vlr_frete - vlr_seguro) - acrescimos da Nota Fiscal
[FRETE BL] - Frete do JOB
[SEGURO] - vlr_seguro da Nota Fiscal
[CUSTOS CIF (MOEDA NEGOCIADA)] = [VALOR FOB] + [FRETE BL] + [SEGURO]		
[Exchange Rate] - Paridade DI - Additional fields do JOB
[CUSTOS CIF (R$)] = [CUSTOS CIF (MOEDA NEGOCIADA)] /[Exchange Rate]		
[MARINHA MERCANTE (AFRMM)] = Taxas Lançadas no custo com nome parecido com "AFRMM%"
[TAXA DE LI] = Taxas Lançadas no custo com nome parecido com "LI %" + Taxas Lançadas no custo com nome parecido com "%licen%"	
[LIBERAÇÃO BL] = Taxas Lançadas no custo com nome parecido com "Lib%BL%"
[ISPS] = Taxas Lançadas no custo com nome parecido com "ISPS%"
[TAXA SISCARGA] = Taxas Lançadas no custo com nome parecido com "%Siscarga%"
[CAPATAZIA (THC)]= Taxas Lançadas no custo com nome parecido com "THC%" + Taxas Lançadas no custo com nome parecido com "Capatazia%" 								
[HANDLING] = Taxas Lançadas no custo com nome parecido com "HANDLING%"
[DEPÓSITO CTNR] = Taxas Lançadas no custo com nome parecido com "Deposito%container%"
[PESAGEM DE CONTAINER] = Taxas Lançadas no custo com nome parecido com "PESAGEM%CTNR%"
[POSICIONAMENTO DE CONTAINER] = Taxas Lançadas no custo com nome parecido com "Posicionamento%CNTR%"
[DESCONSOLIDAÇÃO] = Taxas Lançadas no custo com nome parecido com "Desconso%"
[DEVOLUÇÃO CTNR]= Taxas Lançadas no custo com nome parecido com "DEVOLUCAO%CNTR%"
[LAVAGEM DE CONTAINER] = Taxas Lançadas no custo com nome parecido com "Lavagem CNTR%"

[OUTROS CUSTOS ANTES DA NACIONALIZAÇÃO] = Taxas Lançadas no custo - 		
			([AFRMM (Custo) Value] + [Licença Importação (Custo) Value]+ [Lib. B/L (Custo) Value]+[ISPS (Custo) Value]
			+ [Taxa Siscarga (Custo) Value]+[THC (Custo) Value] +[HANDLING (Custo) Value] +	[DEPOSITO DE CONTAINER(Custo) Value]
			+ [PESAGEM DE CONTAINER (Custo) Value]+	[POSICIONAMENTO DE CONTANER (Custo) Value]+	[Desconsolidação (Custo) Value] 
			+ [DEVOLUCAO DE CONTAINER (Custo) Value]+[Lavagem Container (Custo) Value]+	[PIS (Imposto) Value]+[COFINS (Imposto) Value]
			+[SISCOMEX (Custo) Value]+[DIREITOS ANTIDUMPING(Custo) Value]+[MULTAS(Custo) Value]+[ICMS (Imposto) Value]
			+[LABAMA (Custo) Value]+[TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value]+[Armazenagem (Custo) Value]+	[Demurrage (Custo) Value]
			+[Transp. Interno Value] +	[Despachante (Custo) Value]+[Gestão Processo (Custo) Value]+[INSPECAO DE MADEIRA (Custo) Value]	
			+[TAXA DE EMISSÃO DA LI (Custo) Value]+	[EMISSÃO DANFE (Custo) Value]+[EXONERAÇÃO ICMS (Custo) Value])
					
[Custos totais antes da nacionalização] = Taxas Lançadas no custo
		
[I.I.] = II da Nota Fiscal
[I.P.I.] = IPI  da Nota Fiscal
[PIS] = Taxas Lançadas no custo com nome parecido com "%PIS%"
[COFINS] = Taxas Lançadas no custo com nome parecido com "%COFINS%"
[TAXA SISCOMEX] = Taxas Lançadas no custo com nome parecido com "%SISCO%"
[DIREITOS ANTIDUMPING]= Taxas Lançadas no custo com nome parecido com "Direitos%"
[MULTAS]= Taxas Lançadas no custo com nome parecido com "MULTAS%"
[ICMS]= Taxas Lançadas no custo com nome parecido com "%ICMS%"

[CUSTOS DE NACIONALIZAÇÃO] = ([Custos totais antes da nacionalização] +				
					[II (Imposto) Value] + 	[IPI (Imposto) Value] + [PIS (Imposto) Value] +	[COFINS (Imposto) Value] +
					[SISCOMEX (Custo) Value] +	[DIREITOS ANTIDUMPING(Custo) Value]+[MULTAS(Custo) Value] +
					[ICMS (Imposto) Value])
		
[LABAMA]= Taxas Lançadas no custo com nome parecido com "%Exame%Laboratorial%"
[TROCA DE PALLET / TRATAMENTO DE MADEIRA / FUMIGAÇÃO]= Taxas Lançadas no custo com nome parecido com "%FUMIGACAO%"
[ARMAZENAGEM]= Taxas Lançadas no custo com nome parecido com "%Armazenagem%"
[DEMURRAGE]= Taxas Lançadas no custo com nome parecido com "%Demurrage%"
[FRETE INTERNO (INLAND)]= Taxas Lançadas no custo com nome parecido com "Frete Int%"		

[OUTROS CUSTOS DO PROCESSO]  = ?

[CUSTOS LOGÍSTICOS TOTAIS] = ([Custos de Nacionalização] + [LABAMA (Custo) Value] +
							[TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value] +
							[Armazenagem (Custo) Value] + [Demurrage (Custo) Value] +	[Transp. Interno Value]
							+ [OUTROS CUSTOS DO PROCESSO])
				
[CUSTOS DE DESEMBARAÇO (BDP)]= Taxas Lançadas no custo com nome parecido com "Serv%Desp%"
[GESTÃO DE IMPORTAÇÃO (BDP)]= Taxas Lançadas no custo com nome parecido com "Gestão%"
[INSPEÇÃO DE MADEIRA (BDP)]= Taxas Lançadas no custo com nome parecido com "%INSPECAO%Madeira%"
[TAXA DE EMISSÃO DA LI]= Taxas Lançadas no custo com nome parecido com "EMISSÃO%LI%"
[EMISSÃO DANFE]= Taxas Lançadas no custo com nome parecido com "%Emissão%NFE%"
[EXONERAÇÃO ICMS]= Taxas Lançadas no custo com nome parecido com "%EXONERAÇÃO%"
		
		
[TOTAL DAS DESPESAS + SERVIÇOS BDP] =[CUSTOS LOGÍSTICOS TOTAIS]+[Despachante (Custo) Value]+[Gestão Processo (Custo) Value] +			
			[INSPECAO DE MADEIRA (Custo) Value]+[TAXA DE EMISSÃO DA LI (Custo) Value]+[EMISSÃO DANFE (Custo) Value] +
			[EXONERAÇÃO ICMS (Custo) Value]
		
5[BDP REFERENCE] = [BDP Job]
		
		*/
		
		
		
		
		/*'##'													[HANDLING],
		'##'													[DEPÓSITO CTNR],
		'##'													[PESAGEM DE CONTAINER],
		'##'													[POSICIONAMENTO DE CONTAINER],

		'##'													[DEVOLUÇÃO CTNR],

		'BDP System:A idéia aqui é: se aparecer algum outro custo 
		que porventura não tenha sido listado nas colunas anteriores, 
		incluir o somatório deles aqui.'						[OUTROS CUSTOS ANTES DA NACIONALIZAÇÃO],
		'Somatório de todos os custos até este momento do processo'[CUSTOS ANTES DA NACIONALIZAÇÃO],

		'##'													[DIREITOS ANTIDUMPING],
		'##'													[MULTAS],

		'## =soma(AF11:AN11)'									[CUSTOS DE NACIONALIZAÇÃO],
		'##'													[LABAMA],
		'##'													[TROCA DE PALLET / TRATAMENTO DE MADEIRA / FUMIGAÇÃO],
	
		'Somatório de todos os outros custos lançados no job, 
		que não foram mencionados nas colunas anteriores. 
		Mas aparecem na aba custos / Conta corrente'			[OUTROS CUSTOS DO PROCESSO],
		'## =SOMA(AO11:AU11)'									[CUSTOS LOGÍSTICOS TOTAIS],		
	
		'##'													[INSPEÇÃO DE MADEIRA (BDP)],
		'##'													[TAXA DE EMISSÃO DA LI],
		'##'													[EMISSÃO DANFE],
		'##'													[EXONERAÇÃO ICMS],
		'## =SOMA(AV11:BB11)'									[TOTAL DAS DESPESAS + SERVIÇOS BDP],
	
*/




/*[Item],[Cod. Produto],
[Descrição do Produto],[Incoterm],
[Modal],[Invoice Date],
[Invoice Number],[DI Number],
[DI Date],[ATD Date],[ATA Date],
--[NF Number],[NF Date],
[Quantity],[UOM],[Currency],
[CFR Total Item Value],
[KG/Unit (FOB) Value],
[Freight Value],[% II],[% IPI],			
[Add. Freight (Custo) Value],
[BAF (Custo) Value],
[ISS (Custo) Value],				
[SDA (Custo) Value],
[Total Despesas Value],
[Total Custos Value],
[Custo/Qtd Value],
[Custo Final/Qtd Value],
[Prest. Contas Date],
[Entr. Planta Date],
[NCM]





--[spATL_ProductCosts_Por_JOB_Rel]'1=Reais(BRL', 'IMAMZ201602002BR'
ALTER Procedure [dbo].[spATL_ProductCosts_Por_JOB_Rel]--'1=Reais(BRL', 'IMAMZ201602002BR'
(
	@Tipo	char(1),		--	1=Reais(BRL) / 2=Dolar(USD)
	@JOB	varchar(16)
)
AS

	declare @TAB table
	(
		[BDP Job]			char(16),
		[JOB Date]			datetime,
		[Consignee]			varchar(50),
		[CNPJ]				varchar(20),
		[SHIPPER]			varchar(50),
		[ORIGIN]			varchar(50),
		[DESTINATION]		varchar(50),
		[TIPO DE FRETE]		varchar(50),
		[FRETE BL]			float,		
		[PO Number]			varchar(50),
		[Item]				varchar(6),
		[Cod. Produto]		varchar(50),
		[Descrição do Produto] varchar(200),
		[Incoterm] varchar(10),
		[Modal] varchar(20),
		[Invoice Date] datetime,
		[Invoice Number] varchar(50),
		[DI Number] varchar(50),
		[DI Date] datetime,
		[ATD Date] datetime,
		[ATA Date] datetime,
		--[NF Number] varchar(50),
		--[NF Date] datetime,
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

	--Declare @Cd_Grupo as varchar(10)
	--Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Begin
		insert into
			@TAB ([BDP Job],[JOB Date],[Consignee],[CNPJ],
			
			[SHIPPER],[ORIGIN],[DESTINATION],[TIPO DE FRETE],[FRETE BL],
						
			[PO Number],[Item],[Cod. Produto],[Descrição do Produto],[Incoterm],
			[Modal],[Invoice Date],[Invoice Number],[DI Number],[DI Date],[ATD Date],[ATA Date],
			--[NF Number],[NF Date],
			[Quantity],[UOM],[Currency],[Paridade D.I. Value],[Prest. Contas Date],[Entr. Planta Date],CD_Pedido, Cd_Produto)
		select
			HOU.Num_Proc_HIM, convert(datetime,HOU.Dt_Emis_Him,105),CNS.apelido, CNS.Num_CPF_CNPJ, 
			
			SHP.Nome_Raz_Soc,ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIM ='P' then 'Prepaid' else 'Collect' end),HOU.Vlr_Frete_Efet_HIM,
			
			PO.numero_po_him,PS.item,
			PC.cd_proc_cliente, PC.Produto_Descr, HOU.cd_tp_oper, 'Sea Import', INV.data_po_him, INV.numero_po_him, 
			DI.numero_po_him, DI.data_po_him, LLP.atd_lim, LLP.ata_lim, 
			--NF.numero_po_him, NF.data_po_him, 
			PS.qty, PD.UOM,(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,1), TP40.dt_conclusao, TP13.dt_conclusao, PS.CD_Pedido, PS.Cd_Produto
		from
			House_IMP_Mar HOU with(nolock)
			join llp_imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_him
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_him			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HIM	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HIM	= DST.cd_local
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_him --and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_him = PS.num_proc
			join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP13 with(nolock) on HOU.num_proc_him = TP13.num_proc and TP13.id_task = 13
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_him = TP40.num_proc and TP40.id_task = 40
			left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
			left join po_him INV with(nolock) on INV.num_proc_him = HOU.num_proc_him and INV.id_dc = 2
			left join po_him DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
			--left join po_him NF with(nolock) on NF.num_proc_him = HOU.num_proc_him and NF.id_dc = 10
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_him and PAR.id_campo = 31
		where
			HOU.Num_Proc_Him = @JOB			
		
		UNION ALL
		select
			HOU.Num_Proc_HIA, convert(datetime,HOU.Dt_Emis_HiA,105),CNS.apelido, CNS.Num_CPF_CNPJ, 
			
			SHP.Nome_Raz_Soc,ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIA ='P' then 'Prepaid' else 'Collect' end),HOU.Vlr_Frete_Efet_HIA,
			
			PO.numero_po_hia,PS.item,
			 PC.cd_proc_cliente, PC.Produto_Descr, HOU.cd_tp_oper, 'Air Import', INV.data_po_hia, INV.numero_po_hia, 
			 DI.numero_po_hia, DI.data_po_hia, LLP.atd_lia, LLP.ata_lia, 
			 --NF.numero_po_hia, NF.data_po_hia, 
			 PS.qty, PD.UOM,(case when @Tipo = 1 then 'BRL' else 'USD' end), isnull(PAR.campo_dados,0), TP40.dt_conclusao, 
			 TP13.dt_conclusao, PS.CD_Pedido, PS.Cd_Produto
		from
			House_IMP_aer HOU with(nolock)
			join llp_imp_aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_hia
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_HIA			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HIA	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HIA	= DST.cd_local			
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_hia --and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_hia = PS.num_proc
			join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP13 with(nolock) on HOU.num_proc_hia = TP13.num_proc and TP13.id_task = 13
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_hia = TP40.num_proc and TP40.id_task = 40
			left join po_hia PO with(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc = 1
			left join po_hia INV with(nolock) on INV.num_proc_hia = HOU.num_proc_hia and INV.id_dc = 2
			left join po_hia DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5
			--left join po_hia NF with(nolock) on NF.num_proc_hia = HOU.num_proc_hia and NF.id_dc = 10
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc_hia and PAR.id_campo = 31
		where
			HOU.Num_Proc_HIA = @JOB
			
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
		datename(month,[DI Date]) + ' - ' + convert(varchar(10),datepart(year,[DI Date])) [MONTH],
		
		[BDP Job],[JOB Date],[Consignee],[CNPJ],
		
		[SHIPPER],[ORIGIN],[DESTINATION],[TIPO DE FRETE],[FRETE BL],		
		
		[PO Number],[Item],[Cod. Produto],[Descrição do Produto],[Incoterm],[Modal],[Invoice Date],[Invoice Number],[DI Number],
		[DI Date],[ATD Date],[ATA Date],
		--[NF Number],[NF Date],
		[Quantity],[UOM],[Currency],
		[Paridade D.I. Value],[CIF Total Item Value],[FOB Total Item Value],[CFR Total Item Value],[KG/Unit (FOB) Value],
		[Freight Value],[Insurance Value],[% II],[II (Imposto) Value],[% IPI],[IPI (Imposto) Value],[PIS (Imposto) Value],
		[COFINS (Imposto) Value],[ICMS (Imposto) Value],
		[AFRMM (Custo) Value],[Add. Freight (Custo) Value],[Armazenagem (Custo) Value],[Demurrage (Custo) Value],
		[THC (Custo) Value],[BAF (Custo) Value],[Transp. Interno Value],[Despachante (Custo) Value],[Lib. B/L (Custo) Value],
		[SISCOMEX (Custo) Value],[ISPS (Custo) Value],[Desconsolidação (Custo) Value],[Lavagem Container (Custo) Value],
		[Gestão Processo (Custo) Value],[ISS (Custo) Value],[Taxa Siscarga (Custo) Value],[Licença Importação (Custo) Value],
		[SDA (Custo) Value],[Total Despesas Value],[Total Custos Value],[Custo/Qtd Value],[Custo Final/Qtd Value],[Prest. Contas Date],
		[Entr. Planta Date],
		[NCM]
	from 
		@TAB
*/
GO
