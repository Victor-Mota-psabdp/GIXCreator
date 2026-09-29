SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure spHou_sel

	@num_proc	varchar(16)

as

Select cd_export_hea Cd_Pes from house_exp_Aer
where num_proc_hea=@num_proc

union


Select cd_export_hem Cd_Pes from house_exp_mar
where num_proc_hem=@num_proc


union

Select cd_export_heo Cd_Pes from house_exp_out
where num_proc_heo=@num_proc

union

Select cd_consig_him Cd_Pes from house_imp_mar
where num_proc_him=@num_proc

union


Select cd_consig_hio Cd_Pes from house_imp_out
where num_proc_hio=@num_proc


union

Select cd_consig_hia Cd_Pes from house_imp_aer
where num_proc_hia=@num_proc

GO
