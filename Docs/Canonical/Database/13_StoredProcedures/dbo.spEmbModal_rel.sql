SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spEmbModal_rel
		( 
			@DataInicial 	Varchar(10),
			@DataFinal	Varchar(10)
		)

AS

Select
	'Exportação Aérea' Modal,dbo.strGM_Grupo(Apelido,cd_consig_hea) Cliente,month(convert(Datetime,dt_saida_mea,105)) Mes, year(convert(datetime,dt_saida_mea,105)) Ano, count(num_proc_hea) Emb
From 
	House_exp_aer hOU
	Join Master_exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
Where
	convert(Datetime,dt_saida_mea,105) between @DataInicial and @DataFinal
Group by
	dbo.strGM_Grupo(Apelido,cd_consig_hea) ,month(convert(Datetime,dt_saida_mea,105)) , year(convert(datetime,dt_saida_mea,105))

UNION ALL

Select
	'Exportação Marítima' Modal,Apelido Cliente,month(convert(Datetime,dt_saida_mem,105)) Mes, year(convert(datetime,dt_saida_mem,105)) Ano, count(num_proc_hem) Emb
From 
	House_exp_MAR hOU
	Join Master_exp_MAR mas on mas.num_proc_mem=hou.num_proc_mem
	Join Pessoa pp on pp.cd_pes=cd_export_hem
Where
	convert(Datetime,dt_saida_mem,105) between @DataInicial and @DataFinal
Group by
	Apelido ,month(convert(Datetime,dt_saida_mem,105)) , year(convert(datetime,dt_saida_mem,105))

UNION ALL

Select
	'Importação Marítimo' Modal, Apelido Cliente,month(convert(Datetime,dt_Atrac_mim,105)) Mes, year(convert(datetime,dt_atrac_mim,105)) Ano, count(num_proc_him) Emb
From 
	House_imp_mar hOU
	Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join Pessoa pp on pp.cd_pes=cd_import_him
Where
	convert(Datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal
Group by
	Apelido,month(convert(Datetime,dt_atrac_mim,105)) , year(convert(datetime,dt_atrac_mim,105))


UNION ALL

Select
	'Importação Aéreo' Modal, Apelido Cliente,month(convert(Datetime,dt_cheg_mia,105)) Mes, year(convert(datetime,dt_cheg_mia,105)) Ano, count(num_proc_hia) Emb
From 
	House_imp_aer hOU
	Join Master_imp_Aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
Where
	convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal
Group by
	Apelido,month(convert(Datetime,dt_cheg_mia,105)) , year(convert(datetime,dt_cheg_mia,105))



GO
