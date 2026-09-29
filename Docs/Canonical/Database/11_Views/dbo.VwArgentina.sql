SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view VwArgentina

as

select 'EA' Modal,apelido,count(num_proc_hea) Embarques,month(convert(Datetime,dt_saida_mea,105)) Mes,year(convert(Datetime,dt_saida_mea,105)) Ano from house_exp_aer HOU
Join Master_exp_aer  mas on mas.num_proc_mea=hou.num_proc_mea
Join Pessoa PP on cd_export_hea=pp.cd_pes
Where cd_consig_mea='10066'
and convert(Datetime,dt_saida_mea,105) >='01-01-2005'
Group by apelido,month(convert(Datetime,dt_saida_mea,105)),year(convert(Datetime,dt_saida_mea,105))

union


select 'EM' Modal,apelido,count(num_proc_hem) Embarques,month(convert(Datetime,dt_saida_mem,105)) Mes,year(convert(Datetime,dt_saida_mem,105)) Ano from house_exp_mar HOU
Join Master_exp_mar  mas on mas.num_proc_mem=hou.num_proc_mem
Join Pessoa PP on cd_export_hem=pp.cd_pes
Where cd_consig_mem='10066'
and convert(Datetime,dt_saida_mem,105) >='01-01-2005'
Group by apelido,month(convert(Datetime,dt_saida_mem,105)),year(convert(Datetime,dt_saida_mem,105))

GO
