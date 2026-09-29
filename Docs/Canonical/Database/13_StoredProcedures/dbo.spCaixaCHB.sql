SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spCaixaCHB

AS


select Isnull(convert(varchar(10),ETA_LIA,103),dt_Cheg_mia) DAta, nome_raz_soc,hou.num_proc_hia,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_hia,dc_hia) Valor from caixa_hou_imp_aer CXA
Join house_imp_aer hou on hou.num_proc_hia=cxa.num_proc_hia
Join pessoa pp on pp.cd_pes=cd_consig_hia
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_IMP_AER LLP on llp.num_proc_lia=hou.num_proc_hia
Join Master_Imp_Aer MAS on MAS.num_proC_mia=hou.num_proc_mia
Where
	Convert(Datetime,dt_emis_hia,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_HIA IN (SELECT DISTINCT NUM_PROC_HIA FROM CTA_CTE_HOU_IMP_AER WHERE CONVERT(DATETIME,DT_INS_HIA,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

UNION ALL

select Isnull(convert(varchar(10),ETA_LIM,103),dt_ATRAC_MIM) DAta, nome_raz_soc,hou.num_proc_him,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_him,dc_him) Valor from caixa_hou_imp_mar CXA
Join house_imp_mar hou on hou.num_proc_him=cxa.num_proc_him
Join pessoa pp on pp.cd_pes=cd_consig_him
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_IMP_mar LLP on llp.num_proc_LIM=hou.num_proc_him
Join Master_Imp_mar MAS on MAS.num_proC_MIM=hou.num_proc_MIM
Where
	Convert(Datetime,dt_emis_him,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_him IN (SELECT DISTINCT NUM_PROC_him FROM CTA_CTE_HOU_IMP_mar WHERE CONVERT(DATETIME,DT_INS_him,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

UNION ALL

select (convert(varchar(10),ETA_LIO,103)) DAta, nome_raz_soc,hou.num_proc_HIO,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_HIO,dc_HIO) Valor from caixa_hou_imp_OUT CXA
Join house_imp_OUT hou on hou.num_proc_HIO=cxa.num_proc_HIO
Join pessoa pp on pp.cd_pes=cd_consig_HIO
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_IMP_OUT LLP on llp.num_proc_LIO=hou.num_proc_HIO
Where
	Convert(Datetime,dt_emis_HIO,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_HIO IN (SELECT DISTINCT NUM_PROC_HIO FROM CTA_CTE_HOU_IMP_OUT WHERE CONVERT(DATETIME,DT_INS_HIO,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

UNION ALL

select Isnull(convert(varchar(10),ETD_LEA,103),dt_SAIDA_MEA) DAta, nome_raz_soc,hou.num_proc_HEA,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_HEA,dc_HEA) Valor from caixa_hou_EXP_aer CXA
Join house_EXP_aer hou on hou.num_proc_HEA=cxa.num_proc_HEA
Join pessoa pp on pp.cd_pes=cd_export_HEA
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_EXP_AER LLP on llp.num_proc_LEA=hou.num_proc_HEA
Join Master_EXP_Aer MAS on MAS.num_proC_MEA=hou.num_proc_MEA
Where
	Convert(Datetime,dt_emis_HEA,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_HEA IN (SELECT DISTINCT NUM_PROC_HEA FROM CTA_CTE_HOU_EXP_AER WHERE CONVERT(DATETIME,DT_INS_HEA,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

UNION ALL

select Isnull(convert(varchar(10),ETD_LEM,103),dt_SAIDA_MEM) DAta, nome_raz_soc,hou.num_proc_HEM,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_HEM,dc_HEM) Valor from caixa_hou_EXP_mar CXA
Join house_EXP_mar hou on hou.num_proc_HEM=cxa.num_proc_HEM
Join pessoa pp on pp.cd_pes=cd_export_HEM
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_EXP_mar LLP on llp.num_proc_LEM=hou.num_proc_HEM
Join Master_EXP_mar MAS on MAS.num_proC_MEM=hou.num_proc_MEM
Where
	Convert(Datetime,dt_emis_HEM,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_HEM IN (SELECT DISTINCT NUM_PROC_HEM FROM CTA_CTE_HOU_EXP_mar WHERE CONVERT(DATETIME,DT_INS_HEM,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

UNION ALL

select (convert(varchar(10),ETD_LEO,103)) DAta, nome_raz_soc,hou.num_proc_HEO,Nome_Tp_tx,dbo.valor(vlr_pgto_rcto_HEO,dc_HEO) Valor from caixa_hou_EXP_OUT CXA
Join house_EXP_OUT hou on hou.num_proc_HEO=cxa.num_proc_HEO
Join pessoa pp on pp.cd_pes=cd_export_HEO
Join Tipo_Taxa TT on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join LLP_EXP_OUT LLP on llp.num_proc_LEO=hou.num_proc_HEO
Where
	Convert(Datetime,dt_emis_HEO,105) > '01-01-2008' and num_lcto <> 'PROVISÓRIO'
	AND CXA.NUM_PROC_HEO IN (SELECT DISTINCT NUM_PROC_HEO FROM CTA_CTE_HOU_EXP_OUT WHERE CONVERT(DATETIME,DT_INS_HEO,105) > '01-01-2008' AND LEFT(CD_TP_tX,1)='X')

GO
