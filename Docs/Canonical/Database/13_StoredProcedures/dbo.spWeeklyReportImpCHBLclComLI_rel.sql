SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spWeeklyReportImpCHBLclComLI_rel] -- '01-01-2008','07-31-2008'
		@DataInicial	Varchar(10),
		@DataFinal		VarChar(10)

as


select 
	'Sea' Modal, Nome_Local,Isnull(Canal_LIm,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 1 and 5 then '1-5'
		when  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 6 and 10 then '6-10'
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 11 and 15 then '11-15'
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) > 15 then '>15'
	end
Faixa
,
count(Num_Proc_Lim) Processo,
Nome_Tp_Carga,
month(dt_conclusao) mes,
Isnull(Id_DC,0) LI
from 
	llp_imp_mar LLP
	Join House_imp_mar hou on hou.num_proc_him=num_proc_lim
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Tarefas_Processos TF on num_proc_lim=TF.num_proc and TF.ID_Task=4 and TF.Dt_conclusao is not null
	Join Tipo_Carga TC on TC.cd_tp_carga=LLp.cd_tp_carga
	Left Join PO_HIM LI on Num_Proc_lim=li.num_proc_him and ID_DC=23
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATA_LIm is not null

Group by 	Nome_Local,Isnull(Canal_LIm,'Verde'),
--	cast((Dt_Conclusao - ATA_Lim) as int),	Case 
--		When  cast((Dt_Conclusao - ATA_Lim) as int) between 1 and 3 then '1-3'
--		when  cast((Dt_Conclusao - ATA_Lim) as int) between 4 and 6 then '4-6'
--		When  cast((Dt_Conclusao - ATA_Lim) as int) between 7 and 10 then '7-10'
--		When  cast((Dt_Conclusao - ATA_Lim) as int) > 10 then '>10'
--	end, Isnull(Canal_LIM,'Green')
	Nome_Tp_Carga, dt_conclusao,ata_lim,
	Isnull(Id_DC,0),canal_lim








GO
