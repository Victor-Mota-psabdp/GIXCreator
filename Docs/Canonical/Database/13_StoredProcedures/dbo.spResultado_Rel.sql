SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE         procedure spResultado_Rel --'03-01-2008','03-10-2008'
		(@DataInicial Char(10),
		@DataFinal Char(10)

)

as

Select 
	'IA' Modal, sum(dbo.valor(vlr_org_hia,DC_hia)) Valor,'HIA Real' Det
from 
	cta_cte_hou_imp_aer CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and desp_org_hia='N' and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hia,5) <> 'IAJOB'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL
--OUTROS IMP REAIS
Select 
	'IO' Modal, sum(dbo.valor(vlr_org_hiO,DC_hiO)) Valor,'HIO Real' Det
from 
	cta_cte_hou_imp_OUT CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and desp_org_hiO='N' and convert(datetime,dt_ins_hiO,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hiO,5) <> 'IOJOB' and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'IA' Modal, sum(dbo.valor(vlr_pgto_rcto_hia,cxa.dc_hia)) ,'Hia Cxa' Det
from 
	Caixa_hou_imp_Aer CXA
	JOIN Cta_ctE_hou_imp_aer CTA on CTA.num_proc_hia=CXA.num_proc_hia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hia,5) <> 'IAJOB' and left(cta.cd_tp_tx,1) <> 'X'


UNION ALL
--IMP OUTROS CAIXA
Select 
	'IO' Modal, sum(dbo.valor(vlr_pgto_rcto_hiO,cxa.dc_hiO)) ,'HIO Cxa' Det
from 
	Caixa_hou_imp_OUT CXA
	JOIN Cta_ctE_hou_imp_OUT CTA on CTA.num_proc_hiO=CXA.num_proc_hiO and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hiO=CXA.dc_hiO
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_hiO,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_hiO,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hiO,5) <> 'IAJOB' and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL



select 
	'IA' Modal, sum(dbo.valor(vlr_org_hia*isnull(par.par_moeda,ofc.par_moeda),cta.dc_hia)),'Hia Cta' Det
from 
	cta_ctE_hou_imp_aer CTA
	LEFT JOIN Caixa_hou_imp_aer CXA on CtA.num_proc_hia=CxA.num_proC_hia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_hia,105) and par.cd_tp_par='IMA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_hia,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_hia is null and cta.cd_tp_moeda <> 'REL' and desp_org_hia='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hia,5) <> 'IAJOB'	and left(cta.cd_tp_tx,1) <> 'X'

--IMP OUTROS TAXAS <> REL E SEM CAIXA
UNION ALL

select 
	'IO' Modal, sum(dbo.valor(vlr_org_hiO*isnull(par.par_moeda,ofc.par_moeda),cta.dc_hiO)),'Hia Cta' Det
from 
	cta_ctE_hou_imp_out CTA
	LEFT JOIN Caixa_hou_imp_out CXA on CtA.num_proc_hio=CxA.num_proC_hio and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_hio=CXA.dc_hio and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hio,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_hio,105) and par.cd_tp_par='IMA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_hio,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_hio is null and cta.cd_tp_moeda <> 'REL' and desp_org_hio='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_hio,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hio,5) <> 'IOJOB'	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'IA' Modal, sum(dbo.valor(vlr_org_mia,DC_mia)) Valor,'Mia REL' Det
from 
	cta_cte_mas_imp_aer CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and desp_org_mia='N' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'	

UNION ALL


Select 
	'IA' Modal, sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)), 'Mia CXA' DET
from 
	Caixa_mas_imp_Aer CXA
	JOIN Cta_ctE_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_mia=CXA.dc_mia
Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
	and convert(Datetime,dt_pgto_rcto_mia,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'		

UNION ALL

select 
	'IA' Modal, sum(dbo.valor(vlr_org_mia*isnull(par.par_moeda,ofc.par_moeda),cta.dc_mia)),'Mia Cta' Det 
from 
	cta_ctE_mas_imp_aer CTA
	LEFT JOIN Caixa_mas_imp_aer CXA on CtA.num_proc_mia=CxA.num_proC_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_mia=CXA.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mia,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and par.cd_tp_par='IMA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_mia,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_mia is null and cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X' 

UNION ALL



Select 
	'EA' Modal, sum(dbo.valor(vlr_org_HEA,DC_HEA)) Valor, 'HEA Rel' Det 
from 
	cta_cte_hou_EXP_aer CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and DESP_DST_HEA='N' and convert(datetime,dt_ins_HEA,105) between @DataInicial and @DataFinal
	And left(cta.num_proc_hea,5) <> 'EAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

--EXP OUTROS REL
Select 
	'EO' Modal, sum(dbo.valor(vlr_org_HEO,DC_HEO)) Valor, 'HEO Rel' Det 
from 
	cta_cte_hou_EXP_OUT CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and DESP_ORG_HEO='N' and convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	And left(cta.num_proc_heO,5) <> 'EOJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL



Select 
	'EA' Modal, sum(dbo.valor(vlr_pgto_rcto_HEA,cxa.dc_HEA)), 'Hea Cxa' Det 
from 
	Caixa_hou_EXP_Aer CXA
	JOIN Cta_ctE_hou_EXP_aer CTA on CTA.num_proc_HEA=CXA.num_proc_HEA and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_HEA=CXA.dc_HEA
Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_HEA,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_HEA,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hea,5) <> 'EAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

--EXP OUTROS CAIXA
Select 
	'EO' Modal, sum(dbo.valor(vlr_pgto_rcto_HEO,cxa.dc_HEO)), 'HEO Cxa' Det 
from 
	Caixa_hou_EXP_OUT CXA
	JOIN Cta_ctE_hou_EXP_OUT CTA on CTA.num_proc_HEO=CXA.num_proc_HEO and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_HEO=CXA.dc_HEO
Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_HEO,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_heO,5) <> 'EAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'


UNION ALL

select 
	'EA' Modal, sum(dbo.valor(vlr_org_HEA*isnull(par.par_moeda,ofc.par_moeda),cta.dc_HEA)),'Hea Cta' 
from 
	cta_ctE_hou_EXP_aer CTA
	LEFT JOIN Caixa_hou_EXP_aer CXA on CtA.num_proc_HEA=CxA.num_proC_HEA and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_HEA=CXA.dc_HEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEA,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_HEA,105) and par.cd_tp_par='EXA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_HEA,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_HEA is null and cta.cd_tp_moeda <> 'REL' and DESP_DST_HEA='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_HEA,105) between @DataInicial and @DataFinal
	And left(cta.num_proc_hea,5) <> 'EAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'	
		
UNION ALL

--EXP OUTROS 
select 
	'EO' Modal, sum(dbo.valor(vlr_org_HEO*isnull(par.par_moeda,ofc.par_moeda),cta.dc_HEO)),'HEO Cta' 
from 
	cta_ctE_hou_EXP_OUT CTA
	LEFT JOIN Caixa_hou_EXP_OUT CXA on CtA.num_proc_HEO=CxA.num_proC_HEO and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_HEO=CXA.dc_HEO and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEO,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_HEO,105) and par.cd_tp_par='EXA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_HEO,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_HEO is null and cta.cd_tp_moeda <> 'REL' and DESP_ORG_HEO='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	And left(cta.num_proc_heO,5) <> 'EOJOB'
	and left(cta.cd_tp_tx,1) <> 'X'	


UNION ALL

Select 
	'EA' Modal, sum(dbo.valor(vlr_org_MEA,DC_MEA)) Valor ,'Mea Rel' Det
from 
	cta_cte_mas_EXP_aer CTA
Where 
	cta.cd_tp_moeda='REL' and
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and DESP_DST_MEA='N' and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(num_proc_mea,5) <> 'EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'EA' Modal, sum(dbo.valor(vlr_pgto_rcto_MEA,cxa.dc_MEA)), 'Mea Cxa' Det 
from 
	Caixa_mas_EXP_Aer CXA
	JOIN Cta_ctE_mas_EXP_aer CTA on CTA.num_proc_MEA=CXA.num_proc_MEA and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_MEA=CXA.dc_MEA
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_MEA,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_mea,5) <> 'EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'EA' Modal, sum(dbo.valor(vlr_org_MEA*isnull(par.par_moeda,ofc.par_moeda),cta.dc_MEA)),'Mea Cta' Det
from 
	cta_ctE_mas_EXP_aer CTA
	LEFT JOIN Caixa_mas_EXP_aer CXA on CtA.num_proc_MEA=CxA.num_proC_MEA and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_MEA=CXA.dc_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEA,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_MEA,105) and par.cd_tp_par='EXA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_MEA,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_MEA is null and cta.cd_tp_moeda <> 'REL' and DESP_DST_MEA='N'
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	AND convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_mea,5) <> 'EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL


Select 
	'IM' Modal, sum(dbo.valor(vlr_org_HIM,DC_HIM)) Valor,'HIM REL' Det
from 
	cta_cte_hou_imp_MAR CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and desp_org_HIM='N' and convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_him,5) <> 'IMJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'IM' Modal, sum(dbo.valor(vlr_pgto_rcto_HIM,cxa.dc_HIM)),'HIM CXA' Det 
from 
	Caixa_hou_imp_MAR CXA
	JOIN Cta_ctE_hou_imp_MAR CTA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_HIM=CXA.dc_HIM
Where 
	cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
	and convert(Datetime,dt_pgto_rcto_HIM,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	And left(cta.num_proc_him,5) <> 'IMJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'IM' Modal, sum(dbo.valor(vlr_org_HIM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_HIM)), 'HIM CTA' Det
from 
	cta_ctE_hou_imp_MAR CTA
	LEFT JOIN Caixa_hou_imp_MAR CXA on CtA.num_proc_HIM=CxA.num_proC_HIM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_HIM=CXA.dc_HIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_HIM,105) and par.cd_tp_par='IMM'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_HIM,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_HIM is null and cta.cd_tp_moeda <> 'REL' and desp_org_HIM='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_him,5) <> 'IMJOB'
	and left(cta.cd_tp_tx,1) <> 'X'	
	
UNION ALL

Select 
	'IM' Modal, sum(dbo.valor(vlr_org_MIM,DC_MIM)) Valor,'MIM REL' Det
from 
	cta_cte_mas_imp_MAR CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and desp_org_MIM='N' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'IM' Modal, sum(dbo.valor(vlr_pgto_rcto_MIM,cxa.dc_MIM)), 'Mim CXA' Det 
from 
	Caixa_mas_imp_MAR CXA
	JOIN Cta_ctE_mas_imp_MAR CTA on CTA.num_proc_MIM=CXA.num_proc_MIM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_MIM=CXA.dc_MIM
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
	and convert(Datetime,dt_pgto_rcto_MIM,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'IM' Modal, sum(dbo.valor(vlr_org_MIM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_MIM)), 'Mim CTA' Det 
from 
	cta_ctE_mas_imp_MAR CTA
	LEFT JOIN Caixa_mas_imp_MAR CXA on CtA.num_proc_MIM=CxA.num_proC_MIM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_MIM=CXA.dc_MIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_MIM,105) and par.cd_tp_par='IMM'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_MIM,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_MIM is null and cta.cd_tp_moeda <> 'REL' and desp_org_MIM='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL



Select 
	'EM' Modal, sum(dbo.valor(vlr_org_HEM,DC_HEM)) Valor, 'HEM REL' Det
from 
	cta_cte_hou_EXP_MAR CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and DESP_DST_HEM='N' and convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hem,5) <> 'EMJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'EM' Modal, sum(dbo.valor(vlr_pgto_rcto_HEM,cxa.dc_HEM)),'HEM CXA' Det 
from 
	Caixa_hou_EXP_MAR CXA
	JOIN Cta_ctE_hou_EXP_MAR CTA on CTA.num_proc_HEM=CXA.num_proc_HEM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_HEM=CXA.dc_HEM
Where 
	cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
	and convert(Datetime,dt_pgto_rcto_HEM,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hem,5) <> 'EMJOB'
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'EM' Modal, sum(dbo.valor(vlr_org_HEM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_HEM)) ,'HEM CTA' Det
from 
	cta_ctE_hou_EXP_MAR CTA
	LEFT JOIN Caixa_hou_EXP_MAR CXA on CtA.num_proc_HEM=CxA.num_proC_HEM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_HEM=CXA.dc_HEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_HEM,105) and par.cd_tp_par='EXM'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_HEM,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_HEM is null and cta.cd_tp_moeda <> 'REL' and DESP_DST_HEM='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hem,5) <> 'EMJOB'	
	and left(cta.cd_tp_tx,1) <> 'X'		

UNION ALL

Select 
	'EM' Modal, sum(dbo.valor(vlr_org_MEM,DC_MEM)) Valor, 'MEM REL' DEt
from 
	cta_cte_mas_EXP_MAR CTA
Where 
	cta.cd_tp_moeda='REL' and
	cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
	and DESP_DST_MEM='N' and convert(datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

Select 
	'EM' Modal, sum(dbo.valor(vlr_pgto_rcto_MEM,cxa.dc_MEM)), 'MEM CXA' Det
from 
	Caixa_mas_EXP_MAR CXA
	JOIN Cta_ctE_mas_EXP_MAR CTA on CTA.num_proc_MEM=CXA.num_proc_MEM and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_MEM=CXA.dc_MEM
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	
	and convert(Datetime,dt_pgto_rcto_MEM,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'EM' Modal, sum(dbo.valor(vlr_org_MEM*isnull(par.par_moeda,ofc.par_moeda),cta.dc_MEM)), 'MEM CTA' Det
from 
	cta_ctE_mas_EXP_MAR CTA
	LEFT JOIN Caixa_mas_EXP_MAR CXA on CtA.num_proc_MEM=CxA.num_proC_MEM and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_MEM=CXA.dc_MEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_MEM,105) and par.cd_tp_par='EXM'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_MEM,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_MEM is null and cta.cd_tp_moeda <> 'REL' and DESP_DST_MEM='N'
	and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
	AND convert(datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and left(cta.cd_tp_tx,1) <> 'X'		

UNION ALL

SELECT 
	'IA' Modal, sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,'HIA NF' Det 
From 
	Cta_CtE_hou_imp_aer 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_hia and ref_Acesso=ref_acesso_nf_hia
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_hia,105) <='12-31-2005' 
	AND DESP_ORG_HIA='N'

UNION ALL

SELECT 
	'IA' Modal, sum(dbo.valor(vlr_pgto_nf_Mia,dc_Mia)) Valor,'MIA NF' Det 
From 
	Cta_CtE_mas_imp_aer 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_mia and ref_Acesso=ref_acesso_nf_mia
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_mia,105) <='12-31-2005' 
	AND DESP_ORG_MIA='N'

UNION ALL

SELECT 
	'EA' Modal, sum(dbo.valor(vlr_pgto_nf_hea,dc_hea)) Valor, 'HEA NF' Det 
From 
	Cta_CtE_hou_exp_aer 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_hea and ref_Acesso=ref_acesso_nf_hea
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_hea,105) <='12-31-2005' 
	AND DESP_DST_HEA='N'

UNION ALL

SELECT 
	'EA' Modal, sum(dbo.valor(vlr_pgto_nf_mea,dc_mea)) Valor, 'MEA NF' Det 
From 
	Cta_CtE_mas_exp_aer 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_mea and ref_Acesso=ref_acesso_nf_mea
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_mea,105) <='12-31-2005' 
	AND DESP_DST_MEA='N'

union all


SELECT 
	'IM' Modal, sum(dbo.valor(vlr_pgto_nf_HIM,dc_HIM)) Valor, 'Him NF' Det 
From 
	Cta_CtE_hou_imp_MAR 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_HIM and ref_Acesso=ref_acesso_nf_HIM
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_HIM,105) <='12-31-2005' 
	AND DESP_ORG_HIM='N'


UNION ALL

SELECT 
	'IM' Modal, sum(dbo.valor(vlr_pgto_nf_MIM,dc_MIM)) Valor,'Mim NF' Det
From 
	Cta_CtE_mas_imp_MAR 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_MIM and ref_Acesso=ref_acesso_nf_MIM
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_MIM,105) <='12-31-2005' 
	and desp_org_mim='N' 
	
UNION ALL

SELECT 
	'EM' Modal, sum(dbo.valor(vlr_pgto_nf_HEM,dc_HEM)) Valor, 'HEM NF' Det
From 
	Cta_CtE_hou_exp_MAR 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_HEM and ref_Acesso=ref_acesso_nf_HEM
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_HEM,105) <='12-31-2005' 
	and desp_dst_hem='N'

UNION ALL

SELECT 
	'EM' Modal, sum(dbo.valor(vlr_pgto_nf_MEM,dc_MEM)) Valor,'MEM NF' Det 
From 
	Cta_CtE_mas_exp_MAR 
	Join Base_nota_fiscal NF on NF.nota_fiscal=Num_nf_MEM and ref_Acesso=ref_acesso_nf_MEM
Where
	emissao between @DataInicial and @DataFinal and convert(Datetime,dt_ins_MEM,105) <='12-31-2005' 
	AND DESP_DST_MEM='N'


UNION 


Select 
	'CH' Modal, sum(dbo.valor(vlr_pgto_rcto_MEA,cxa.dc_MEA)), 'Mea Cxa' Det 
from 
	Caixa_mas_EXP_Aer CXA
	JOIN Cta_ctE_mas_EXP_aer CTA on CTA.num_proc_MEA=CXA.num_proc_MEA and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_MEA=CXA.dc_MEA
	Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' 
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and convert(Datetime,dt_pgto_rcto_MEA,105) between @DataInicial and @DataFinal 
	and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_mea,5)  = 'EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION ALL

select 
	'CH' Modal, sum(dbo.valor(vlr_org_MEA*isnull(par.par_moeda,ofc.par_moeda),cta.dc_MEA)),'Mea Cta' Det
from 
	cta_ctE_mas_EXP_aer CTA
	LEFT JOIN Caixa_mas_EXP_aer CXA on CtA.num_proc_MEA=CxA.num_proC_MEA and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_MEA=CXA.dc_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEA,105)<=@DataFinal
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,cta.dt_ins_MEA,105) and par.cd_tp_par='EXA'
	left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,cta.dt_ins_MEA,105) and OFC.cd_tp_par='OFC'
Where 
	cxa.num_proc_MEA is null and cta.cd_tp_moeda <> 'REL' and DESP_DST_MEA='N'
	and (cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	AND convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_mea,5)  = 'EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'

UNION all


Select 
	'CH' Modal, sum(dbo.valor(vlr_org_MEA,DC_MEA)) Valor ,'Mea Rel' Det
from 
	cta_cte_mas_EXP_aer CTA
Where 
	cta.cd_tp_moeda='REL' and
	(cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) AND cta.cd_tp_tx not IN (SELECT CD_TP_TX FROM TIPO_TAXA WHERE LEFT(CD_TP_TX,1)='£' OR CD_TP_TX IN ('DS1','DS2','DS3','DS4')))
	and DESP_DST_MEA='N' and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and left(num_proc_mea,5) ='EASSZ'	
	and left(cta.cd_tp_tx,1) <> 'X'







GO
