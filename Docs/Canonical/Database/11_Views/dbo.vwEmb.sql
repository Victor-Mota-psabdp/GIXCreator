SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE       View vwEmb as

select 
	'Importação Maritíma' Modal,nome_raz_soc, count(num_proc_him) Processos,
	month(convert(Datetime,dt_atrac_mim, 105)) Mes , year(convert(Datetime,dt_atrac_mim, 105)) Ano
from 
	house_imp_mar hou
	Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join pessoa pp on pp.cd_pes=hou.cd_consig_him
where 
	convert(datetime,dt_atrac_mim,105)>='01-01-2005'
group by
	nome_raz_soc, month(convert(Datetime,dt_atrac_mim, 105)), year(convert(Datetime,dt_atrac_mim, 105))


UNION 

select 
	'Importação Aérea' Modal,nome_raz_soc, count(num_proc_hia) Processos,
	month(convert(Datetime,dt_cheg_mia, 105)) Mes, year(convert(Datetime,dt_cheg_mia, 105)) Ano
from 
	house_imp_aer hou
	Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join pessoa pp on pp.cd_pes=hou.cd_consig_hia
where 
	convert(datetime,dt_cheg_mia,105)>='01-01-2005'
group by
	nome_raz_soc, month(convert(Datetime,dt_cheg_mia, 105)), year(convert(Datetime,dt_cheg_mia, 105))

union 



select 
	'Exportação Maritíma' Modal,nome_raz_soc, count(num_proc_hem) Processos,
	month(convert(Datetime,dt_saida_mem, 105)) Mes, year(convert(Datetime,dt_saida_mem, 105)) Ano
from 
	house_exp_mar hou
	Join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	Join pessoa pp on pp.cd_pes=hou.cd_export_hem
where 
	convert(datetime,dt_saida_mem,105)>='01-01-2005'
group by
	nome_raz_soc, month(convert(Datetime,dt_saida_mem, 105)), year(convert(Datetime,dt_saida_mem, 105))

union

select 
	'Exportação Aérea' Modal,dbo.strGM_Grupo(nome_raz_soc,cd_consig_hea) , count(num_proc_hea) Processos,
	month(convert(Datetime,dt_saida_mea, 105)) Mes, year(convert(Datetime,dt_saida_mea, 105)) Ano 
from 
	house_exp_aer hou
	Join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join pessoa pp on pp.cd_pes=hou.cd_export_hea
where 
	convert(datetime,dt_saida_mea,105)>='01-01-2005'
group by
	dbo.strGM_Grupo(nome_raz_soc,cd_consig_hea), month(convert(Datetime,dt_saida_mea, 105)), year(convert(Datetime,dt_saida_mea, 105))







GO
