SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View vwEmbarques_Rel

as
select 'EA' Modal,UPPER(org.pais_local) Origem,UPPER(dst.Pais_Local) Destino,count(num_proc_hea) Quantidade,month(convert(datetime,dt_saida_mea,105)) Mes, Year(convert(datetime,dt_saida_mea,105)) Ano from house_exp_aer HOU
Join localidade org on org.cd_local=cd_org_hea
join localidade dst on dst.cd_local=cd_dst_heA
join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
Where convert(datetime,dt_saida_mea,105) >= '05-01-2006'
group by month(convert(datetime,dt_saida_mea,105)),org.pais_local,dst.Pais_Local,Year(convert(datetime,dt_saida_mea,105))


UNION ALL

select 'EM' Modal,UPPER(org.pais_local) Origem,UPPER(dst.Pais_Local) Destino,count(num_proc_hem) Quantidade,month(convert(datetime,dt_saida_mem,105)) Mes,Year (convert(datetime,dt_saida_mem,105)) from house_exp_mar HOU
Join localidade org on org.cd_local=cd_org_hem
join localidade dst on dst.cd_local=cd_dst_hem
join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
Where convert(datetime,dt_saida_mem,105) >= '05-01-2006'
group by month(convert(datetime,dt_saida_mem,105)),org.pais_local,dst.Pais_Local,YEAR(convert(datetime,dt_saida_mem,105))


UNION ALL

select 'IA' Modal,UPPER(org.pais_local) Origem,UPPER(dst.Pais_Local) Destino,count(num_proc_hia) Quantidade,month(convert(datetime,dt_cheg_mia,105)) Mes, Year(convert(datetime,dt_cheg_mia,105)) from house_imp_aer HOU
Join localidade org on org.cd_local=cd_org_hia
join localidade dst on dst.cd_local=cd_dst_hia
join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Where convert(datetime,dt_cheg_mia,105) >= '05-01-2006'
group by month(convert(datetime,dt_cheg_mia,105)),org.pais_local,dst.Pais_Local,Year(convert(datetime,dt_cheg_mia,105))


UNION ALL

select 'IM' Modal,UPPER(org.pais_local) Origem,UPPER(dst.Pais_Local) Destino,count(num_proc_him) Quantidade,month(convert(datetime,dt_atrac_mim,105)) Mes,Year (convert(datetime,dt_atrac_mim,105)) from house_imp_mar HOU
Join localidade org on org.cd_local=cd_org_him
join localidade dst on dst.cd_local=cd_dst_him
join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
Where convert(datetime,dt_atrac_mim,105) >= '05-01-2006'
group by month(convert(datetime,dt_atrac_mim,105)),org.pais_local,dst.Pais_Local,YEAR(convert(datetime,dt_atrac_mim,105))

GO
