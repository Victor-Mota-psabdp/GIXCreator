SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spProcessosMes_rel
		@data	varchar(10)
as

select 
	'IA' Modal,apelido,count(num_proc_hia) Process,month(convert(datetime,dt_cheg_mia,105)) Mes,Year(convert(datetime,dt_cheg_mia,105)) Ano
from
	house_imp_aer hou
	Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
where
	convert(datetime,dt_cheg_mia,105) >=convert(datetime,@data,105) and left(num_proc_hia,5)<>'IAJOB'
group by 
	apelido,month(convert(datetime,dt_cheg_mia,105)),Year(convert(datetime,dt_cheg_mia,105))

Union all

select 
	'EA' Modal,apelido,count(num_proc_hea) Process,month(convert(datetime,dt_saida_mea,105)) Mes,Year(convert(datetime,dt_saida_mea,105)) Ano
from
	house_exp_aer hou
	Join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
where
	convert(datetime,dt_saida_mea,105) >=convert(datetime,@data,105) and left(num_proc_hea,5)<>'eajob'
group by 
	apelido,month(convert(datetime,dt_saida_mea,105)),Year(convert(datetime,dt_saida_mea,105))

Union all

select 
	'IA' Modal,apelido,count(num_proc_him) Process,month(convert(datetime,dt_atrac_mim,105)) Mes,Year(convert(datetime,dt_atrac_mim,105)) Ano
from
	house_imp_mar hou
	Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join Pessoa pp on pp.cd_pes=cd_import_him
where
	convert(datetime,dt_atrac_mim,105) >=convert(datetime,@data,105) and left(num_proc_him,5)<>'imjob'
group by 
	apelido,month(convert(datetime,dt_atrac_mim,105)),Year(convert(datetime,dt_atrac_mim,105))

Union all

select 
	'EA' Modal,apelido,count(num_proc_hem) Process,month(convert(datetime,dt_saida_mem,105)) Mes,Year(convert(datetime,dt_saida_mem,105)) Ano
from
	house_exp_mar hou
	Join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	Join Pessoa pp on pp.cd_pes=cd_export_hem
where
	convert(datetime,dt_saida_mem,105) >=convert(datetime,@data,105) and left(num_proc_hem,5)<>'emjob'
group by 
	apelido,month(convert(datetime,dt_saida_mem,105)),Year(convert(datetime,dt_saida_mem,105))


GO
