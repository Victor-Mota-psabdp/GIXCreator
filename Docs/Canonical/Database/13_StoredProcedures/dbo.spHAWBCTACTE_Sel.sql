SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 03/06 - incluido with nolock + retirado left join

CREATE	Procedure [dbo].[spHAWBCTACTE_Sel] 

	@Processo 	VarChar (16)

AS
	select
		tt.cd_tp_tx_Ofc Cd_TAXA,
		vlr_org_hea Valor_Taxa,
		Comp_Job_HEa P_C
	from cta_cte_hou_exp_aer CC with(nolock)
	join tipo_taxa tt with(nolock) on CC.cd_tp_tx=tt.cd_tp_tx
	where 
		CC.num_proc_hea = @Processo and 
		CC.dc_hea <> 'D' and 
		Comp_Job_HEa is not null 
		and Comp_Job_HEa<>'N'






GO
