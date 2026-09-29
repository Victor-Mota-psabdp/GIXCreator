SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spResumoModalDel_Rel] --'06-01-2010','06-30-2010'
		@DataInicial	Datetime,
		@DataFinal		Datetime,
		@Modal			Varchar(50)
AS


if @modal= 'Ocean Import'
	Begin
		select 'Ocean Import' Modal,num_proc_lim Job,sum(dbo.valor(vlr_org_him,cta.dc_him)) Net_Revenue from llp_imp_mar
		Left Join cta_cte_hou_imp_mar cta on cta.num_proc_him=num_proc_lim
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			eta_lim between @DataInicial and @Datafinal and pft_aer='S'
		Group by 
				num_proc_lim
	End

if @modal= 'Ocean Export'
	Begin
		select 'Ocean Export' Modal, Num_Proc_lem Job, sum(dbo.valor(vlr_org_hem,cta.dc_hem)) Net_Revenue from llp_exp_mar
		Left Join cta_cte_hou_exp_mar cta on cta.num_proc_hem=num_proc_lem
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			etd_lem between @DataInicial and @Datafinal and pft_aer='S'
		Group by Num_Proc_lem
	End

if @modal= 'Air Import'
	Begin
		select 'Air Import' Modal, Num_Proc_lia Job, sum(dbo.valor(vlr_org_hia,cta.dc_hia)) Net_Revenue from llp_imp_aer
		Left Join cta_cte_hou_imp_aer cta on cta.num_proc_hia=num_proc_lia
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			eta_lia between @DataInicial and @Datafinal and pft_aer='S'
		Group by
			Num_Proc_Lia
	End
if @modal= 'Air Export'
	Begin
		select 'Air Export' Modal, Num_Proc_Lea Job, sum(dbo.valor(vlr_org_hea,cta.dc_hea)) Net_Revenue from llp_exp_aer
		Left Join cta_cte_hou_exp_aer cta on cta.num_proc_hea=num_proc_lea
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			etd_lea between @DataInicial and @Datafinal and pft_aer='S'
		Group by Num_PRoc_lea
	End

if @modal= 'Other Import'
	Begin
		select 'Other Import' Modal, num_proc_lio Job, sum(dbo.valor(vlr_org_hio,cta.dc_hio)) Net_Revenue from llp_imp_out
		Left Join cta_cte_hou_imp_out cta on cta.num_proc_hio=num_proc_lio
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			eta_lio between @DataInicial and @Datafinal and pft_aer='S'

		Group by num_proc_lio
	End

if @modal= 'Other Export'
	Begin

		Select 'Other Export' Modal, num_proc_leo Job, sum(dbo.valor(vlr_org_heo,cta.dc_heo)) Net_Revenue from llp_exp_out
		Left Join cta_cte_hou_exp_out cta on cta.num_proc_heo=num_proc_leo
		Left Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_tp_Tx and pft_aer='S'
		where
			etd_leo between @DataInicial and @Datafinal and pft_aer='S'
		Group by 
			Num_Proc_Leo
	End


GO
