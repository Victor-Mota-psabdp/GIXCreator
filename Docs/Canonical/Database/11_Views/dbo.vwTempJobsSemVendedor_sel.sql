SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwTempJobsSemVendedor_sel]

as

select apelido,hou.num_proc_hem num_proc_hia,etd_lem data ,org.nome_local Origem, dst.nome_local Destino from house_exp_mar Hou
Join job_exp_mar JOB on JOB.num_proc_hem=hou.num_proc_hem
Join Pessoa PP on pp.cd_pes=cd_export_hem
Join Localidade Org on org.cd_local=cd_org_hem
Join Localidade Dst on Dst.cd_local=cd_Dst_hem
Join LLP_exp_mar LLP on llp.num_proc_lem=hou.num_proc_hem
where
	convert(Datetime,dt_emis_hem,105)>='01-01-2011'
	and cd_vendedor is null

GO
