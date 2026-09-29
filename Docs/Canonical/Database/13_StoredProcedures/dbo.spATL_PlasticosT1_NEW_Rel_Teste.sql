SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_PlasticosT1_NEW_Rel_Teste 'GRupo Dow', '2021-01-01','2021-10-30','0'
CREATE Procedure	[dbo].[spATL_PlasticosT1_NEW_Rel_Teste]
(
	@Grupo varchar(20),
	@Dt_Inicial	datetime,
	@Dt_Final	datetime,
	@Tipo varchar(100)		--	0=OPEN / 1=CLOSE
)
As
	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	set @Tipo = left(@Tipo,1)

	select
		(case when H54hj.HSGDataFU is NOT NULL then 'ALTERADA' else 'NÃO ALTERADA' end)  [Status],
		Right(Left(P.Planta,5),2)					[Company ID],
		P.Planta									[Planta],
		P.Num_Pedido								[SAP],
		isnull(PO1.numero_po_hia,P.Num_PO)			[PO],
		isnull(PO9.numero_po_hia,P.Customer_PO)		[Customer PO],		
		HOU.Num_Proc_HIA							[BDP Reference],
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)			[GMID],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)		[Produto],
		sum(isnull(PD.Peso_Liquido_TOT,0))/1000		[TON],
		LLP.Canal_LIA								[Channel],
		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 then Peso_real_hia else sum(isnull(PD.Peso_Liquido_TOT,0))	end) [Peso Liquido],
		(case when isnull(Peso_Bruto_hia,0) > Peso_real_hia then Peso_Bruto_hia else sum(isnull(PD.Peso_Bruto_TOT,0)) end) [Peso Bruto],
		DS.Nome_Local								[Porto de Embarque],
		HOU.voo_HIA									[Navio],
		HOU.Voo_HIA									[Voyage],
		LC.Nome_Local								[Porto de Chegada],
		LLP.ETD_LIA									[ETD Date],
		LLP.ATD_LIA									[Data de Embarque],
		LLP.ETA_LIA									[ETA Date],
		ATA_LIA										[Atracação Date],
		T15.dt_conclusao							[Presença Carga Date],
		T63.Dt_Conclusao							[Docs Ok to Register Date],
		PO5.numero_po_hia							[Entry Number],
		T4.dt_conclusao								[Customs Clearance Date],
		T13.dt_conclusao							[Transport Doc Delivery Date],
		--isnull(max(H54hj.HSGDataFU),ETA_Lia +13)	[Previsão Date],
		max(H54hj.HSGDataFU)	[Previsão Date],
		--(case when max(H54hj.HSDDescricao) is not null then 
		--		convert(varchar(10), max(H54hj.HSGData),103) + ' Previsão: ' + convert(varchar(10),max(H54hj.HSGDataFU),103) + ' - ' + max(H54hj.HSDDescricao)
		--	else
		--		(select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral where hsgprocesso = hou.num_proc_hia and cd_tp_ocor = 54 and disp_cliente = 'S' order by hsgseq desc) end) [Motivo de Atraso],
		(Select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral with(nolock) where hsgprocesso = hou.num_proc_hia and HSGDataFU is not null and disp_cliente = 'S' order by hsgseq desc) [Motivo de Atraso],
		AGT.Nome_Raz_Soc							[Agente de Carga],
		CIA.Nome_Cia_Aer							[Armador],
		'AIR'										[Modal],
		HOU.MAWB_HIA								[MAWB],
		HOU.HAWB_HIA								[HAWB],
		CON.Num_CPF_CNPJ							[CNPJ]						
		
	from
		House_Imp_Aer HOU with(nolock)
		INNER HASH JOIN LLP_Imp_Aer LLP with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Left HASH JOIN Job_Imp_Aer JIA with(nolock) on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
		INNER HASH JOIN Pedido_Ship PS  with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
		INNER HASH JOIN Pedido P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		INNER HASH JOIN Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Left HASH JOIN Localidade LC with(nolock) on Hou.Cd_Dst_HIA = Lc.Cd_Local
		Left HASH JOIN Localidade DS with(nolock) on Hou.Cd_org_HIA = DS.Cd_Local
		Left HASH JOIN Cia_Aerea	CIA with(nolock) on JIA.Cd_Cia_Aer = CIA.Cd_Cia_Aer
		Left HASH JOIN Pessoa AGT with(nolock) on JIA.cd_agente = AGT.cd_pes
		Left HASH JOIN Pessoa CON with(nolock) on HOU.Cd_Consig_HIA = CON.Cd_Pes
		left HASH JOIN po_hia PO1 with(nolock) on PO1.num_proc_hia = HOU.num_proc_hia and PO1.id_dc=1
		left HASH JOIN po_hia PO9 with(nolock) on PO9.num_proc_hia = HOU.num_proc_hia and PO9.id_dc=9
		left HASH JOIN po_hia PO5 with(nolock) on PO5.num_proc_hia = HOU.num_proc_hia and PO5.id_dc=5
		left HASH JOIN tarefas_processos T15 with(nolock) on T15.num_proc = HOU.num_proc_hia and T15.id_task = 15
		left HASH JOIN tarefas_processos T13 with(nolock) on T13.num_proc = HOU.num_proc_hia and T13.id_task = 7
		left HASH JOIN tarefas_processos T4 with(nolock) on T4.num_proc = HOU.num_proc_hia and T4.id_task = 4
		left HASH JOIN Tarefas_Processos T63 with(nolock) on T63.Num_Proc = HOU.Num_Proc_HIA and T63.ID_Task = 63
		--left HASH JOIN hist_geral H56 with(nolock) on H56.hsgprocesso = HOU.num_proc_hia and H56.cd_tp_ocor = 56 and H56.disp_cliente = 'S'
		--left HASH JOIN hist_geral H57 with(nolock) on H57.hsgprocesso = HOU.num_proc_hia and H57.cd_tp_ocor = 57 and H57.disp_cliente = 'S'
		--left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_hia and H54hj.cd_tp_ocor = 54 and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from  hist_geral with (nolock)  where disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso and cd_tp_ocor = 54 order by hsgdata desc)
		left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_hia and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from  hist_geral with (nolock)  where HSGDataFU is not null and  disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso order by hsgdata desc)
	where 	
	--HOU.Num_Proc_HIA in ('IMCSR201808859BR','IMCSR201808857BR ','IMCSR201809004BR','IMCSR201809008BR','IOCSR201809042BR','IOCSR201808003BR') and
		convert(datetime,Dt_Emis_HIA,105) between getdate()-365 and @Dt_Final
		and right(left(HOU.Num_proc_HIA,5),3)  = @Grupo
		--Alessandra 19/10/2021 - ticket 100-301631 - adicionada planta J925
		--Kaique 03/09/2024 - ticket 100-468872 - adicionada as plantas G759 e G673 
		and (P.Planta IN ('05031WQ','05031WJ','P706','A972','A975','B042','J925', 'G759', 'G673','L012'))
		and isnull(llp.id_status,0) not in ( '9','5','8','7') 
		and (
				(@Tipo = '0' and (T13.dt_conclusao is null or T13.dt_conclusao >= getdate()-10))
				OR
				(@Tipo = '1' and T13.dt_conclusao < getdate()-5)
			)
	Group by
		H54hj.HSGDataFU,
		HOU.Num_proc_HIA,
		Right(Left(P.Planta,5),2),
		P.Planta,
		PO9.numero_po_hia,
		P.Num_Pedido,
		PO1.numero_po_hia,P.Num_PO,
		LLP.Canal_LIA,
		Peso_real_hia,
		Peso_Bruto_hia,
		HOU.voo_HIA,
		LC.Nome_Local,
		LLP.ETD_LIA,
		LLP.ATD_LIA,
		LLP.ETA_LIA,
		ATA_LIA	,
		AGT.Nome_Raz_Soc,
		CIA.nome_cia_aer,
		T15.dt_conclusao,
		T63.Dt_Conclusao,
		T13.dt_conclusao,
		DS.Nome_Local,
		T4.dt_conclusao,
		PO5.numero_po_hia,
		P.Customer_PO,
		HOU.MAWB_HIA,
		HOU.HAWB_HIA,
		CON.Num_CPF_CNPJ


UNION ALL

	select
		(case when H54hj.HSGDataFU is NOT NULL then 'ALTERADA' else 'NÃO ALTERADA' end)  [Status],
		Right(Left(P.Planta,5),2)					[Company ID],
		P.Planta									[Planta],
		P.Num_Pedido								[SAP],
		isnull(PO1.numero_po_him,P.Num_PO)			[PO],
		isnull(PO9.numero_po_him,P.Customer_PO)		[Customer PO],
		HOU.Num_Proc_HIM							[BDP Reference],
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)			[GMID],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)		[Produto],
		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 and upper(PD.Peso_UOM) <> 'LB'
				then Peso_liquido_him /1000	
			when sum(isnull(PD.Peso_Liquido_TOT,0)) <> 0 and upper(PD.Peso_UOM) <> 'LB'
				then sum(isnull(PD.Peso_Liquido_TOT,0))	/1000	
			when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 and upper(PD.Peso_UOM) = 'LB'
				then (Peso_liquido_him * 0.4536) /1000	
			when sum(isnull(PD.Peso_Liquido_TOT,0)) <> 0 and upper(PD.Peso_UOM) = 'LB'
				then (sum(isnull(PD.Peso_Liquido_TOT,0)) * 0.4536) /1000 end)[TON],

		LLP.Canal_LIM								[Channel],

		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 and upper(PD.Peso_UOM) <> 'LB'
				then Peso_liquido_him 
			when sum(isnull(PD.Peso_Liquido_TOT,0)) <> 0 and upper(PD.Peso_UOM) <> 'LB'
				then sum(isnull(PD.Peso_Liquido_TOT,0))	
			when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 and upper(PD.Peso_UOM) = 'LB'
				then Peso_liquido_him * 0.4536
			when sum(isnull(PD.Peso_Liquido_TOT,0)) <> 0 and upper(PD.Peso_UOM) = 'LB'
				then sum(isnull(PD.Peso_Liquido_TOT,0)) * 0.4536 end) [Peso Liquido],

		(case when isnull(Peso_Bruto_him,0) > Peso_liquido_him 
				then Peso_Bruto_him 
			else sum(isnull(PD.Peso_Bruto_TOT,0)) end) [Peso Bruto],
		DS.Nome_Local								[Porto de Embarque],
		HOU.Navio_HIM								[Navio],
		HOU.Viagem_HIM								[Voyage],
		LC.Nome_Local								[Porto de Chegada],
		LLP.ETD_LIM									[ETD Date],
		LLP.ATD_LIM									[Data de Embarque],
		LLP.ETA_LIM									[ETA Date],
		ATA_LIM										[Atracação Date],
		T15.dt_conclusao							[Presença Carga Date],
		T63.Dt_Conclusao							[Docs Ok to Register Date],
		PO5.numero_po_him							[Entry Number],
		T4.dt_conclusao								[Customs Clearance Date],
		T13.dt_conclusao							[Transport Doc Delivery Date],
		--isnull(max(H54hj.HSGDataFU),ETA_Lia +13)	[Previsão Date],
		max(H54hj.HSGDataFU)	[Previsão Date],
		--(case when max(H54hj.HSDDescricao) is not null then 
		--		convert(varchar(10), max(H54hj.HSGData),103) + ' Previsão: ' + convert(varchar(10),max(H54hj.HSGDataFU),103) + ' - ' + max(H54hj.HSDDescricao)
		--	else
		--		(select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral where hsgprocesso = hou.num_proc_hia and cd_tp_ocor = 54 and disp_cliente = 'S' order by hsgseq desc) end) [Motivo de Atraso],
		(Select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral with(nolock) where hsgprocesso = hou.num_proc_him and HSGDataFU is not null and disp_cliente = 'S' order by hsgseq desc) [Motivo de Atraso],
		AGT.Nome_Raz_Soc							[Agente de Carga],
		ARM.Nome_Armador							[Armador],
		'OCEAN'										[Modal],
		HOU.MAWB_HIM								[MAWB],
		HOU.HAWB_HIM								[HAWB],
		CON.Num_CPF_CNPJ							[CNPJ]
	from
		House_Imp_Mar HOU with(nolock)
		INNER HASH JOIN LLP_Imp_Mar LLP with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Left HASH JOIN Job_Imp_Mar JIM with(nolock) on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
		INNER HASH JOIN Pedido_Ship PS  with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
		INNER HASH JOIN Pedido P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		INNER HASH JOIN Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Left HASH JOIN Localidade LC with(nolock) on Hou.Cd_Dst_HIM = Lc.Cd_Local
		Left HASH JOIN Localidade DS with(nolock) on Hou.Cd_org_HIM = DS.Cd_Local
		Left HASH JOIN Armador ARM with(nolock) on JIM.Cd_Armador = ARM.Cd_Armador
		Left HASH JOIN Pessoa AGT with(nolock) on JIM.cd_agente = AGT.cd_pes
		Left HASH JOIN Pessoa CON with(nolock) on HOU.Cd_Consig_HIM = CON.Cd_Pes
		left HASH JOIN po_him PO1 with(nolock) on PO1.num_proc_him = HOU.num_proc_him and PO1.id_dc=1
		left HASH JOIN po_him PO9 with(nolock) on PO9.num_proc_him = HOU.num_proc_him and PO9.id_dc=9
		left HASH JOIN po_him PO5 with(nolock) on PO5.num_proc_him = HOU.num_proc_him and PO5.id_dc=5
		left HASH JOIN tarefas_processos T15 with(nolock) on T15.num_proc = HOU.num_proc_him and T15.id_task = 15
		left HASH JOIN tarefas_processos T13 with(nolock) on T13.num_proc = HOU.num_proc_him and T13.id_task = 7
		left HASH JOIN tarefas_processos T4 with(nolock) on T4.num_proc = HOU.num_proc_him and T4.id_task = 4
		left HASH JOIN Tarefas_Processos T63 with(nolock) on T63.Num_Proc = HOU.Num_Proc_HIM and T63.ID_Task = 63
		--left HASH JOIN hist_geral H56 with(nolock) on H56.hsgprocesso = HOU.num_proc_him and H56.cd_tp_ocor = 56 and H56.disp_cliente = 'S'
		--left HASH JOIN hist_geral H57 with(nolock) on H57.hsgprocesso = HOU.num_proc_him and H57.cd_tp_ocor = 57 and H57.disp_cliente = 'S'
		--left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_him and H54hj.cd_tp_ocor = 54 and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from hist_geral with (nolock)  where  disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso and cd_tp_ocor = 54 order by hsgdata desc)
		left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_him and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from  hist_geral with (nolock)  where HSGDataFU is not null and  disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso order by hsgdata desc)
	where 
	--HOU.Num_Proc_HIM in ('IMCSR201808859BR','IMCSR201808857BR ','IMCSR201809004BR','IMCSR201809008BR','IOCSR201809042BR','IOCSR201808003BR') and
		convert(datetime,Dt_Emis_HIM,105) between getdate()-365 and @Dt_Final
		and right(left(HOU.Num_proc_HIM,5),3)  = @Grupo
		--Alessandra 19/10/2021 - ticket 100-301631 - adicionada planta J925
		--Kaique 03/09/2024 - ticket 100-468872 - adicionada as plantas G759 e G673 
		and (P.Planta IN ('05031WQ','05031WJ','P706','A972','A975','B042','J925', 'G759', 'G673','L012'))
		 and isnull(llp.id_status,0) not in ( '9','5','8','7') 
		and (
				(@Tipo = '0' and (T13.dt_conclusao is null or T13.dt_conclusao >= getdate()-10))
				OR
				(@Tipo = '1' and T13.dt_conclusao < getdate()-5)
			)
	Group by
		H54hj.HSGDataFU,
		HOU.Num_proc_HIM,
		Right(Left(P.Planta,5),2),
		P.Planta,
		PO9.numero_po_him,
		P.Num_Pedido,
		PO1.numero_po_him,P.Num_PO,
		LLP.Canal_LIM,
		Peso_liquido_him,
		Peso_Bruto_him,
		HOU.Navio_HIM,
		HOU.Viagem_HIM,
		LC.Nome_Local,
		LLP.ETD_LIM,
		LLP.ATD_LIM,
		LLP.ETA_LIM,
		ATA_LIM	,
		AGT.Nome_Raz_Soc,
		ARM.Nome_Armador,
		T15.dt_conclusao,
		T63.Dt_Conclusao,
		T13.dt_conclusao,
		PD.Peso_UOM,
		DS.Nome_Local,
		T4.dt_conclusao,
		PO5.numero_po_him,
		P.Customer_PO,
		HOU.MAWB_HIM,
		HOU.HAWB_HIM,
		CON.Num_CPF_CNPJ

UNION ALL

	select
		(case when H54hj.HSGDataFU is NOT NULL then 'ALTERADA' else 'NÃO ALTERADA' end)  [Status],
		Right(Left(P.Planta,5),2)					[Company ID],
		P.Planta									[Planta],
		P.Num_Pedido								[SAP],
		isnull(PO1.numero_po_hio,P.Num_PO)			[PO],
		isnull(PO9.numero_po_hio,P.Customer_PO)		[Customer PO],
		HOU.Num_Proc_HIO							[BDP Reference],
		dbo.fBusca_GMID(HOU.Num_Proc_HIO)			[GMID],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)		[Produto],
		sum(isnull(PD.Peso_Liquido_TOT,0))/1000		[TON],		
		LLP.Canal_LIO								[Channel],
		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 then Peso_real_hio else sum(isnull(PD.Peso_Liquido_TOT,0))	end) [Peso Liquido],
		(case when isnull(Peso_Bruto_hio,0) > Peso_real_hio then Peso_Bruto_hio else sum(isnull(PD.Peso_Bruto_TOT,0)) end) [Peso Bruto],
		DS.Nome_Local								[Porto de Embarque],	
		HOU.voo_HIO									[Navio],
		HOU.Voo_HIO									[Voyage],
		LC.Nome_Local								[Porto de Chegada],
		LLP.ETD_LIO									[ETD Date],
		LLP.ATD_LIO									[Data de Embarque],
		LLP.ETA_LIO									[ETA Date],
		ATA_LIO										[Atracação Date],
		T15.dt_conclusao							[Presença Carga Date],
		T63.Dt_Conclusao							[Docs Ok to Register Date],
		PO5.numero_po_hio							[Entry Number],
		T4.dt_conclusao								[Customs Clearance Date],
		T13.dt_conclusao							[Transport Doc Delivery Date],
		--isnull(max(H54hj.HSGDataFU),ETA_Lia +13)	[Previsão Date],
		max(H54hj.HSGDataFU)	[Previsão Date],
		--(case when max(H54hj.HSDDescricao) is not null then 
		--		convert(varchar(10), max(H54hj.HSGData),103) + ' Previsão: ' + convert(varchar(10),max(H54hj.HSGDataFU),103) + ' - ' + max(H54hj.HSDDescricao)
		--	else
		--		(select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral where hsgprocesso = hou.num_proc_hia and cd_tp_ocor = 54 and disp_cliente = 'S' order by hsgseq desc) end) [Motivo de Atraso],
		(Select top 1 convert(varchar(10), HSGData,103) + ' Previsão: ' + convert(varchar(10),HSGDataFU,103) + ' - ' + HSDDescricao from hist_geral with(nolock) where hsgprocesso = hou.num_proc_hio and HSGDataFU is not null and disp_cliente = 'S' order by hsgseq desc) [Motivo de Atraso],
		AGT.Nome_Raz_Soc							[Agente de Carga],
		CAR.Nome_Raz_Soc							[Armador],
		(case when LLP.tipo_lio = 'T' then 'TRUCK' else 'RAIL' end) [Modal],
		HOU.MAWB_HIO								[MAWB],
		HOU.HAWB_HIO								[HAWB],
		CON.Num_CPF_CNPJ							[CNPJ]		
	from
		House_Imp_Out HOU with(nolock)
		INNER HASH JOIN LLP_Imp_Out LLP with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		INNER HASH JOIN Pedido_Ship PS  with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
		INNER HASH JOIN Pedido P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		INNER HASH JOIN Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Left HASH JOIN Localidade LC with(nolock) on Hou.Cd_Dst_HIO = Lc.Cd_Local
		Left HASH JOIN Localidade DS with(nolock) on Hou.Cd_org_HIO = DS.Cd_Local
		Left HASH JOIN Pessoa CAR with(nolock) on LLP.Cd_carrier   = CAR.Cd_Pes
		Left HASH JOIN Pessoa AGT with(nolock) on LLP.cd_agente = AGT.cd_pes
		Left HASH JOIN Pessoa CON with(nolock) on HOU.Cd_Consig_HIO = CON.Cd_Pes
		left HASH JOIN po_hio PO1 with(nolock) on PO1.num_proc_hio = HOU.num_proc_hio and PO1.id_dc=1
		left HASH JOIN po_hio PO9 with(nolock) on PO9.num_proc_hio = HOU.num_proc_hio and PO9.id_dc=9
		left HASH JOIN po_hio PO5 with(nolock) on PO5.num_proc_hio = HOU.num_proc_hio and PO5.id_dc=5
		left HASH JOIN tarefas_processos T15 with(nolock) on T15.num_proc = HOU.num_proc_hio and T15.id_task = 15
		left HASH JOIN tarefas_processos T13 with(nolock) on T13.num_proc = HOU.num_proc_hio and T13.id_task = 7
		left HASH JOIN tarefas_processos T4 with(nolock) on T4.num_proc = HOU.num_proc_hio and T4.id_task = 4
		left HASH JOIN Tarefas_Processos T63 with(nolock) on T63.Num_Proc = HOU.Num_Proc_HIO and T63.ID_Task = 63
		--left HASH JOIN hist_geral H56 with(nolock) on H56.hsgprocesso = HOU.num_proc_hio and H56.cd_tp_ocor = 56 and H56.disp_cliente = 'S'
		--left HASH JOIN hist_geral H57 with(nolock) on H57.hsgprocesso = HOU.num_proc_hio and H57.cd_tp_ocor = 57 and H57.disp_cliente = 'S'
		--left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_hio and H54hj.cd_tp_ocor = 54  and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from hist_geral with (nolock)  where disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso and cd_tp_ocor = 54 order by hsgdata desc)
		left HASH JOIN hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_hio and H54hj.disp_cliente = 'S' and  H54hj.hsgdata = (select top 1 hsgdata from  hist_geral with (nolock)  where HSGDataFU is not null and  disp_cliente = 'S' and hsgprocesso= H54hj.hsgprocesso order by hsgdata desc)
	where 
	--HOU.Num_Proc_HIO in ('IMCSR201808859BR','IMCSR201808857BR ','IMCSR201809004BR','IMCSR201809008BR','IOCSR201809042BR','IOCSR201808003BR') and
		convert(datetime,Dt_Emis_HIO,105) between getdate()-365 and @Dt_Final
		and right(left(HOU.Num_proc_HIO,5),3)  = @Grupo
		--Alessandra 19/10/2021 - ticket 100-301631 - adicionada planta J925
		--Kaique 03/09/2024 - ticket 100-468872 - adicionada as plantas G759 e G673 
		and (P.Planta IN ('05031WQ','05031WJ','P706','A972','A975','B042','J925', 'G759', 'G673','L012'))
		and isnull(llp.id_status,0) not in ( '9','5','8','7') 
		and (
				(@Tipo = '0' and (T13.dt_conclusao is null or T13.dt_conclusao >= getdate()-10))
				OR
				(@Tipo = '1' and T13.dt_conclusao < getdate()-5)
			)
	Group by
		H54hj.HSGDataFU,
		HOU.Num_proc_HIO,
		Right(Left(P.Planta,5),2),
		P.Planta,
		PO9.numero_po_hio,
		P.Num_Pedido,
		PO1.numero_po_hio,P.Num_PO,
		LLP.Canal_LIO,
		Peso_real_hio,
		Peso_Bruto_hio,
		HOU.voo_HIO,
		LC.Nome_Local,
		LLP.ETD_LIO,
		LLP.ATD_LIO,
		LLP.ETA_LIO,
		ATA_LIO,
		AGT.Nome_Raz_Soc,
		CAR.Nome_Raz_Soc,
		T15.dt_conclusao,
		T63.Dt_Conclusao,
		T13.dt_conclusao,
		LLP.tipo_lio,
		DS.Nome_Local,
		T4.dt_conclusao,
		PO5.numero_po_hio,
		P.Customer_PO,
		HOU.MAWB_HIO,
		HOU.HAWB_HIO,
		CON.Num_CPF_CNPJ
	order by 1,6
	

GO
