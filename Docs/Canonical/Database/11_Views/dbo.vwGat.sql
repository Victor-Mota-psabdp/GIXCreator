SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view vwGat

as


select org.nome_local + '-' + dst.nome_local TradeLine, org.nome_local Origem, month(convert(datetime,dt_cheg_mia,105)) Mes, sum(peso_real_hia) Peso, count(num_proc_hia) Embarques from house_imp_aer hou
Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Join localidade org on org.cd_local=cd_org_mia
Join localidade dst on dst.cd_local=cd_dst_mia

where left(num_proc_hia,5)<>'IAJOB'
	and convert(datetime,dt_cheg_mia,105) >='01-01-2005'
	and org.pais_local in ('EUA', 'Estados Unidos', 'USA')
group by
	month(convert(Datetime,dt_cheg_mia,105)),org.nome_local,dst.nome_local



GO
