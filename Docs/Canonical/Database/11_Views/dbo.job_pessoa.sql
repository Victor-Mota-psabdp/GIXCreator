SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   view job_pessoa
as

Select Apelido,Nome_usuario,cd_export_hem,cd_Tp_ocor From House_exp_mar HOU
Join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
Join job_exp_mar job on job.num_proc_hem=job_hem
Join Usuario VD on VD.cd_usuario=cd_vendedor
Join Pessoa PP ON PP.cd_pes=cd_export_hem
Left Join hist_geral on job_hem=hsgprocesso and cd_tp_ocor=30

Where 
 convert(Datetime,dt_saida_mem,105) >='01-01-2006'

Union 

Select Apelido,Nome_usuario,cd_export_hea,cd_Tp_ocor From House_exp_aer HOU
Join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
Join job_exp_aer job on job.num_proc_hea=job_hea
Join Usuario VD on VD.cd_usuario=cd_vendedor
Join Pessoa PP ON PP.cd_pes=cd_export_hea
Left Join hist_geral on job_hea=hsgprocesso and cd_tp_ocor=30

Where 
 convert(Datetime,dt_saida_mea,105) >='01-01-2006'


UNION

Select Apelido,Nome_usuario,cd_import_hia,0 From House_imp_aer HOU

Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Join job_imp_aer job on job.num_proc_hia=job_hia
Join Usuario VD on VD.cd_usuario=cd_vendedor
Join Pessoa PP ON PP.cd_pes=cd_import_hia

Where 
 convert(Datetime,dt_cheg_mia,105) >='01-01-2006'

union 


Select Apelido,Nome_usuario,cd_import_him,0 From House_imp_mar HOU

Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
Join job_imp_mar job on job.num_proc_him=job_him
Join Usuario VD on VD.cd_usuario=cd_vendedor
Join Pessoa PP ON PP.cd_pes=cd_import_him

Where 
 convert(Datetime,dt_atrac_mim,105) >='01-01-2006'



GO
