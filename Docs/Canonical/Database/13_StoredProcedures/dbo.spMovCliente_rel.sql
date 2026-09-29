SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      procedure spMovCliente_rel 

		@datainicial 	varchar(10),
		@datafinal	varchar(10),
		@pessoa		varchar(30)
AS

select 
	'Importação Aérea' as Modal,pp.apelido as Exportador, org.nome_local as Origem, 
	dest.nome_local as Destino,count(hou.num_proc_hia) as Embarques,
	max(convert(datetime, hou.eta_hia, 105)) as Data, sum(hou.peso_real_hia) as Peso 

from 
	
	house_imp_aer as hou

	inner join pessoa as pp on (hou.cd_export_hia=pp.cd_pes)
	inner join pessoa as cliente on (hou.cd_import_hia=cliente.cd_pes)
	inner join localidade as org on (hou.cd_org_hia=org.cd_local)
	inner join localidade as dest on (hou.cd_dst_hia=dest.cd_local)
	Join Master_Imp_Aer mas on mas.num_proc_mia=hou.num_proc_mia

where 
	left(hou.num_proc_hia,5) <> 'IAJOB' and convert(datetime, mas.dt_cheg_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105) and
	cliente.apelido like @pessoa

group by 
	pp.apelido, org.nome_local, dest.nome_local




union




select 
	'Exportação Aérea' as Modal,pp.apelido as Exportador, org.nome_local as Origem, 
	dest.nome_local as Destino,count(hou.num_proc_hea) as Embarques,
	max(convert(datetime, mas.dt_saida_mea, 105)) as Data, sum(hou.Peso_Tax) as Peso 

from 
	house_exp_aer as hou

	inner join pessoa as pp on (hou.cd_consig_hea=pp.cd_pes)
	inner join pessoa as cliente on (hou.cd_export_hea=cliente.cd_pes)
	inner join localidade as org on (hou.cd_org_hea=org.cd_local)
	inner join localidade as dest on (hou.cd_dst_hea=dest.cd_local)
	inner join master_exp_aer as mas on (mas.num_proc_mea=hou.num_proc_mea)
where 
	left(hou.num_proc_hea,5) <> 'EAJOB' and convert(datetime, mas.dt_saida_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105) 
	and cliente.apelido like @pessoa

group by pp.apelido, org.nome_local, dest.nome_local



union

select 
	'Importação Maritima' as Modal,pp.apelido as Exportador, org.nome_local as Origem, 
	dest.nome_local as Destino,count(hou.num_proc_him) as Embarques,max(convert(datetime, mas.dt_atrac_mim, 105)) as Data, 
	sum(hou.peso_bruto_him) as Peso 

from 
	house_imp_mar as hou

	inner join pessoa as pp on (hou.cd_import_him=pp.cd_pes)
	inner join pessoa as cliente on (hou.cd_import_him=cliente.cd_pes)
	inner join localidade as org on (hou.cd_org_him=org.cd_local)
	inner join localidade as dest on (hou.cd_dst_him=dest.cd_local)
	inner join master_imp_mar as mas on (mas.num_proc_mim=hou.num_proc_mim)
where 
	left(hou.num_proc_him,5) <> 'IMJOB' and convert(datetime, mas.dt_atrac_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105) and
	cliente.apelido like @pessoa

group by pp.apelido, org.nome_local, dest.nome_local



union



select 'Exportação Maritima' as Modal,pp.apelido as Exportador, org.nome_local as Origem, dest.nome_local as Destino,count(hou.num_proc_hem) as Embarques,max(convert(datetime, mas.dt_saida_mem, 105)) as Data, sum(hou.peso_bruto_hem) as Peso from house_exp_mar as hou
inner join pessoa as pp on (hou.cd_consig_hem=pp.cd_pes)
inner join pessoa as cliente on (hou.cd_export_hem=cliente.cd_pes)
inner join localidade as org on (hou.cd_org_hem=org.cd_local)
inner join localidade as dest on (hou.cd_dst_hem=dest.cd_local)
inner join master_exp_mar as mas on (mas.num_proc_mem=hou.num_proc_mem) 
where left(hou.num_proc_hem,5) <> 'EMJOB' and convert(datetime, mas.dt_saida_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105) 
and cliente.apelido like @pessoa
group by pp.apelido, org.nome_local, dest.nome_local










GO
