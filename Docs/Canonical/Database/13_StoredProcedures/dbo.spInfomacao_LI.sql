SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--spInfomacao_LI 'Grupo DOW','2011-01-01','2011-11-30',''

CREATE       Procedure [dbo].[spInfomacao_LI]
(
	@Grupo varchar(20),
	@Dt_Inicial datetime,
	@Dt_Final datetime
)
As
	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes from pessoa where apelido = @Grupo)

	select distinct 
		llp.num_proc_lim [Referencia BDP],
		ph.numero_po_him [Número da Ordem],
		po.numero_po_him [Número da PO],
		nav.navio_him [Navio ou Voo],
		etd.etd_lim [ETD Date],
		eta.eta_lim [ETA Date],
		TP180.Dt_Conclusao [Conferência de LI],
		TP181.Dt_Conclusao [Conferência de LI Sub],
		pc.cd_proc_cliente GMID,
		pd.ncm NCM,
		pc.produto_descr [Descrição],
		li.numero_po_him [Número da LI],
		nli.import_license [Necessita de LI],
		nli.tipo_li [Pré / Pós]
	from 
		llp_imp_mar LLP with(nolock)
		join pedido_ship PS with(nolock) on ps.num_proc=llp.num_proc_lim
		join pedido_det PD with(nolock) on pd.cd_pedido=ps.cd_pedido  and PD.cd_produto=PS.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido and P.Cd_Grupo=@Cd_Grupo
		left join po_him PH with(nolock) on ph.num_proc_him=ps.num_proc and ph.id_dc='3'
		left join po_him PO with(nolock) on po.num_proc_him=ps.num_proc and po.id_dc='1'
		left join house_imp_mar NAV with(nolock) on nav.num_proc_him=ps.num_proc
		left join llp_imp_mar ETA with(nolock) on eta.num_proc_lim=ps.num_proc
		left join llp_imp_mar ETD with(nolock) on etd.num_proc_lim=ps.num_proc
		left join produto_cliente PC with(nolock) on pc.cd_prod=ps.cd_produto
		left join proc_ncm PN with(nolock) on pn.num_proc=ps.num_proc
		left join NCM N with(nolock) on n.id_ncm=pn.id_ncm
		left join po_him LI with(nolock) on li.num_proc_him=ps.num_proc and li.id_dc='23'
		left join produto_chb NLI with(nolock) on nli.cd_prod=pc.cd_prod
		left join Tarefas_Processos TP180 with (nolock)on LLP.Num_Proc_Lim = TP180.Num_Proc and TP180.ID_Task = '180' 
		left join Tarefas_Processos TP181 with (nolock)on LLP.Num_Proc_Lim = TP181.Num_Proc and TP181.ID_Task = '181' 
		
	where 
		etd.etd_lim between @Dt_Inicial and @Dt_Final

	union all

	select distinct 
		llp.num_proc_lia Referencia_BDP,
		ph.numero_po_hia Numero_Ordem,
		po.numero_po_hia Numero_PO,
		voo.Voo_hia Navio_ou_voo,
		etd.etd_lia ETD,
		eta.eta_lia ETA,
		TP180.Dt_Conclusao [Conferência de LI],
		TP181.Dt_Conclusao [Conferência de LI Sub],
		pc.cd_proc_cliente GMID,
		pd.ncm NCM,
		pc.produto_descr Descricao,
		li.numero_po_hia Numero_LI,
		nli.import_license Necessidade_LI,
		nli.tipo_li Pre_Pos
	from 
		llp_imp_aer LLP with(nolock)
		join pedido_ship PS with(nolock)on ps.num_proc=llp.num_proc_lia
		join pedido_det PD with(nolock)on pd.cd_pedido=ps.cd_pedido  and PD.cd_produto=PS.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock)on P.cd_pedido=PS.cd_pedido and P.Cd_Grupo=@Cd_Grupo
		left join po_hia PH with(nolock)on ph.num_proc_hia=ps.num_proc and ph.id_dc='3'
		left join po_hia PO with(nolock)on po.num_proc_hia=ps.num_proc and po.id_dc='1'
		left join house_imp_aer VOO with(nolock)on voo.num_proc_hia=ps.num_proc
		left join llp_imp_aer ETA with(nolock)on eta.num_proc_lia=ps.num_proc
		left join llp_imp_aer ETD with(nolock)on etd.num_proc_lia=ps.num_proc
		left join produto_cliente PC with(nolock)on pc.cd_prod=ps.cd_produto
		left join proc_ncm PN with(nolock)on pn.num_proc=ps.num_proc
		left join NCM N with(nolock)on n.id_ncm=pn.id_ncm
		left join po_hia LI with(nolock)on li.num_proc_hia=ps.num_proc and li.id_dc='23'
		left join produto_chb NLI with(nolock)on nli.cd_prod=pc.cd_prod
		left join Tarefas_Processos TP180 with(nolock)on LLP.Num_Proc_Lia = TP180.Num_Proc and TP180.ID_Task = '180' 
		left join Tarefas_Processos TP181 with(nolock)on LLP.Num_Proc_Lia = TP181.Num_Proc and TP181.ID_Task = '181'
	where 
		etd.etd_lia between @Dt_Inicial and @Dt_Final

	union all

	select distinct 
		llp.num_proc_lio Referencia_BDP,
		ph.numero_po_hio Numero_Ordem,
		po.numero_po_hio Numero_PO,
		voo.voo_hio Navio_ou_voo,
		etd.etd_lio ETD,
		eta.eta_lio ETA,
		TP180.Dt_Conclusao [Conferência de LI],
		TP181.Dt_Conclusao [Conferência de LI Sub],
		pc.cd_proc_cliente GMID,
		pd.ncm NCM,
		pc.produto_descr Descricao,
		li.numero_po_hio Numero_LI,
		nli.import_license Necessidade_LI,
		nli.tipo_li Pre_Pos
	from 
		llp_imp_out LLP with(nolock)
		join pedido_ship PS with(nolock)on ps.num_proc=llp.num_proc_lio
		join pedido_det PD with(nolock)on pd.cd_pedido=ps.cd_pedido  and PD.cd_produto=PS.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock)on P.cd_pedido=PS.cd_pedido and P.Cd_Grupo=@Cd_Grupo
		left join po_hio PH with(nolock)on ph.num_proc_hio=ps.num_proc and ph.id_dc='3'
		left join po_hio PO with(nolock)on po.num_proc_hio=ps.num_proc and po.id_dc='1'
		left join house_imp_out VOO with(nolock)on voo.num_proc_hio=ps.num_proc
		left join llp_imp_out ETA with(nolock)on eta.num_proc_lio=ps.num_proc
		left join llp_imp_out ETD with(nolock)on etd.num_proc_lio=ps.num_proc
		left join produto_cliente PC with(nolock)on pc.cd_prod=ps.cd_produto
		left join proc_ncm PN with(nolock)on pn.num_proc=ps.num_proc
		left join NCM N with(nolock)on n.id_ncm=pn.id_ncm
		left join po_hio LI with(nolock)on li.num_proc_hio=ps.num_proc and li.id_dc='23'
		left join produto_chb NLI with(nolock)on nli.cd_prod=pc.cd_prod
		left join Tarefas_Processos TP180 with(nolock)on LLP.Num_Proc_Lio = TP180.Num_Proc and TP180.ID_Task = '180' 
		left join Tarefas_Processos TP181 with(nolock)on LLP.Num_Proc_Lio = TP181.Num_Proc and TP181.ID_Task = '181'
	where 
		etd.etd_lio between @Dt_Inicial and @Dt_Final



GO
