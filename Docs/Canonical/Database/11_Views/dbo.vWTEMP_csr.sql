SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
cREATE View vWTEMP_csr

as

select nome_usuario, count(job_hea) EMB, month(convert(datetime,dt_saida_mea,105)) MES from house_exp_Aer HOU
Join Job_exp_aer job on job.num_proc_hea=job_hea
Join Usuario US on US.cd_usuario=job.cd_usuario
Join Master_exp_Aer MAS on MAS.num_proC_mea=hou.num_proc_mea
Where convert(datetime,dt_saida_mea,105)>='01-01-2007'
Group by nome_usuario,month(convert(datetime,dt_saida_mea,105))

unION

select nome_usuario, count(job_hia) EMB, month(convert(datetime,dt_cheg_mia,105)) MES from house_imp_Aer HOU
Join Job_imp_aer job on job.num_proc_hia=job_hia
Join Usuario US on US.cd_usuario=job.cd_usuario
Join Master_imp_Aer MAS on MAS.num_proC_mia=hou.num_proc_mia
Where convert(datetime,dt_cheg_mia,105)>='01-01-2007'
Group by nome_usuario,month(convert(datetime,dt_cheg_mia,105))

UNION 

select nome_usuario, count(job_HEM) EMB, month(convert(datetime,dt_saida_MEM,105)) MES from house_exp_MAR HOU
Join Job_exp_MAR job on job.num_proc_HEM=job_HEM
Join Usuario US on US.cd_usuario=job.cd_usuario
Join Master_exp_MAR MAS on MAS.num_proC_MEM=hou.num_proc_MEM
Where convert(datetime,dt_saida_MEM,105)>='01-01-2007'
Group by nome_usuario,month(convert(datetime,dt_saida_MEM,105))

unION

select nome_usuario, count(job_HIM) EMB, month(convert(datetime,dt_ATRAC_MIM,105)) MES from house_imp_MAR HOU
Join Job_imp_MAR job on job.num_proc_HIM=job_HIM
Join Usuario US on US.cd_usuario=job.cd_usuario
Join Master_imp_MAR MAS on MAS.num_proC_MIM=hou.num_proc_MIM
Where convert(datetime,dt_ATRAC_MIM,105)>='01-01-2007'
Group by nome_usuario,month(convert(datetime,dt_ATRAC_MIM,105))


GO
