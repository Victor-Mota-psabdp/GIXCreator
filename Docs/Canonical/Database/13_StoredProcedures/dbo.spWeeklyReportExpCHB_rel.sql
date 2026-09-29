SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spWeeklyReportExpCHB_rel] --'03-01-2008','03-31-2008'
		@DataInicial	Varchar(10),
		@DataFinal		VarChar(10)

as

select 
	'Air' Modal, Nome_Local,Isnull(Canal_LEA,'Green') Canal,
	Case 
		When  cast(( ATD_LEa - Dt_Conclusao )as int) *-1  between 0 and 3 then '0-3'
		when  cast((ATD_LEa - Dt_Conclusao ) as int)*-1 between 4 and 6 then '4-6'
		When  cast((ATD_LEa - Dt_Conclusao ) as int)*-1 between 7 and 10 then '7-10'
		When  cast((ATD_LEa - Dt_Conclusao )as int)*-1  > 10 then '>10'
		When  cast((ATD_LEa - Dt_Conclusao )as int)*-1  < 0 then '0-3'

	end
Faixa
,
count(Num_Proc_LEa) Processo,
'LCL' Tipo_Carga,
month(dt_conclusao) Mes
from 
	llp_EXP_aer
	Join House_EXp_aer hou on hou.num_proc_hEa=num_proc_lEa
	Join Localidade DST on DST.cd_local=CD_ORG_HEA
	Join Tarefas_Processos TF on num_proc_lEa=TF.num_proc and TF.ID_Task=12and TF.Dt_conclusao is not null
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATD_lEA is not null

Group by 	Nome_Local,Isnull(Canal_LEA,'Verde'),
	cast((Dt_Conclusao - ATD_lEa) as int), Isnull(Canal_LEA,'Green') 
	,ATD_LEA,DT_CONCLUSAO

UNION ALL

select 
	'Sea' Modal, Nome_Local,Isnull(Canal_LEm,'Green') Canal,
	Case 
		When  cast((ATD_lEm - Dt_Conclusao ) as int)*-1 between 1 and 3 then '1-3'
		when  cast((ATD_lEm - Dt_Conclusao )as int)*-1  between 4 and 6 then '4-6'
		When  cast((ATD_lEm - Dt_Conclusao )as int)*-1  between 7 and 10 then '7-10'
		When  cast((ATD_lEm - Dt_Conclusao )as int)*-1  > 10 then '>10'
		When  cast((ATD_lEm - Dt_Conclusao )as int)*-1  < 0 then '1-3'


	end
Faixa
,
count(Num_Proc_LEm) Processo,
Nome_tp_Carga,
month(dt_conclusao) Mes
from 
	llp_EXp_mar LLP
	Join House_EXp_mar hou on hou.num_proc_hEm=num_proc_lEm
	Join Localidade DST on DST.cd_local=CD_ORG_hEm
	Join Tarefas_Processos TF on num_proc_lEm=TF.num_proc and TF.ID_Task=12and TF.Dt_conclusao is not null
	Join Tipo_Carga TC on TC.cd_tp_carga=LLp.cd_tp_carga
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATD_LEM is not null

Group by 	Nome_Local,Isnull(Canal_LEM,'Verde')
, Isnull(Canal_LEM,'Green') ,atd_LEM,DT_CONCLUSAO,
Nome_Tp_carga

UNION all

select 
	'Truck' Modal, Nome_Local,Isnull(Canal_LEO,'Green') Canal,
	Case 
		When  cast((ATD_lEO - Dt_Conclusao )as int)*-1  between 1 and 3 then '1-3'
		when  cast((ATD_lEO - Dt_Conclusao )as int)*-1  between 4 and 6 then '4-6'
		When  cast((ATD_lEO - Dt_Conclusao )as int)*-1  between 7 and 10 then '7-10'
		When  cast((ATD_lEO - Dt_Conclusao )as int)*-1  > 10 then '>10'
		When  cast((ATD_lEO - Dt_Conclusao )as int)*-1  < 0  then '1-3'


	end
Faixa
,
count(Num_Proc_LEO) Processo,
'LCL',
month(dt_conclusao) Mes
from 
	llp_EXP_out
	Join House_EXP_out hou on hou.num_proc_HEO=num_proc_LEO
	Join Localidade DST on DST.cd_local=CD_ORG_HEO
	Join Tarefas_Processos TF on num_proc_LEO=TF.num_proc and TF.ID_Task=12and TF.Dt_conclusao is not null
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATD_lEO is not null
	and tipo_LEO='T'
Group by 	Nome_Local,Isnull(Canal_LEO,'Green'), Isnull(Canal_LEO,'Green') 
			,atd_LEO,DT_CONCLUSAO
UNION ALL 

select 
	'Truck' Modal, Nome_Local,Isnull(Canal_LEO,'Green') Canal,
	Case 
		When  cast(( ATD_lEO - Dt_Conclusao )as int)*-1  between 1 and 3 then '1-3'
		when  cast((ATD_lEO - Dt_Conclusao )as int)*-1  between 4 and 6 then '4-6'
		When  cast((ATD_lEO - Dt_Conclusao)as int)*-1  between 7 and 10 then '7-10'
		When  cast((ATD_lEO - Dt_Conclusao)as int)*-1  > 10 then '>10'
	end
	Faixa
	,
count(Num_Proc_LEO) Processo,
'LCL',
month(dt_conclusao) Mes
from 
	llp_EXP_out
	Join House_EXP_out hou on hou.num_proc_HEO=num_proc_LEO
	Join Localidade DST on DST.cd_local=CD_ORG_HEO
	Join Tarefas_Processos TF on num_proc_LEO=TF.num_proc and TF.ID_Task=12and TF.Dt_conclusao is not null
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATD_lEO is not null
	and tipo_LEO='R'
Group by 	Nome_Local,Isnull(Canal_LEO,'Green'),
	cast((Dt_Conclusao - ATD_lEO) as int),	Isnull(Canal_LEO,'Green') 
	,atd_LEO,DT_CONCLUSAO




GO
