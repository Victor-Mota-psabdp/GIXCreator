SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from house_imp_mar where convert(datetime,Dt_Emis_HIM,103) between (getdate() - 180)  and (getdate() + 1)
--select * from llp_imp_mar where etd_lim between (getdate() - 180)  and (getdate() + 1) 
--and right(left(Num_proc_lIM,5),3)  = 'CSR'
--order by 3 desc

/*
select top 10 * from llp_imp_out order by 4 desc

select * from report
spATL_PlasticosT1_Rel 'GRUPO DOW','2011-11-01','2011-11-30','0'
incluido a planta and (P.Planta IN ('05031WQ','05031WJ'))
*/

--[spATL_PlasticosT1_Rel]'Grupo Dow','2012-01-08','2012-05-08','0'
--[spATL_PlasticosT1_Teste_Rel]'Grupo Dow','2010-01-08','2012-05-08','0'
CREATE Procedure	[dbo].[spATL_PlasticosT1_Teste_Rel]--'Grupo Dow','2012-05-08','2012-05-08','0'
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
		isnull(PO3.numero_po_him,P.Num_Pedido)		[SAP],
		isnull(PO1.numero_po_him,P.Num_PO)			[PO],
		HOU.Num_Proc_HIM							[BDP Reference],
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)			[GMID],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)		[Produto],
		sum(isnull(PD.Peso_Liquido_TOT,0))/1000		[TON],
		LLP.Canal_LIM								[Channel],
		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 then Peso_liquido_him else sum(isnull(PD.Peso_Liquido_TOT,0))	end) [Peso Liquido],
		(case when isnull(Peso_Bruto_him,0) > Peso_liquido_him then Peso_Bruto_him else sum(isnull(PD.Peso_Bruto_TOT,0)) end) [Peso Bruto],
		HOU.Navio_HIM								[Navio],
		LC.Nome_Local								[Porto de Chegada],
		LLP.ETD_LIM									[ETD Date],
		LLP.ATD_LIM									[Data de Embarque],
		LLP.ETA_LIM									[ETA Date],
		ATA_LIM										[Atracação Date],
		T15.dt_conclusao							[Presença Carga Date],
		isnull(max(H54hj.HSGDataFU),ETA_Lim +13)	[Previsão Date],
		max(H57.HSGDataFU)							[Entrega Date],
		max(H56.HSGDataFU)							[Deposito Date],
		T13.dt_conclusao							[PO Date],
		H54hj.HSDDescricao							[Motivo de Atraso],
		AGT.Nome_Raz_Soc							[Agente de Carga],
		ARM.Nome_Armador							[Armador],
		'OCEAN'										[Modal]
	from
		House_Imp_Mar HOU
		Join LLP_Imp_Mar LLP with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Left Join Job_Imp_Mar JIM with(nolock) on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
		Join Pedido_Ship PS  with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
		Join Pedido P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Left Join Localidade LC with(nolock) on Hou.Cd_Dst_HIM = Lc.Cd_Local
		Left Join Armador ARM with(nolock) on JIM.Cd_Armador = ARM.Cd_Armador
		Left Join Pessoa AGT with(nolock) on JIM.cd_agente = AGT.cd_pes
		left join po_him PO1 with(nolock) on PO1.num_proc_him = HOU.num_proc_him and PO1.id_dc=1
		left join po_him PO3 with(nolock) on PO3.num_proc_him = HOU.num_proc_him and PO1.id_dc=3
		left join tarefas_processos T15 with(nolock) on T15.num_proc = HOU.num_proc_him and T15.id_task = 15
		left join tarefas_processos T13 with(nolock) on T13.num_proc = HOU.num_proc_him and T13.id_task = 13
		left join hist_geral H54 with(nolock) on H54.hsgprocesso = HOU.num_proc_him and H54.cd_tp_ocor = 54 and H54.disp_cliente = 'S'
		left join hist_geral H56 with(nolock) on H56.hsgprocesso = HOU.num_proc_him and H54.cd_tp_ocor = 56 and H56.disp_cliente = 'S'
		left join hist_geral H57 with(nolock) on H57.hsgprocesso = HOU.num_proc_him and H54.cd_tp_ocor = 57 and H57.disp_cliente = 'S'
		left join hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_him and H54hj.cd_tp_ocor = 54 and convert(char(10),H54hj.hsgdata) = convert(char(10),getdate()) and H54hj.disp_cliente = 'S'
	where 
		LLP.ETD_LIM between @Dt_Inicial and @Dt_Final
		and right(left(HOU.Num_proc_HIM,5),3)  = @Grupo
		and (P.Planta IN ('05031WQ','05031WJ'))
		and (T13.dt_conclusao is null or T13.dt_conclusao >= getdate()-5)
				
	Group by
		H54hj.HSGDataFU,
		HOU.Num_proc_HIM,
		Right(Left(P.Planta,5),2),
		P.Planta,
		PO3.numero_po_him,P.Num_Pedido,
		PO1.numero_po_him,P.Num_PO,
		LLP.Canal_LIM,
		Peso_liquido_him,
		Peso_Bruto_him,
		HOU.Navio_HIM,
		LC.Nome_Local,
		LLP.ETD_LIM,
		LLP.ATD_LIM,
		LLP.ETA_LIM,
		ATA_LIM	,
		AGT.Nome_Raz_Soc,
		ARM.Nome_Armador,
		T15.dt_conclusao,
		T13.dt_conclusao,
		H54hj.HSDDescricao

--UNION ALL
--
--	select
--		(case when H54hj.HSGDataFU is NOT NULL then 'ALTERADA' else 'NÃO ALTERADA' end)  [Status],
--		Right(Left(P.Planta,5),2)					[Company ID],
--		P.Planta									[Planta],
--		isnull(PO3.numero_po_hia,P.Num_Pedido)		[SAP],
--		isnull(PO1.numero_po_hia,P.Num_PO)			[PO],
--		HOU.Num_Proc_HIA							[BDP Reference],
--		dbo.fBusca_GMID(HOU.Num_Proc_HIA)			[GMID],
--		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)		[Produto],
--		sum(isnull(PD.Peso_Liquido_TOT,0))/1000		[TON],
--		LLP.Canal_LIA								[Channel],
--		(case when sum(isnull(PD.Peso_Liquido_TOT,0)) = 0 then Peso_real_hia else sum(isnull(PD.Peso_Liquido_TOT,0))	end) [Peso Liquido],
--		(case when isnull(Peso_Bruto_hia,0) > Peso_real_hia then Peso_Bruto_hia else sum(isnull(PD.Peso_Bruto_TOT,0)) end) [Peso Bruto],
--		HOU.voo_HIA									[Navio],
--		LC.Nome_Local								[Porto de Chegada],
--		LLP.ETD_LIA									[ETD Date],
--		LLP.ATD_LIA									[Data de Embarque],
--		LLP.ETA_LIA									[ETA Date],
--		ATA_LIA										[Atracação Date],
--		T15.dt_conclusao							[Presença Carga Date],
--		isnull(max(H54hj.HSGDataFU),ETA_Lia +13)	[Previsão Date],
--		max(H57.HSGDataFU)							[Entrega Date],
--		max(H56.HSGDataFU)							[Deposito Date],
--		T13.dt_conclusao							[PO Date],
--		H54hj.HSDDescricao							[Motivo de Atraso],
--		AGT.Nome_Raz_Soc							[Agente de Carga],
--		CIA.Nome_Cia_Aer							[Armador],
--		'AIR'										[Modal]
--	from
--		House_Imp_Aer HOU
--		Join LLP_Imp_Aer LLP with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
--		Left Join Job_Imp_Aer JIA with(nolock) on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
--		Join Pedido_Ship PS  with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
--		Join Pedido P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
--		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
--		Left Join Localidade LC with(nolock) on Hou.Cd_Dst_HIA = Lc.Cd_Local
--		Left Join Cia_Aerea	CIA with(nolock) on JIA.Cd_Cia_Aer = CIA.Cd_Cia_Aer
--		Left Join Pessoa AGT with(nolock) on JIA.cd_agente = AGT.cd_pes
--		left join po_hia PO1 with(nolock) on PO1.num_proc_hia = HOU.num_proc_hia and PO1.id_dc=1
--		left join po_hia PO3 with(nolock) on PO3.num_proc_hia = HOU.num_proc_hia and PO1.id_dc=3
--		left join tarefas_processos T15 with(nolock) on T15.num_proc = HOU.num_proc_hia and T15.id_task = 15
--		left join tarefas_processos T13 with(nolock) on T13.num_proc = HOU.num_proc_hia and T13.id_task = 13
--		left join hist_geral H54 with(nolock) on H54.hsgprocesso = HOU.num_proc_hia and H54.cd_tp_ocor = 54 and H54.disp_cliente = 'S'
--		left join hist_geral H56 with(nolock) on H56.hsgprocesso = HOU.num_proc_hia and H54.cd_tp_ocor = 56 and H56.disp_cliente = 'S'
--		left join hist_geral H57 with(nolock) on H57.hsgprocesso = HOU.num_proc_hia and H54.cd_tp_ocor = 57 and H57.disp_cliente = 'S'
--		left join hist_geral H54hj with(nolock) on H54hj.hsgprocesso = HOU.num_proc_hia and H54hj.cd_tp_ocor = 54 and convert(char(10),H54hj.hsgdata) = convert(char(10),getdate()) and H54hj.disp_cliente = 'S'
--	where 
--		LLP.ETD_LIA between @Dt_Inicial and @Dt_Final
--		and right(left(HOU.Num_proc_HIA,5),3)  = @Grupo
--		and (P.Planta IN ('05031WQ','05031WJ'))
--		and (
--				(@Tipo = '0' and (T13.dt_conclusao is null or T13.dt_conclusao >= getdate()-5))
--				OR
--				(@Tipo = '1' and T13.dt_conclusao < getdate()-5)
--			)
--	Group by
--		H54hj.HSGDataFU,
--		HOU.Num_proc_HIA,
--		Right(Left(P.Planta,5),2),
--		P.Planta,
--		PO3.numero_po_hia,P.Num_Pedido,
--		PO1.numero_po_hia,P.Num_PO,
--		LLP.Canal_LIA,
--		Peso_real_hia,
--		Peso_Bruto_hia,
--		HOU.voo_HIA,
--		LC.Nome_Local,
--		LLP.ETD_LIA,
--		LLP.ATD_LIA,
--		LLP.ETA_LIA,
--		ATA_LIA	,
--		AGT.Nome_Raz_Soc,
--		CIA.nome_cia_aer,
--		T15.dt_conclusao,
--		T13.dt_conclusao,
--		H54hj.HSDDescricao

	--order by 1,6

order by 15 desc
GO
