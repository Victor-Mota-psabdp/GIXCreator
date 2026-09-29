SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spJobs_pCSR
		@datainicial	varchar(10),
		@datafinal 	varchar(10)

AS

select  
	apelido, nome_usuario, count(job_hea) as Qty,'Exportação Aérea' as Modal

from house_exp_aer as hou

	left outer join job_exp_aer as job on (hou.job_hea=job.num_proc_hea)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_export_hea)
where
	convert(datetime,dt_emis_hea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by apelido,nome_usuario


UNION


select  
	apelido, nome_usuario, count(job_HIA) as Qty, 'Importação Aérea' as Modal

from house_IMP_aer as hou
	
	left outer join job_IMP_aer as job on (hou.job_HIA=job.num_proc_HIA)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_IMPort_HIA)
where
	convert(datetime,dt_emis_hia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by apelido,nome_usuario


UNION

select  
	apelido, nome_usuario, count(job_HEM) as Qty,'Exportação Marítima' as Modal

from house_exp_MAR as hou

	left outer join job_exp_MAR as job on (hou.job_HEM=job.num_proc_HEM)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_export_HEM)
where
	convert(datetime,dt_emis_hem,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by apelido,nome_usuario


UNION


select  
	apelido, nome_usuario, count(job_HIM) as Qty,'Importação Marítima' as Modal 

from house_IMP_MAR as hou

	left outer join job_IMP_MAR as job on (hou.job_HIM=job.num_proc_HIM)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_IMPort_HIM)
where
	convert(datetime,dt_emis_him,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


group by apelido,nome_usuario


GO
