SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view vwRobertoReport

AS


SELECT 
	'Air Import' Modal,ORG.NOME_LOCAL ORIGEM, DST.NOME_LOCAL DESTINO, 
	sUM(dbo.spresultado_mas(num_proc_hia) + DBO.SPRESULTADO(NUM_PROC_HIA)) Valor,
	month(convert(datetime,dt_cheg_mia,105)) Mes, Year(convert(datetime,dt_cheg_mia,105)) Ano,
	PP.NOME_RAZ_SOC CONSIGNEE,SH.NOME_RAZ_SOC SHIPPER, SUM(peso_BRUTO_hia) PESO, count(num_proc_hia) EMB,'LCL' Tipo,
	0 TEUS


FROM HOUSE_IMP_AER HOU
JOIN MASTER_IMP_AER MAS ON MAS.NUM_PROC_MIA=HOU.NUM_PROC_MIA
JOIN LOCALIDADE ORG ON ORG.CD_LOCAL=CD_ORG_HIA
JOIN LOCALIDADE DST ON DST.CD_LOCAL=CD_DST_HIA
JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIA
JOIN PESSOA SH ON SH.CD_PES=CD_EXPORT_HIA
where converT(datetime,dt_cheg_mia,105) > = '01-01-2007'
 
and num_proc_hia not like 'IACSR%'

group by
	ORG.NOME_LOCAL,DST.NOME_LOCAL,Year(convert(datetime,dt_cheg_mia,105)) ,MONTH(convert(datetime,dt_cheg_mia,105)),
	PP.NOME_RAZ_SOC, SH.NOME_RAZ_SOC


union all


SELECT 
	'Air Export',ORG.NOME_LOCAL ORIGEM, DST.NOME_LOCAL DESTINO, 
	sUM(dbo.spresultado_mas(num_proc_HEA) + DBO.SPRESULTADO(NUM_PROC_HEA)) Valor,
	month(convert(datetime,dt_SAIDA_MEA,105)) Mes, Year(convert(datetime,dt_SAIDA_MEA,105)) Ano,
	PP.NOME_RAZ_SOC CONSIGNEE,SH.NOME_RAZ_SOC SHIPPER, SUM(peso_BRUTO_HEA) PESO, count(num_proc_HEA) EMB,'LCL' Tipo,
	0 TEUS


FROM HOUSE_EXP_AER HOU
JOIN MASTER_EXP_AER MAS ON MAS.NUM_PROC_MEA=HOU.NUM_PROC_MEA
JOIN LOCALIDADE ORG ON ORG.CD_LOCAL=CD_ORG_HEA
JOIN LOCALIDADE DST ON DST.CD_LOCAL=CD_DST_HEA
JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HEA
JOIN PESSOA SH ON SH.CD_PES=CD_EXPORT_HEA
where converT(datetime,dt_SAIDA_MEA,105) > = '01-01-2007'
 
and num_proc_HEA not like 'EACSR%'

group by
	ORG.NOME_LOCAL,DST.NOME_LOCAL,Year(convert(datetime,dt_SAIDA_MEA,105)) ,MONTH(convert(datetime,dt_SAIDA_MEA,105)),
	PP.NOME_RAZ_SOC, SH.NOME_RAZ_SOC

union all

SELECT 
	'Sea Import',ORG.NOME_LOCAL ORIGEM, DST.NOME_LOCAL DESTINO, 
	sUM(dbo.spresultado_mas(num_proc_him) + DBO.SPRESULTADO(NUM_PROC_him)) Valor,
	month(convert(datetime,dt_atrac_MIM,105)) Mes, Year(convert(datetime,dt_atrac_MIM,105)) Ano,
	PP.NOME_RAZ_SOC CONSIGNEE,SH.NOME_RAZ_SOC SHIPPER, SUM(peso_BRUTO_him) PESO, count(num_proc_him) EMB,'LCL' Tipo,
	sum(dbo.fbusca_TEUS(num_proc_him)) TEUS


FROM HOUSE_IMP_mar HOU
JOIN MASTER_IMP_mar MAS ON MAS.NUM_PROC_MIM=HOU.NUM_PROC_MIM
JOIN LOCALIDADE ORG ON ORG.CD_LOCAL=CD_ORG_him
JOIN LOCALIDADE DST ON DST.CD_LOCAL=CD_DST_him
JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_him
JOIN PESSOA SH ON SH.CD_PES=CD_EXPORT_him
where converT(datetime,dt_atrac_MIM,105) > = '01-01-2007'
 
and num_proc_him not like 'EmCSR%'

group by
	ORG.NOME_LOCAL,DST.NOME_LOCAL,Year(convert(datetime,dt_atrac_mim,105)) ,MONTH(convert(datetime,dt_atrac_mim,105)),
	PP.NOME_RAZ_SOC, SH.NOME_RAZ_SOC

union all


SELECT 
	'Sea Export',ORG.NOME_LOCAL ORIGEM, DST.NOME_LOCAL DESTINO, 
	sUM(dbo.spresultado_mas(num_proc_hem) + DBO.SPRESULTADO(NUM_PROC_hem)) Valor,
	month(convert(datetime,dt_Saida_mem,105)) Mes, Year(convert(datetime,dt_Saida_mem,105)) Ano,
	PP.NOME_RAZ_SOC CONSIGNEE,SH.NOME_RAZ_SOC SHIPPER, SUM(peso_BRUTO_hem) PESO, count(num_proc_hem) EMB,'LCL' Tipo,
	sum(dbo.fbusca_TEUS(num_proc_hem)) TEUS


FROM HOUSE_exp_mar HOU
JOIN MASTER_exp_mar MAS ON MAS.NUM_PROC_mem=HOU.NUM_PROC_mem
JOIN LOCALIDADE ORG ON ORG.CD_LOCAL=CD_ORG_hem
JOIN LOCALIDADE DST ON DST.CD_LOCAL=CD_DST_hem
JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_hem
JOIN PESSOA SH ON SH.CD_PES=CD_EXPORT_hem
where converT(datetime,dt_Saida_mem,105) > = '01-01-2007'
 
and num_proc_hem not like 'EmCSR%'

group by
	ORG.NOME_LOCAL,DST.NOME_LOCAL,Year(convert(datetime,dt_Saida_mem,105)) ,MONTH(convert(datetime,dt_Saida_mem,105)),
	PP.NOME_RAZ_SOC, SH.NOME_RAZ_SOC

GO
