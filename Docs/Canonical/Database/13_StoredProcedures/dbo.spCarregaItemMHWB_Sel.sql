SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spCarregaItemMHWB_Sel]--'EAREC20050300201'

@Processo 	varchar(16)

as
	Select 
		nome_tp_tx, Comp_Job_Hea MHAWB, LLP.Dt_Impres_Lea DtPrint 
	from cta_cte_hou_exp_aer ccea 
	   left join tipo_taxa as tt on ccea.cd_tp_tx = tt.cd_tp_tx
	   left join LLP_exp_aer LLP on ccea.num_proc_hea = LLP.num_proc_Lea
	where 
		ccea.num_proc_hea = @Processo and dc_hea = 'C'
UNION ALL
	Select 
		nome_tp_tx, Comp_Job_Hem MHAWB, LLP.Dt_Impres_Lem DtPrint 
	from cta_cte_hou_exp_mar ccea
	   left join tipo_taxa as tt on ccea.cd_tp_tx = tt.cd_tp_tx
	   left join LLP_exp_mar LLP on ccea.num_proc_hem = LLP.num_proc_Lem
	where 
		ccea.num_proc_hem = @Processo and dc_hem = 'C'

----------------------------------------------------------------------------
UNION ALL
	Select 
		nome_tp_tx, comp_mbl_mea MHAWB, LLP.Dt_Impres_Lea DtPrint 
	from cta_cte_mas_exp_aer ccea
	   left join tipo_taxa as tt on ccea.cd_tp_tx = tt.cd_tp_tx
	   left join LLP_exp_aer LLP on ccea.num_proc_mea = LLP.num_proc_Lea
	where 
		ccea.num_proc_mea = @Processo and dc_mea = 'C'

UNION ALL
	Select 
		nome_tp_tx, 'N' MHAWB, LLP.Dt_Impres_Lem DtPrint 
	from cta_cte_mas_exp_mar ccea
	   left join tipo_taxa as tt on ccea.cd_tp_tx = tt.cd_tp_tx
	   left join LLP_exp_mar LLP on ccea.num_proc_mem = LLP.num_proc_Lem
	where 
		ccea.num_proc_mem = @Processo and dc_mem = 'C'
------------------------------------------------------------------------------
UNION ALL
	Select 
		nome_tp_tx, Comp_Job_HIM MHAWB, getdate() DtPrint 
	from cta_cte_hou_imp_mar CC
		left join tipo_taxa as tt on cc.cd_tp_tx = tt.cd_tp_tx
		left join LLP_imp_mar LLP on cc.num_proc_him = LLP.num_proc_Lim
	where 
		cc.num_proc_Him = @Processo and dc_him = 'C'
	




GO
