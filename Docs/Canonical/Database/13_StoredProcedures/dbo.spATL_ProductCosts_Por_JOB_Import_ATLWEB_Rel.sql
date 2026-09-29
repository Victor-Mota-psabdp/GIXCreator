SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[spATL_ProductCosts_Por_JOB_Import_ATLWEB_Rel]'1=Reais(BRL)','GRUPO Dow', '2025-06-01', '2025-06-10'

--Select * from ATL_WEB.dbo.ProductCosts_Por_JOB_Import

CREATE Procedure [dbo].[spATL_ProductCosts_Por_JOB_Import_ATLWEB_Rel]--'1=Reais(BRL)','GRUPO Dow', '2025-05-10', '2025-06-10'
(
	@Tipo	char(1),		--	1=Reais(BRL) / 2=Dolar(USD)
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
		[CFR Total Item Value] float,
		[Envio da Prestação de Contas] Datetime,
		[Group Name]			varchar(20)
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	BEGIN
		Delete ATL_WEB.dbo.ProductCosts_Por_JOB_Import where [Envio da Prestação de Contas] between @DtInicial and @DtFinal and [Group Name] = @Grupo
	END

	Begin
		insert into
			@TAB ([BDP Job],CD_Pedido,Cd_Produto,
			[PO Number],[SHIPPER],[Consignee],[CNPJ],[Incoterm],
			[ORIGIN],[DESTINATION],
			[TIPO DE FRETE],[DI Date],			
			[Currency],[Paridade D.I. Value],[DI Number],
			[Envio da Prestação de Contas],[Group Name]
			)
		select distinct
			HOU.Num_Proc_HIM,PS.CD_Pedido,PS.Cd_Produto,
			PO.numero_po_him,SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc,CNS.Num_CPF_CNPJ,HOU.cd_tp_oper,			 			
			ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HIM ='P' then 'Prepaid' else 'Collect' end),DI.data_po_him,	
			(case when 1 = 1 then 'BRL' else 'USD' end), 
			isnull(PAR.campo_dados,1),
			DI.numero_po_him
			,TP40.dt_conclusao,@Grupo
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
			,TP40.dt_conclusao,@Grupo
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
			,TP40.dt_conclusao,@Grupo
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


	Insert into ATL_WEB.dbo.ProductCosts_Por_JOB_Import
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
		sum([FOB Total Item Value])										[VALOR FOB],
		sum([Freight Value])											[FRETE BL],
		sum([Insurance Value])											[SEGURO],		
		sum([VALOR DA MERCADORIA])										[VALOR DA MERCADORIA],
		sum([AFRMM (Custo) Value])										[MARINHA MERCANTE (AFRMM)],
		sum([Licença Importação (Custo) Value])							[TAXA DE LI],		
		sum([Lib. B/L (Custo) Value])									[LIBERAÇÃO BL],
		sum([ISPS (Custo) Value])										[ISPS],
		sum([Taxa Siscarga (Custo) Value])								[TAXA SISCARGA],
		sum([THC (Custo) Value]	)										[CAPATAZIA (THC)],
		sum([HANDLING (Custo) Value])									[HANDLING],
		sum([DEPOSITO DE CONTAINER(Custo) Value])						[DEPÓSITO CTNR],
		sum([PESAGEM DE CONTAINER (Custo) Value])						[PESAGEM DE CONTAINER],
		sum([POSICIONAMENTO DE CONTANER (Custo) Value])					[POSICIONAMENTO DE CONTAINER],
		sum([Desconsolidação (Custo) Value])							[DESCONSOLIDAÇÃO],
		SUM([DEVOLUCAO DE CONTAINER (Custo) Value])						[DEVOLUÇÃO CTNR],
		sum([Lavagem Container (Custo) Value])							[LAVAGEM DE CONTAINER],					
		
		sum([Custos totais antes da nacionalização])					[Custos antes da nacionalização],
		
		sum([II (Imposto) Value])										[I.I.],
		sum([IPI (Imposto) Value])										[I.P.I.],
		sum([PIS (Imposto) Value])										[PIS],
		sum([COFINS (Imposto) Value])									[COFINS],
		sum([SISCOMEX (Custo) Value])									[TAXA SISCOMEX],
		sum([DIREITOS ANTIDUMPING(Custo) Value])						[DIREITOS ANTIDUMPING],
		SUM([MULTAS(Custo) Value])										[MULTAS],
		sum([ICMS (Imposto) Value])										[ICMS],
				
		sum([CUSTOS DE NACIONALIZAÇÃO])									[CUSTOS DE NACIONALIZAÇÃO],
		
		sum([LABAMA (Custo) Value])										[LABAMA],
		SUM([TRATAMENTO DE MADEIRA/FUMIGACAO(Custo) Value])				[FUMIGAÇÃO],
		sum([Armazenagem (Custo) Value]	)								[ARMAZENAGEM],
		sum([Demurrage (Custo) Value])									[DEMURRAGE],
		sum([Transp. Interno Value]	)									[FRETE INTERNO (INLAND)],
		
		sum([CUSTOS LOGÍSTICOS TOTAIS])									[CUSTOS LOGÍSTICOS],
				
		sum([Despachante (Custo) Value])								[CUSTOS DE DESEMBARAÇO (BDP)],
		sum([Gestão Processo (Custo) Value])							[GESTÃO DE IMPORTAÇÃO (BDP)],
		sum([INSPECAO DE MADEIRA (Custo) Value])						[INSPEÇÃO DE MADEIRA (BDP)],
		SUM([TAXA DE EMISSÃO DA LI (Custo) Value])						[TAXA DE EMISSÃO DA LI],
		SUM([EMISSÃO DANFE (Custo) Value])								[EMISSÃO DANFE],
		SUM([EXONERAÇÃO ICMS (Custo) Value])							[EXONERAÇÃO ICMS],
		
		sum([TOTAL DAS DESPESAS + SERVIÇOS BDP])						[TOTAL DAS DESPESAS + SERVIÇOS BDP], 
		
		sum([OUTROS CUSTOS DO PROCESSO])								[OUTROS CUSTOS DO PROCESSO],
		sum([VALOR DOS ACRÉSCIMOS (DI)])								[VALOR DOS ACRÉSCIMOS (DI)],
				
		SUM([TotaldeCustos])											[CUSTOS TOTAIS DO PROCESSO],
						
		[BDP Job]														[BDP REFERENCE]	
		,[Envio da Prestação de Contas]
		,[Group Name]
	--into ATL_WEB.dbo.ProductCosts_Por_JOB_Import
	from 
		@TAB		
	GRoup by
		[DI Date],[PO Number],[Consignee],[CNPJ],[Incoterm],[SHIPPER],[ORIGIN],[DESTINATION],[TIPO DE FRETE],
		[BDP Job],[Paridade D.I. Value],[Envio da Prestação de Contas],[Group Name]
		

	Select 
		[MONTH],
		[PO Number],
		[SHIPPER],
		[Consignee],
		[CNPJ],
		[Incoterm],
		[ORIGIN],
		[DESTINATION],
		[TIPO DE FRETE],
		[Exchange Rate],
		[VALOR FOB],
		[FRETE BL],
		[SEGURO],
		[VALOR DA MERCADORIA],
		[MARINHA MERCANTE (AFRMM)],
		[TAXA DE LI],
		[LIBERAÇÃO BL],
		[ISPS],
		[TAXA SISCARGA],
		[CAPATAZIA (THC)],
		[HANDLING],
		[DEPÓSITO CTNR],
		[PESAGEM DE CONTAINER],
		[POSICIONAMENTO DE CONTAINER],
		[DESCONSOLIDAÇÃO],
		[DEVOLUÇÃO CTNR],
		[LAVAGEM DE CONTAINER],
		[Custos antes da nacionalização],
		[I.I.],
		[I.P.I.],
		[PIS],
		[COFINS],
		[TAXA SISCOMEX],
		[DIREITOS ANTIDUMPING],
		[MULTAS],
		[ICMS],
		[CUSTOS DE NACIONALIZAÇÃO],
		[LABAMA],
		[FUMIGAÇÃO],
		[ARMAZENAGEM],
		[DEMURRAGE],
		[FRETE INTERNO (INLAND)],
		[CUSTOS LOGÍSTICOS],
		[CUSTOS DE DESEMBARAÇO (BDP)],
		[GESTÃO DE IMPORTAÇÃO (BDP)],
		[INSPEÇÃO DE MADEIRA (BDP)],
		[TAXA DE EMISSÃO DA LI],
		[EMISSÃO DANFE],
		[EXONERAÇÃO ICMS],
		[TOTAL DAS DESPESAS + SERVIÇOS BDP],
		[OUTROS CUSTOS DO PROCESSO],
		[VALOR DOS ACRÉSCIMOS (DI)],
		[CUSTOS TOTAIS DO PROCESSO],
		[BDP REFERENCE]	
		from 
		ATL_WEB.dbo.ProductCosts_Por_JOB_Import with(nolock)
		where 
		[Envio da Prestação de Contas] between @DtInicial and @DtFinal and [Group Name] = @Grupo

	----sp_help ATL_WEB.dbo.ProductCosts_Por_JOB_Import


		
		
		

GO
