SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
entrega transpo = IMP
envio docs = EXP
select * from tipo_tarefas
spDOW_ExportALINE_Rel 'CSR'
*/


CREATE procedure [dbo].[spDOW_ExportALINE_Rel]
	@GRP varchar(3),
	@DataInicial datetime
as
	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = @GRP)

	select distinct --top 10
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LEM,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEM,'10') Plant_Exit_Act,
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,

		'Ocean' Modal,

		(case 
			when len(Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga))<> '1' then Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) = 'T' then 'Isotank'
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) <> 'T' and Carga.nome_tp_carga = 'BULK' then 'Bulk Cargo'
			when (Isnull(right(cm.cd_tp_cont,1),Carga.nome_tp_Carga)) <> 'T' and Carga.nome_tp_carga <> 'BULK' then 'Vessel-Container'
		end) Dispatch,

		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) Forma_A,
		dbo.fBusca_Containers(LLP.Num_Proc_LEM) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LEM ETD,
		LLP.ATD_LEM ATD,
		LLP.ETA_LEM ETA,
		LLP.ATA_LEM ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEM,'12') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEM,'4') Customs_Clearence,
		Canal_LEM Channel,
		Business_Descr Business_Name,
		Business_Group_Descr Business_Grupo,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LEM BDP_Ref,
		P.Dt_Pedido,
		Carga.nome_tp_carga
	from
		LLP_Exp_Mar LLP
		Join House_Exp_Mar HOU on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LEM and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		Left Join Tipo_Carga Carga on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		left Join Localidade Org on hou.cd_org_hem=Org.cd_local
		left Join Localidade Dst on cd_dst_hem=DSt.cd_local
		left Join Pais PA on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		Left Join Container_hou_exp_mar CH on num_proc_lem=CH.num_proc_hem
		Left Join Container_mas_exp_mar CM on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LEM and CANC.cd_tp_ocor='28'
	where
		CANC.HSGProcesso is null and LLP.ATD_LEM is not NULL
		and dbo.fBusca_Tarefa(LLP.Num_Proc_LEM,12) > @DataInicial

UNION ALL

	select distinct --top 10
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LEA,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEA,'10') Plant_Exit_Act,
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,
		'Air' Modal,
		'' Dispatch_Type,
		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) Forma_A,
		dbo.fBusca_Containers(LLP.Num_Proc_LEA) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LEA ETD,
		LLP.ATD_LEA ATD,
		LLP.ETA_LEA ETA,
		LLP.ATA_LEA ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEA,'12') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEA,'4') Customs_Clearence,
		Canal_LEA Channel,
		Business_Descr Business_Name,
		Business_Group_Descr Business_Grupo,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LEA BDP_Ref,
		P.Dt_Pedido,
		'' nome_tp_carga
	from
		LLP_Exp_Aer LLP
		Join House_Exp_Aer HOU on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LEA and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		left Join Localidade Org on hou.cd_org_HEA=Org.cd_local
		left Join Localidade Dst on cd_dst_HEA=DSt.cd_local
		left Join Pais PA on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente=@cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente=@cd_pes_grupo
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LEA and CANC.cd_tp_ocor='28'
	where
		CANC.HSGProcesso is null and LLP.ATD_LEA is not NULL
		and dbo.fBusca_Tarefa(LLP.Num_Proc_LEA,12) > @DataInicial

UNION ALL

	select distinct
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LEO,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEO,'10') Plant_Exit_Act,

		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,

		(case when tipo_LEO = 'T' then 'Truck' else 'Rail' end) Modal,
		'' Dispatch_Type,
		(case when PA.Form_A = 'S' then 'YES' else 'NO' end) Forma_A,
		dbo.fBusca_Containers(LLP.Num_Proc_LEO) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LEO ETD,
		LLP.ATD_LEO ATD,
		LLP.ETA_LEO ETA,
		LLP.ATA_LEO ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEO,'12') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LEO,'4') Customs_Clearence,
		Canal_LEO Channel,
		Business_Descr Business_Name,
		Business_Group_Descr Business_Grupo,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LEO BDP_Ref,
		P.Dt_Pedido,
		'' nome_tp_carga
	from
		LLP_Exp_Out LLP
		Join House_Exp_Out HOU on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LEO and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		left Join Localidade Org on hou.cd_org_HEO=Org.cd_local
		left Join Localidade Dst on cd_dst_HEO=DSt.cd_local
		left Join Pais PA on PA.cd_pais=DST.cd_pais
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente=@cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente=@cd_pes_grupo
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LEO and CANC.cd_tp_ocor='28'
	where
		CANC.HSGProcesso is null and LLP.ATD_LEO is not NULL
		and dbo.fBusca_Tarefa(LLP.Num_Proc_LEO,12) > @DataInicial

order by
		Dt_Pedido



GO
