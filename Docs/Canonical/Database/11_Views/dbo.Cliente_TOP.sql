SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View Cliente_TOP

AS
--HEA

select 
	dbo.strGM_Grupo(Nome_Raz_Soc,cd_consig_hea) Cliente,  count(distinct(hou.num_proC_hea)) Emb, sum(dbo.valor( Vlr_Pgto_nf_hea,cta.dc_hea)) Receita
from 
	house_exp_aer HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join Cta_Cte_hou_exp_aer cta on cta.num_proc_hea=hou.num_proc_hea
	Join Localidade dst on dst.cd_local=cd_dst_hea
where 
	dst.pais_local='EUA' and dt_saida_mea like '%%/%%/2005'
Group by 
	dbo.strGM_Grupo(Nome_Raz_Soc,cd_consig_hea)


--MEA
UNION ALL
select 
	dbo.strGM_Grupo(Nome_Raz_Soc,cd_consig_hea) Cliente,  0 Emb, sum(dbo.valor( Vlr_Pgto_nf_mea,cta.dc_mea)) 
from 
	house_exp_aer HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join Cta_Cte_Mas_exp_aer cta on cta.num_proc_mea=hou.num_proc_mea
	Join Localidade dst on dst.cd_local=cd_dst_hea
where 
	dst.pais_local='EUA' and dt_saida_mea like '%%/%%/2005'
Group by 
	dbo.strGM_Grupo(Nome_Raz_Soc,cd_consig_hea)


UNION ALL
--HIA

select 
	Nome_Raz_Soc Cliente,  count(distinct(hou.num_proC_hia)) Emb, sum(dbo.valor( Vlr_Pgto_nf_hia,cta.dc_hia)) 
from 
	house_imp_aer HOU
	Join Pessoa pp on pp.cd_pes=cd_import_hia
	join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join Cta_Cte_hou_imp_aer cta on cta.num_proc_hia=hou.num_proc_hia
	Join Localidade dst on dst.cd_local=cd_org_hia
where 
	dst.pais_local='EUA' and dt_cheg_mia like '%%/%%/2005'
Group by 
	Nome_Raz_Soc

--HIM

UNION ALL

select 
	Nome_Raz_Soc Cliente,  count(distinct(hou.num_proC_him)) Emb, sum(dbo.valor( Vlr_Pgto_nf_him,cta.dc_him)) 
from 
	house_imp_MAR HOU
	Join Pessoa pp on pp.cd_pes=cd_import_hiM
	join Master_imp_mar mas on mas.num_proc_miM=hou.num_proc_miM
	Join Cta_Cte_hou_imp_mar cta on cta.num_proc_him=hou.num_proc_him
	Join Localidade dst on dst.cd_local=cd_org_him
where 
	dst.pais_local='EUA' and dt_atrac_mim like '%%/%%/2005'
Group by 
	Nome_Raz_Soc


--HEM

--HIA
UNION ALL

select 
	Nome_Raz_Soc Cliente,  count(distinct(hou.num_proC_hem)) Emb, sum(dbo.valor( Vlr_Pgto_nf_hem,cta.dc_hem)) 
from 
	house_exp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hem
	join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	Join Cta_Cte_hou_exp_mar cta on cta.num_proc_hem=hou.num_proc_hem
	Join Localidade dst on dst.cd_local=cd_dst_hem
where 
	dst.pais_local='EUA' and dt_saida_mem like '%%/%%/2005'
Group by 
	Nome_Raz_Soc



GO
