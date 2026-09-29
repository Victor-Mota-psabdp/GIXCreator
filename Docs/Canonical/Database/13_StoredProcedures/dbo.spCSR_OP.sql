SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE      Procedure spCSR_OP
			@Modal varchar(2)
AS

BEGIN
	IF @modaL='EA'
		(
			SELECT
				hsgDataFU dt_follow_up,job_hea JOB_Number,pp.apelido Cliente ,nome_usuario CSR,cd_tp_ocor, HSDDescricao Detalhes

			FROM 	
				house_exp_aer hou
				inner join job_exp_aer job on job.num_proc_hea=hou.job_hea
				inner join pessoa pp on pp.cd_pes=cd_export_hea
				inner join usuario US on US.cd_usuario=job.cd_usuario
				inner join hist_geral hist on hsgprocesso=hou.job_hea
			WHERE
				cd_tp_ocor in (16,14,20,7) and 
				dbo.Hist_Contra(cd_tp_ocor,job_hea,hou.num_proc_hea) is null
				and hsgDataFU >=convert(datetime,'11/05/2005',105)
			GROUP BY
				hsgDataFU,job_hea,pp.apelido,nome_usuario,cd_tp_ocor, HsDDescricao 
		)	

	if @modal='IA'
		(
			SELECT
				hsgDataFU dt_follow_up,job_HIA Job_Number,pp.apelido Cliente ,nome_usuario CSR,cd_tp_ocor, hsDDescricao Detalhes

			FROM 	
				house_IMP_aer hou
				inner join job_IMP_aer job on job.num_proc_HIA=hou.job_HIA
				inner join pessoa pp on pp.cd_pes=cd_IMPort_HIA
				inner join usuario US on US.cd_usuario=job.cd_usuario
				inner join hist_geral hist on hsgprocesso=hou.job_HIA
			WHERE
				cd_tp_ocor in (15,14,20,7) and 
				dbo.Hist_Contra(cd_tp_ocor,job_HIA,hou.num_proc_hia) is null
				and hsgDataFU >=convert(datetime,'01/01/2005',105)	
			GROUP BY
				hsgDataFU,job_HIA ,pp.apelido ,nome_usuario ,cd_tp_ocor, hsDDescricao
		)


	IF @modaL='EM'
		
		(
			SELECT
				hsgDataFU dt_follow_up,job_hem Job_Number,pp.apelido Cliente ,nome_usuario CSR,cd_tp_ocor, hsdDescricao Detalhes

			FROM 	
				house_exp_mar hou
				inner join job_exp_mar job on job.num_proc_hem=hou.job_hem
				inner join pessoa pp on pp.cd_pes=cd_export_hem
				inner join usuario US on US.cd_usuario=job.cd_usuario
				inner join hist_geral hist on hsgprocesso=hou.job_hem
			WHERE
				cd_tp_ocor in (16,14,20,7) and 
				dbo.Hist_Contra(cd_tp_ocor,job_hem,hou.num_proc_hem) is null
				and hsgdataFU >=convert(datetime,'01/01/2005',105)
			GROUP  BY
				hsgDataFU,job_hem ,pp.apelido,nome_usuario,cd_tp_ocor, hsDDescricao
		)

	if @modal='IM'
		(
			SELECT
				hsgdataFU dt_follow_up,job_him Job_Number,pp.apelido Cliente ,nome_usuario CSR,cd_tp_ocor, hsdDescricao Detalhes

			FROM 	
				house_IMP_mar hou
				inner join job_IMP_mar job on job.num_proc_him=hou.job_him
				inner join pessoa pp on pp.cd_pes=cd_IMPort_him
				inner join usuario US on US.cd_usuario=job.cd_usuario
				inner join hist_geral hist on hsgprocesso=hou.job_him
			WHERE
				cd_tp_ocor in (15,14,20,7) and 
				dbo.Hist_Contra(cd_tp_ocor,job_him,hou.num_proc_him) is null
				and hsgDataFU >=convert(datetime,'01/01/2005',105)	
			GROUP BY 
				hsgDataFU,job_him ,pp.apelido ,nome_usuario,cd_tp_ocor, hsdDescricao
		)
		

END		










GO
