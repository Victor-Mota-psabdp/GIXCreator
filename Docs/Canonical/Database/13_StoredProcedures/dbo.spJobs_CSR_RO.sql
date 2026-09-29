SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     procedure spJobs_CSR_RO
		@datainicial	varchar(10),
		@datafinal 	varchar(10)

AS

select  
	pp.apelido, nome_usuario, count(job_hea) as Qty,'Exportação Aérea' as Modal,Cd_Consig_HEA DST,agt.apelido Agente,cd_tp_ocor

from house_exp_aer as hou

	left outer join job_exp_aer  job on (hou.job_hea=job.num_proc_hea)
	inner join usuario  us on (us.cd_usuario=job.cd_usuario)
	left join pessoa  pp on (pp.cd_pes=hou.cd_export_hea)
	left join pessoa agt on (job.Cd_Agente=agt.cd_pes)
	left outer join Hist_geral hst on (job.num_proc_hea=hst.hsgprocesso and cd_tp_ocor=30)
where
	convert(datetime,dt_emis_hea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by pp.apelido,nome_usuario,Cd_Consig_HEA,agt.apelido,cd_tp_ocor


UNION


select  
	pp.apelido, nome_usuario, count(job_HIA) as Qty, 'Importação Aérea' as Modal,'DST',
	agt.apelido,cd_tp_ocor

from house_IMP_aer as hou
	
	left outer join job_IMP_aer as job on (hou.job_HIA=job.num_proc_HIA)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_IMPort_HIA)
	left join pessoa agt on (job.Cd_Agente=agt.cd_pes)
	left outer join Hist_geral hst on (job.num_proc_hia=hst.hsgprocesso and cd_tp_ocor=30)
where
	convert(datetime,dt_emis_hia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by pp.apelido,nome_usuario,agt.apelido,cd_tp_ocor


UNION

select  
	pp.apelido, nome_usuario, count(job_HEM) as Qty,'Exportação Marítima' as Modal, cd_consig_hem DST,
	agt.apelido,cd_tp_ocor

from house_exp_MAR as hou

	left outer join job_exp_MAR as job on (hou.job_HEM=job.num_proc_HEM)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa agt on (job.Cd_Agente=agt.cd_pes)
	left join pessoa as pp on (pp.cd_pes=hou.cd_export_HEM)
	left outer join Hist_geral hst on (job.num_proc_heM=hst.hsgprocesso and cd_tp_ocor=30)
where
	convert(datetime,dt_emis_hem,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

group by pp.apelido,nome_usuario,cd_consig_hem,agt.apelido,cd_tp_ocor


UNION


select  
	pp.apelido, nome_usuario, count(job_HIM) as Qty,'Importação Marítima' as Modal,'DST',
	agt.apelido,cd_tp_ocor

from house_IMP_MAR as hou

	left outer join job_IMP_MAR as job on (hou.job_HIM=job.num_proc_HIM)
	inner join usuario as us on (us.cd_usuario=job.cd_usuario)
	left join pessoa as pp on (pp.cd_pes=hou.cd_IMPort_HIM)
	left join pessoa agt on (job.Cd_Agente=agt.cd_pes)
	left outer join Hist_geral hst on (job.num_proc_hIM=hst.hsgprocesso and cd_tp_ocor=30)
where
	convert(datetime,dt_emis_him,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


group by pp.apelido,nome_usuario,agt.apelido,cd_tp_ocor







GO
