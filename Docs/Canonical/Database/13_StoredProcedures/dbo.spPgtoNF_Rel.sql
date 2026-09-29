SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure spPgtoNF_Rel

as

select distinct cta.num_nf_him from caixa_hou_imp_mar CXA
Join Cta_Cte_Hou_Imp_mar CTa on CTa.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto
Where dt_pgto_rcto='07/07/2008'

UNION

select distinct cta.num_nf_HIA from caixa_hou_imp_AER CXA
Join Cta_Cte_Hou_Imp_AER CTa on CTa.num_proc_HIA=CXA.num_proc_HIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_HIA=cxa.dc_HIA
Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto
Where dt_pgto_rcto='07/07/2008'

UNION

select distinct cta.num_nf_HIO from caixa_hou_imp_OUT CXA
Join Cta_Cte_Hou_Imp_OUT CTa on CTa.num_proc_HIO=CXA.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_HIO=cxa.dc_HIO
Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto
Where dt_pgto_rcto='07/07/2008'
GO
