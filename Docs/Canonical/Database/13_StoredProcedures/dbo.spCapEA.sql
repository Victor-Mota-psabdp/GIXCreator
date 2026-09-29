SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  	Procedure spCapEA

			@processo  varchar(16)
as

select 
	MEA.num_proc_mea, refer_cons_Mea, MAWB_MEA, HAWB_HEA, apelido, job_hea   from Master_exp_aer MEA
		left join house_exp_aer HEA on MEA.num_proc_mea = HEA.num_proc_mea
		left join pessoa ps on HEA.cd_export_hea = ps.cd_pes
		where MEA.num_proc_mea = @processo




GO
