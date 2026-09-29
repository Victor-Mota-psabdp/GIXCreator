SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE     Procedure spCont_Rel  

	@datainicial 	varchar(10),
	@datafinal	varchar(10)

AS

SELECT
	'R' Tipo,cxa.num_proc_hia, nome_tp_Tx, CXA.DC_HIA, cxa.num_lcto, cxa.vlr_pgto_rcto_hia, 
	convert(datetime,cxa.Dt_Pgto_Rcto_HIA,105) Dt_Pgto_Rcto_HIA , cxo.Dt_Pgto_Rcto_HIA PgtoOP, cxm.Dt_Pgto_Rcto_MIA 
FROM
	caixa_hou_imp_aer cxa
	LEFT JOIN cta_cte_hou_imp_aer cto on cxa.num_proc_hia=cto.num_proc_hia and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hia <> cto.dc_hia 
	left join caixa_hou_imp_aer cxo on cxa.num_proc_hia=cxo.num_proc_hia and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hia <> cxo.dc_hia and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hia,105)<=convert(datetime,cxa.dt_pgto_rcto_hia,105)
	left join cta_cte_mas_imp_aer ctm on left(cxa.num_proc_hia,14)=ctm.num_proc_mia and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hia <> ctm.dc_mia 
	left join caixa_mas_imp_aer cxm on left(cxa.num_proc_hia,14)=cxm.num_proc_mia and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hia <> cxm.dc_mia and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_mia,105)<=convert(datetime,cxa.dt_pgto_rcto_hia,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx

WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hia,105) between convert(datetime,@datainicial,105)
	and convert(datetime, @datafinal,105)  AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hia is not null or ctm.num_proc_mia is not null)

UNION ALL

SELECT
	'R' Tipo,cxa.num_proc_hea, nome_tp_Tx, CXA.DC_hea, cxa.num_lcto, cxa.vlr_pgto_rcto_hea, 
	convert(datetime,cxa.Dt_Pgto_Rcto_hea,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_hea, cxm.Dt_Pgto_Rcto_mea 
FROM
	caixa_hou_exp_aer cxa
	left join cta_cte_hou_exp_aer cto on cxa.num_proc_hea=cto.num_proc_hea and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hea <> cto.dc_hea 
	left join caixa_hou_exp_aer cxo on cxa.num_proc_hea=cxo.num_proc_hea and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hea <> cxo.dc_hea and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hea,105)<=convert(Datetime,cxa.dt_pgto_rcto_hea,105)
	left join cta_cte_mas_exp_aer ctm on left(cxa.num_proc_hea,14)=ctm.num_proc_mea and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hea <> ctm.dc_mea 
	left join caixa_mas_exp_aer cxm on left(cxa.num_proc_hea,14)=cxm.num_proc_mea and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hea <> cxm.dc_mea and cxm.num_lcto<>'PROVISÓRIO' and convert(Datetime,cxm.dt_pgto_rcto_mea,105)<=convert(datetime,cxa.dt_pgto_rcto_hea,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hea is not null or ctm.num_proc_mea is not null)

UNION

SELECT
	'R' Tipo,cxa.num_proc_him, nome_tp_Tx, CXA.DC_him, cxa.num_lcto, cxa.vlr_pgto_rcto_him, 
	convert(datetime,cxa.Dt_Pgto_Rcto_him,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_him, cxm.Dt_Pgto_Rcto_MIM 
FROM
	caixa_hou_imp_mar cxa
	left join CTA_CTE_hou_imp_mar cTo on cxa.num_proc_him=cTo.num_proc_him and cxa.cd_tp_tx=cTo.cd_tp_tx and cxa.dc_him <> cTo.dc_him 
	left join caixa_hou_imp_mar cxo on cxa.num_proc_him=cxo.num_proc_him and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_him <> cxo.dc_him and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_him,105)<=convert(datetime,cxa.dt_pgto_rcto_him,105)
	left join cta_cte_mas_imp_mar ctm on left(cxa.num_proc_him,14)=ctm.num_proc_MIM and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_him <> ctm.dc_MIM 
	left join caixa_mas_imp_mar cxm on left(cxa.num_proc_him,14)=cxm.num_proc_MIM and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_him <> cxm.dc_MIM and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_MIM,105)<=convert(datetime,cxa.dt_pgto_rcto_him,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_him,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_him is not null or ctm.num_proc_mim is not null)

UNION ALL

SELECT
	'R' Tipo,cxa.num_proc_hem, nome_tp_Tx, CXA.DC_hem, cxa.num_lcto, cxa.vlr_pgto_rcto_hem, 
	convert(datetime,cxa.Dt_Pgto_Rcto_hem,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_hem, cxm.Dt_Pgto_Rcto_mem 
FROM
	caixa_hou_exp_mar cxa
	left join cta_cte_hou_exp_mar cto on cxa.num_proc_hem=cto.num_proc_hem and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hem <> cto.dc_hem 
	left join caixa_hou_exp_mar cxo on cxa.num_proc_hem=cxo.num_proc_hem and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hem <> cxo.dc_hem and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hem,105)<=convert(datetime,cxa.dt_pgto_rcto_hem,105)
	left join cta_cte_mas_exp_mar ctm on left(cxa.num_proc_hem,14)=ctm.num_proc_mem and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hem <> ctm.dc_mem 
	left join caixa_mas_exp_mar cxm on left(cxa.num_proc_hem,14)=cxm.num_proc_mem and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hem <> cxm.dc_mem and cxm.num_lcto<>'PROVISÓRIO' and convert(Datetime,cxm.dt_pgto_rcto_mem,105)<=convert(datetime,cxa.dt_pgto_rcto_hem,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hem,105) between convert(datetime,@DataInicial,105) and
	convert(datetime,@datafinal,105)  AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hem is not null or ctm.num_proc_mem is not null)

UNION

SELECT
	'R' Tipo,cxa.num_proc_Mia, nome_tp_Tx, CXA.DC_MIA, cxa.num_lcto, cxa.vlr_pgto_rcto_Mia, 
	convert(datetime,cxa.Dt_Pgto_Rcto_MIA,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MIA, cxH.Dt_Pgto_Rcto_HIA 
FROM
	caixa_MAS_imp_aer cxa
	left join cta_cte_MAS_imp_aer cto on cxa.num_proc_Mia=cto.num_proc_Mia and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_Mia <> cto.dc_Mia 
	left join caixa_MAS_imp_aer cxo on cxa.num_proc_Mia=cxo.num_proc_Mia and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_Mia <> cxo.dc_Mia and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_Mia,105)<=convert(datetime,cxa.dt_pgto_rcto_Mia,105)
	left join cta_cte_HOU_imp_aer ctH on cxa.num_proc_Mia=LEFT(ctH.num_proc_Hia,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_Mia <> ctH.dc_Hia 
	left join caixa_HOU_imp_aer cxH on cxa.num_proc_Mia=LEFT(cxH.num_proc_Hia,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_Mia <> cxH.dc_Hia and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_Hia,105)<=convert(datetime,cxa.dt_pgto_rcto_Mia,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_Mia,105) between convert(datetime,@datainicial,105) 
	and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_mia is not null or cth.num_proc_hia is not null)


UNION

SELECT
	'R' Tipo,cxa.num_proc_mea, nome_tp_Tx, CXA.DC_mea, cxa.num_lcto, cxa.vlr_pgto_rcto_mea, 
	convert(datetime,cxa.Dt_Pgto_Rcto_mea,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_mea, cxH.Dt_Pgto_Rcto_hea 
FROM
	caixa_MAS_exp_aer cxa
	left join cta_cte_MAS_exp_aer cto on cxa.num_proc_mea=cto.num_proc_mea and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_mea <> cto.dc_mea 
	left join caixa_MAS_exp_aer cxo on cxa.num_proc_mea=cxo.num_proc_mea and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_mea <> cxo.dc_mea and cxo.num_lcto<>'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_rcto_mea,105)<=convert(datetime,cxa.dt_pgto_rcto_mea,105)
	left join cta_cte_HOU_exp_aer ctH on cxa.num_proc_mea=LEFT(ctH.num_proc_hea,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_mea <> ctH.dc_hea 
	left join caixa_HOU_exp_aer cxH on cxa.num_proc_mea=LEFT(cxH.num_proc_hea,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_mea <> cxH.dc_hea and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_hea,105)<=convert(datetime,cxa.dt_pgto_rcto_mea,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_mea,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@datafinal,105)  AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_mea is not null or cth.num_proc_hea is not null)


UNION

SELECT
	'R' Tipo,cxa.num_proc_MIM, nome_tp_Tx, CXA.DC_MIM, cxa.num_lcto, cxa.vlr_pgto_rcto_MIM, 
	convert(datetime,cxa.Dt_Pgto_Rcto_MIM,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MIM, cxH.Dt_Pgto_Rcto_HIM 
FROM
	caixa_MAS_imp_MAR cxa
	left join cta_cte_MAS_imp_MAR cto on cxa.num_proc_MIM=cto.num_proc_MIM and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_MIM <> cto.dc_MIM 
	left join caixa_MAS_imp_MAR cxo on cxa.num_proc_MIM=cxo.num_proc_MIM and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_MIM <> cxo.dc_MIM and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_MIM,105)<=convert(datetime,cxa.dt_pgto_rcto_MIM,105)
	left join cta_cte_HOU_imp_MAR ctH on cxa.num_proc_MIM=LEFT(ctH.num_proc_HIM,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_MIM <> ctH.dc_HIM 
	left join caixa_HOU_imp_MAR cxH on cxa.num_proc_MIM=LEFT(cxH.num_proc_HIM,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_MIM <> cxH.dc_HIM and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_HIM,105)<=convert(datetime,cxa.dt_pgto_rcto_MIM,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_MIM,105) between convert(datetime,@datainicial,105)
	and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_MIM is not null or cth.num_proc_HIM is not null)


UNION

SELECT
	'R' Tipo,cxa.num_proc_MEM, nome_tp_Tx, CXA.DC_MEM, cxa.num_lcto, cxa.vlr_pgto_rcto_MEM, 
	convert(datetime, cxa.Dt_Pgto_Rcto_mem,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MEM, cxH.Dt_Pgto_Rcto_HEM 
FROM
	caixa_MAS_exp_MAR cxa
	left join cta_cte_MAS_exp_MAR cto on cxa.num_proc_MEM=cto.num_proc_MEM and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_MEM <> cto.dc_MEM 
	left join caixa_MAS_exp_MAR cxo on cxa.num_proc_MEM=cxo.num_proc_MEM and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_MEM <> cxo.dc_MEM and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_MEM,105)<=convert(datetime,cxa.dt_pgto_rcto_MEM,105)
	left join cta_cte_HOU_exp_MAR ctH on cxa.num_proc_MEM=LEFT(ctH.num_proc_HEM,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_MEM <> ctH.dc_HEM 
	left join caixa_HOU_exp_MAR cxH on cxa.num_proc_MEM=LEFT(cxH.num_proc_HEM,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_MEM <> cxH.dc_HEM and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_HEM,105)<=convert(datetime,cxa.dt_pgto_rcto_MEM,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_MEM,105) between convert(datetime,@datainicial,105)
	and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_MEM is not null or cth.num_proc_HEM is not null)

union

SELECT
	'N' Tipo,cxa.num_proc_hia, nome_tp_Tx, CXA.DC_HIA, cxa.num_lcto, cxa.vlr_pgto_rcto_hia, 
	convert(datetime,cxa.Dt_Pgto_Rcto_HIA,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_HIA PgtoOP, cxm.Dt_Pgto_Rcto_MIA 
FROM
	caixa_hou_imp_aer cxa
	LEFT JOIN cta_cte_hou_imp_aer cto on cxa.num_proc_hia=cto.num_proc_hia and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hia <> cto.dc_hia 
	left join caixa_hou_imp_aer cxo on cxa.num_proc_hia=cxo.num_proc_hia and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hia <> cxo.dc_hia and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hia,105)<=convert(datetime,cxa.dt_pgto_rcto_hia,105)
	left join cta_cte_mas_imp_aer ctm on left(cxa.num_proc_hia,14)=ctm.num_proc_mia and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hia <> ctm.dc_mia 
	left join caixa_mas_imp_aer cxm on left(cxa.num_proc_hia,14)=cxm.num_proc_mia and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hia <> cxm.dc_mia and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_mia,105)<=convert(datetime,cxa.dt_pgto_rcto_hia,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hia,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@DataFinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hia is null AND ctm.num_proc_mia is null)

UNION ALL

SELECT
	'N' Tipo,cxa.num_proc_hea, nome_tp_Tx, CXA.DC_hea, cxa.num_lcto, cxa.vlr_pgto_rcto_hea, 
	convert(datetime,cxa.Dt_Pgto_Rcto_hea,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_hea, cxm.Dt_Pgto_Rcto_mea 
FROM
	caixa_hou_exp_aer cxa
	left join cta_cte_hou_exp_aer cto on cxa.num_proc_hea=cto.num_proc_hea and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hea <> cto.dc_hea 
	left join caixa_hou_exp_aer cxo on cxa.num_proc_hea=cxo.num_proc_hea and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hea <> cxo.dc_hea and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hea,105)<=convert(datetime,cxa.dt_pgto_rcto_hea,105)
	left join cta_cte_mas_exp_aer ctm on left(cxa.num_proc_hea,14)=ctm.num_proc_mea and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hea <> ctm.dc_mea 
	left join caixa_mas_exp_aer cxm on left(cxa.num_proc_hea,14)=cxm.num_proc_mea and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hea <> cxm.dc_mea and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_mea,105)<=convert(datetime,cxa.dt_pgto_rcto_hea,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hea,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hea is null AND ctm.num_proc_mea is null)

UNION

SELECT
	'N' Tipo,cxa.num_proc_him, nome_tp_Tx, CXA.DC_him, cxa.num_lcto, cxa.vlr_pgto_rcto_him, 
	convert(datetime,cxa.Dt_Pgto_Rcto_him,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_him, cxm.Dt_Pgto_Rcto_MIM 
FROM
	caixa_hou_imp_mar cxa
	left join CTA_CTE_hou_imp_mar cTo on cxa.num_proc_him=cTo.num_proc_him and cxa.cd_tp_tx=cTo.cd_tp_tx and cxa.dc_him <> cTo.dc_him 
	left join caixa_hou_imp_mar cxo on cxa.num_proc_him=cxo.num_proc_him and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_him <> cxo.dc_him and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_him,105)<=convert(Datetime,cxa.dt_pgto_rcto_him,105)
	left join cta_cte_mas_imp_mar ctm on left(cxa.num_proc_him,14)=ctm.num_proc_MIM and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_him <> ctm.dc_MIM 
	left join caixa_mas_imp_mar cxm on left(cxa.num_proc_him,14)=cxm.num_proc_MIM and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_him <> cxm.dc_MIM and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_MIM,105)<=convert(datetime,cxa.dt_pgto_rcto_him,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_him,105) between convert(datetime,@DataInicial,105) and
	convert(datetime,@datafinal,105) and  CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_him is null AND ctm.num_proc_mim is null)

UNION ALL

SELECT
	'N' Tipo,cxa.num_proc_hem, nome_tp_Tx, CXA.DC_hem, cxa.num_lcto, cxa.vlr_pgto_rcto_hem, 
	convert(datetime,cxa.Dt_Pgto_Rcto_hem,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_hem, cxm.Dt_Pgto_Rcto_mem 
FROM
	caixa_hou_exp_mar cxa
	left join cta_cte_hou_exp_mar cto on cxa.num_proc_hem=cto.num_proc_hem and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_hem <> cto.dc_hem 
	left join caixa_hou_exp_mar cxo on cxa.num_proc_hem=cxo.num_proc_hem and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_hem <> cxo.dc_hem and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_hem,105)<=convert(datetime,cxa.dt_pgto_rcto_hem,105)
	left join cta_cte_mas_exp_mar ctm on left(cxa.num_proc_hem,14)=ctm.num_proc_mem and cxa.cd_tp_tx=ctm.cd_tp_tx and cxa.dc_hem <> ctm.dc_mem 
	left join caixa_mas_exp_mar cxm on left(cxa.num_proc_hem,14)=cxm.num_proc_mem and cxa.cd_tp_tx=cxm.cd_tp_tx and cxa.dc_hem <> cxm.dc_mem and cxm.num_lcto<>'PROVISÓRIO' and convert(datetime,cxm.dt_pgto_rcto_mem,105)<=convert(Datetime,cxa.dt_pgto_rcto_hem,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_hem,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_hem is null AND ctm.num_proc_mem is null)

UNION

SELECT
	'N' Tipo,cxa.num_proc_Mia, nome_tp_Tx, CXA.DC_MIA, cxa.num_lcto, cxa.vlr_pgto_rcto_Mia, 
	convert(Datetime,cxa.Dt_Pgto_Rcto_MIA,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MIA, cxH.Dt_Pgto_Rcto_HIA 
FROM
	caixa_MAS_imp_aer cxa
	left join cta_cte_MAS_imp_aer cto on cxa.num_proc_Mia=cto.num_proc_Mia and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_Mia <> cto.dc_Mia 
	left join caixa_MAS_imp_aer cxo on cxa.num_proc_Mia=cxo.num_proc_Mia and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_Mia <> cxo.dc_Mia and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_Mia,105)<=convert(datetime,cxa.dt_pgto_rcto_Mia,105)
	left join cta_cte_HOU_imp_aer ctH on cxa.num_proc_Mia=LEFT(ctH.num_proc_Hia,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_Mia <> ctH.dc_Hia 
	left join caixa_HOU_imp_aer cxH on cxa.num_proc_Mia=LEFT(cxH.num_proc_Hia,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_Mia <> cxH.dc_Hia and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_Hia,105)<=convert(datetime,cxa.dt_pgto_rcto_Mia,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_Mia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_mia is null AND cth.num_proc_hia is null)


UNION

SELECT
	'N' Tipo,cxa.num_proc_mea, nome_tp_Tx, CXA.DC_mea, cxa.num_lcto, cxa.vlr_pgto_rcto_mea, 
	convert(Datetime,cxa.Dt_Pgto_Rcto_mea,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_mea, cxH.Dt_Pgto_Rcto_hea 
FROM
	caixa_MAS_exp_aer cxa
	left join cta_cte_MAS_exp_aer cto on cxa.num_proc_mea=cto.num_proc_mea and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_mea <> cto.dc_mea 
	left join caixa_MAS_exp_aer cxo on cxa.num_proc_mea=cxo.num_proc_mea and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_mea <> cxo.dc_mea and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_mea,105)<=convert(datetime,cxa.dt_pgto_rcto_mea,105)
	left join cta_cte_HOU_exp_aer ctH on cxa.num_proc_mea=LEFT(ctH.num_proc_hea,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_mea <> ctH.dc_hea 
	left join caixa_HOU_exp_aer cxH on cxa.num_proc_mea=LEFT(cxH.num_proc_hea,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_mea <> cxH.dc_hea and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_hea,105)<=convert(datetime,cxa.dt_pgto_rcto_mea,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_mea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_mea is null AND cth.num_proc_hea is null)


UNION

SELECT
	'N' Tipo,cxa.num_proc_MIM, nome_tp_Tx, CXA.DC_MIM, cxa.num_lcto, cxa.vlr_pgto_rcto_MIM, 
	convert(datetime,cxa.Dt_Pgto_Rcto_MIM,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MIM, cxH.Dt_Pgto_Rcto_HIM 
FROM
	caixa_MAS_imp_MAR cxa
	left join cta_cte_MAS_imp_MAR cto on cxa.num_proc_MIM=cto.num_proc_MIM and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_MIM <> cto.dc_MIM 
	left join caixa_MAS_imp_MAR cxo on cxa.num_proc_MIM=cxo.num_proc_MIM and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_MIM <> cxo.dc_MIM and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_MIM,105)<=convert(datetime,cxa.dt_pgto_rcto_MIM,105)
	left join cta_cte_HOU_imp_MAR ctH on cxa.num_proc_MIM=LEFT(ctH.num_proc_HIM,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_MIM <> ctH.dc_HIM 
	left join caixa_HOU_imp_MAR cxH on cxa.num_proc_MIM=LEFT(cxH.num_proc_HIM,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_MIM <> cxH.dc_HIM and cxH.num_lcto<>'PROVISÓRIO' and convert(Datetime,cxH.dt_pgto_rcto_HIM,105)<=convert(datetime,cxa.dt_pgto_rcto_MIM,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_MIM,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_MIM is  null AND cth.num_proc_HIM is null)


UNION

SELECT
	'N' Tipo,cxa.num_proc_MEM, nome_tp_Tx, CXA.DC_MEM, cxa.num_lcto, cxa.vlr_pgto_rcto_MEM, 
	convert(datetime,cxa.Dt_Pgto_Rcto_MEM,105) Dt_Pgto_Rcto_HIA, cxo.Dt_Pgto_Rcto_MEM, cxH.Dt_Pgto_Rcto_HEM 
FROM
	caixa_MAS_exp_MAR cxa
	left join cta_cte_MAS_exp_MAR cto on cxa.num_proc_MEM=cto.num_proc_MEM and cxa.cd_tp_tx=cto.cd_tp_tx and cxa.dc_MEM <> cto.dc_MEM 
	left join caixa_MAS_exp_MAR cxo on cxa.num_proc_MEM=cxo.num_proc_MEM and cxa.cd_tp_tx=cxo.cd_tp_tx and cxa.dc_MEM <> cxo.dc_MEM and cxo.num_lcto<>'PROVISÓRIO' and convert(datetime,cxo.dt_pgto_rcto_MEM,105)<=convert(datetime,cxa.dt_pgto_rcto_MEM,105)
	left join cta_cte_HOU_exp_MAR ctH on cxa.num_proc_MEM=LEFT(ctH.num_proc_HEM,14) and cxa.cd_tp_tx=ctH.cd_tp_tx and cxa.dc_MEM <> ctH.dc_HEM 
	left join caixa_HOU_exp_MAR cxH on cxa.num_proc_MEM=LEFT(cxH.num_proc_HEM,14) and cxa.cd_tp_tx=cxH.cd_tp_tx and cxa.dc_MEM <> cxH.dc_HEM and cxH.num_lcto<>'PROVISÓRIO' and convert(datetime,cxH.dt_pgto_rcto_HEM,105)<=convert(datetime,cxa.dt_pgto_rcto_MEM,105)
	JOIN Tipo_taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
WHERE 
	convert(datetime,cxa.dt_pgto_rcto_MEM,105) between convert(datetime,@datainicial,105)
	and convert(datetime,@datafinal,105)  AND CXA.NUM_LCTO <> 'PROVISÓRIO'
	and (cto.num_proc_MEM is null AND cth.num_proc_HEM is null)





GO
