SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  view Vend_CSR as

select 
	apelido, vd.nome_usuario Vendedor, us.nome_usuario Usuario, org.nome_local Origem, 
	dst.nome_local Destino,min(convert(datetime,dt_cheg_mia,105)) Data,cta.cd_tp_moeda, sum(vlr_org_hia) Profit
from 
	house_imp_aer hou
	JOIN job_imp_aer job on job.num_proc_hia=hou.job_hia
	JOIN usuario us on us.cd_usuario=job.cd_usuario
	JOIN pessoa pp on pp.cd_pes=cd_import_hia
	JOIN usuario vd on vd.cd_usuario=cd_vendedor
	JOIN master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	JOIN localidade org on org.cd_local=cd_org_hia
	JOIN Localidade dst on dst.cd_local=cd_dst_hia
	LEFT JOIN cta_cte_hou_imp_aer cta on hou.num_proc_hia=cta.num_proc_hia and cd_tp_tx in (select cd_tp_tx from tipo_taxa where pft_aer='S')
where 
	convert(datetime,dt_cheg_mia,105)>= '01-06-2005'
group by
	apelido, vd.nome_usuario , us.nome_usuario, org.nome_local , dst.nome_local, cta.cd_tp_moeda

union

SELECT
	apelido, vd.nome_usuario, us.nome_usuario,org.nome_local Origem, dst.nome_local Destino, 
	min(convert(datetime,dt_atrac_mim,105)) Data,cta.cd_Tp_moeda, sum(vlr_org_hiM) 
FROM
	house_imp_mar hou
	JOIN job_imp_mar job on job.num_proc_him=hou.job_him
	JOIN usuario us on us.cd_usuario=job.cd_usuario
	JOIN pessoa pp on pp.cd_pes=cd_import_him
	JOIN usuario vd on vd.cd_usuario=cd_vendedor
	JOIN master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	JOIN localidade org on org.cd_local=cd_org_him
	JOIN localidade dst on dst.cd_local=cd_dst_him
	LEFT JOIN Cta_cte_hou_imp_mar cta on hou.num_proc_him=cta.num_proc_him and cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S')
WHERE
	convert(datetime,dt_atrac_mim,105)>= '01-06-2005'
GROUP BY 
	apelido, vd.nome_usuario, us.nome_usuario,org.nome_local, dst.nome_local,cta.cd_tp_moeda

union 

SELECT
	dbo.strGM_Grupo(apelido,cd_consig_hea), vd.nome_usuario Vendedor, us.nome_usuario Usuario, 
	org.nome_local Origem, dst.nome_local Destino, min(convert(datetime,dt_saida_mea,105)) Data, 'Moeda', 0 
FROM
	house_exp_aer hou
	join job_exp_aer job on job.num_proc_hea=hou.job_hea
	join usuario us on us.cd_usuario=job.cd_usuario
	Join pessoa pp on pp.cd_pes=cd_export_hea
	Join usuario vd on vd.cd_usuario=cd_vendedor
	Join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join localidade org on org.cd_local=cd_org_hea
	Join Localidade dst on dst.cd_local=cd_dst_hea
WHERE
	convert(datetime,dt_saida_mea,105)>= '01-06-2005'
GROUP BY
	dbo.strGM_Grupo(apelido,cd_consig_hea), vd.nome_usuario , us.nome_usuario , org.nome_local, dst.nome_local 

union

SELECT 
	apelido, vd.nome_usuario, us.nome_usuario, org.nome_local Origem, 
	dst.nome_local Destino, min(convert(datetime,dt_saida_mem,105)) Data, 'Moeda', 0 
FROM
	house_exp_mar hou
	JOIN job_exp_mar job on job.num_proc_hem=hou.job_hem
	JOIN usuario us on us.cd_usuario=job.cd_usuario
	JOIN pessoa pp on pp.cd_pes=cd_export_hem
	JOIN usuario vd on vd.cd_usuario=cd_vendedor
	JOIN master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	JOIN localidade org on org.cd_local=cd_org_hem
	JOIN localidade dst on dst.cD_local=cd_dst_hem
WHERE
	convert(datetime,dt_saida_mem,105)>= '01-06-2005'
GROUP BY
	apelido, vd.nome_usuario, us.nome_usuario, org.nome_local , dst.nome_local 


GO
