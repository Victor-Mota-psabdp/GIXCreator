SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from report_parametro
--select * from report

--[spVencidos_Sel]'Grupo ROHM & HAAS','2011-09-01','2011-09-09','','S - SIM'


CREATE Procedure [dbo].[spVencidos_Sel]

		@Grupo			Varchar(50),		
		@DtInicial		Datetime,
		@DtFinal		Datetime,
		@DC				varchar(10), --C- Credit / D - Debit
		@Historico		varchar(10)	 --S - SIM / N - NAO

As
	if @DC <> ''
		set @DC = left(@DC,1)
	else
		set @DC = '%'	

	Declare @cd_pes_grupo as varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	
	Declare @Hist as int

	if @Historico = 'S - SIM'
		set @Hist = 95
	else
		set @Hist = ''

	select 
		Pe.apelido													[Cliente],
		cta.num_proc_him											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_him)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_him											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_him													[DC],
		cta.vlr_org_him												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_him,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_him,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_imp_mar CTA		
--		Join House_Imp_MAr hou With(Nolock)on hou.num_proc_him=cta.num_proc_him
		join pessoa PE With(Nolock) on cta.cd_cred_dev_him = Pe.cd_pes
--		Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_Him and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_him = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_him = te.num_proc and te.id_task = 40
		join PO_him PO With(Nolock) on PO.num_proc_him = CTA.num_proc_him and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_him and cd_tp_ocor=@Hist
	where 
		cta.dc_him like @dc
		and convert(datetime,dt_ins_him,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_HIm,5),3)  = @Grupo

UNION ALL
	select 
		Pe.apelido													[Cliente],
		cta.num_proc_hia											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_hia)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_hia											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_hia													[DC],
		cta.vlr_org_hia												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_hia,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_hia,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_imp_aer CTA		
--		Join House_Imp_aer hou With(Nolock)on hou.num_proc_hia=cta.num_proc_hia
		join pessoa PE With(Nolock) on cta.cd_cred_dev_hia = Pe.cd_pes
--		Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_hia and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_hia = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_hia = te.num_proc and te.id_task = 40
		join PO_hia PO With(Nolock) on PO.num_proc_hia = CTA.num_proc_hia and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_hia and cd_tp_ocor=@hist
	where 
		cta.dc_hia like @dc
		and convert(datetime,dt_ins_hia,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_HIa,5),3)  = @Grupo

UNION ALL
	select 
		Pe.apelido													[Cliente],
		cta.num_proc_hio											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_hio)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_hio											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_hio													[DC],
		cta.vlr_org_hio												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_hio,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_hio,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_imp_out CTA		
		--Join House_Imp_out hou With(Nolock)on hou.num_proc_hio=cta.num_proc_hio
		join pessoa PE With(Nolock) on cta.cd_cred_dev_hio = Pe.cd_pes
		--Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_Hio and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_hio = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_hio = te.num_proc and te.id_task = 40
		join PO_hio PO With(Nolock) on PO.num_proc_hio = CTA.num_proc_hio and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_hio and cd_tp_ocor=@hist
	where 
		cta.dc_hio like @dc
		and convert(datetime,dt_ins_hio,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_HIO,5),3)  = @Grupo
		
UNION ALL
--EXPORTAÇÂO
	select 
		Pe.apelido													[Cliente],
		cta.num_proc_hem											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_hem)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_hem											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_hem													[DC],
		cta.vlr_org_hem												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_hem,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_hem,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_exp_mar CTA		
		--Join House_exp_MAr hou With(Nolock)on hou.num_proc_hem=cta.num_proc_hem
		join pessoa PE With(Nolock) on cta.cd_cred_dev_hem = Pe.cd_pes
		--Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_hem and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_hem = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_hem = te.num_proc and te.id_task = 40
		join PO_hem PO With(Nolock) on PO.num_proc_hem = CTA.num_proc_hem and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_hem and cd_tp_ocor=@hist
	where 
		cta.dc_hem like @dc
		and convert(datetime,dt_ins_hem,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_Hem,5),3)  = @Grupo

UNION ALL
	select 
		Pe.apelido													[Cliente],
		cta.num_proc_hea											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_hea)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_hea											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_hea													[DC],
		cta.vlr_org_hea												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_hea,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_hea,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_exp_aer CTA		
		--Join House_exp_aer hou With(Nolock)on hou.num_proc_hea=cta.num_proc_hea
		join pessoa PE With(Nolock) on cta.cd_cred_dev_hea = Pe.cd_pes
		--Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_hea and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_hea = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_hea = te.num_proc and te.id_task = 40
		join PO_hea PO With(Nolock) on PO.num_proc_hea = CTA.num_proc_hea and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_hea and cd_tp_ocor=@hist
	where 
		cta.dc_hea like @dc
		and convert(datetime,dt_ins_hea,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_Hea,5),3)  = @Grupo


UNION ALL
	select 
		Pe.apelido													[Cliente],
		cta.num_proc_heo											[JOB],
		[dbo].[fBusca_NotaFiscalVencidos_Num](cta.num_proc_heo)		[NF],
		TP.dt_conclusao												[Emissao NF Data],
		PO.numero_po_heo											[PO],
		TT.nome_tp_tx												[Taxa],
		cta.dc_heo													[DC],
		cta.vlr_org_heo												[Valor(R$) Value],
		(convert(datetime,cta.dt_prev_pgto_heo,103))				[Vencimento Data],
		DATEDIFF(DAY, (convert(datetime,cta.dt_prev_pgto_heo,103)), GETDATE()) * -1 [Atraso],		
		TE.dt_conclusao												[Envio Data],
		HSDDescricao												[Historico Cobranca]
	from cta_cte_hou_exp_out CTA		
		--Join House_exp_out hou With(Nolock)on hou.num_proc_heo=cta.num_proc_heo
		join pessoa PE With(Nolock) on cta.cd_cred_dev_heo = Pe.cd_pes
		--Join Pessoa_LLP PPL With(Nolock) on PPL.cd_pes=HOU.Cd_Consig_heo and PPL.Cd_Pes_Grupo=@Cd_Grupo
		join tipo_Taxa TT With(Nolock) on TT.cd_tp_tx = CTA.cd_tp_tx  and cta.cd_tp_tx in ('XCA','XCQ','XEQ','XEU')
		join tarefas_processos TP With(Nolock) on cta.num_proc_heo = tp.num_proc and tp.id_task = 78
		join tarefas_processos TE With(Nolock) on cta.num_proc_heo = te.num_proc and te.id_task = 40
		join PO_heo PO With(Nolock) on PO.num_proc_heo = CTA.num_proc_heo and po.id_dc = 1
		Left Join Atlantis.dbo.Hist_Geral HSD With(Nolock) on HSGPRocesso=cta.Num_Proc_heo and cd_tp_ocor=@hist
	where 
		cta.dc_heo like @dc
		and convert(datetime,dt_ins_heo,103) between convert(datetime,@dtinicial,103) and convert(datetime,@dtfinal,103)
		and right(left(cta.Num_proc_HEO,5),3)  = @Grupo

order by atraso
GO
