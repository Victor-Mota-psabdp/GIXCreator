SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o nome da taxa, alex financeiro - 6/3/13 -cadu
--[SP_SEL_CAIXAS]'01/01/2011', '31/12/2011', 'DOW%','Prestação de Contas (CHB)'
CREATE    PROCEDURE  [dbo].[SP_SEL_CAIXAS]
				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@Pessoa	varchar (30),
				@Nome_Tp_Tx varchar(50)
AS

Select 
	Nome_Tp_Tx Taxa, Apelido Credor_Devedor, CXA.num_Proc_HIA N_Processo,
	CXA.cd_tp_Tx, cxa.dc_hia DC, CXA.num_lcto Lancamento, Vlr_Ref_Hia Vl_Moeda_Forte,
	dbo.fBusca_TipoDocCliente('N',CXA.num_proc_hia,'1') PO,
	Num_Cta_Cte,
	Vlr_Pgto_Rcto_Hia Valor_Real, 
	1.0000	Paridade,
	Num_rcb_Hia Comprovante	, convert(Datetime,dt_pgto_rcto,105) Data,
	Num_Doc, Cd_Tp_Moeda ,isnull(descricao,'Não Classificado') Grupo_TX,
	Num_NF_HIA NF
From
	vwcxas CXA with(nolock)
	Join Pgto_Rcto PG with(nolock) on PG.num_lcto=CXA.num_lcto
	Join vwcta_Cte CTA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_cred_dev_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_Tx
	Left Join Taxa_Grupo TXG with(nolock) on TXG.cd_tx_grp=ref_Ctb_Tx and cxa.dc_hia=TXG.dc
Where
	convert(Datetime,dt_pgto_rcto,105)  between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
	and (apelido like @Pessoa  or @Pessoa='%')
--	and (apelido =@Pessoa or @Pessoa='%')
	and (Nome_Tp_Tx like @Nome_Tp_Tx or @Nome_Tp_Tx='%') 
	and Vlr_Ref_Hia <> 0
	And 	 Cd_TP_Moeda<>'REL'



Union all


Select 
	Nome_Tp_Tx Taxa, Apelido Credor_Devedor, CXA.num_Proc_HIA N_Processo,
	CXA.cd_tp_Tx, cxa.dc_hia DC, CXA.num_lcto Lancamento, Vlr_Ref_Hia Vl_Moeda_Forte,
	dbo.fBusca_TipoDocCliente('N',CXA.num_proc_hia,'1') PO,
	Num_Cta_Cte,
	Vlr_Pgto_Rcto_Hia Valor_Real, 
	(
		
			Vlr_Pgto_Rcto_Hia/Vlr_Ref_Hia
		
	
	) 
	
	Paridade,
	Num_rcb_Hia Comprovante	, convert(Datetime,dt_pgto_rcto,105) Data,
	Num_Doc, Cd_Tp_Moeda ,isnull(descricao,'Não Classificado') Grupo_TX,
		Num_NF_HIA NF
From
	vwcxas CXA with(nolock)
	Join Pgto_Rcto PG with(nolock) on PG.num_lcto=CXA.num_lcto
	Join vwcta_Cte CTA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_cred_dev_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_Tx
	Left Join Taxa_Grupo TXG with(nolock) on TXG.cd_tx_grp=ref_Ctb_Tx and cxa.dc_hia=TXG.dc
Where
	convert(Datetime,dt_pgto_rcto,105)  between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
	and (apelido like @Pessoa  or @Pessoa='%')
--	and (apelido =@Pessoa or @Pessoa='%')
	and (Nome_Tp_Tx like @Nome_Tp_Tx or @Nome_Tp_Tx='%') 
	and Cd_TP_Moeda='REL' and Vlr_Pgto_Rcto_Hia<>0 and Vlr_Ref_Hia<>0
	


--order by cxa.num_lcto
--select (
--	nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_mas_exp_aer.num_proc_mea) as N_Processo, 
--	(caixa_mas_exp_aer.cd_tp_tx), 
--	(caixa_mas_exp_aer.dc_mea) as DC, 
--	(caixa_mas_exp_aer.num_lcto) as Lancamento, 
--	cast(caixa_mas_exp_aer.vlr_ref_mea as money)as Vl_Moeda_Forte, 
--	cast(caixa_mas_exp_aer.par_moeda_mea as money) as Paridade, 
--	cast(caixa_mas_exp_aer.vlr_pgto_rcto_mea as money) as Valor_Real, 
--	convert(datetime, caixa_mas_exp_aer.dt_pgto_rcto_mea, 105) as Data, 
--	caixa_mas_exp_aer.num_rcb_mea as Comprovante,
--	cd_tp_moeda,
--	Num_doc,
--	dbo.fbusca_docs_po_modal(caixa_mas_exp_aer.num_proc_mea,'1') PO,
--	Num_Cta_cte
--from caixa_mas_exp_aer
--join cta_cte_mas_exp_aer on caixa_mas_exp_aer.cd_tp_tx=cta_cte_mas_exp_aer.cd_tp_tx and caixa_mas_exp_aer.dc_mea=cta_cte_mas_exp_aer.dc_mea and caixa_mas_exp_aer.num_proc_mea=cta_cte_mas_exp_aer.num_proc_mea
--join pessoa on cta_cte_mas_exp_aer.cd_cred_dev_mea=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_mas_exp_aer.cd_tp_tx
--join pgto_rcto PR on caixa_mas_exp_aer.num_lcto = PR.num_lcto
--
--WHERE caixa_mas_exp_aer.NUM_LCTO<>'Provisório' and apelido <> 'Rateio' 
--AND convert(datetime, caixa_mas_exp_aer.dt_pgto_rcto_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--and pessoa.apelido like @Pessoa 
--
--
--UNION
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_mas_IMP_aer.num_proc_mIA) as N_Processo, 
--	(caixa_mas_IMP_AER.cd_tp_tx), 
--	(caixa_mas_IMP_AER.dc_mIA) as DC, 
--	(caixa_mas_IMP_AER.num_lcto) as Lancamento, 
--	cast(caixa_mas_IMP_AER.vlr_ref_mIA as money)as Vl_Moeda_Forte, 
--	cast(caixa_mas_IMP_AER.par_moeda_mIA as money) as Paridade, 
--	cast(caixa_mas_IMP_AER.vlr_pgto_rcto_mIA as money) as Valor_Real, 
--	convert(datetime, caixa_mas_IMP_AER.dt_pgto_rcto_mIA, 105) as Data, 
--	caixa_mas_IMP_AER.num_rcb_mIA as comprovante,
--	cd_tp_moeda,
--	Num_doc,
--	dbo.fbusca_docs_po_modal(caixa_mas_IMP_AER.num_proc_mia,'1') PO  ,	
--		Num_Cta_cte
--from caixa_mas_IMP_AER
--join cta_cte_mas_IMP_aer on caixa_mas_IMP_aer.cd_tp_tx=cta_cte_mas_IMP_aer.cd_tp_tx and caixa_mas_IMP_aer.dc_mIa=cta_cte_mas_IMP_aer.dc_mIa and caixa_mas_IMP_aer.num_proc_mIA=cta_cte_mas_IMP_aer.num_proc_mIA
--join pessoa on cta_cte_mas_IMP_aer.cd_cred_dev_mIA=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_mas_IMP_aer.cd_tp_tx
--join pgto_rcto PR on caixa_mas_imp_aer.num_lcto = PR.num_lcto
--WHERE caixa_mas_IMP_AER.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--and convert(datetime, caixa_mas_imp_aer.dt_pgto_rcto_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--and pessoa.apelido like @Pessoa
--UNION
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_mas_IMP_MAR.num_proc_mIM) as N_Processo, 
--	(caixa_mas_IMP_MAR.cd_tp_tx), 
--	(caixa_mas_IMP_MAR.dc_mIM) as DC, 
--	(caixa_mas_IMP_MAR.num_lcto) as Lancamento, 
--	cast(caixa_mas_IMP_MAR.vlr_ref_mIM as money)as Vl_Moeda_Forte, 
--	cast(caixa_mas_IMP_MAR.par_moeda_mIM as money) as Paridade, 
--	cast(caixa_mas_IMP_MAR.vlr_pgto_rcto_mIM as money) as Valor_Real, 
--	convert(datetime, caixa_mas_IMP_MAR.dt_pgto_rcto_mIM, 105) as Data, 
--	caixa_mas_IMP_MAR.num_rcb_mIM as comprovante,
--	cd_tp_moeda,
--	Num_doc,
--	dbo.fbusca_docs_po_modal(caixa_mas_IMP_MAR.num_proc_mim,'1') PO 	
--		,	Num_Cta_cte  
--from caixa_mas_IMP_MAR
--join cta_cte_mas_IMP_MAR on caixa_mas_IMP_MAR.cd_tp_tx=cta_cte_mas_IMP_MAR.cd_tp_tx and caixa_mas_IMP_MAR.dc_mIM=cta_cte_mas_IMP_MAR.dc_mIM and caixa_mas_IMP_MAR.num_proc_mIM=cta_cte_mas_IMP_MAR.num_proc_mIM
--join pessoa on cta_cte_mas_IMP_MAR.cd_cred_dev_mIM=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_mas_IMP_MAR.cd_tp_tx
--join pgto_rcto PR on caixa_mas_imp_mar.num_lcto = PR.num_lcto
--WHERE caixa_mas_IMP_MAR.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--and convert(datetime, caixa_mas_imp_mar.dt_pgto_rcto_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--and pessoa.apelido like @Pessoa
--union
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_mas_EXP_MAR.num_proc_mEM) as N_Processo, 
--	(caixa_mas_EXP_MAR.cd_tp_tx), 
--	(caixa_mas_EXP_MAR.dc_mEM) as DC, 
--	(caixa_mas_EXP_MAR.num_lcto) as Lancamento, 
--	cast(caixa_mas_EXP_MAR.vlr_ref_mEM as money)as Vl_Moeda_Forte, 
--	cast(caixa_mas_EXP_MAR.par_moeda_mEM as money) as Paridade, 
--	cast(caixa_mas_EXP_MAR.vlr_pgto_rcto_mEM as money) as Valor_Real, 
--	convert(datetime, caixa_mas_EXP_MAR.dt_pgto_rcto_mEM, 105) as Data, 
--	caixa_mas_exp_MAR.num_rcb_mEM as comprovante,
--	cd_tp_moeda,
--	Num_doc,
--	dbo.fbusca_docs_po_modal(caixa_mas_EXP_MAR.num_proc_mem,'1') PO 
--	,	Num_Cta_cte	  
--from caixa_mas_EXP_MAR
--join cta_cte_mas_EXP_MAR on caixa_mas_EXP_MAR.cd_tp_tx=cta_cte_mas_EXP_MAR.cd_tp_tx and caixa_mas_EXP_MAR.dc_mEM=cta_cte_mas_EXP_MAR.dc_mEM and caixa_mas_EXP_MAR.num_proc_mEM=cta_cte_mas_EXP_MAR.num_proc_mEM
--join pessoa on cta_cte_mas_EXP_MAR.cd_cred_dev_mEM=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_mas_EXP_MAR.cd_tp_tx
--join pgto_rcto PR on caixa_mas_exp_mar.num_lcto = PR.num_lcto
--WHERE caixa_mas_EXP_MAR.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--and convert(datetime, caixa_mas_exp_mar.dt_pgto_rcto_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--and pessoa.apelido like @Pessoa
--
--union
--
--select 
--	(nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_EXP_MAR.num_proc_hEM) as N_Processo, 
--	(caixa_hou_EXP_MAR.cd_tp_tx), 
--	(caixa_hou_EXP_MAR.dc_hEM) as DC, 
--	(caixa_hou_EXP_MAR.num_lcto) as Lancamento, 
--	cast(caixa_hou_EXP_MAR.vlr_ref_hEM as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_EXP_MAR.par_moeda_hEM as money) as Paridade, 
--	cast(caixa_hou_EXP_MAR.vlr_pgto_rcto_hEM as money) as Valor_Real, 
--	convert(datetime, caixa_hou_EXP_MAR.dt_pgto_rcto_hEM, 105) as Data, 
--	caixa_hou_exp_MAR.num_rcb_hEM as comprovante,
--	cd_tp_moeda,
--	Num_doc,	  
--	dbo.fbusca_docs_po_modal(caixa_hou_EXP_MAR.num_proc_hem,'1') PO 
--	,	Num_Cta_cte
--from 
--	caixa_hou_EXP_MAR
--
--join cta_cte_hou_EXP_MAR on caixa_hou_EXP_MAR.cd_tp_tx=cta_cte_hou_EXP_MAR.cd_tp_tx and caixa_hou_EXP_MAR.dc_hEM=cta_cte_hou_EXP_MAR.dc_hEM and caixa_hou_EXP_MAR.num_proc_hEM=cta_cte_hou_EXP_MAR.num_proc_hEM
--join pessoa on cta_cte_hou_EXP_MAR.cd_cred_dev_hEM=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_EXP_MAR.cd_tp_tx
--join pgto_rcto PR on caixa_hou_exp_mar.num_lcto = PR.num_lcto
--WHERE 
--	caixa_hou_EXP_MAR.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_exp_mar.dt_pgto_rcto_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_exp_mar.num_proc_hem,5) <> 'EMJOB'
--
--union
--
--select 
--	(nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_IMP_MAR.num_proc_hIM) as N_Processo, 
--	(caixa_hou_IMP_MAR.cd_tp_tx), 
--	(caixa_hou_IMP_MAR.dc_hIM) as DC, 
--	(caixa_hou_IMP_MAR.num_lcto) as Lancamento, 
--	cast(caixa_hou_IMP_MAR.vlr_ref_hIM as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_IMP_MAR.par_moeda_hIM as money) as Paridade, 
--	cast(caixa_hou_IMP_MAR.vlr_pgto_rcto_hIM as money) as Valor_Real, 
--	convert(datetime, caixa_hou_IMP_MAR.dt_conv_hIM, 105) as Data, 
--	caixa_hou_IMP_MAR.num_rcb_hIM as comprovante,
--	cd_tp_moeda,
--	Num_doc,  
--	dbo.fbusca_docs_po_modal(caixa_hou_IMP_MAR.num_proc_him,'1') PO
--	,	Num_Cta_cte
--from 
--	caixa_hou_IMP_MAR
--
--join cta_cte_hou_IMP_MAR on caixa_hou_IMP_MAR.cd_tp_tx=cta_cte_hou_IMP_MAR.cd_tp_tx and caixa_hou_IMP_MAR.dc_hIM=cta_cte_hou_IMP_MAR.dc_hIM and caixa_hou_IMP_MAR.num_proc_hIM=cta_cte_hou_IMP_MAR.num_proc_hIM
--join pessoa on cta_cte_hou_IMP_MAR.cd_cred_dev_hIM=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_IMP_MAR.cd_tp_tx
--join pgto_rcto PR on caixa_hou_imp_mar.num_lcto = PR.num_lcto
--WHERE 
--	caixa_hou_IMP_MAR.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_imp_mar.dt_conv_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_imp_mar.num_proc_him,5) <> 'IMJOB'
--union
--
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_IMP_AER.num_proc_hIA) as N_Processo, 
--	(caixa_hou_IMP_AER.cd_tp_tx), 
--	(caixa_hou_IMP_AER.dc_hIA) as DC, 
--	(caixa_hou_IMP_AER.num_lcto) as Lancamento, 
--	cast(caixa_hou_IMP_AER.vlr_ref_hIA as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_IMP_AER.par_moeda_hIA as money) as Paridade, 
--	cast(caixa_hou_IMP_AER.vlr_pgto_rcto_hIA as money) as Valor_Real, 
--	convert(datetime, caixa_hou_IMP_AER.Dt_pgto_rcto_hIA, 105) as Data, 
--	caixa_hou_IMP_AER.num_rcb_hIA as comprovante,
--	cd_tp_moeda,
--	Num_doc,
--	dbo.fbusca_docs_po_modal(caixa_hou_IMP_AER.num_proc_hia,'1') PO
--	,	Num_Cta_cte
--from caixa_hou_IMP_AER
--
--join cta_cte_hou_IMP_AER on caixa_hou_IMP_AER.cd_tp_tx=cta_cte_hou_IMP_AER.cd_tp_tx and caixa_hou_IMP_AER.dc_hIA=cta_cte_hou_IMP_AER.dc_hIA and caixa_hou_IMP_AER.num_proc_hIA=cta_cte_hou_IMP_AER.num_proc_hIA
--join pessoa on cta_cte_hou_IMP_AER.cd_cred_dev_hIA=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_IMP_AER.cd_tp_tx
--join pgto_rcto PR on caixa_hou_imp_aer.num_lcto = PR.num_lcto
--WHERE 
--	caixa_hou_IMP_AER.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_imp_aer.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_imp_aer.num_proc_hia,5) <> 'IAJOB'
--
--UNION
--select 
--	(nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_EXP_AER.num_proc_hEA) as N_Processo, 
--	(caixa_hou_EXP_AER.cd_tp_tx), 
--	(caixa_hou_EXP_AER.dc_hEA) as DC, 
--	(caixa_hou_EXP_AER.num_lcto) as Lancamento, 
--	cast(caixa_hou_EXP_AER.vlr_ref_hEA as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_EXP_AER.par_moeda_hEA as money) as Paridade, 
--	cast(caixa_hou_EXP_AER.vlr_pgto_rcto_hEA as money) as Valor_Real, 
--	convert(datetime, caixa_hou_EXP_AER.Dt_pgto_rcto_hEA, 105) as Data, 
--	caixa_hou_EXP_AER.num_rcb_hEA as comprovante,
--	cd_tp_moeda,
--	Num_doc,  
--	dbo.fbusca_docs_po_modal(caixa_hou_EXP_AER.num_proc_hea,'1') PO
--	,	Num_Cta_cte
--from 
--	caixa_hou_EXP_AER
--
--join cta_cte_hou_EXP_AER on caixa_hou_EXP_AER.cd_tp_tx=cta_cte_hou_EXP_AER.cd_tp_tx and caixa_hou_EXP_AER.dc_hEA=cta_cte_hou_EXP_AER.dc_hEA and caixa_hou_EXP_AER.num_proc_hEA=cta_cte_hou_EXP_AER.num_proc_hEA
--join pessoa on cta_cte_hou_EXP_AER.cd_cred_dev_hEA=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_EXP_AER.cd_tp_tx
--join pgto_rcto PR on caixa_hou_exp_aer.num_lcto = PR.num_lcto
--WHERE 
--	caixa_hou_EXP_AER.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_exp_aer.dt_pgto_rcto_hea, 105)  between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_exp_aer.num_proc_hea,5) <> 'EAJOB'
--
--union 
--
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_IMP_out.num_proc_hio) as N_Processo, 
--	(caixa_hou_IMP_out.cd_tp_tx), 
--	(caixa_hou_IMP_out.dc_hio) as DC, 
--	(caixa_hou_IMP_out.num_lcto) as Lancamento, 
--	cast(caixa_hou_IMP_out.vlr_ref_hio as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_IMP_out.par_moeda_hio as money) as Paridade, 
--	cast(caixa_hou_IMP_out.vlr_pgto_rcto_hio as money) as Valor_Real, 
--	convert(datetime, caixa_hou_IMP_out.Dt_pgto_rcto_hio, 105) as Data, 
--	caixa_hou_IMP_out.num_rcb_hio as comprovante,
--	cd_tp_moeda,
--	Num_doc,	  
--	dbo.fbusca_docs_po_modal(caixa_hou_IMP_out.num_proc_hio,'1') PO
--	,	Num_Cta_cte
--from caixa_hou_IMP_out
--
--join cta_cte_hou_IMP_out on caixa_hou_IMP_out.cd_tp_tx=cta_cte_hou_IMP_out.cd_tp_tx and caixa_hou_IMP_out.dc_hio=cta_cte_hou_IMP_out.dc_hio and caixa_hou_IMP_out.num_proc_hio=cta_cte_hou_IMP_out.num_proc_hio
--join pessoa on cta_cte_hou_IMP_out.cd_cred_dev_hio=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_IMP_out.cd_tp_tx
--join pgto_rcto PR on caixa_hou_imp_out.num_lcto = PR.num_lcto
--WHERE 
--	caixa_hou_IMP_out.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_imp_out.dt_pgto_rcto_hio, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_imp_out.num_proc_hio,5) <> 'IAJOB'
--union
--
--select (nome_tp_tx) as Taxa, 
--	(pessoa.apelido) as Credor_Devedor,
--	(caixa_hou_exp_out.num_proc_heo) as N_Processo, 
--	(caixa_hou_exp_out.cd_tp_tx), 
--	(caixa_hou_exp_out.dc_heo) as DC, 
--	(caixa_hou_exp_out.num_lcto) as Lancamento, 
--	cast(caixa_hou_exp_out.vlr_ref_heo as money)as Vl_Moeda_Forte, 
--	cast(caixa_hou_exp_out.par_moeda_heo as money) as Paridade, 
--	cast(caixa_hou_exp_out.vlr_pgto_rcto_heo as money) as Valor_Real, 
--	convert(datetime, caixa_hou_exp_out.Dt_pgto_rcto_heo, 105) as Data, 
--	caixa_hou_exp_out.num_rcb_heo as comprovante,
--	cd_tp_moeda,
--	Num_doc,	  
--	dbo.fbusca_docs_po_modal(caixa_hou_exp_out.num_proc_heo,'1') PO
--	,	Num_Cta_cte
--from caixa_hou_exp_out
--
--join cta_cte_hou_exp_out on caixa_hou_exp_out.cd_tp_tx=cta_cte_hou_exp_out.cd_tp_tx and caixa_hou_exp_out.dc_heo=cta_cte_hou_exp_out.dc_heo and caixa_hou_exp_out.num_proc_heo=cta_cte_hou_exp_out.num_proc_heo
--join pessoa on cta_cte_hou_exp_out.cd_cred_dev_heo=pessoa.cd_pes
--join tipo_taxa on tipo_taxa.cd_tp_tx=caixa_hou_exp_out.cd_tp_tx
--join pgto_rcto PR on caixa_hou_exp_out.num_lcto = PR.num_lcto
--
--WHERE 
--	caixa_hou_exp_out.NUM_LCTO<>'Provisório' and apelido <> 'Rateio'
--	and convert(datetime, caixa_hou_exp_out.dt_pgto_rcto_heo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and pessoa.apelido like @Pessoa
--	and left(cta_cte_hou_exp_out.num_proc_heo,5) <> 'IAJOB'
--
--
--




GO
