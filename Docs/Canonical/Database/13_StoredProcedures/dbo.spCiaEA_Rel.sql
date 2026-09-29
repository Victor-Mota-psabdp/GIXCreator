SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure spCiaEA_Rel

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)

AS

SELECT
	nome_cia_aer,org.nome_local as origem, dst.nome_local as destino,
	count(num_proc_mea) as QtyEmb, sum(peso_bruto_mea) as Peso,dst.Pais_local

FROM
	
	master_exp_aer as hou

INNER JOIN localidade as org on (org.cd_local=cd_org_mea)
INNER JOIN localidade as dst on (dst.cd_local=cd_dst_mea)
INNER JOIN cia_aerea as ca on (ca.cd_cia_aer=hou.cd_cia_aer)

WHERE
	convert(datetime,dt_saida_mea,105) between convert(datetime, @datainicial,105) and convert(datetime,@datafinal,105)


GROUP BY
	nome_cia_aer, org.nome_local,dst.nome_local,dst.Pais_local





GO
