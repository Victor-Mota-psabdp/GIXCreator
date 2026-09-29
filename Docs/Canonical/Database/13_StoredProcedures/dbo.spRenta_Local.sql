SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spRenta_Local --spRenta_Local '06-01-2006','06-30-2006'
		(
			@DataInicial Char(10),
			@DataFinal Char(10)
		)
as


-- Caixa Importação Aérea

Select 
	'HIA' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia) as Decimal(10,2))) Valor 
from 
	House_imp_aer HOU
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_Aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_ORG_HIA='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'HIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIA*PAr_Moeda,cta.dc_hia) as Decimal(10,2))) Valor 
from 
	House_imp_aer HOU
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_Aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	LEFT Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_hia,105)
Where 
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'HIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIA*OFC.PAr_Moeda,cta.dc_hia) as Decimal(10,2))) Valor 
from 
	House_imp_aer HOU
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_Aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	LEFT Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(Datetime,dt_ins_hia,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_hia,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'HIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIA,cta.dc_hia) as Decimal(10,2))) Valor 
from 
	House_imp_aer HOU
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_Aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
where 
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' AND DESP_ORG_HIA='N'
Group by 
	CIDADE_lOCAL



union all

-- Caixa Importação Aérea

Select 
	'MIA' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_MIA,cta.dc_MIA) as Decimal(10,2))) Valor 
from 
	MASTER_imp_aer MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_Aer CTA on CTA.num_proc_MIA=MAS.num_proc_MIA
	Join Caixa_MAS_imp_aer CXA on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.dc_MIA=cxa.dc_MIA and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIA,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_MIA,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_ORG_MIA='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'MIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIA*PAr_Moeda,cta.dc_MIA) as Decimal(10,2))) Valor 
from 
	MASTER_imp_aer MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_Aer CTA on CTA.num_proc_MIA=MAS.num_proc_MIA
	LEFT Join Caixa_MAS_imp_aer CXA on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.dc_MIA=cxa.dc_MIA and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIA,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_MIA,105)
Where 
	convert(Datetime,dt_ins_MIA,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'MIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIA*OFC.PAr_Moeda,cta.dc_MIA) as Decimal(10,2))) Valor 
from 
	MASTER_imp_aer MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_Aer CTA on CTA.num_proc_MIA=MAS.num_proc_MIA
	LEFT Join Caixa_MAS_imp_aer CXA on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.dc_MIA=cxa.dc_MIA and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIA,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(Datetime,dt_ins_MIA,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=OFC.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(Datetime,dt_ins_MIA,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_MIA,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'MIA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIA,cta.dc_MIA) as Decimal(10,2))) Valor 
from 
	MASTER_imp_aer MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_Aer CTA on CTA.num_proc_MIA=MAS.num_proc_MIA
where 
	convert(Datetime,dt_ins_MIA,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL


UNION ALL

-- Caixa exportação Aérea

Select 
	'EA' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_hea,cta.dc_hea) as Decimal(10,2))) Valor 
from 
	House_exp_aer HOU
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_Aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=cxa.num_proc_hea and cta.dc_hea=cxa.dc_hea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_DST_hea='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_hea*PAr_Moeda,cta.dc_hea) as Decimal(10,2))) Valor 
from 
	House_exp_aer HOU
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_Aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	LEFT Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=cxa.num_proc_hea and cta.dc_hea=cxa.dc_hea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_hea,105)
Where 
	convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_hea*OFC.PAr_Moeda,cta.dc_hea) as Decimal(10,2))) Valor 
from 
	House_exp_aer HOU
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_Aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	LEFT Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=cxa.num_proc_hea and cta.dc_hea=cxa.dc_hea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(Datetime,dt_ins_hea,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_hea,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_hea,cta.dc_hea) as Decimal(10,2))) Valor 
from 
	House_exp_aer HOU
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_Aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
where 
	convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL



union all

-- Caixa exportação Aérea

Select 
	'EA' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_mea,cta.dc_mea) as Decimal(10,2))) Valor 
from 
	MASTER_exp_aer MAS
	Join Localidade DST on DST.cd_local=cd_org_mea
	Join Cta_Cte_MAS_exp_Aer CTA on CTA.num_proc_mea=MAS.num_proc_mea
	Join Caixa_MAS_exp_aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.dc_mea=cxa.dc_mea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_mea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_DST_mea='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_mea*PAr_Moeda,cta.dc_mea) as Decimal(10,2))) Valor 
from 
	MASTER_exp_aer MAS
	Join Localidade DST on DST.cd_local=cd_org_mea
	Join Cta_Cte_MAS_exp_Aer CTA on CTA.num_proc_mea=MAS.num_proc_mea
	LEFT Join Caixa_MAS_exp_aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.dc_mea=cxa.dc_mea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_mea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_mea,105)
Where 
	convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_mea*OFC.PAr_Moeda,cta.dc_mea) as Decimal(10,2))) Valor 
from 
	MASTER_exp_aer MAS
	Join Localidade DST on DST.cd_local=cd_org_mea
	Join Cta_Cte_MAS_exp_Aer CTA on CTA.num_proc_mea=MAS.num_proc_mea
	LEFT Join Caixa_MAS_exp_aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.dc_mea=cxa.dc_mea and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_mea,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(Datetime,dt_ins_mea,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_mea,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'EA',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_mea,cta.dc_mea) as Decimal(10,2))) Valor 
from 
	MASTER_exp_aer MAS
	Join Localidade DST on DST.cd_local=cd_org_mea
	Join Cta_Cte_MAS_exp_Aer CTA on CTA.num_proc_mea=MAS.num_proc_mea
where 
	convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL

UNION ALL

-- Caixa Importação Aérea

Select 
	'IM' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_HIM,cta.dc_HIM) as Decimal(10,2))) Valor 
from 
	House_imp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.dc_HIM=cxa.dc_HIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_ORG_HIM='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIM*PAr_Moeda,cta.dc_HIM) as Decimal(10,2))) Valor 
from 
	House_imp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	LEFT Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.dc_HIM=cxa.dc_HIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_HIM,105)
Where 
	convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIM*OFC.PAr_Moeda,cta.dc_HIM) as Decimal(10,2))) Valor 
from 
	House_imp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	LEFT Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.dc_HIM=cxa.dc_HIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(Datetime,dt_ins_HIM,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_HIM,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HIM,cta.dc_HIM) as Decimal(10,2))) Valor 
from 
	House_imp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
where 
	convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL



union all

-- Caixa Importação Aérea

Select 
	'IM' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_MIM,cta.dc_MIM) as Decimal(10,2))) Valor 
from 
	MASTER_imp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA on CTA.num_proc_MIM=MAS.num_proc_MIM
	Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.dc_MIM=cxa.dc_MIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_ORG_MIM='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIM*PAr_Moeda,cta.dc_MIM) as Decimal(10,2))) Valor 
from 
	MASTER_imp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA on CTA.num_proc_MIM=MAS.num_proc_MIM
	LEFT Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.dc_MIM=cxa.dc_MIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_MIM,105)
Where 
	convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIM*OFC.PAr_Moeda,cta.dc_MIM) as Decimal(10,2))) Valor 
from 
	MASTER_imp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA on CTA.num_proc_MIM=MAS.num_proc_MIM
	LEFT Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.dc_MIM=cxa.dc_MIM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(Datetime,dt_ins_MIM,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_MIM,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'IM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MIM,cta.dc_MIM) as Decimal(10,2))) Valor 
from 
	MASTER_imp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA on CTA.num_proc_MIM=MAS.num_proc_MIM
where 
	convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL


UNION ALL

-- Caixa exportação Aérea

Select 
	'EM' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_HEM,cta.dc_HEM) as Decimal(10,2))) Valor 
from 
	House_exp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_org_HEM
	Join Cta_Cte_hou_exp_MAR CTA on CTA.num_proc_HEM=HOU.num_proc_HEM
	Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.dc_HEM=cxa.dc_HEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_DST_HEM='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HEM*PAr_Moeda,cta.dc_HEM) as Decimal(10,2))) Valor 
from 
	House_exp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_org_HEM
	Join Cta_Cte_hou_exp_MAR CTA on CTA.num_proc_HEM=HOU.num_proc_HEM
	LEFT Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.dc_HEM=cxa.dc_HEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='EXM' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_HEM,105)
Where 
	convert(Datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HEM*OFC.PAr_Moeda,cta.dc_HEM) as Decimal(10,2))) Valor 
from 
	House_exp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_org_HEM
	Join Cta_Cte_hou_exp_MAR CTA on CTA.num_proc_HEM=HOU.num_proc_HEM
	LEFT Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.dc_HEM=cxa.dc_HEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXM' and convert(Datetime,dt_ins_HEM,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_HEM,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_HEM,cta.dc_HEM) as Decimal(10,2))) Valor 
from 
	House_exp_MAR HOU
	Join Localidade DST on DST.cd_local=cd_org_HEM
	Join Cta_Cte_hou_exp_MAR CTA on CTA.num_proc_HEM=HOU.num_proc_HEM
where 
	convert(Datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL



union all

-- Caixa exportação Aérea

Select 
	'EM' Modal,cIDADE_lOCAL,Sum(cast(dbo.valor(vlr_pgto_rcto_MEM,cta.dc_MEM) as Decimal(10,2))) Valor 
from 
	MASTER_exp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_org_MEM
	Join Cta_Cte_MAS_exp_MAR CTA on CTA.num_proc_MEM=MAS.num_proc_MEM
	Join Caixa_MAS_exp_MAR CXA on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.dc_MEM=cxa.dc_MEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
Where 
	convert(Datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) AND DESP_DST_MEM='N' AND CTA.CD_TP_MOEDA <> 'REL'
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Paridade Modal

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MEM*PAr_Moeda,cta.dc_MEM) as Decimal(10,2))) Valor 
from 
	MASTER_exp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_org_MEM
	Join Cta_Cte_MAS_exp_MAR CTA on CTA.num_proc_MEM=MAS.num_proc_MEM
	LEFT Join Caixa_MAS_exp_MAR CXA on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.dc_MEM=cxa.dc_MEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	JOIN PARIDADE PAR ON PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='EXM' and convert(datetime,dt_par,105)=convert(Datetime,dt_ins_MEM,105)
Where 
	convert(Datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

--Conta Corrente Oficial

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MEM*OFC.PAr_Moeda,cta.dc_MEM) as Decimal(10,2))) Valor 
from 
	MASTER_exp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_org_MEM
	Join Cta_Cte_MAS_exp_MAR CTA on CTA.num_proc_MEM=MAS.num_proc_MEM
	LEFT Join Caixa_MAS_exp_MAR CXA on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.dc_MEM=cxa.dc_MEM and cta.cd_tp_Tx=cxa.cd_tp_Tx and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataFinal and num_lcto <> 'PROVISÓRIO'
	LEFT JOIN PARIDADE PAR ON CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXM' and convert(Datetime,dt_ins_MEM,105)=convert(datetime,PAR.dt_par,105)
	JOIN PARIDADE OFC  ON CTA.cd_tp_moeda=ofc.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(Datetime,dt_ins_MEM,105)=convert(datetime,OFC.dt_par,105)
Where 
	convert(Datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA <> 'REL' and par.par_moeda is null and cxa.num_lcto is null
Group by 
	CIDADE_lOCAL


UNION ALL

Select 
	'EM',cIDADE_lOCAL,Sum(cast(dbo.valor(VLR_ORG_MEM,cta.dc_MEM) as Decimal(10,2))) Valor 
from 
	MASTER_exp_MAR MAS
	Join Localidade DST on DST.cd_local=cd_org_MEM
	Join Cta_Cte_MAS_exp_MAR CTA on CTA.num_proc_MEM=MAS.num_proc_MEM
where 
	convert(Datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	AND CTA.CD_TP_MOEDA = 'REL' 
Group by 
	CIDADE_lOCAL




GO
