SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE vIEW vwExpAer

as
select apelido,sum(peso_tax) Peso,month(convert(datetime,dt_saida_mea,105)) Mes,year(convert(datetime,dt_saida_mea,105)) Ano  from house_exp_aer hou
Join Pessoa PP on pp.cd_pes=cd_export_hea
Join master_exp_aer mas on mas.num_proc_mea=left(hou.num_proc_hea,14)
where year(convert(datetime,dt_saida_mea,105)) > 2006 and left(hou.num_proc_hea,5) <> 'EADES'
Group by 

apelido,month(convert(datetime,dt_saida_mea,105)) ,year(convert(datetime,dt_saida_mea,105)) 
GO
