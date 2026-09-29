SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select Comp_Job_HiM from cta_cte_hou_imp_mar where num_proc_him = 'IMEXC20110101501'

--21/03/11 - a stored só pegava os casos EM, porém ela era usada na criação do hbl, foi incluido o select pra IM - Cadu

CREATE	Procedure [dbo].[spHblMECTACTE_Sel] 

	@Processo 	VarChar (16)

AS
	select
		tt.Nome_tp_tx_ing Nome_TAXA,
		CC.cd_tp_moeda,
		vlr_org_hem Valor_Taxa,
		Comp_Job_HEM P_C
	from
		cta_cte_hou_exp_mar CC With(nolock)
		left join tipo_taxa tt With(nolock) on CC.cd_tp_tx=tt.cd_tp_tx
	where 
		CC.num_proc_hem = @Processo and 
		CC.dc_hem <> 'D' and 
		Comp_Job_HEM is not null and Comp_Job_HEM<>'N'

union all

	select
		tt.Nome_tp_tx_ing Nome_TAXA,
		CC.cd_tp_moeda,
		vlr_org_him Valor_Taxa,
		Comp_Job_HiM P_C
	from
		cta_cte_hou_imp_mar CC With(nolock)
		left join tipo_taxa tt With(nolock) on CC.cd_tp_tx=tt.cd_tp_tx
	where 
		CC.num_proc_him = @Processo and 
		CC.dc_him <> 'D' and 
		Comp_Job_HiM is not null and Comp_Job_HiM<>'N'

GO
