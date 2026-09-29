SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View AereoConsol as
select dbo.StrGM_Grupo(apelido, cd_consig_hea) Cliente,month(convert(datetime,dt_saida_mea,105)) Mes ,CEILING((CAST(LEFT(DT_SAIDA_MEA,2)  as money)/7)) Semana, org.nome_local Origem, dst.nome_local Destino, sum(Peso_Real_HEA) Peso, count(hou.num_proc_hea) Embarques from house_exp_aer hou
inner join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
inner join localidade org on org.cd_local=cd_org_hea
inner join localidade dst on dst.cd_local=cd_dst_hea
inner join pessoa pp on pp.cd_pes=cd_export_hea
where convert(datetime, dt_saida_mea, 105) >= convert(Datetime, '01/09/2004',105)
group by month(convert(datetime,dt_saida_mea,105)) ,CEILING((CAST(LEFT(DT_SAIDA_MEA,2)  as money)/7)) , org.nome_local, dst.nome_local 
,dbo.StrGM_Grupo(apelido, cd_consig_hea)

GO
