SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
--MZC,MZ2,AWD - AWB FEE
--CCV,CR1,CR2,CRR,XDR,XDS,XDY,XDZ - courier
--BLF,LBC.XAG,XLC - Liberacao de BL
--SIS,XAD

CREATE Procedure [dbo].[spVixFL_Rel]-- '2010-07-01', '2010-12-31'

	@DataInicial as datetime,
	@DataFinal as datetime

as

select 
	HOU.Num_proc_hia Processo, EXPT.Apelido Exportador,IMP.Apelido Importador,
	HAWB_HIA,hou.Obs_Hia Handling, ATA_LIA DT_Chegada,CTA.cd_tp_tx Taxas, 
	dbo.FConverterMoeda(CTA.Cd_Tp_Moeda,'REL') * CTA.Vlr_ORG_HIA Valor 
from 
	house_imp_aer HOU
	join llp_imp_aer LLP on LLP.num_proc_lia = HOU.Num_proc_hia
	left outer join Master_imp_aer MAS on HOU.num_proc_mia = MAS.num_proc_mia
	left outer join job_imp_aer JOB on HOU.job_hia = JOB.Num_proc_hia
	left outer join Cta_Cte_hou_imp_aer CTA on HOU.Num_proc_hia = CTA. Num_proc_hia
	--join Caixa_hou_imp_aer CX on CTA.Num_proc_hia = CTA.Num_proc_hia
	left outer join pessoa IMP on hou.cd_import_hia = IMP.cd_pes
	left outer join pessoa EXPT on hou.cd_export_hia = EXPT.cd_pes
	--left outer join Tipo_taxa TT on CTA.Cd_tp_tx = TT.cd_tp_tx
where 
	CTA.Cd_tp_tx in ('PBD', 'DVC', 'PSA','DES','MZC','MZ2','AWD','CCV','CR1','CR2','CRR','XDR','XDS','XDY','XDZ','BLF','LBC','XAG','XLC','SIS','XAD') and CTA.DC_HIA = 'C' and HOU.Cd_dst_hia in ('VIX','GIG')  and JOB.CD_Vendedor = 'FL' and ATA_LIA between @DataInicial and @DataFinal
group by 
	HOU.Num_proc_hia,CTA.CD_tp_tx,CTA.Vlr_ORG_HIA,HAWB_HIA, ATA_LIA,hou.Obs_Hia,IMP.Apelido, EXPT.Apelido, dbo.FConverterMoeda(CTA.Cd_Tp_Moeda,'REL') * CTA.Vlr_ORG_HIA

union all

select 
	HOU.Num_proc_him Processo, EXPT.Apelido Exportador,IMP.Apelido Importador,
	HAWB_him,hou.Obs_Him Handling, ATA_LIM DT_Chegada,CTA.cd_tp_tx Taxas,
	dbo.FConverterMoeda(CTA.Cd_Tp_Moeda,'REL') * CTA.Vlr_ORG_HIM Valor 
from 
	house_imp_mar HOU
	join llp_imp_mar LLP on LLP.num_proc_lim = HOU.Num_proc_him
	left outer join Master_imp_mar MAS on HOU.num_proc_mim = MAS.num_proc_mim
	left outer join job_imp_mar JOB on HOU.job_him = JOB.Num_proc_him
	left outer join Cta_Cte_hou_imp_mar CTA on HOU.Num_proc_him = CTA. Num_proc_him
	--join Caixa_hou_imp_mar CX on CTA.Num_proc_him = CTA.Num_proc_him
	left outer join pessoa IMP on hou.cd_import_him = IMP.cd_pes
	left outer join pessoa EXPT on hou.cd_export_him = EXPT.cd_pes
	--left outer join Tipo_taxa TT on CTA.Cd_tp_tx = TT.cd_tp_tx
where 
	CTA.Cd_tp_tx in ('PBD', 'DVC', 'PSA','DES','MZC','MZ2','AWD','CCV','CR1','CR2','CRR','XDR','XDS','XDY','XDZ','BLF','LBC','XAG','XLC','SIS','XAD') and CTA.DC_HIM = 'C' and HOU.Cd_dst_him in ('VIX','GIG') and JOB.CD_Vendedor = 'FL' and ATA_LIM between @DataInicial and @DataFinal
group by 
	HOU.Num_proc_him,CTA.CD_tp_tx,CTA.Vlr_ORG_HIM,HAWB_him, ATA_LIM,hou.Obs_Him,IMP.Apelido, EXPT.Apelido, dbo.FConverterMoeda(CTA.Cd_Tp_Moeda,'REL') * CTA.Vlr_ORG_HIM




GO
