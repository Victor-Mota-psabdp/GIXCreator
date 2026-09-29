SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spExportSun_Rel 'GRUPO SUN CHEMICAL','2011-08-01','2012-05-31'

CREATE Procedure [dbo].[spExportSun_Rel]--'SUN','2011-05-01','2011-09-27'
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
AS

set @Grupo = ( select top 1 grupo from grupo G with(nolock) join pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo where apelido = @Grupo)

BEGIN
	select 
		IC.num_invoice			[Invoice],
		PL.cd_planta			[Codigo do Estabelecimento],
		(select max(data_po_heo) from po_heo with(nolock) where id_dc = 4 and num_proc_heo = IC.num_proc) [Data da RE],
--		RE.numero_po_heo		[Numero do RE],
		dbo.fbusca_docs_po_modal(IC.num_proc,4)[Numero do RE],
		ID.dtNF					[Data da Nota Fiscal],
		PLC.cd_vendor			[Código da Pessoa Física/Jurídica],	
		ID.nf					[Número da Nota Fiscal],
		dbo.fBusca_CampoCliente (IC.num_proc, '112') [Série da Nota Fiscal],
		--PC.cd_proc_cliente		[Código do Produto],	
		isnull(PDet.NCM,PC.NCM_Cliente) [NCM por Item],
		(case when DDE.numero_po_heo IS not NULL then '0' else '1' end) [Tipo De Documento],
		'0' [Tipo de Exportação],
		(case when DDE.numero_po_heo IS not NULL then DDE.numero_po_heo else DSE.numero_po_heo end) [Número da DDE / DSE],
		--DDE.numero_po_heo		[Número da DDE / DSE],
		(case when DDE.data_po_heo IS not NULL then DDE.data_po_heo else DSE.data_po_heo end) [Data da DDE / DSE],
		--DDE.data_po_heo			[Data da DDE / DSE],
		T46.dt_conclusao		[Data de Averbação],
		DST.Pais_LOCAL			[País de Destino],
		PIB.cd_pais_IBGE		[Codigo Siscomex],
		HEO.HAWB_heo			[Número do Conhecimento de Embarque],
		llp.atd_Leo				[Data do Conhecimento de Embarque],
		'CTRC'					[Tipo do Conhecimento de Transporte],
		llp.vlr_invoice			[Valor US$ (Invoice)],
		PES.nome_raz_soc		[Importador],
		DST.Pais_LOCAL			[Destino],
		--LLP.atd_leo				[Data Embarque],
		dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento  (NF)],
		PC.cd_proc_cliente		[Código Produto (Invoice)],
		PC.Produto_Descr		[Descrição                             (Invoice)],
		ID.peso_liquido			[Quantidade     (Invoice)],	
		ID.tipo_unid			[Unidade (Invoice)],
		ID.preco_unit			[Valor Unitário (Invoice)],
		(ID.peso_liquido *	ID.preco_unit)[Valor Total (Invoice)],
		dbo.fBusca_Custo(IC.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') [Custo de Documentação],
		''						[Draw Back -             Ato Concessório],
		HEO.cd_tp_moeda			[Moeda],
		CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '117'))[Valor da Nota - R$ ],
		CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '111'))[Taxa Faturamento Valor],
		--dbo.fBusca_CampoCliente (IC.num_proc, '113')[Data Taxa Fat],
		--dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento Invoice],
		(case when llp.ata_leo IS NULL then 'EM Transito' else 'ENTREGUE' end) [STATUS],
		'SUN CHEMICAL'			[Fabricante],
		(case when da.dt_envio IS NULL then 'NAO' else 'SIM' end)[Certificado de origem],	
		''						[no.]
		
		from invoice_cliente IC with(nolock)
			join invoice_det ID with(nolock) on ID.id_inv = IC.id_inv
			join Produto_Cliente PC with(nolock) on  ID.cd_produto = PC.cd_prod
			Left Join Pedido_Det PDet with(nolock) on PDet.cd_pedido	=ID.cd_pedido and PDet.cd_produto=ID.cd_produto and ID.Item=convert(int,PDet.Item)
			Join Pedido_Ship PS with(nolock) on PS.cd_pedido =ID.cd_pedido and PS.cd_produto=ID.cd_produto and PS.Num_Proc=IC.Num_Proc and ID.Item=convert(int,PS.Item)
			--left join po_heo RE on RE.num_proc_heo = IC.num_proc and RE.id_dc = '4'
			--left join po_heo NF on NF.num_proc_heo = IC.num_proc and NF.id_dc = '10'
			left join po_heo DDE with(nolock) on DDE.num_proc_heo = IC.num_proc and DDE.id_dc = '12'
			left join po_heo DSE with(nolock) on DSE.num_proc_heo = IC.num_proc and DSE.id_dc = '26'
			join house_exp_out HEO with(nolock) on HEO.num_proc_heo  =IC.num_proc
			left join pessoa_llp PL with(nolock) on PL.cd_pes = HEO.cd_export_heo
			left join pessoa_llp PLC with(nolock) on PLC.cd_pes = HEO.cd_consig_heo
			join llp_exp_out LLP with(nolock) on LLP.num_proc_leo  =IC.num_proc
			left join pessoa PES with(nolock)on PES.cd_pes  = HEO.cd_consig_heo
			left join localidade DST with(nolock) on DST.cd_local = HEO.cd_dst_heo
			left join pais Pais with(nolock) on Pais.nome_pais = Dst.pais_local
			left join pais_ibge PIB with(nolock)on PIB.cd_pais = Pais.cd_pais	
			Left Join Tarefas_Processos T46 with(nolock) on IC.num_proc=T46.num_proc and T46.id_task=15
			left join doc_anexos DA with(nolock) on DA.num_proc = IC.num_proc and da.id_dc = 13
		where 
		data_invoice between @DtInicial and @DtFinal
		and right(left(IC.num_proc,5),3) = @Grupo
		and isnull(LLP.id_status,0) <> 9

	group by 
	llp.vlr_invoice,IC.num_invoice,	PL.cd_planta,IC.num_proc,PC.cd_proc_cliente,
	PDet.NCM,PC.NCM_Cliente,DDE.numero_po_heo,DDE.data_po_heo,T46.dt_conclusao,DST.Pais_LOCAL,HEO.HAWB_heo,
	llp.atd_Leo,llp.vlr_invoice,PES.nome_raz_soc,DST.Pais_LOCAL,LLP.atd_leo,PC.cd_proc_cliente,PC.Produto_Descr,
	ID.peso_liquido,HEO.cd_tp_moeda,ID.tipo_unid,ID.preco_unit,llp.ata_leo,da.dt_envio,
	PIB.cd_pais_IBGE,ID.dtNF,ID.nf,PLC.cd_vendor,DSE.numero_po_heo,DSE.data_po_heo,PS.CD_Pedido, PS.Cd_Produto

UNION ALL

	select 
	IC.num_invoice			[Invoice],
	PL.cd_planta			[Codigo do Estabelecimento],
	(select max(data_po_hem) from po_hem with(nolock) where id_dc = 4 and num_proc_hem = IC.num_proc) [Data da RE],
	dbo.fbusca_docs_po_modal(IC.num_proc,1)[Numero do RE],	
--	RE.data_po_hem			[Data da RE],
--	RE.numero_po_hem		[Numero do RE],
	ID.dtNF					[Data da Nota Fiscal],
	PLC.cd_vendor			[Código da Pessoa Física/Jurídica],
	ID.nf					[Número da Nota Fiscal],
	dbo.fBusca_CampoCliente (IC.num_proc, '112') [Série da Nota Fiscal],
	--PC.cd_proc_cliente		[Código do Produto],	
	isnull(PDet.NCM,PC.NCM_Cliente) [NCM],
	(case when DDE.numero_po_hem IS not NULL then '0' else '1' end) [Tipo De Documento],
	'0' [Tipo de Exportação],
	(case when DDE.numero_po_hem IS not NULL then DDE.numero_po_hem else DSE.numero_po_hem end) [Número da DDE / DSE],
	--DDE.numero_po_hem		[Número da DDE / DSE],
	(case when DDE.data_po_hem IS not NULL then DDE.data_po_hem else DSE.data_po_hem end) [Data da DDE / DSE],
	--DDE.data_po_hem			[Data da DDE / DSE],	
	T46.dt_conclusao		[Data de Averbação],
	DST.Pais_LOCAL			[País de Destino],
	PIB.cd_pais_IBGE		[Codigo Siscomex],
	HEO.HAWB_hem			[Número do Conhecimento de Embarque],
	llp.atd_Lem				[Data do Conhecimento de Embarque],
	'BL'					[Tipo do Conhecimento de Transporte],
	llp.vlr_invoice			[Valor US$ (Invoice)],
	PES.nome_raz_soc		[Importador],
	DST.Pais_LOCAL			[Destino],
	--LLP.atd_lem				[Data Embarque],
	--IC.Vencimento			[Data Vencimento  (NF)],
	dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento  (NF)],
	PC.cd_proc_cliente		[Código Produto (Invoice)],
	PC.Produto_Descr		[Descrição                             (Invoice)],
	ID.peso_liquido			[Quantidade     (Invoice)],	
	ID.tipo_unid			[Unidade (Invoice)],
	ID.preco_unit			[Valor Unitário (Invoice)],
	(ID.peso_liquido *	ID.preco_unit)[Valor Total (Invoice)],
	dbo.fBusca_Custo(IC.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') [Custo de Documentação],
	''						[Draw Back -             Ato Concessório],
	HEO.cd_tp_moeda			[Moeda],
	CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '117'))[Valor da Nota - R$ ],
	CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '111'))[Taxa Faturamento Valor],
	--dbo.fBusca_CampoCliente (IC.num_proc, '113')[Data Taxa Fat],
	--dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento Invoice],
	(case when llp.ata_lem IS NULL then 'EM Transito' else 'ENTREGUE' end) [STATUS],
	'SUN CHEMICAL'			[Fabricante],
	(case when da.dt_envio IS NULL then 'NAO' else 'SIM' end)[Certificado de origem],	
	''						[no.]	
	from invoice_cliente IC with(nolock)
		join invoice_det ID with(nolock) on ID.id_inv = IC.id_inv
		join Produto_Cliente PC with(nolock) on  ID.cd_produto = PC.cd_prod
		Left Join Pedido_Det PDet with(nolock) on PDet.cd_pedido	=ID.cd_pedido and PDet.cd_produto=ID.cd_produto and ID.Item=convert(int,PDet.Item)
		Join Pedido_Ship PS with(nolock) on PS.cd_pedido =ID.cd_pedido and PS.cd_produto=ID.cd_produto and PS.Num_Proc=IC.Num_Proc and ID.Item=convert(int,PS.Item)
		--left join po_hem RE on RE.num_proc_hem = IC.num_proc and RE.id_dc = '4'
		--left join po_hem NF on NF.num_proc_hem = IC.num_proc and NF.id_dc = '10'
		left join po_hem DDE with(nolock) on DDE.num_proc_hem = IC.num_proc and DDE.id_dc = '12'
		left join po_hem DSE with(nolock) on DSE.num_proc_hem = IC.num_proc and DSE.id_dc = '26'
		join house_exp_mar HEO with(nolock) on HEO.num_proc_hem  =IC.num_proc
		left join pessoa_llp PL with(nolock) on PL.cd_pes = HEO.cd_export_hem
		left join pessoa_llp PLC with(nolock) on PLC.cd_pes = HEO.cd_consig_hem
		join llp_exp_mar LLP with(nolock) on LLP.num_proc_lem  =IC.num_proc
		left join pessoa PES with(nolock) on PES.cd_pes  = HEO.cd_consig_hem
		left join localidade DST with(nolock) on DST.cd_local = HEO.cd_dst_hem
		left join pais Pais with(nolock) on Pais.nome_pais = Dst.pais_local
		left join pais_ibge PIB with(nolock)on PIB.cd_pais = Pais.cd_pais
		Left Join Tarefas_Processos T46 with(nolock) on IC.num_proc=T46.num_proc and T46.id_task=15
		left join doc_anexos DA on DA.num_proc = IC.num_proc and da.id_dc = 13
	where 
		data_invoice between @DtInicial and @DtFinal
		and right(left(IC.num_proc,5),3) = @Grupo
		and isnull(LLP.id_status,0) <> 9

	group by 
	llp.vlr_invoice,IC.num_invoice,	PL.cd_planta,IC.num_proc,PC.cd_proc_cliente,
	PDet.NCM,PC.NCM_Cliente,DDE.numero_po_hem,DDE.data_po_hem,T46.dt_conclusao,DST.Pais_LOCAL,HEO.HAWB_hem,
	llp.atd_Lem,llp.vlr_invoice,PES.nome_raz_soc,DST.Pais_LOCAL,LLP.atd_lem,PC.cd_proc_cliente,PC.Produto_Descr,
	ID.peso_liquido,HEO.cd_tp_moeda,ID.tipo_unid,ID.preco_unit,llp.ata_lem,da.dt_envio,
	PIB.cd_pais_IBGE,ID.dtNF,ID.nf,PLC.cd_vendor,DSE.numero_po_hem,DSE.data_po_hem,PS.CD_Pedido, PS.Cd_Produto
UNION ALL

	select 
	IC.num_invoice			[Invoice],
	PL.cd_planta			[Codigo do Estabelecimento],
	(select max(data_po_hea) from po_hea with(nolock) where id_dc = 4 and num_proc_hea = IC.num_proc) [Data da RE],
	dbo.fbusca_docs_po_modal(IC.num_proc,1)[Numero do RE],
--	RE.data_po_hea			[Data da RE],
--	RE.numero_po_hea		[Numero do RE],
	ID.dtNF					[Data da Nota Fiscal],
	PLC.cd_vendor			[Código da Pessoa Física/Jurídica],
	ID.nf					[Número da Nota Fiscal],
	dbo.fBusca_CampoCliente (IC.num_proc, '112') [Série da Nota Fiscal],
	--PC.cd_proc_cliente		[Código do Produto],	
	isnull(PDet.NCM,PC.NCM_Cliente) [NCM],
	(case when DDE.numero_po_hea IS not NULL then '0' else '1' end) [Tipo De Documento],
	'0' [Tipo de Exportação],
	(case when DDE.numero_po_hea IS not NULL then DDE.numero_po_hea else DSE.numero_po_hea end) [Número da DDE / DSE],
	--DDE.numero_po_hea		[Número da DDE / DSE],
	(case when DDE.data_po_hea IS not NULL then DDE.data_po_hea else DSE.data_po_hea end) [Data da DDE / DSE],
	--DDE.data_po_hea			[Data da DDE / DSE],
	T46.dt_conclusao		[Data de Averbação],
	DST.Pais_LOCAL			[País de Destino],
	PIB.cd_pais_IBGE		[Codigo Siscomex],
	HEO.HAWB_hea			[Número do Conhecimento de Embarque],
	llp.atd_Lea				[Data do Conhecimento de Embarque],
	'AWB'					[Tipo do Conhecimento de Transporte],
	llp.vlr_invoice			[Valor US$ (Invoice)],
	PES.nome_raz_soc		[Importador],
	DST.Pais_LOCAL			[Destino],
	--LLP.atd_lea				[Data Embarque],
	--IC.Vencimento			[Data Vencimento  (NF)],
	dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento  (NF)],
	PC.cd_proc_cliente		[Código Produto (Invoice)],
	PC.Produto_Descr		[Descrição                             (Invoice)],
	ID.peso_liquido			[Quantidade     (Invoice)],	
	ID.tipo_unid			[Unidade (Invoice)],
	ID.preco_unit			[Valor Unitário (Invoice)],
	(ID.peso_liquido *	ID.preco_unit)[Valor Total (Invoice)],
	dbo.fBusca_Custo(IC.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') [Custo de Documentação],
	''						[Draw Back -             Ato Concessório],
	HEO.cd_tp_moeda			[Moeda],
	CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '117'))[Valor da Nota - R$ ],
	CONVERT(float,dbo.fBusca_CampoCliente (IC.num_proc, '111'))[Taxa Faturamento],
	--dbo.fBusca_CampoCliente (IC.num_proc, '113')[Data Taxa Fat],
	--dbo.fBusca_CampoCliente (IC.num_proc, '29')[Data Vencimento Invoice],
	(case when llp.ata_lea IS NULL then 'EM Transito' else 'ENTREGUE' end) [STATUS],
	'SUN CHEMICAL'			[Fabricante],
	(case when da.dt_envio IS NULL then 'NAO' else 'SIM' end)[Certificado de origem],	
	''						[no.]
	
	from invoice_cliente IC with(nolock)
		join invoice_det ID with(nolock) on ID.id_inv = IC.id_inv
		join Produto_Cliente PC with(nolock) on  ID.cd_produto = PC.cd_prod
		Left Join Pedido_Det PDet with(nolock) on PDet.cd_pedido	=ID.cd_pedido and PDet.cd_produto=ID.cd_produto and ID.Item=convert(int,PDet.Item)
		Join Pedido_Ship PS with(nolock) on PS.cd_pedido =ID.cd_pedido and PS.cd_produto=ID.cd_produto and PS.Num_Proc=IC.Num_Proc and ID.Item=convert(int,PS.Item)
		left join po_hea RE with(nolock) on RE.num_proc_hea = IC.num_proc and RE.id_dc = '4'
		--left join po_hea NF on NF.num_proc_hea = IC.num_proc and NF.id_dc = '10'
		left join po_hea DDE with(nolock) on DDE.num_proc_hea = IC.num_proc and DDE.id_dc = '12'
		left join po_hea DSE with(nolock) on DSE.num_proc_hea = IC.num_proc and DSE.id_dc = '26'
		join house_exp_aer HEO with(nolock) on HEO.num_proc_hea  =IC.num_proc
		left join pessoa_llp PL with(nolock) on PL.cd_pes = HEO.cd_export_hea
		left join pessoa_llp PLC with(nolock) on PLC.cd_pes = HEO.cd_consig_hea
		join llp_exp_aer LLP with(nolock) on LLP.num_proc_lea  =IC.num_proc
		left join pessoa PES with(nolock) on PES.cd_pes  = HEO.cd_consig_hea
		left join localidade DST with(nolock) on DST.cd_local = HEO.cd_dst_hea
		left join pais Pais with(nolock) on Pais.nome_pais = Dst.pais_local
		left join pais_ibge PIB with(nolock) on PIB.cd_pais = Pais.cd_pais
		Left Join Tarefas_Processos T46 with(nolock) on IC.num_proc=T46.num_proc and T46.id_task=15
		left join doc_anexos DA on DA.num_proc = IC.num_proc and da.id_dc = 13
	where 
		data_invoice between @DtInicial and @DtFinal
		and right(left(IC.num_proc,5),3) = @Grupo
		and isnull(LLP.id_status,0) <> 9

	group by 
	llp.vlr_invoice,IC.num_invoice,	PL.cd_planta,IC.num_proc,PC.cd_proc_cliente,
	PDet.NCM,PC.NCM_Cliente,DDE.numero_po_hea,DDE.data_po_hea,T46.dt_conclusao,DST.Pais_LOCAL,HEO.HAWB_hea,
	llp.atd_Lea,llp.vlr_invoice,PES.nome_raz_soc,DST.Pais_LOCAL,LLP.atd_lea,PC.cd_proc_cliente,PC.Produto_Descr,
	ID.peso_liquido,HEO.cd_tp_moeda,ID.tipo_unid,ID.preco_unit,llp.ata_lea,da.dt_envio,
	PIB.cd_pais_IBGE,ID.dtNF,ID.nf,PLC.cd_vendor,DSE.numero_po_hea,DSE.data_po_hea,PS.CD_Pedido, PS.Cd_Produto
	order by IC.num_invoice

END
GO
