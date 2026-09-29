SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE   Procedure spJobSel 
		@Processo	varchar(16)

as

IF LEFT(@PROCESSO,2)='IA'
	BEGIN
	 Select 
		Job_hia Job,Apelido Cliente, org.Nome_Local Origem, dst.Nome_Local Destino,
		hou.num_proc_hia Processo,ETA_HIA ETA,etd_hia ETD,numero_po_hia PO,hawb_hia HAWB,obs_hia OBS,
		Dt_cheg_mia Data

   	 from 
		house_imp_aer hou
		Join Job_imp_Aer JOB on job.num_proc_hia=hou.job_hia
		join pessoa pp on pp.cd_pes=cd_imporT_hia
		Join Localidade org on org.cd_local=cd_org_hia
		Join Localidade dst on dst.cd_local=cd_dst_hia
		Left Join PO_HIA PO on job_hia=PO.NUM_PROC_HIA
		Left Join Master_imp_aer mas on hou.num_proc_mia=mas.num_proc_mia
	 Where
		job_hia=@processo

	END

IF LEFT(@PROCESSO,2)='EA'
	BEGIN
	 Select 
		Job_hea,Apelido Cliente, org.Nome_Local Origem, dst.Nome_Local Destino,
		hou.num_proc_hea Processo,ETA_hea ETD,etd_hea ETD,numero_po_hea PO,hawb_hea HAWB,obs_hea Obs, dt_saida_mea Data
	 from 
		house_exp_aer hou
		Join Job_exp_Aer JOB on job.num_proc_hea=hou.job_hea
		join pessoa pp on pp.cd_pes=cd_exporT_hea
		Join Localidade org on org.cd_local=cd_org_hea
		Join Localidade dst on dst.cd_local=cd_dst_hea
		Left Join PO_hea PO on job_hea=PO.NUM_PROC_hea
		Left Join Master_exp_aer mas on hou.num_proc_mea=mas.num_proc_mea
	 Where
		job_hea=@processo
	END


IF LEFT(@PROCESSO,2)='IM'
	BEGIN
	 Select 
		Job_him,Apelido Cliente, org.Nome_Local Origem, dst.Nome_Local Destino,
		hou.num_proc_him Processo,dt_cheg_him ETA,dt_saida_him ETD,numero_po_him PO,hawb_him HAWB,obs_him Obs, dt_atrac_mim Data
	 from 
		house_imp_mar hou
		Join Job_imp_mar JOB on job.num_proc_him=hou.job_him
		join pessoa pp on pp.cd_pes=cd_imporT_him
		Join Localidade org on org.cd_local=cd_org_him
		Join Localidade dst on dst.cd_local=cd_dst_him
		Left Join PO_him PO on job_him=PO.NUM_PROC_him
		Left Join Master_imp_mar mas on hou.num_proc_mim=mas.num_proc_mim
	 Where
		job_him=@processo
	END


IF LEFT(@PROCESSO,2)='EM'
	BEGIN
	 Select 
		Job_hem,Apelido Cliente, org.Nome_Local Origem, dst.Nome_Local Destino,
		hou.num_proc_hem Processo,ETA_mem ETA,etd_mem ETD,numero_po_hem PO,hawb_hem HAWB,obs_hem Obs, dt_saida_mem Data
	 from 
		house_exp_mar hou
		Join Job_exp_mar JOB on job.num_proc_hem=hou.job_hem
		join pessoa pp on pp.cd_pes=cd_exporT_hem
		Join Localidade org on org.cd_local=cd_org_hem
		Join Localidade dst on dst.cd_local=cd_dst_hem
		Left Join PO_hem PO on job_hem=PO.NUM_PROC_hem
		Left Join Master_exp_mar mas on hou.num_proc_mem=mas.num_proc_mem
	 Where
		job_hem=@processo
	END





GO
