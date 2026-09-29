SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
entrega transpo = IMP
envio docs = Imp
spDOW_ImportALINE_Rel 'CSR'
select * from localidade
"3 - Sales Order" = Inter-company
"2 - P.O." = Third

*/


CREATE procedure [dbo].[spDOW_ImportALINE_Rel] 
	@GRP varchar(3),
	@Data_Inicial datetime
as
	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = @GRP)

	select distinct
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LIM,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,'10') Plant_Exit_Act,
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,

		'Ocean' Modal,
		(case 
			when len(Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga))<> '1' then Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) = 'T' then 'Isotank'
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) <> 'T' and nome_tp_carga = 'BULK' then 'Bulk Cargo'
			when (Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) <> 'T' and nome_tp_carga <> 'BULK' then 'Vessel-Container'
		end) Dispatch,
		dbo.fBusca_TipoDocCliente('D',LLP.Num_Proc_LIM,'23') LI_Dt,
		dbo.fBusca_Containers(LLP.Num_Proc_LIM) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LIM ETD,
		LLP.ATD_LIM ATD,
		LLP.ETA_LIM ETA,
		LLP.ATA_LIM ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,'7') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,'4') Customs_Clearence,
		Canal_LIM Channel,
		Business_Descr  Business_Name,
		Business_Group_Descr  Business_Group,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LIM BDP_Ref,
		P.Dt_Pedido,
		nome_tp_carga
	from
		LLP_Imp_Mar LLP
		Join House_Imp_Mar HOU on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LIM and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		Left Join Tipo_Carga Carga on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		left Join Localidade Org on hou.cd_org_HIM=Org.cd_local
		left Join Localidade Dst on cd_dst_HIM=DSt.cd_local
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		Left Join Container_hou_imp_mar CH on num_proc_lim=CH.num_proc_him
		Left Join Container_mas_imp_mar CM on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LIM and CANC.cd_tp_ocor='28'
	where
		CANC.HSGProcesso is null and dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,7) > @Data_Inicial


UNION ALL

	select distinct
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LIA,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,'10') Plant_Exit_Act,

		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,

		'Air' Modal,
		'' Dispatch_Type,
		dbo.fBusca_TipoDocCliente('D',LLP.Num_Proc_LIA,'23') LI_Dt,
		dbo.fBusca_Containers(LLP.Num_Proc_LIA) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LIA ETD,
		LLP.ATD_LIA ATD,
		LLP.ETA_LIA ETA,
		LLP.ATA_LIA ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,'7') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,'4') Customs_Clearence,
		Canal_LIA Channel,
		Business_Descr Business_Name,
		Business_Group_Descr Business_Group,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LIA BDP_Ref,
		P.Dt_Pedido,
		'' nome_tp_carga
	from
		LLP_Imp_Aer LLP
		Join House_Imp_Aer HOU on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LIA and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		left Join Localidade Org on hou.cd_org_HIA=Org.cd_local
		left Join Localidade Dst on cd_dst_HIA=DSt.cd_local
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LIA and CANC.cd_tp_ocor = '28'
	where
		CANC.HSGProcesso is null and dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,7) > @Data_Inicial

UNION ALL

	select distinct
		P.Num_Pedido,
		dbo.fBusca_Tarefa_Prev (LLP.Num_Proc_LIO,'10') Plant_Exit_Est,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIO,'10') Plant_Exit_Act,
--		(case
--			when (P.num_pedido = P.num_po) and cd_tipo = '4' and @GRP = 'CSR' then 'Sample' 
--			when (P.num_pedido = P.num_po) and cd_tipo <> '4' and @GRP = 'CSR' then 'Third'
--			when (P.num_pedido <> P.num_po) and @GRP = 'CSR' then 'Inter-company'
--			when (P.num_po is null) and @GRP = 'CSR' then 'Sample'
--
--			when left(P.num_pedido,2)='47' and @GRP = 'ROB' then 'Inter-company'
--			when left(P.num_pedido,2)='45' and @GRP = 'ROB' then 'Third'
--			when (left(P.num_pedido,2)<>'47' and left(P.num_pedido,2)<>'45') and @GRP = 'ROB' then 'Sample'
--		end)  Order_Type,
		(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
		end)  Order_Type,

		(case when tipo_LIO = 'T' then 'Truck' else 'Rail' end) Modal,
		'' Dispatch_Type,
		dbo.fBusca_TipoDocCliente('D',LLP.Num_Proc_LIO,'23') LI_Dt,
		dbo.fBusca_Containers(LLP.Num_Proc_LIO) Containers,
		(select Nome_Pais from pais where cd_pais = Org.cd_pais) Origem,
		(select Nome_Pais from pais where cd_pais = Dst.cd_pais) Destino,
		LLP.ETD_LIO ETD,
		LLP.ATD_LIO ATD,
		LLP.ETA_LIO ETA,
		LLP.ATA_LIO ATA,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIO,'7') Trans_Doc_Del_Dt,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIO,'4') Customs_Clearence,
		Canal_LIO Channel,
		Business_Descr Business_Name,
		Business_Group_Descr Business_Group,
		Org.Nome_Local Port_Origin,
		Dst.Nome_Local Port_Destination,
		'' Docs_Requirement,
		LLP.Num_Proc_LIO BDP_Ref,
		P.Dt_Pedido,
		'' nome_tp_carga
	from
		LLP_Imp_Out LLP
		Join House_Imp_Out HOU on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		Join Pedido_Ship PS on PS.Num_proc = LLP.Num_Proc_LIO and right(left(PS.Num_proc,5),3) = @GRP
		Join Pedido P on P.cd_pedido = PS.cd_pedido and P.cd_Grupo = @cd_pes_grupo
		left Join Localidade Org on hou.cd_org_HIO=Org.cd_local
		left Join Localidade Dst on cd_dst_HIO=DSt.cd_local
		left Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
		left join de_para_produto DPP on DPP.GMID = PC.cd_proc_cliente and DPP.cd_cliente = @cd_pes_grupo
		left Join Hist_Geral CANC on CANC.HSGProcesso = LLP.Num_Proc_LIO and CANC.cd_tp_ocor = '28'
	where
		CANC.HSGProcesso is null and dbo.fBusca_Tarefa(LLP.Num_Proc_LIO,4) > @Data_Inicial

order by
		Dt_Pedido
















GO
