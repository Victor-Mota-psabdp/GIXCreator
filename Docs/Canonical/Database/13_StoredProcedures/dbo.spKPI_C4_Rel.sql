SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spKPI_C4_Rel

		@DataInicial	varchar(10),
		@DataFinal	varchar(10),
		@Usuario	varchar(20)

AS


select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_hea,cta.dc_hea)) Valor, Apelido 

from 
	house_exp_aer HOU

	inner join job_exp_aer  JOB on HOU.job_hea=job.num_proc_hea
	inner join pessoa pp on pp.cd_pes=cd_export_hea
	inner join cta_cte_hou_exp_aer CTA on (CTA.num_proc_hea=HOU.num_proc_hea)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_hea and bf.ref_acesso=cta.ref_acesso_nf_hea

Where
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario  like @usuario

group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_Mea,cta.dc_Mea)) Valor ,apelido

from 
	house_exp_aer HOU

	inner join job_exp_aer  JOB on HOU.job_hea=job.num_proc_hea
	inner join pessoa pp on pp.cd_pes=cd_export_hea
	inner join cta_cte_mas_exp_aer CTA on (CTA.num_proc_Mea=HOU.num_proc_Mea)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_Mea and bf.ref_acesso=cta.ref_acesso_nf_Mea
Where

	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
	nome_usuario  like @usuario

group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_hia,cta.dc_hia)) Valor, apelido 

from 
	house_imp_aer HOU

	inner join job_imp_aer  JOB on HOU.job_hia=job.num_proc_hia
	inner join pessoa pp on pp.cd_pes=cd_import_hia
	inner join cta_cte_hou_imp_aer CTA on (CTA.num_proc_hia=HOU.num_proc_hia)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_hia and bf.ref_acesso=cta.ref_acesso_nf_hia
Where
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario  like @usuario
group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_mia,cta.dc_mia)) Valor, apelido 

from 
	house_imp_aer HOU

	inner join job_imp_aer  JOB on HOU.job_hia=job.num_proc_hia
	inner join pessoa pp on pp.cd_pes=cd_import_hia
	inner join cta_cte_mas_imp_aer CTA on (CTA.num_proc_mia=HOU.num_proc_mia)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_mia and bf.ref_acesso=cta.ref_acesso_nf_mia
Where

	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario like @usuario
group by 
	nome_usuario, apelido

UNION ALL


select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_hem,cta.dc_hem)) Valor, apelido 

from 
	house_exp_mar HOU

	inner join job_exp_mar  JOB on HOU.job_hem=job.num_proc_hem
	inner join pessoa pp on pp.cd_pes=cd_export_hem
	inner join cta_cte_hou_exp_mar CTA on (CTA.num_proc_hem=HOU.num_proc_hem)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_hem and bf.ref_acesso=cta.ref_acesso_nf_hem
Where
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario  like @usuario
group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_mem,cta.dc_mem)) Valor, apelido 

from 
	house_exp_mar HOU

	inner join job_exp_mar  JOB on HOU.job_hem=job.num_proc_hem
	inner join cta_cte_mas_exp_mar CTA on (CTA.num_proc_mem=HOU.num_proc_mem)
	inner join pessoa pp on pp.cd_pes=cd_export_hem
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_mem and bf.ref_acesso=cta.ref_acesso_nf_mem
Where 
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario  like @usuario
group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_him,cta.dc_him)) Valor, apelido

from 
	house_imp_mar HOU

	inner join job_imp_mar  JOB on HOU.job_him=job.num_proc_him
	inner join pessoa pp on pp.cd_pes=cd_import_him
	inner join cta_cte_hou_imp_mar CTA on (CTA.num_proc_him=HOU.num_proc_him)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_him and bf.ref_acesso=cta.ref_acesso_nf_him

Where
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario  like @usuario
group by 
	nome_usuario, apelido

UNION ALL

select 
	Nome_usuario,
	sum(dbo.valor(vlr_pgto_nf_mim,cta.dc_mim)) Valor, apelido 

from 
	house_imp_mar HOU

	inner join job_imp_mar  JOB on HOU.job_him=job.num_proc_him
	inner join pessoa pp on pp.cd_pes=cd_import_him
	inner join cta_cte_mas_imp_mar CTA on (CTA.num_proc_mim=HOU.num_proc_mim)
	inner join usuario US on JOB.cd_vendedor=US.cd_usuario
	inner join base_nota_fiscal bf on bf.nota_fiscal=cta.num_nf_mim and bf.ref_acesso=cta.ref_acesso_nf_mim
Where
	emissao between convert(datetime,@datainicial,105) and
		convert(datetime,@datafinal,105) and
		nome_usuario like @usuario
group by 
	nome_usuario, apelido


GO
