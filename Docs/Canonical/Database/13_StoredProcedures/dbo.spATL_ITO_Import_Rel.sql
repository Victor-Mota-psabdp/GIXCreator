SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
antiga spDOW_ImportALINE_Rel 'CSR'

"3 - Sales Order" = Inter-company
"2 - P.O." = Third

*/


CREATE procedure [dbo].[spATL_ITO_Import_Rel] 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select distinct
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end) [Order Type],
		'Ocean' [Modalidade],
		(case 
			when len(Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga))<> '1' then Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) = 'T' then 'Isotank'
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) <> 'T' and nome_tp_carga = 'BULK' then 'Bulk Cargo'
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) <> 'T' and nome_tp_carga <> 'BULK' then 'Vessel-Container'
		end) [Dispatch Type],
		LI.data_po_him [LI Date],
		dbo.fBusca_Containers(LLP.Num_Proc_LIM) [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LIM [ETD Date],
		LLP.ATD_LIM [ATD Date],
		LLP.ETA_LIM [ETA Date],
		LLP.ATA_LIM [ATA Date],
		T7.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LIM [Channel],
		Business_Descr  [Business Name],
		Business_Group_Descr  [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		nome_tp_carga [Type of Cargo]
	from
		LLP_Imp_Mar LLP with(nolock)
		Join House_Imp_Mar HOU with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_him
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
		Left Join Tipo_Carga Carga with(nolock) on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		left Join Localidade Org with(nolock) on hou.cd_org_HIM=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HIM=DSt.cd_local
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		Left Join Container_hou_imp_mar CH with(nolock) on num_proc_lim=CH.num_proc_him
		Left Join Container_mas_imp_mar CM with(nolock) on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LIM and CANC.cd_tp_ocor=28
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T7 with(nolock) on T7.num_proc=PS.num_proc and T7.id_task = 7
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
		left join po_him LI with(nolock) on LI.num_proc_him=PS.num_proc and LI.id_dc=23
	where
		CANC.HSGProcesso is null and T7.dt_conclusao between @DtInicial and @DtFinal


UNION ALL

	select distinct
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end) [Order Type],
		'Air' [Modalidade],
		null [Dispatch Type],
		LI.data_po_hia [LI Date],
		null [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LIA [ETD Date],
		LLP.ATD_LIA [ATD Date],
		LLP.ETA_LIA [ETA Date],
		LLP.ATA_LIA [ATA Date],
		T7.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LIA [Channel],
		Business_Descr  [Business Name],
		Business_Group_Descr  [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		null [Type of Cargo]
	from
		LLP_Imp_Aer LLP with(nolock)
		Join House_Imp_Aer HOU with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_hia
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo		left Join Localidade Org with(nolock) on hou.cd_org_HIA=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HIA=DSt.cd_local
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LIA and CANC.cd_tp_ocor = '28'
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T7 with(nolock) on T7.num_proc=PS.num_proc and T7.id_task = 7
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
		left join po_hia LI with(nolock) on LI.num_proc_hia=PS.num_proc and LI.id_dc=23
	where
		CANC.HSGProcesso is null and T7.dt_conclusao between @DtInicial and @DtFinal

UNION ALL

	select distinct
		PS.num_proc [BDP Ref.],
		P.Num_Pedido [Sales Order],
		T10.dt_previsao [Plant Exit Date - Estimated],
		T10.dt_conclusao [Plant Exit Date - Actual],
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end) [Order Type],
		(case when tipo_LIO = 'T' then 'Truck' else 'Rail' end) [Modalidade],
		null [Dispatch Type],
		LI.data_po_hio [LI Date],
		null [Containers],
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) [Origin],
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) [Destination],
		LLP.ETD_LIO [ETD Date],
		LLP.ATD_LIO [ATD Date],
		LLP.ETA_LIO [ETA Date],
		LLP.ATA_LIO [ATA Date],
		T7.dt_conclusao [Transp. Doc. Del. Date],
		T4.dt_conclusao [Customs Clearance Date],
		Canal_LIO [Channel],
		Business_Descr  [Business Name],
		Business_Group_Descr  [Business Group Name],
		Org.Nome_Local [Port of Origin],
		Dst.Nome_Local [Port of Destination],
		null [Type of Cargo]
	from
		LLP_Imp_Out LLP with(nolock)
		Join House_Imp_Out HOU with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_hio
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo		left Join Localidade Org with(nolock) on hou.cd_org_HIO=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HIO=DSt.cd_local
		left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP with(nolock) on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		left Join Hist_Geral CANC with(nolock) on CANC.HSGProcesso = LLP.Num_Proc_LIO and CANC.cd_tp_ocor = '28'
		left join tarefas_processos T10 with(nolock) on T10.num_proc=PS.num_proc and T10.id_task = 10
		left join tarefas_processos T7 with(nolock) on T7.num_proc=PS.num_proc and T7.id_task = 7
		left join tarefas_processos T4 with(nolock) on T4.num_proc=PS.num_proc and T4.id_task = 4
		left join po_hio LI with(nolock) on LI.num_proc_hio=PS.num_proc and LI.id_dc=23
	where
		CANC.HSGProcesso is null and T4.dt_conclusao between @DtInicial and @DtFinal
















GO
