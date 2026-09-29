SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW VWTMP_TRANS

AS


select 'IMP' MODAL, Nome_Regiao,count(num_proc_hia) Qty,month(convert(datetime,dt_cheg_mia,105)) MES from house_imp_aer Hou
Join Localidade ORG on org.cd_local=cd_org_hia
Join regiao RG on RG.cd_regiao=org.cd_regiao
Join Master_Imp_Aer MAS on MAS.num_proc_mia=HOU.num_proc_mia
Where convert(datetime,dt_cheg_mia,105)>='01-01-2007'
Group by Nome_Regiao,month(convert(datetime,dt_cheg_mia,105))


UNION ALL

select 'IMP', Nome_Regiao,count(num_proc_him) Qty,month(convert(datetime,dt_atrac_mim,105)) MES from house_imp_mar Hou
Join Localidade ORG on org.cd_local=cd_org_him
Join regiao RG on RG.cd_regiao=org.cd_regiao
Join Master_Imp_mar MAS on MAS.num_proc_mim=HOU.num_proc_mim
Where convert(datetime,dt_atrac_mim,105)>='01-01-2007'
Group by Nome_Regiao,month(convert(datetime,dt_atrac_mim,105))

union all


select 'EXP',Nome_Regiao,count(num_proc_HEA) Qty,month(convert(datetime,dt_SAIDA_MEA,105)) MES from house_EXP_aer Hou
Join Localidade ORG on org.cd_local=cd_DST_HEA
Join regiao RG on RG.cd_regiao=org.cd_regiao
Join Master_EXP_Aer MAS on MAS.num_proc_MEA=HOU.num_proc_MEA
Where convert(datetime,dt_SAIDA_MEA,105)>='01-01-2007'
Group by Nome_Regiao,month(convert(datetime,dt_SAIDA_MEA,105))


UNION ALL

select 'EXP', Nome_Regiao,count(num_proc_HEM) Qty,month(convert(datetime,dt_SAIDA_MEM,105)) MES from house_EXP_mar Hou
Join Localidade ORG on org.cd_local=cd_DST_HEM
Join regiao RG on RG.cd_regiao=org.cd_regiao
Join Master_EXP_mar MAS on MAS.num_proc_MEM=HOU.num_proc_MEM
Where convert(datetime,dt_SAIDA_MEM,105)>='01-01-2007'
Group by Nome_Regiao,month(convert(datetime,dt_SAIDA_MEM,105))


GO
