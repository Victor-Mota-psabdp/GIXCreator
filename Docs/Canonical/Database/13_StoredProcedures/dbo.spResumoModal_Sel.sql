SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spResumoModal_Sel] --'06-01-2010','06-30-2010'
		@DataInicial	Datetime,
		@DataFinal		Datetime

AS



select 'Ocean Import' Modal, count(distinct num_proc_lim) Qty, sum(dbo.valor(vlr_org_him,cta.dc_him)) Net_Revenue from llp_imp_mar
Left Join cta_cte_hou_imp_mar cta on cta.num_proc_him=num_proc_lim
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	eta_lim between @DataInicial and @Datafinal and pft_aer='S'

union all


select 'Ocean Export', count(distinct num_proc_lem) Qty, sum(dbo.valor(vlr_org_hem,cta.dc_hem)) Net_Revenue from llp_exp_mar
Left Join cta_cte_hou_exp_mar cta on cta.num_proc_hem=num_proc_lem
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	etd_lem between @DataInicial and @Datafinal and pft_aer='S'

union all

select 'Air Import', count(distinct num_proc_lia) Qty, sum(dbo.valor(vlr_org_hia,cta.dc_hia)) Net_Revenue from llp_imp_aer
Left Join cta_cte_hou_imp_aer cta on cta.num_proc_hia=num_proc_lia
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	eta_lia between @DataInicial and @Datafinal and pft_aer='S'



union all

select 'Air Export', count(distinct num_proc_lea) Qty, sum(dbo.valor(vlr_org_hea,cta.dc_hea)) Net_Revenue from llp_exp_aer
Left Join cta_cte_hou_exp_aer cta on cta.num_proc_hea=num_proc_lea
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	etd_lea between @DataInicial and @Datafinal and pft_aer='S'


union all

select 'Other Import', count(distinct num_proc_lio) Qty, sum(dbo.valor(vlr_org_hio,cta.dc_hio)) Net_Revenue from llp_imp_out
Left Join cta_cte_hou_imp_out cta on cta.num_proc_hio=num_proc_lio
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	eta_lio between @DataInicial and @Datafinal and pft_aer='S'



union all

select 'Other Export', count(distinct num_proc_leo) Qty, sum(dbo.valor(vlr_org_heo,cta.dc_heo)) Net_Revenue from llp_exp_out
Left Join cta_cte_hou_exp_out cta on cta.num_proc_heo=num_proc_leo
Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
where
	etd_leo between @DataInicial and @Datafinal and pft_aer='S'

order by 1

GO
