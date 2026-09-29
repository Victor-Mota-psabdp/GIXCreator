SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE    procedure spClienteEmb_rel
		@pessoa	varchar(50)
as

select 
	'Exportação Aérea' Modal, LEFT(dbo.strgm_grupo(nome_raz_soc,cd_consig_hea),20) nome_raz_soc,count(hou.num_proc_hea) Emb, sum(Peso_REal_HEA) Peso, 
	month(convert(datetime,dt_saida_mea,105)) Mes 
from 
	house_exp_aer hou
	Join pessoa pp on pp.cd_pes=cd_export_hea
	Join master_exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
Where 
	convert(datetime,dt_saida_mea,105)>='01-01-2006' and
	apelido like @pessoa

Group by 
	LEFT(dbo.strgm_grupo(nome_raz_soc,cd_consig_hea),20), month(convert(datetime,dt_saida_mea,105))
	
Union
	

select 
	'Exportação Marítima' Modal, LEFT(nome_raz_soc,20),count(hou.num_proc_hem) Emb, sum(Peso_bruto_HEm) Peso, 
	month(convert(datetime,dt_saida_mem,105)) Mes 
from 
	house_exp_mar hou
	Join pessoa pp on pp.cd_pes=cd_export_hem
	Join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
Where 
	convert(datetime,dt_saida_mem,105)>='01-01-2006' 
	and apelido like @pessoa

Group by 
	LEFT(nome_raz_soc,20), month(convert(datetime,dt_saida_mem,105))
	

union

select 
	'Importação Marítima' Modal, LEFT(nome_raz_soc,20),count(hou.num_proc_him) Emb, sum(Peso_bruto_Him) Peso, 
	month(convert(datetime,dt_atrac_mim,105)) Mes 
from 
	house_imp_mar hou
	Join pessoa pp on pp.cd_pes=cd_import_him
	Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
Where 
	convert(datetime,dt_atrac_mim,105)>='01-01-2006' 
	and apelido like @pessoa

Group by 
	LEFT(nome_raz_soc,20), month(convert(datetime,dt_atrac_mim,105))
	

UNION 


select 
	'Importação Aérea' Modal, LEFT(nome_raz_soc,20),count(hou.num_proc_hia) Emb, sum(Peso_real_Hia) Peso, 
	month(convert(datetime,dt_cheg_mia,105)) Mes 
from 
	house_imp_aer hou
	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Where 
	convert(datetime,dt_cheg_mia,105)>='01-01-2006' 
	and apelido like @pessoa

Group by 
	LEFT(nome_raz_soc,20), month(convert(datetime,dt_cheg_mia,105))
	







GO
