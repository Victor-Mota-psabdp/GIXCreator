SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure spMovCarga_Rel 

	@pessoa varchar(50),
	@origem varchar(50),
	@destino varchar(50),
	@pais_origem varchar(50),
	@pais_destino varchar(50),
	@datainicial varchar(10),
	@datafinal   varchar(10)

as


select 
	count(hou.num_proc_hia) as Embarque,sum(qtd_tot_vol_hia) as Volume, 
	sum(peso_real_hia) as Peso,de.nome_local as Origem,
	para.nome_local as Destino, imp.apelido ,de.pais_local as PaisOrigem,
	para.pais_local as PaisDestino
	

from 
	house_imp_aer as hou

	inner join pessoa as imp on (imp.cd_pes=cd_imporT_hia)
	inner join localidade as DE on (de.cd_local=cd_org_hia)
	inner join localidade as PARA on (para.cd_local=cd_dst_hia)
	inner join master_imp_aer as mas on (mas.num_proc_mia=hou.num_proc_mia)	

where 
	convert(datetime, dt_cheg_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	and de.nome_local like @origem and para.nome_local like @destino and apelido like @pessoa
	and de.pais_local like @pais_origem and para.pais_local like @pais_destino
		
group by 
	de.nome_local, para.nome_local, apelido, de.pais_local, para.pais_local


UNION

select 
	count(hou.num_proc_him) as Embarque,sum(qtd_tot_vol_him) as Volume, 
	sum(peso_bruto_him) as Peso,de.nome_local as Origem,
	para.nome_local as Destino, imp.apelido ,de.pais_local as PaisOrigem,
	para.pais_local as PaisDestino
	

from 
	house_imp_mar as hou

	inner join pessoa as imp on (imp.cd_pes=cd_imporT_him)
	inner join localidade as DE on (de.cd_local=cd_org_him)
	inner join localidade as PARA on (para.cd_local=cd_dst_him)
	inner join master_imp_mar as mas on (mas.num_proc_mim=hou.num_proc_mim)	

where 
	convert(datetime, DT_ATRAC_MIM, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	and de.nome_local like @origem and para.nome_local like @destino and apelido like @pessoa
	and de.pais_local like @pais_origem and para.pais_local like @pais_destino
		
group by 
	de.nome_local, para.nome_local, apelido, de.pais_local, para.pais_local



union

select 
	count(hou.num_proc_hem) as Embarque,sum(qtd_tot_vol_hem) as Volume, 
	sum(peso_bruto_hem) as Peso,de.nome_local as Origem,
	para.nome_local as Destino, exp.apelido ,de.pais_local as PaisOrigem,
	para.pais_local as PaisDestino
	

from 
	house_exp_mar as hou

	inner join pessoa as exp on (exp.cd_pes=cd_exporT_hem)
	inner join localidade as DE on (de.cd_local=cd_org_hem)
	inner join localidade as PARA on (para.cd_local=cd_dst_hem)
	inner join master_exp_mar as mas on (mas.num_proc_mem=hou.num_proc_mem)	

where 
	convert(datetime, dt_saida_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	and de.nome_local like @origem and para.nome_local like @destino and apelido like @pessoa
	and de.pais_local like @pais_origem and para.pais_local like @pais_destino
		
group by 
	de.nome_local, para.nome_local, apelido, de.pais_local, para.pais_local



union

select 
	count(hou.num_proc_hea) as Embarque,sum(qtd_tot_vol_hea) as Volume, 
	sum(peso_tax) as Peso,de.nome_local as Origem,
	para.nome_local as Destino, exp.apelido ,de.pais_local as PaisOrigem,
	para.pais_local as PaisDestino
	

from 
	house_exp_aer as hou

	inner join pessoa as exp on (exp.cd_pes=cd_exporT_hea)
	inner join localidade as DE on (de.cd_local=cd_org_hea)
	inner join localidade as PARA on (para.cd_local=cd_dst_hea)
	inner join master_exp_aer as mas on (mas.num_proc_mea=hou.num_proc_mea)	

where 
	convert(datetime, dt_saida_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	and de.nome_local like @origem and para.nome_local like @destino and apelido like @pessoa
	and de.pais_local like @pais_origem and para.pais_local like @pais_destino
		
group by 
	de.nome_local, para.nome_local, apelido, de.pais_local, para.pais_local





GO
