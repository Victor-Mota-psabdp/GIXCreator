SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_ITO_Export_Rel 'Grupo DOW', '2011-05-01', '2011-08-08',''


CREATE procedure [dbo].[spATL_ITO_Export_Rel]

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime

as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select distinct --top 10
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  [Order Type],
		'Ocean' [Modalidade],
		(case 
			when len(Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga))<> '1' then Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) = 'T' then 'Isotank'
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) <> 'T' and Carga.nome_tp_carga = 'BULK' then 'Bulk Cargo'
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) <> 'T' and Carga.nome_tp_carga <> 'BULK' then 'Vessel-Container'
		end) [Dispatch Type],
		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) [LI Date],
		dbo.fBusca_Containers(LLP.Num_Proc_LEM) [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LEM [ETD Date],
		LLP.ATD_LEM [ATD Date],
		LLP.ETA_LEM [ETA Date],
		LLP.ATA_LEM [ATA Date],
		T12.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LEM [Channel],
		Business_Descr [Business Name],
		Business_Group_Descr [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		Carga.nome_tp_carga [Type of Cargo]
	from
		LLP_Exp_Mar LLP with(nolock)
		Join House_Exp_Mar HOU with(nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
		Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_hem
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
		Left Join Tipo_Carga Carga with(nolock) on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		left Join Localidade Org with(nolock) on hou.cd_org_hem=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_hem=DSt.cd_local
		left Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		Left Join Container_hou_exp_mar CH with(nolock) on num_proc_lem=CH.num_proc_hem
		Left Join Container_mas_exp_mar CM with(nolock) on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LEM and CANC.cd_tp_ocor=28
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T12 with(nolock) on T12.num_proc=PS.num_proc and T12.id_task = 12
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
	where
		CANC.HSGProcesso is null and LLP.ATD_LEM is not NULL
		and T12.dt_conclusao between @DtInicial and @DtFinal

UNION ALL

	select distinct --top 10
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  [Order Type],
		'Air' [Modalidade],
		null [Dispatch Type],
		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) [LI Date],
		null [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LEA [ETD Date],
		LLP.ATD_LEA [ATD Date],
		LLP.ETA_LEA [ETA Date],
		LLP.ATA_LEA [ATA Date],
		T12.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LEA [Channel],
		Business_Descr [Business Name],
		Business_Group_Descr [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		null [Type of Cargo]
	from
		LLP_Exp_Aer LLP with(nolock)
		Join House_Exp_Aer HOU  with(nolock) on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
		Join Pedido_Ship PS with(nolock) on PS.num_proc=HOU.num_proc_hea
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
		left Join Localidade Org with(nolock) on hou.cd_org_HEA=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HEA=DSt.cd_local
		left Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente=@cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente=@cd_pes_grupo
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LEA and CANC.cd_tp_ocor=28
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T12 with(nolock) on T12.num_proc=PS.num_proc and T12.id_task = 12
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
	where
		CANC.HSGProcesso is null and LLP.ATD_LEA is not NULL
		and T12.dt_conclusao between @DtInicial and @DtFinal

UNION ALL

	select distinct --top 10
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  [Order Type],
		(case when tipo_LEO = 'T' then 'Truck' else 'Rail' end) [Modalidade],
		null [Dispatch Type],
		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) [LI Date],
		null [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LEO [ETD Date],
		LLP.ATD_LEO [ATD Date],
		LLP.ETA_LEO [ETA Date],
		LLP.ATA_LEO [ATA Date],
		T12.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LEO [Channel],
		Business_Descr [Business Name],
		Business_Group_Descr [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		null [Type of Cargo]
	from
		LLP_Exp_Out LLP with(nolock)
		Join House_Exp_Out HOU with(nolock) on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
		Join Pedido_Ship PS with(nolock) on PS.num_proc=HOU.num_proc_heo
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
		left Join Localidade Org with(nolock) on hou.cd_org_HEO=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HEO=DSt.cd_local
		left Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente=@cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente=@cd_pes_grupo
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LEO and CANC.cd_tp_ocor=28
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T12 with(nolock) on T12.num_proc=PS.num_proc and T12.id_task = 12
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
	where
		CANC.HSGProcesso is null and LLP.ATD_LEO is not NULL
		and T12.dt_conclusao between @DtInicial and @DtFinal



GO
