SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    view vwRelDESDOW

as



select LEFT(NUM_PROC,2) processo,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-ATA_LIA AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-ATA_LIA AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-ATA_LIA)AS FLOAT)) Media,canal_lia,COUNT(ATA_LIA)Quantidade,'A' TIPO from house_imp_aer HOU
Join LLP_Imp_Aer LLP on LLP.num_proC_Lia=hou.num_proc_hia
Join Tarefas_processos TF ON num_proc=hou.num_proc_hia and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_DST_HIA
WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_lia,LEFT(NUM_PROC,2)


UNION

select LEFT(NUM_PROC,2) PROCESSO,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-ATA_LIM AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-ATA_LIM AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-ATA_LIM)AS FLOAT)) Media,canal_LIM,COUNT(ATA_LIM) Quantidade,'M' from house_imp_MAR HOU
Join LLP_Imp_MAR LLP on LLP.num_proC_LIM=hou.num_proc_HIM
Join Tarefas_processos TF ON num_proc=hou.num_proc_HIM and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_DST_HIM
WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_LIM,LEFT(NUM_PROC,2)

UNION

select LEFT(NUM_PROC,2) PROCESSO,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-data_po_hio AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-data_po_hio AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-data_po_hio)AS FLOAT)) Media,canal_LIO,COUNT(ATA_LIO) Quantidade,TIPO_LIO from house_imp_OUT HOU
Join LLP_Imp_OUT LLP on LLP.num_proC_LIO=hou.num_proc_HIO
Join Tarefas_processos TF ON num_proc=hou.num_proc_HIO and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_DST_HIO
Join Po_hio PO on PO.num_proC_hio=hou.num_proc_hio and Id_DC=5
WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_LIO,LEFT(NUM_PROC,2),TIPO_LIO

union 
select LEFT(NUM_PROC,2) processo,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-ATD_lea AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-ATD_lea AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-ATD_lea)AS FLOAT)) Media,canal_lea,COUNT(ATD_lea)Quantidade,'A' TIPO from house_exp_aer HOU
Join LLP_exp_Aer LLP on LLP.num_proC_lea=hou.num_proc_hea
Join Tarefas_processos TF ON num_proc=hou.num_proc_hea and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_org_hea

WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_lea,LEFT(NUM_PROC,2)


UNION

select 
	LEFT(NUM_PROC,2) PROCESSO,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-ATD_lem AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-ATD_lem AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-ATD_lem)AS FLOAT)) Media,canal_lem,COUNT(ATD_lem) Quantidade,'M' 

from house_exp_MAR HOU
Join LLP_exp_MAR LLP on LLP.num_proC_lem=hou.num_proc_hem
Join Tarefas_processos TF ON num_proc=hou.num_proc_hem and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_org_hem
WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_lem,LEFT(NUM_PROC,2)

UNION

select LEFT(NUM_PROC,2) PROCESSO,NOME_LOCAL,MAX(CAST(DT_CONCLUSAO-ATD_leo AS FLOAT)) Maximo,MIN(CAST(DT_CONCLUSAO-ATD_leo AS FLOAT)) Minimo,AVG(CAST((DT_CONCLUSAO-ATD_leo)AS FLOAT)) Media,canal_leo,COUNT(ATD_leo) Quantidade,TIPO_leo from house_exp_OUT HOU
Join LLP_exp_OUT LLP on LLP.num_proC_leo=hou.num_proc_heo
Join Tarefas_processos TF ON num_proc=hou.num_proc_heo and TF.id_Task=4
jOIN lOCALIDADE DST ON DST.CD_LOCAL=HOU.CD_org_heo
WHERE DT_CONCLUSAO > '03-01-2008' 
GROUP BY NOME_LOCAL,Canal_leo,LEFT(NUM_PROC,2),TIPO_leo







GO
