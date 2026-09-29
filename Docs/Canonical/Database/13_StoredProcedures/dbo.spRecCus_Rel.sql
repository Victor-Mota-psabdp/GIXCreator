SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       PROCEDURE [dbo].[spRecCus_Rel] 	
			(
			   @DataInicial	Varchar(10),
			   @DataFinal   Varchar(10)
			)
as



select 
	Cta.Num_proc_hia Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_hia, CTA.vlr_org_hia, 
	isnull(Vlr_pgto_rcto_hia,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1') PG_AJ, Nome_tp_tx
	   
from 
	cta_ctE_hou_imp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_hia,105) and PAR.cd_tp_par='IMA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_hia,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_hia='N' and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hia,5) <> 'IAJOB' and 	
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	Cta.Num_proc_mia Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_mia, CTA.vlr_org_mia, 
	isnull(Vlr_pgto_rcto_mia,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal, isnull(PGA.num_lcto,'1'),Nome_tp_tx      
from 
	cta_ctE_mas_imp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mia,105) and PAR.cd_tp_par='IMA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_mia,105)  and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mia=CXA.dc_mia and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_mia='N' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'


UNION ALL

select 
	Cta.Num_proc_hea Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_hea, CTA.vlr_org_hea, 
	isnull(Vlr_pgto_rcto_hea,0) PG, isnull(OFC.par_moeda,0) Oficial, ISNULL(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1'),Nome_tp_tx      
from 
	cta_ctE_hou_exp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_hea,105) and PAR.cd_tp_par='EXA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_hea,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_hea='N' and convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hea,5) <> 'EAJOB' and 	
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'



UNION ALL



select 
	Cta.Num_proc_mea Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_mea, CTA.vlr_org_mea, 
	isnull(Vlr_pgto_rcto_mea,0) PG, isnull(OFC.par_moeda,0) Oficial, IsNull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1'),Nome_tp_Tx   
from 
	cta_ctE_mas_exp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mea,105) and PAR.cd_tp_par='EXA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_mea,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mea=CXA.dc_mea and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_mea='N' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'


union all


select 
	Cta.Num_proc_HIM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_HIM, CTA.vlr_org_HIM, 
	isnull(Vlr_pgto_rcto_HIM,0) PG, isnull(OFC.par_moeda,0) Oficial, IsNull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1'),Nome_tp_Tx   
from 
	cta_ctE_hou_imp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_HIM,105) and PAR.cd_tp_par='IMM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and converT(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_HIM,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_HIM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_HIM='N' and convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_HIM,5) <> 'IMJOB' and 	
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	Cta.Num_proc_MIM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_MIM, CTA.vlr_org_MIM, 
	isnull(Vlr_pgto_rcto_MIM,0) PG, isnull(OFC.par_moeda,0) Oficial, IsNull(PAR.par_moeda,0) Par_Modal, isnull(PGA.num_lcto,'1'),Nome_tp_Tx      
from 
	cta_ctE_mas_imp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and convert(Datetime,PAR.dt_par,105)=convert(datetime,dt_ins_MIM,105) and PAR.cd_tp_par='IMM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_MIM,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_MIM=CXA.dc_MIM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MIM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_MIM='N' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	Cta.Num_proc_HEM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_HEM, CTA.vlr_org_HEM, 
	isnull(Vlr_pgto_rcto_HEM,0) PG, isnull(OFC.par_moeda,0) Oficial, IsNull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1'),Nome_tp_tx      
from 
	cta_ctE_hou_exp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and Convert(Datetime,PAR.dt_par,105)=Convert(DateTime,dt_ins_HEM,105) and PAR.cd_tp_par='EXM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and Convert(Datetime,OFC.dt_par,105)=Convert(Datetime,dt_ins_HEM,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_HEM=CXA.dc_HEM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_HEM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_HEM='N' and convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_HEM,5) <> 'EMJOB' and 	
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'


UNION ALL



select 
	Cta.Num_proc_MEM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_MEM, CTA.vlr_org_MEM, 
	isnull(Vlr_pgto_rcto_MEM,0) PG, isnull(OFC.par_moeda,0) Oficial, IsNull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1'),Nome_tp_tx
from 
	cta_ctE_mas_exp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and Convert(DateTime,PAR.dt_par,105)=Convert(Datetime,dt_ins_MEM,105) and PAR.cd_tp_par='EXM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and Convert(Datetime,OFC.dt_par,105)=Convert(Datetime,dt_ins_MEM,105) and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_exp_MAR CXA on CTA.num_proc_MEM=CXA.num_proc_MEM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_MEM=CXA.dc_MEM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MEM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_MEM='N' and convert(datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
and left(cta.cd_tp_tx,1) <> 'X'
UNION ALL

SELECT
	Cta.num_proc_hia, CTA.cd_tp_tx, 'REL', cta.dc_hia, vlr_pgto_nf_hia,
	0, 0,Par_nf_hia,'1',Nome_tp_tx
FROM
	Cta_ctE_hou_imp_aer CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
	Join Tipo_taxa tt on cta.cd_tp_tx=TT.cd_tp_tx
WHERE
	convert(datetime,dt_ins_hia,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_hia='C' and desp_org_hia='N'
and left(cta.cd_tp_tx,1) <> 'X'
UNION ALL



SELECT
	Cta.num_proc_him, CTA.cd_tp_tx, 'REL', cta.dc_him, vlr_pgto_nf_him,
	0, 0,Par_nf_him,'1',Nome_tp_tx
FROM
	Cta_ctE_hou_imp_mar CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_him and ref_acesso=ref_acesso_nf_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
WHERE
	convert(datetime,dt_ins_him,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_him='C' and desp_org_him='N'
and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL


SELECT
	Cta.num_proc_hea, CTA.cd_tp_tx, 'REL', cta.dc_hea, vlr_pgto_nf_hea,
	0, 0,Par_nf_hea,'1',Nome_tp_Tx
FROM
	Cta_ctE_hou_exp_aer CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_hea and ref_acesso=ref_acesso_nf_hea
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
WHERE
	convert(datetime,dt_ins_hea,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_hea='C' and desp_dst_hea='N'
and left(cta.cd_tp_tx,1) <> 'X'
UNION ALL



SELECT
	Cta.num_proc_hem, CTA.cd_tp_tx, 'REL', cta.dc_hem, vlr_pgto_nf_hem,
	0, 0,Par_nf_hem,'1',Nome_tp_tx
FROM
	Cta_ctE_hou_exp_mar CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_hem and ref_acesso=ref_acesso_nf_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
WHERE
	convert(datetime,dt_ins_hem,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_hem='C' and desp_dst_hem='N'
and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

SELECT
	Cta.num_proc_mia, CTA.cd_tp_tx, 'REL', cta.dc_mia, vlr_pgto_nf_mia,
	0, 0,Par_nf_mia,'1',Nome_tp_Tx
FROM
	Cta_ctE_mas_imp_aer CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_mia and ref_acesso=ref_acesso_nf_mia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx	
WHERE
	convert(datetime,dt_ins_mia,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_mia='C' and desp_org_mia='N'
and left(cta.cd_tp_tx,1) <> 'X'
UNION ALL



SELECT
	Cta.num_proc_mim, CTA.cd_tp_tx, 'REL', cta.dc_mim, vlr_pgto_nf_mim,
	0, 0,Par_nf_mim,'1',Nome_tp_tx
FROM
	Cta_ctE_mas_imp_mar CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_mim and ref_acesso=ref_acesso_nf_mim
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
WHERE
	convert(datetime,dt_ins_mim,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_mim='C' and desp_org_mim='N'
and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL


SELECT
	Cta.num_proc_mea, CTA.cd_tp_tx, 'REL', cta.dc_mea, vlr_pgto_nf_mea,
	0, 0,Par_nf_mea,'1',Nome_tp_tx
FROM
	Cta_ctE_mas_exp_aer CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_mea and ref_acesso=ref_acesso_nf_mea
	Join Tipo_taxa TT on TT.cd_tp_TX=cta.cd_tp_tx
WHERE
	convert(datetime,dt_ins_mea,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_mea='C' and desp_dst_mea='N'
and left(cta.cd_tp_tx,1) <> 'X'
UNION ALL



SELECT
	Cta.num_proc_mem, CTA.cd_tp_tx, 'REL', cta.dc_mem, vlr_pgto_nf_mem,
	0, 0,Par_nf_mem,'1',Nome_tp_tx
FROM
	Cta_ctE_mas_exp_mar CTA
	Left Join Base_notA_fiscal NF on Nf.notA_fiscal=num_nf_mem and ref_acesso=ref_acesso_nf_mem
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_Tx
WHERE
	convert(datetime,dt_ins_mem,105)<='12-31-2005' and emissao between @DataInicial and @DataFinal
	and dc_mem='C' and desp_dst_mem='N'
and left(cta.cd_tp_tx,1) <> 'X'









GO
