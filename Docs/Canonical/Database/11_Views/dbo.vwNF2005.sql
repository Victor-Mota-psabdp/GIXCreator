SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  view vwNF2005

as
select nome_tp_tx, sum(vlr_pgto_NF_hia) NF from ctA_ctE_hou_imp_aer Cta
Join Base_NotA_fiscal NF on num_nf_hia=nota_fiscal and ref_Acesso=ref_Acesso_nf_hia
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_hia,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
group by nome_tp_tx

union all



select nome_tp_tx, sum(vlr_pgto_NF_hea) NF from ctA_ctE_hou_exp_aer Cta
Join Base_NotA_fiscal NF on num_nf_hea=nota_fiscal and ref_Acesso=ref_Acesso_nf_hea
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_hea,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
and desp_dst_hea='N'
group by nome_tp_tx

UNION ALL



select nome_tp_tx, sum(vlr_pgto_NF_him) NF from ctA_ctE_hou_imp_mar Cta
Join Base_NotA_fiscal NF on num_nf_him=nota_fiscal and ref_Acesso=ref_Acesso_nf_him
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_him,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
group by nome_tp_tx

union all



select nome_tp_tx, sum(vlr_pgto_NF_hem) NF from ctA_ctE_hou_exp_mar Cta
Join Base_NotA_fiscal NF on num_nf_hem=nota_fiscal and ref_Acesso=ref_Acesso_nf_hem
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_hem,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
and desp_dst_hem='N'
group by nome_tp_tx

union all



select nome_tp_tx, sum(vlr_pgto_NF_MIA) NF from ctA_ctE_MAS_imp_aer Cta
Join Base_NotA_fiscal NF on num_nf_MIA=nota_fiscal and ref_Acesso=ref_Acesso_nf_MIA
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_MIA,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
group by nome_tp_tx

union all



select nome_tp_tx, sum(vlr_pgto_NF_MEA) NF from ctA_ctE_MAS_exp_aer Cta
Join Base_NotA_fiscal NF on num_nf_MEA=nota_fiscal and ref_Acesso=ref_Acesso_nf_MEA
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_MEA,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
and desp_dst_MEA='N'
group by nome_tp_tx

UNION ALL



select nome_tp_tx, sum(vlr_pgto_NF_MIM) NF from ctA_ctE_MAS_imp_mar Cta
Join Base_NotA_fiscal NF on num_nf_MIM=nota_fiscal and ref_Acesso=ref_Acesso_nf_MIM
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_MIM,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
group by nome_tp_tx

union all



select nome_tp_tx, sum(vlr_pgto_NF_MEM) NF from ctA_ctE_MAS_exp_mar Cta
Join Base_NotA_fiscal NF on num_nf_MEM=nota_fiscal and ref_Acesso=ref_Acesso_nf_MEM
Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
where converT(datetime,dt_ins_MEM,105) <='12-31-2005' and emissao between '01-01-2006' and '02-28-2006'
and desp_dst_MEM='N'
group by nome_tp_tx



GO
