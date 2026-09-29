SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure spArmador_rel

		@datainicial	varchar(10),
		@datafinal	varchar(10)
AS

SELECT
	nome_armador,nome_tp_Cont,org.nome_local as Origem,
	dst.nome_local as Destino,count(nome_tp_cont) as Container,
	count(distinct(mas.num_proc_mem)) as Embarques  

FROM
	container_mas_Exp_mar as cc

INNER JOIN tipo_container as tc on (tc.cd_tp_cont=cc.cd_tp_cont)
INNER JOIN master_exp_mar as mas on (mas.num_proc_mem=cc.num_proc_mem)
LEFT OUTER JOIN armador as arm on (mas.cd_armador=arm.cd_armador)
INNER JOIN house_exp_mar as hou on (hou.num_proc_mem=cc.num_proc_mem)
INNER JOIN localidade as org on(org.cd_local=cd_org_mem)
INNER JOIN localidade as dst on (dst.cd_local=cd_dst_mem)

WHERE
	convert(datetime,dt_saida_mem, 105) between
	convert(datetime, @datainIcial,105) and convert(datetime,@datafinal,105)
	and nome_armador is not null

GROUP BY
	nome_armador,nome_tp_Cont,org.nome_local,dst.nome_local




GO
