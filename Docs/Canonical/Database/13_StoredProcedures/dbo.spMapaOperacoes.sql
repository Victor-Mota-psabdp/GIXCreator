SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE               Procedure spMapaOperacoes 

	@Modal	varchar(2),
	@cliente varchar(50)
as

if @modal = 'EM'
BEGIN
	select 
		job_hem as JOB,apelido,nome_usuario,cd_org_hem as Org,cd_dst_hem as Dst, 
		cast(HIST.cd_tp_ocor as money) as cd_tp_ocor,hist.HSGDataFU,dt_saida_mem as DtMaster,dt_saida_mem as DtSaida,hawb_hem

	from 
		house_exp_mar as hou

		left join Hist_Geral as hist on (job_hem=hist.hsgprocesso or hou.num_proc_hem=hist.hsgprocesso)
		inner join pessoa as pp on (cd_export_hem=pp.cd_pes)
		left join master_exp_mar as mas on (hou.num_proc_mem=mas.num_proc_mem)
		left outer join job_exp_mar as job on (job.num_proc_hem=job_hem)
		left outer join usuario on (usuario.cd_usuario=job.cd_usuario)
		left outer join hist_geral as FN on (job_hem=fn.hsgprocesso and 11=fn.cd_tp_ocor) 	

	where
		left(job_hem,2)='EM' and fn.hsgdata is null
		and apelido like @cliente and convert(datetime, dt_emis_hem,105) >= convert(Datetime, '01/10/2005',105)

END

IF @modal = 'IM'
BEGIN
	select 
		job_him as JOB,apelido,nome_usuario,cd_org_him as Org,cd_dst_him as Dst, 
		cast(HIST.cd_tp_ocor as money) as cd_tp_ocor,hist.hsgDataFU,dt_atrac_mim as DtMaster,dt_saida_him as DtSaida,hawb_him

	from 
		house_imp_mar as hou

		left join hist_geral as hist on (job_him=hist.hsgprocesso or hou.num_proc_him=hist.hsgprocesso)
		inner join pessoa as pp on (cd_import_him=pp.cd_pes)
		left outer join master_imp_mar as mas on(hou.num_proc_mim=mas.num_proc_mim)
		left outer join job_imp_mar as job on (job.num_proc_him=job_him)
		left outer join usuario on (usuario.cd_usuario=job.cd_usuario)
		left outer join hist_geral as FN on (fn.hsgprocesso=job_him and fn.cd_tp_ocor=11)	

	where
		left(job_him,2)='IM' and fn.hsgdata is null
		and apelido like @cliente and convert(datetime, dt_emis_him,105) >= convert(Datetime, '01/10/2005',105)
END
if @modal = 'EA'
BEGIN
	select 
		job_hea as JOB,apelido,nome_usuario,cd_org_hea as Org,cd_dst_hea as Dst,  
		cast(HIST.cd_tp_ocor as money) as cd_tp_ocor,max(hist.hsgDataFU) dt_follow_up, dt_saida_mea as DtMaster,dt_saida_mea as DtSaida,hawb_hea

	from 
		house_exp_aer as hou

		left join hist_geral as hist on (job_hea=hist.hsgprocesso or hou.num_proc_hea=hist.hsgprocesso)
		inner join pessoa as pp on (cd_export_hea=pp.cd_pes)
		left outer join master_exp_aer as mas on(hou.num_proc_mea=mas.num_proc_mea)
		left outer join job_exp_aer as job on (job.num_proc_hea=job_hea)
		left outer join usuario on (usuario.cd_usuario=job.cd_usuario)
		left outer join hist_geral as FN on (fn.hsgprocesso=job_hea and fn.cd_tp_ocor=11)	

	where
		left(job_hea,2)='EA' and fn.hsgprocesso is null
		and apelido like @cliente and convert(datetime, dt_emis_hea,105) >= convert(Datetime, '01/10/2005',105)

	group by 
		job_hea,apelido,nome_usuario,cd_org_hea,cd_dst_hea,  
		cast(HIST.cd_tp_ocor as money), dt_saida_mea,dt_saida_mea,hawb_hea
END

IF @modal = 'IA'
BEGIN
	select 
		job_hia as Job,apelido,nome_usuario,cd_org_hia as Org,cd_dst_hia as Dst,
		cast(HIST.cd_tp_ocor as money) as cd_tp_ocor,hist.hsgDataFU, dt_cheg_mia as dtMaster,etd_hia as DtSaida,hawb_hia

	from 
		house_imp_aer as hou

		LEFT join hist_geral as hist on (job_hia=hist.hsgprocesso or hou.num_proc_hia=hist.hsgprocesso)
		inner join pessoa as pp on (cd_import_hia=pp.cd_pes)
		left outer join job_imp_aer as job on (job.num_proc_hia=job_hia)
		left outer join master_imp_aer as mas on(hou.num_proc_mia=mas.num_proc_mia)
		left outer join usuario on (usuario.cd_usuario=job.cd_usuario)
		left outer join hist_geral as FN on (fn.hsgprocesso=job_hia and fn.cd_tp_ocor=11)	

	where
		left(job_hia,2)='IA' and fn.hsgdata is null
		and apelido like @cliente and convert(datetime, dt_emis_hia,105) >= convert(Datetime, '01/10/2005',105)
END


















GO
