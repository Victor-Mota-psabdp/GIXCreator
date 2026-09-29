SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spEmb_Rel 

		@datainicial 	varchar(10),
		@datafinal	varchar(10)
AS


SELECT
	'IA' Modal,count(num_proc_hia) Emb 
FROM
	house_imp_aer hou
	Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
Where
	left(num_proc_hia,5)<> 'IAJOB' and
	convert(datetime, dt_cheg_mia, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


UNION ALL


SELECT
	'EA' Modal,count(num_proc_hEa) Emb 
FROM
	house_EXp_aer hou
	Join master_EXP_aer mas on mas.num_proc_mEa=hou.num_proc_mEa
Where
	left(num_proc_hEa,5)<> 'EAJOB' and
	convert(datetime, dt_SAIDA_mEa, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


UNION ALL


SELECT
	'EM' Modal,count(num_proc_hEM) Emb 
FROM
	house_EXp_MAr hou
	Join master_EXP_MAr mas on mas.num_proc_mEM=hou.num_proc_mEM
Where
	left(num_proc_HEM,5)<> 'EMJOB' and
	convert(datetime, dt_SAIDA_mEM, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

	
UNION ALL

SELECT
	'IM' Modal,count(num_proc_hIM) Emb 
FROM
	house_IMP_MAr hou
	Join master_IMP_MAr mas on mas.num_proc_mIM=hou.num_proc_mIM
Where
	left(num_proc_HIM,5)<> 'IMJOB' and
	convert(datetime, dt_ATRAC_mIM, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)
		

GO
