SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	Procedure [dbo].[spHBL_CtaCte_Rel] 

	@Processo 	VarChar (16)

AS
	IF left(@Processo,2) = 'EM'
		Begin
			select
				tt.Nome_tp_tx_ing Nome_TAXA,
				CC.cd_tp_moeda,
				vlr_org_hem Valor_Taxa,
				Comp_Job_HEM P_C
			from
				cta_cte_hou_exp_mar CC
				left join tipo_taxa tt on CC.cd_tp_tx=tt.cd_tp_tx
			where 
				CC.num_proc_hem = @Processo and 
				CC.dc_hem <> 'D' and 
				Comp_Job_HEM is not null and Comp_Job_HEM<>'N'
		End

	Else IF left(@Processo,2) = 'IM'
		Begin
			select
				tt.Nome_tp_tx_ing Nome_TAXA,
				CC.cd_tp_moeda,
				vlr_org_him Valor_Taxa,
				Comp_Job_HIM P_C
			from
				cta_cte_hou_imp_mar CC
				left join tipo_taxa tt on CC.cd_tp_tx=tt.cd_tp_tx
			where 
				CC.num_proc_him = @Processo and 
				CC.dc_him <> 'D' and 
				Comp_Job_HIM is not null and Comp_Job_HIM <> 'N'
		End

	Else IF left(@Processo,2) = 'IA'
		Begin
			select
				tt.Nome_tp_tx_ing Nome_TAXA,
				CC.cd_tp_moeda,
				vlr_org_hia Valor_Taxa,
				Comp_Job_HIA P_C
			from
				cta_cte_hou_imp_aer CC
				left join tipo_taxa tt on CC.cd_tp_tx=tt.cd_tp_tx
			where 
				CC.num_proc_hia = @Processo and 
				CC.dc_hia <> 'D' and 
				Comp_Job_HIA is not null and Comp_Job_HIA <> 'N'
		End

GO
