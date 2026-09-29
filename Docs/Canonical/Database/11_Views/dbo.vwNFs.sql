SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vwNFs


AS


select num_nf_hia, cd_Tp_Tx, dc_hia, vlr_pgto_nf_hia  from cta_Cte_hou_imp_Aer
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_hia and ref_Acesso=ref_Acesso_NF_HIA
Where emissao between '01-01-2006' and '01-31-2006'
and desp_org_hia='N'


union all


select num_nf_hea, cd_Tp_Tx, dc_hea, vlr_pgto_nf_hea  from cta_Cte_hou_exp_Aer
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_hea and ref_Acesso=ref_Acesso_NF_HeA
Where emissao between '01-01-2006' and '01-31-2006'
and desp_dst_hea='N'


UNION ALL


select num_nf_hiM, cd_Tp_Tx, dc_hiM, vlr_pgto_nf_hiM  from cta_Cte_hou_Imp_MAr
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_hiM and ref_Acesso=ref_Acesso_NF_HIM
Where emissao between '01-01-2006' and '01-31-2006'
and desp_org_hiM='N'


union all


select num_nf_heM, cd_Tp_Tx, dc_heM, vlr_pgto_nf_heM  from cta_Cte_hou_exp_MAr
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_heM and ref_Acesso=ref_Acesso_NF_HeM
Where emissao between '01-01-2006' and '01-31-2006'
and desp_dst_heM='N'

UNION ALL


select num_nf_Mia, cd_Tp_Tx, dc_Mia, vlr_pgto_nf_Mia  from cta_Cte_MAS_imp_Aer
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_Mia and ref_Acesso=ref_Acesso_NF_MIA
Where emissao between '01-01-2006' and '01-31-2006'
and desp_org_Mia='N'


UNION ALL

select num_nf_MEa, cd_Tp_Tx, dc_MEa, vlr_pgto_nf_MEa  from cta_Cte_MAS_EXp_Aer
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_MEa and ref_Acesso=ref_Acesso_NF_MEA
Where emissao between '01-01-2006' and '01-31-2006'
and desp_DST_MEa='N'


UNION ALL


select num_nf_MiM, cd_Tp_Tx, dc_MiM, vlr_pgto_nf_MiM  from cta_Cte_MAS_imp_MAr
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_MiM and ref_Acesso=ref_Acesso_NF_MIM
Where emissao between '01-01-2006' and '01-31-2006'
and desp_org_MiM='N'


UNION ALL

select num_nf_MEM, cd_Tp_Tx, dc_MEM, vlr_pgto_nf_MEM  from cta_Cte_MAS_EXp_MAr
Join Base_Nota_Fiscal NF on NF.notA_fiscal=num_nf_MEM and ref_Acesso=ref_Acesso_NF_MEM
Where emissao between '01-01-2006' and '01-31-2006'
and desp_DST_MEM='N'


GO
