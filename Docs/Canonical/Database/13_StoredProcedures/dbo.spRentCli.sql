SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure spRentCli (
				@DataInicial Char(10),
				@DataFinal Char(10)
			)

as

--spRentCli '04-01-2006','06-30-2006'
--Itens em Reais

Select 
	Nome_tp_tx,Nome_local,'IA' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hia,dc_hia)) as Decimal(10,2)) Valor,'Hia REL' Det
from 
	House_imp_Aer HOU
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	CTA.cd_tp_moeda='REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_hia='N' and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
group by 
	apelido,Nome_tp_tx,Nome_local


UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'IA' Modal,Apelido, cast(sum(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia)) as Decimal(10,2)) Valor,'Hia CXA' Det 
from 
	House_imp_Aer HOU
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and month(convert(Datetime,dt_ins_hia,105))=month(convert(datetime,dt_pgto_rcto_hia,105)) and year(convert(datetime,dt_ins_hia,105))=year(convert(datetime,dt_pgto_rcto_hia,105)) and num_lcto <> 'PROVISÓRIO'
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_hia='N' and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	
group by 
	apelido,Nome_tp_tx, Nome_Local

UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'IA' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hia * Par_moeda,cta.dc_hia)) as Decimal(10,2)) Valor,'Hia Cta' Det 
from 
	House_imp_Aer HOU
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and month(convert(Datetime,dt_ins_hia,105))=month(convert(datetime,dt_pgto_rcto_hia,105)) and year(convert(datetime,dt_ins_hia,105))=year(convert(datetime,dt_pgto_rcto_hia,105)) and num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='IMA' and convert(Datetime,par.dt_par,105)=convert(Datetime,dt_ins_hia,105)
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Join Localidade DST on DST.cd_local=cd_Dst_hia
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_hia='N' and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
group by 
	apelido,Nome_tp_tx, Nome_Local


UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'IA' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hia * ofc.Par_moeda,cta.dc_hia)) as Decimal(10,2)) Valor,'Hia Cta Of' Det 
from 
	House_imp_Aer HOU
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and month(convert(Datetime,dt_ins_hia,105))=month(convert(datetime,dt_pgto_rcto_hia,105)) and year(convert(datetime,dt_ins_hia,105))=year(convert(datetime,dt_pgto_rcto_hia,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='IMA' and convert(Datetime,dt_ins_hia,105)=convert(Datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_hia,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_Tp_tx
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_hia='N' and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null
group by 
	apelido,Nome_tp_tx, Nome_Local


UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'IA' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hia * 1,cta.dc_hia)) as Decimal(10,2)) Valor,'Hia Cta Of' Det 
from 
	House_imp_Aer HOU
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and month(convert(Datetime,dt_ins_hia,105))=month(convert(datetime,dt_pgto_rcto_hia,105)) and year(convert(datetime,dt_ins_hia,105))=year(convert(datetime,dt_pgto_rcto_hia,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='IMA' and convert(Datetime,dt_ins_hia,105)=convert(Datetime,par.dt_par,105)
	LEFT Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_hia,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_Tp_tx
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_hia='N' and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null and ofc.par_moeda is null
group by 
	apelido,Nome_tp_tx, Nome_Local



UNION ALL


--RATEIO CTA_CTE MAS REAL
Select 
	Nome_tp_tx, Nome_Local,'IA',Apelido,sum(cast(dbo.valor(vlr_org_mia*dbo.sppar_mas(num_proc_hia),dc_mia) as Decimal(10,2))) Valor,'MIA REL' Det 
from 
	cta_cte_mas_imp_aer CTA
	Join House_imp_aer Hou on Hou.num_proc_mia=cta.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	Cta.cd_tp_moeda = 'REL' and desp_org_mia='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	
Group by Apelido,Nome_tp_tx, Nome_Local


Union ALL

Select 
	Nome_tp_tx, Nome_Local,'IA',Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_mia*dbo.sppar_mas(num_proc_hia),cta.dc_mia) as Decimal(10,2))) Valor, 'MIA CXA' Det 
from 
	cta_cte_mas_imp_aer CTA
	Join House_imp_aer Hou on Hou.num_proc_mia=cta.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local

union all


Select 
	Nome_tp_tx, Nome_Local,'IA',Apelido,sum(cast(dbo.valor(vlr_org_mia*PAr.Par_moeda*dbo.sppar_mas(num_proc_hia),cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA' Det 
from 
	cta_cte_mas_imp_aer CTA
	Join House_imp_aer Hou on Hou.num_proc_mia=cta.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='OFC' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'IA',Apelido,sum(cast(dbo.valor(vlr_org_mia*OFC.Par_moeda*dbo.sppar_mas(num_proc_hia),cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA OF' Det 
from 
	cta_cte_mas_imp_aer CTA
	Join House_imp_aer Hou on Hou.num_proc_mia=cta.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_ins_mia,105)=convert(datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local

union all

Select 
	Nome_tp_tx, Nome_Local,'IA',Apelido,sum(cast(dbo.valor(vlr_org_mia*dbo.sppar_mas(num_proc_hia),cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA OF' Det 
from 
	cta_cte_mas_imp_aer CTA
	Join House_imp_aer Hou on Hou.num_proc_mia=cta.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMA' and convert(datetime,dt_ins_mia,105)=convert(datetime,par.dt_par,105)
	LEFT Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_mia='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
	and ofc.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local




UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IA', Apelido,sum(cast(dbo.valor(vlr_org_mia/qtd_hawb_mia,dc_mia) as Decimal(10,2))) Valor,'MIA REL' Det
FROM
	ctA_cte_mas_imp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
	Join House_imp_aer HOU on HOU.num_proc_mia=CTa.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda='REL' and desp_org_mia='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION all

SELECT
	Nome_tp_tx, Nome_Local,'IA', Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_mia/qtd_hawb_mia,cta.dc_mia) as Decimal(10,2))) Valor,'MIA CXA' Det
FROM
	ctA_cte_mas_imp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
	Join House_imp_aer HOU on HOU.num_proc_mia=CTa.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Caixa_mas_imp_Aer CXA on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dC_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105))
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_mia='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IA', Apelido,sum(cast(dbo.valor(vlr_org_mia*par.par_moeda/qtd_hawb_mia,cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA' Det
FROM
	ctA_cte_mas_imp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
	Join House_imp_aer HOU on HOU.num_proc_mia=CTa.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	LEFT Join Caixa_mas_imp_Aer CXA on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dC_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105))
	Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_mia='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local	


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IA', Apelido,sum(cast(dbo.valor(vlr_org_mia*ofc.par_moeda/qtd_hawb_mia,cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA OFC' Det
FROM
	ctA_cte_mas_imp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
	Join House_imp_aer HOU on HOU.num_proc_mia=CTa.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	LEFT Join Caixa_mas_imp_Aer CXA on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dC_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mia,105)
	Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_mia='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION

SELECT
	Nome_tp_tx, Nome_Local,'IA', Apelido,sum(cast(dbo.valor(vlr_org_mia/qtd_hawb_mia,cta.dc_mia) as Decimal(10,2))) Valor,'MIA CTA OFC' Det
FROM
	ctA_cte_mas_imp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
	Join House_imp_aer HOU on HOU.num_proc_mia=CTa.num_proc_mia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	LEFT Join Caixa_mas_imp_Aer CXA on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dC_mia and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_rcto_mia,105)) and year(convert(datetime,dt_ins_mia,105))=year(convert(datetime,dt_pgto_rcto_mia,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mia,105)
	LEFT Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_mia,105)
	Join Localidade DST on DST.cd_local=cd_dst_hia
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_mia='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
	and ofc.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local


union all

--EXPORTACAO AEREA

Select 
	Nome_tp_tx, Nome_Local,'EA' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea) Apelido, cast(sum(dbo.valor(vlr_org_hea,dc_hea)) as Decimal(10,2)) Valor,'HEA REL' Det 
from 
	House_exp_Aer HOU
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Join Localidade DST on DST.cd_local=cd_org_hea
Where 
	CTA.cd_tp_moeda='REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hea='N' and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
group by 
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'EA' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea), cast(sum(dbo.valor(vlr_pgto_rcto_hea,cta.dc_hea)) as Decimal(10,2)) Valor,'HEA CXA' Det
from 
	House_exp_Aer HOU
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and month(convert(Datetime,dt_ins_hea,105))=month(convert(datetime,dt_pgto_rcto_hea,105)) and year(convert(datetime,dt_ins_hea,105))=year(convert(datetime,dt_pgto_rcto_hea,105)) and num_lcto <> 'PROVISÓRIO'
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade ORG on org.cd_local=cd_org_hea
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hea='N' and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	
group by 
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local

UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'EA' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea), cast(sum(dbo.valor(vlr_org_hea * Par_moeda,cta.dc_hea)) as Decimal(10,2)) Valor,'HEA CTA' Det
from 
	House_exp_Aer HOU
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and month(convert(Datetime,dt_ins_hea,105))=month(convert(datetime,dt_pgto_rcto_hea,105)) and year(convert(datetime,dt_ins_hea,105))=year(convert(datetime,dt_pgto_rcto_hea,105)) and num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='EXA' and convert(Datetime,par.dt_par,105)=convert(Datetime,dt_ins_hea,105)
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade ORG on ORG.cd_local=cd_org_hea
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hea='N' and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
group by 
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'EA' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea), cast(sum(dbo.valor(vlr_org_hea * ofc.Par_moeda,cta.dc_hea)) as Decimal(10,2)) Valor, 'HEA CTA OFC' DET 
from 
	House_exp_Aer HOU
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and month(convert(Datetime,dt_ins_hea,105))=month(convert(datetime,dt_pgto_rcto_hea,105)) and year(convert(datetime,dt_ins_hea,105))=year(convert(datetime,dt_pgto_rcto_hea,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='EXA' and convert(Datetime,dt_ins_hea,105)=convert(Datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_hea,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade ORG on Org.cd_local=cd_org_hea
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hea='N' and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null
group by 
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


union all

Select 
	Nome_tp_tx, Nome_Local,'EA' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea), cast(sum(dbo.valor(vlr_org_hea ,cta.dc_hea)) as Decimal(10,2)) Valor, 'HEA CTA OFC' DET 
from 
	House_exp_Aer HOU
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and month(convert(Datetime,dt_ins_hea,105))=month(convert(datetime,dt_pgto_rcto_hea,105)) and year(convert(datetime,dt_ins_hea,105))=year(convert(datetime,dt_pgto_rcto_hea,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='EXA' and convert(Datetime,dt_ins_hea,105)=convert(Datetime,par.dt_par,105)
	LEFT Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_hea,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade ORG on Org.cd_local=cd_org_hea
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hea='N' and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null
	and ofc.par_moeda is null
group by 
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local



UNION ALL


--RATEIO CTA_CTE MAS REAL
Select 
	Nome_tp_tx, Nome_Local,'EA',dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*dbo.sppar_mas(num_proc_hea),dc_mea) as Decimal(10,2))) Valor,'MEA REL' Det
from 
	cta_cte_mas_exp_aer CTA
	Join House_exp_aer Hou on Hou.num_proc_mea=cta.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Localidade ORG on org.cd_local=cd_org_hea
Where 
	Cta.cd_tp_moeda = 'REL' and DESP_DST_mea='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	
Group by dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


Union ALL

Select 
	Nome_tp_tx, Nome_Local,'EA',dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_pgto_rcto_mea*dbo.sppar_mas(num_proc_hea),cta.dc_mea) as Decimal(10,2))) Valor,'MEA CXA' Det 
from 
	cta_cte_mas_exp_aer CTA
	Join House_exp_aer Hou on Hou.num_proc_mea=cta.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Localidade ORG on ORg.cd_local=cd_org_hea
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mea='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


union all


Select 
	Nome_tp_tx, Nome_Local,'EA',dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*PAr.Par_moeda*dbo.sppar_mas(num_proc_hea),cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA'
from 
	cta_cte_mas_exp_aer CTA
	Join House_exp_aer Hou on Hou.num_proc_mea=cta.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='OFC' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_mea,105)
	Join Localidade ORG on Org.cd_local=cd_org_hea
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mea='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'EA',dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*OFC.Par_moeda*dbo.sppar_mas(num_proc_hea),cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA OFC' Det
from 
	cta_cte_mas_exp_aer CTA
	Join House_exp_aer Hou on Hou.num_proc_mea=cta.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXA' and convert(datetime,dt_ins_mea,105)=convert(datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_mea,105)
	Join Localidade Org on Org.cd_local=cd_org_hea
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mea='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local

UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'EA',dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*dbo.sppar_mas(num_proc_hea),cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA OFC' Det
from 
	cta_cte_mas_exp_aer CTA
	Join House_exp_aer Hou on Hou.num_proc_mea=cta.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXA' and convert(datetime,dt_ins_mea,105)=convert(datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_mea,105)
	Join Localidade Org on Org.cd_local=cd_org_hea
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mea='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
	AND OFC.PAR_MOEDA IS NULL
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local




UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EA', dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea/qtd_hawb_mea,dc_mea) as Decimal(10,2))) Valor,'MEA REL' 
FROM
	ctA_cte_mas_exp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
	Join House_exp_aer HOU on HOU.num_proc_mea=CTa.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Localidade Org on Org.cd_local=cd_org_hea
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda='REL' and DESP_DST_mea='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local	

UNION all

SELECT
	Nome_tp_tx, Nome_Local,'EA', dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_pgto_rcto_mea/qtd_hawb_mea,cta.dc_mea) as Decimal(10,2))) Valor,'MEA CXA'
FROM
	ctA_cte_mas_exp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
	Join House_exp_aer HOU on HOU.num_proc_mea=CTa.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dC_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105))	Join Localidade DST on DST.cd_local=cd_org_hea
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mea='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local	


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EA', dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*par.par_moeda/qtd_hawb_mea,cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA'
FROM
	ctA_cte_mas_exp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
	Join House_exp_aer HOU on HOU.num_proc_mea=CTa.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	LEFT Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dC_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105))
	Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mea,105)
	Join Localidade Org on Org.cd_local=cd_org_hea
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mea='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EA', dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea*ofc.par_moeda/qtd_hawb_mea,cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA OFC'
FROM
	ctA_cte_mas_exp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
	Join House_exp_aer HOU on HOU.num_proc_mea=CTa.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	LEFT Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dC_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mea,105)
	Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_mea,105)
	Join Localidade Org on Org.cd_local=cd_org_hea
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mea='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local	

UNION



SELECT
	Nome_tp_tx, Nome_Local,'EA', dbo.strGM_Grupo(Apelido,cd_consig_hea),sum(cast(dbo.valor(vlr_org_mea/qtd_hawb_mea,cta.dc_mea) as Decimal(10,2))) Valor,'MEA CTA OFC'
FROM
	ctA_cte_mas_exp_aer CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
	Join House_exp_aer HOU on HOU.num_proc_mea=CTa.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	LEFT Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dC_mea and month(convert(datetime,dt_ins_mea,105))=month(convert(datetime,dt_pgto_rcto_mea,105)) and year(convert(datetime,dt_ins_mea,105))=year(convert(datetime,dt_pgto_rcto_mea,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mea,105)
	LEFT Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_mea,105)
	Join Localidade Org on Org.cd_local=cd_org_hea
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mea='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
	AND OFC.PAR_MOEDA IS NULL
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea),Nome_tp_tx, Nome_Local	


union 

--IMPORTACAO MARITIMO

Select 
	Nome_tp_tx, Nome_Local,'IMR' Modal,Apelido, cast(sum(dbo.valor(vlr_org_HIM,dc_HIM)) as Decimal(10,2)) Valor,'HIM REL' Det
from 
	House_imp_MAR HOU
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cta.cd_tp_tx
	Join Localidade Org on Org.cd_local=cd_dst_him
Where 
	CTA.cd_tp_moeda='REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_HIM='N' and convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
group by 
	apelido,Nome_tp_tx, Nome_Local



UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'IMC' Modal,Apelido, cast(sum(dbo.valor(vlr_pgto_rcto_HIM,cta.dc_HIM)) as Decimal(10,2)) Valor,'HIM CXA' Det
from 
	House_imp_MAR HOU
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM and month(convert(Datetime,dt_ins_HIM,105))=month(convert(datetime,dt_pgto_rcto_HIM,105)) and year(convert(datetime,dt_ins_HIM,105))=year(convert(datetime,dt_pgto_rcto_HIM,105)) and num_lcto <> 'PROVISÓRIO'
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cta.cd_tp_tx
	Join Localidade DST on DSt.cd_local=cd_dst_him
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_HIM='N' and convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	
group by 
	apelido,Nome_tp_tx, Nome_Local

UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'IMP' Modal,Apelido, cast(sum(dbo.valor(vlr_org_HIM * Par_moeda,cta.dc_HIM)) as Decimal(10,2)) Valor, 'HIM CTA' Det
from 
	House_imp_MAR HOU
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM and month(convert(Datetime,dt_ins_HIM,105))=month(convert(datetime,dt_pgto_rcto_HIM,105)) and year(convert(datetime,dt_ins_HIM,105))=year(convert(datetime,dt_pgto_rcto_HIM,105)) and num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='IMM' and convert(Datetime,par.dt_par,105)=convert(Datetime,dt_ins_HIM,105)
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_HIM='N' and convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
group by 
	apelido,Nome_tp_tx, Nome_Local


UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'IMO' Modal,Apelido, cast(sum(dbo.valor(vlr_org_HIM * ofc.Par_moeda,cta.dc_HIM)) as Decimal(10,2)) Valor,'HIM CTA OFC' Det
from 
	House_imp_MAR HOU
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=HOU.num_proc_HIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM and month(convert(Datetime,dt_ins_HIM,105))=month(convert(datetime,dt_pgto_rcto_HIM,105)) and year(convert(datetime,dt_ins_HIM,105))=year(convert(datetime,dt_pgto_rcto_HIM,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='IMM' and convert(Datetime,dt_ins_HIM,105)=convert(Datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_HIM,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Localidade DST on DST.cd_local=cd_dst_him
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and desp_org_HIM='N' and convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null
group by 
	apelido,Nome_tp_tx, Nome_Local


UNION ALL


--RATEIO CTA_CTE MAS REAL
Select 
	Nome_tp_tx, Nome_Local,'IMM',Apelido,sum(cast(dbo.valor(vlr_org_MIM*dbo.sppar_mas(num_proc_HIM),dc_MIM) as Decimal(10,2))) Valor,'MIM REL' Det 
from 
	cta_cte_mas_imp_MAR CTA
	Join House_imp_MAR Hou on Hou.num_proc_MIM=cta.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Localidade Org on Org.cd_local=cd_dst_him
Where 
	Cta.cd_tp_moeda = 'REL' and desp_org_MIM='N'
	and rateio_tx='K' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	
Group by Apelido,Nome_tp_tx, Nome_Local


Union ALL



Select 
	Nome_tp_tx, Nome_Local,'IMM',Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_MIM*dbo.sppar_mas(num_proc_HIM),cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CXA' Det 
from 
	cta_cte_mas_imp_MAR CTA
	Join House_imp_MAR Hou on Hou.num_proc_MIM=cta.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_MIM=cxa.dc_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Localidade Dst on DST.cd_local=cd_dst_him
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_MIM='N'
	and rateio_tx='K' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local


union all


Select 
	Nome_tp_tx, Nome_Local,'IMM',Apelido,sum(cast(dbo.valor(vlr_org_MIM*PAr.Par_moeda*dbo.sppar_mas(num_proc_HIM),cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CTA' Det 
from 
	cta_cte_mas_imp_MAR CTA
	Join House_imp_MAR Hou on Hou.num_proc_MIM=cta.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_MIM=cxa.dc_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='OFC' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_MIM,105)
	Join Localidade DST on DST.cd_local=cd_dst_him
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_MIM='N'
	and rateio_tx='K' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'IMM',Apelido,sum(cast(dbo.valor(vlr_org_MIM*OFC.Par_moeda*dbo.sppar_mas(num_proc_HIM),cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CTA OFC' Det 
from 
	cta_cte_mas_imp_MAR CTA
	Join House_imp_MAR Hou on Hou.num_proc_MIM=cta.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_MIM=cxa.dc_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(datetime,dt_ins_MIM,105)=convert(datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_MIM,105)
	Join Localidade DST on DST.cd_local=cd_dst_him
Where 
	Cta.cd_tp_moeda <> 'REL' and desp_org_MIM='N'
	and rateio_tx='K' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IMM', Apelido,sum(cast(dbo.valor(vlr_org_MIM/qtd_hawb_MIM,dc_MIM) as Decimal(10,2))) Valor,'MIM REL' Det
FROM
	ctA_cte_mas_imp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_MAR mas on mas.num_proc_MIM=cta.num_proc_MIM
	Join House_imp_MAR HOU on HOU.num_proc_MIM=CTa.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Localidade Org on Org.cd_local=cd_dst_him
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda='REL' and desp_org_MIM='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION all

SELECT
	Nome_tp_tx, Nome_Local,'IMM', Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_MIM/qtd_hawb_MIM,cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CXA' Det
FROM
	ctA_cte_mas_imp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_MAR mas on mas.num_proc_MIM=cta.num_proc_MIM
	Join House_imp_MAR HOU on HOU.num_proc_MIM=CTa.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIM=cxa.dC_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105))
	Join Localidade DST on DST.cd_local=cd_dst_him
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_MIM='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IMM', Apelido,sum(cast(dbo.valor(vlr_org_MIM*par.par_moeda/qtd_hawb_MIM,cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CTA' Det
FROM
	ctA_cte_mas_imp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_MAR mas on mas.num_proc_MIM=cta.num_proc_MIM
	Join House_imp_MAR HOU on HOU.num_proc_MIM=CTa.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	LEFT Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIM=cxa.dC_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105))
	Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMM' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_MIM,105)
	Join Localidade DST on DST.cd_local=cd_dst_him
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_MIM='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local
	


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'IMM', Apelido,sum(cast(dbo.valor(vlr_org_MIM*ofc.par_moeda/qtd_hawb_MIM,cta.dc_MIM) as Decimal(10,2))) Valor,'MIM CTA OFC' Det
FROM
	ctA_cte_mas_imp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_imp_MAR mas on mas.num_proc_MIM=cta.num_proc_MIM
	Join House_imp_MAR HOU on HOU.num_proc_MIM=CTa.num_proc_MIM
	Join Pessoa PP on PP.cd_pes=cd_import_HIM
	LEFT Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIM=cxa.dC_MIM and month(convert(datetime,dt_ins_MIM,105))=month(convert(datetime,dt_pgto_rcto_MIM,105)) and year(convert(datetime,dt_ins_MIM,105))=year(convert(datetime,dt_pgto_rcto_MIM,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMM' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_MIM,105)
	Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_MIM,105)
	Join Localidade DST on DST.cd_local=cd_dst_him
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and desp_org_MIM='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION


Select 
	Nome_tp_tx, Nome_Local,'EM' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hem,dc_hem)) as Decimal(10,2)) Valor,'HEM REL' Det 
from 
	House_exp_MAR HOU
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_hem=HOU.num_proc_hem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Localidade Org on Org.cd_local=cd_org_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
Where 
	CTA.cd_tp_moeda='REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hem='N' and convert(Datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
group by 
	apelido,Nome_tp_tx, Nome_Local



UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'EM' Modal,Apelido, cast(sum(dbo.valor(vlr_pgto_rcto_hem,cta.dc_hem)) as Decimal(10,2)) Valor,'HEM CXA' Det
from 
	House_exp_MAR HOU
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_hem=HOU.num_proc_hem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Caixa_hou_exp_MAR CXA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hem=CXA.dc_hem and month(convert(Datetime,dt_ins_hem,105))=month(convert(datetime,dt_pgto_rcto_hem,105)) and year(convert(datetime,dt_ins_hem,105))=year(convert(datetime,dt_pgto_rcto_hem,105)) and num_lcto <> 'PROVISÓRIO'
	Join Tipo_taxa TT on TT.cd_tp_Tx=cta.cd_tp_tx
	Join Localidade Org on ORG.cd_local=cd_org_hem
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hem='N' and convert(Datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	
group by 
	apelido,Nome_tp_tx, Nome_Local


UNION ALL

Select 
	Nome_tp_tx, Nome_Local,'EM' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hem * Par_moeda,cta.dc_hem)) as Decimal(10,2)) Valor,'HEM CTA' Det
from 
	House_exp_MAR HOU
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_hem=HOU.num_proc_hem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hem=CXA.dc_hem and month(convert(Datetime,dt_ins_hem,105))=month(convert(datetime,dt_pgto_rcto_hem,105)) and year(convert(datetime,dt_ins_hem,105))=year(convert(datetime,dt_pgto_rcto_hem,105)) and num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='EXM' and convert(Datetime,par.dt_par,105)=convert(Datetime,dt_ins_hem,105)
	Join Localidade Org on Org.cd_local=cd_org_hem
	Join TIpo_taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hem='N' and convert(Datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
group by 
	apelido,Nome_tp_tx, Nome_Local



UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'EM' Modal,Apelido, cast(sum(dbo.valor(vlr_org_hem * ofc.Par_moeda,cta.dc_hem)) as Decimal(10,2)) Valor,'HEM CTA OFC' Det 
from 
	House_exp_MAR HOU
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_hem=HOU.num_proc_hem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hem=CXA.dc_hem and month(convert(Datetime,dt_ins_hem,105))=month(convert(datetime,dt_pgto_rcto_hem,105)) and year(convert(datetime,dt_ins_hem,105))=year(convert(datetime,dt_pgto_rcto_hem,105)) and num_lcto <> 'PROVISÓRIO'
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and par.cd_tp_par='EXM' and convert(Datetime,dt_ins_hem,105)=convert(Datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,dt_ins_hem,105)=convert(datetime,ofc.dt_par,105)
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Localidade Org on Org.cd_Local=cd_org_hem
Where 
	CTA.cd_tp_moeda<>'REL' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exC)
	and DESP_DST_hem='N' and convert(Datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and PAR.PAR_MOEDA is null
group by 
	apelido,Nome_tp_tx, Nome_Local



UNION ALL


--RATEIO CTA_CTE MAS REAL
Select 
	Nome_tp_tx, Nome_Local,'EM',Apelido,sum(cast(dbo.valor(vlr_org_mem*dbo.sppar_mas(num_proc_hem),dc_mem) as Decimal(10,2))) Valor,'MEM REL' Det 
from 
	cta_cte_mas_exp_MAR CTA
	Join House_exp_MAR Hou on Hou.num_proc_mem=cta.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Localidade Org on Org.cd_local=cd_org_hem
Where 
	Cta.cd_tp_moeda = 'REL' and DESP_DST_mem='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	
Group by Apelido,Nome_tp_tx, Nome_Local



Union ALL

Select 
	Nome_tp_tx, Nome_Local,'EM',Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_mem*dbo.sppar_mas(num_proc_hem),cta.dc_mem) as Decimal(10,2))) Valor,'MEM CXA' Det
from 
	cta_cte_mas_exp_MAR CTA
	Join House_exp_MAR Hou on Hou.num_proc_mem=cta.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Localidade Org on Org.cd_local=cd_org_hem
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mem='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local



union all


Select 
	Nome_tp_tx, Nome_Local,'EM',Apelido,sum(cast(dbo.valor(vlr_org_mem*PAr.Par_moeda*dbo.sppar_mas(num_proc_hem),cta.dc_mem) as Decimal(10,2))) Valor,'MEM CTA' Det
from 
	cta_cte_mas_exp_MAR CTA
	Join House_exp_MAR Hou on Hou.num_proc_mem=cta.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.cd_tp_par='OFC' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_mem,105)
	Join Localidade Org on Org.cd_local=cd_org_hem
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mem='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION ALL


Select 
	Nome_tp_tx, Nome_Local,'EM',Apelido,sum(cast(dbo.valor(vlr_org_mem*OFC.Par_moeda*dbo.sppar_mas(num_proc_hem),cta.dc_mem) as Decimal(10,2))) Valor,'MEM CTA OFC' Det
from 
	cta_cte_mas_exp_MAR CTA
	Join House_exp_MAR Hou on Hou.num_proc_mem=cta.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Tipo_taxa TT on TT.cd_tp_tx=CTa.cd_tp_Tx
	LEFT Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=CXa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105)) and cxa.num_lcto <> 'PROVISÓRIO'
	left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXM' and convert(datetime,dt_ins_mem,105)=convert(datetime,par.dt_par,105)
	Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and par.cd_tp_par='OFC' and convert(Datetime,OFC.dt_par,105)=convert(Datetime,dt_ins_mem,105)
	Join Localidade Org on org.cd_local=cd_org_hem
Where 
	Cta.cd_tp_moeda <> 'REL' and DESP_DST_mem='N'
	and rateio_tx='K' and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
	and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EM', Apelido,sum(cast(dbo.valor(vlr_org_mem/qtd_hawb_mem,dc_mem) as Decimal(10,2))) Valor,'MEM REL' Det
FROM
	ctA_cte_mas_exp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_MAR mas on mas.num_proc_mem=cta.num_proc_mem
	Join House_exp_MAR HOU on HOU.num_proc_mem=CTa.num_proc_mem
		Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Localidade Org on Org.cd_local=cd_org_hem
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda='REL' and DESP_DST_mem='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local


UNION all

SELECT
	Nome_tp_tx, Nome_Local,'EM', Apelido,sum(cast(dbo.valor(vlr_pgto_rcto_mem/qtd_hawb_mem,cta.dc_mem) as Decimal(10,2))) Valor, 'MEM CXA' Det
FROM
	ctA_cte_mas_exp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_MAR mas on mas.num_proc_mem=cta.num_proc_mem
	Join House_exp_MAR HOU on HOU.num_proc_mem=CTa.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dC_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105))
	Join Localidade Org on Org.cd_local=cd_org_hem
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mem='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EM', Apelido,sum(cast(dbo.valor(vlr_org_mem*par.par_moeda/qtd_hawb_mem,cta.dc_mem) as Decimal(10,2))) Valor,'MEM CTA' Det
FROM
	ctA_cte_mas_exp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_MAR mas on mas.num_proc_mem=cta.num_proc_mem
	Join House_exp_MAR HOU on HOU.num_proc_mem=CTa.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	LEFT Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dC_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105))
	Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='EXM' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mem,105)
	Join Localidade Org on Org.cd_local=cd_org_hem
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mem='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null
Group by
	Apelido,Nome_tp_tx, Nome_Local



UNION ALL

SELECT
	Nome_tp_tx, Nome_Local,'EM', Apelido,sum(cast(dbo.valor(vlr_org_mem*ofc.par_moeda/qtd_hawb_mem,cta.dc_mem) as Decimal(10,2))) Valor,'MEM CTA OFC' Det
FROM
	ctA_cte_mas_exp_MAR CTA
	Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Join Master_exp_MAR mas on mas.num_proc_mem=cta.num_proc_mem
	Join House_exp_MAR HOU on HOU.num_proc_mem=CTa.num_proc_mem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	LEFT Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dC_mem and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_rcto_mem,105)) and year(convert(datetime,dt_ins_mem,105))=year(convert(datetime,dt_pgto_rcto_mem,105))
	left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='EXM' and convert(datetime,par.dt_par,105)=convert(Datetime,dt_ins_mem,105)
	Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and ofc.cd_tp_par='OFC' and convert(datetime,ofc.dt_par,105)=converT(datetime,dt_ins_mem,105)
	Join Localidade org on org.cd_local=cd_org_hem
Where
	cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_moeda<>'REL' and DESP_DST_mem='N' and rateio_tx <> 'K'
	and convert(Datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and par.par_moeda is null
Group by
	Apelido,Nome_tp_tx, Nome_Local
	








GO
