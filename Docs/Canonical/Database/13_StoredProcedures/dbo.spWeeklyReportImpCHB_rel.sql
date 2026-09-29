SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spWeeklyReportImpCHB_rel] --'07-01-2008','07-31-2008'
		@DataInicial	Varchar(10),
		@DataFinal		VarChar(10)

as

select 
	'Air' Modal, Nome_Local,Isnull(Canal_LIA,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao) between 1 and 3 then '1-3'
		when  dbo.quantidade_dias(Ata_lia,Dt_conclusao) between 4 and 6 then '4-6'
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao)  between 7 and 10 then '7-10'
		When  dbo.quantidade_dias(Ata_lia,Dt_conclusao) > 10 then '>10'
	end
Faixa
,
count(Num_Proc_Lia) Processo,
'LCL' Tipo_Carga,
month(dt_conclusao) Mes,
Isnull(Id_DC,0) LI
from 
	llp_imp_aer
	Join House_imp_aer hou on hou.num_proc_hia=num_proc_lia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Tarefas_Processos TF on num_proc_lia=TF.num_proc and TF.ID_Task=4 and TF.Dt_conclusao is not null
	Left Join PO_HIA LI on num_proc_lia=li.num_proc_hia and Id_dc=23
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATA_LIA is not null

Group by 	Nome_Local,Isnull(Canal_LIA,'Verde'),
	cast((Dt_Conclusao - ATA_Lia) as int),	 
Isnull(Canal_LIA,'Green') ,dt_conclusao,
	ATA_LIA, Isnull(Id_DC,0) 

UNION ALL

select 
	'Sea' Modal, Nome_Local,Isnull(Canal_LIm,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 1 and 3 then '1-3'
		when  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 4 and 6 then '4-6'
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) between 7 and 10 then '7-10'
		When  dbo.quantidade_dias(Ata_lim,Dt_conclusao) > 10 then '>10'
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
	cast((Dt_Conclusao - ATA_Lim) as int),	Case 
		When  cast((Dt_Conclusao - ATA_Lim) as int) between 1 and 3 then '1-3'
		when  cast((Dt_Conclusao - ATA_Lim) as int) between 4 and 6 then '4-6'
		When  cast((Dt_Conclusao - ATA_Lim) as int) between 7 and 10 then '7-10'
		When  cast((Dt_Conclusao - ATA_Lim) as int) > 10 then '>10'
	end, Isnull(Canal_LIM,'Green'),Nome_Tp_Carga, dt_conclusao,ata_lim,
	Isnull(Id_DC,0) 

UNION all

select 
	'Truck' Modal, Nome_Local,Isnull(Canal_LIO,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao) between 1 and 3 then '1-3'
		when  dbo.quantidade_dias(Ata_lio,Dt_conclusao) between 4 and 6 then '4-6'
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao) between 7 and 10 then '7-10'
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao) > 10 then '>10'
	end
Faixa
,
count(Num_Proc_LiO) Processo,
'LCL',
month(dt_conclusao) Mes,
Isnull(Id_DC,0) LI

from 
	llp_imp_out
	Join House_imp_out hou on hou.num_proc_hio=num_proc_lio
	Join Localidade DST on DST.cd_local=cd_dst_hio
	Join Tarefas_Processos TF on num_proc_lio=TF.num_proc and TF.ID_Task=4 and TF.Dt_conclusao is not null
	Left Join PO_HIO LI on num_proc_lio=LI.num_proc_hio and ID_DC=23
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATA_LIO is not null
	and tipo_lio='T'
Group by 	Nome_Local,Isnull(Canal_LIO,'Green'),
	cast((Dt_Conclusao - ATA_Lio) as int),	Case 
		When  cast((Dt_Conclusao - ATA_Lio) as int) between 1 and 3 then '1-3'
		when  cast((Dt_Conclusao - ATA_Lio) as int) between 4 and 6 then '4-6'
		When  cast((Dt_Conclusao - ATA_Lio) as int) between 7 and 10 then '7-10'
		When  cast((Dt_Conclusao - ATA_Lio) as int) > 10 then '>10'
	end, Isnull(Canal_LIo,'Green'),dt_conclusao,
	ATA_LIO,Isnull(Id_DC,0)

UNION ALL 

select 
	'Rail' Modal, Nome_Local,Isnull(Canal_LIO,'Green') Canal,
	Case 
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao) between 1 and 3 then '1-3'
		when  dbo.quantidade_dias(Ata_lio,Dt_conclusao) between 4 and 6 then '4-6'
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao)  between 7 and 10 then '7-10'
		When  dbo.quantidade_dias(Ata_lio,Dt_conclusao) > 10 then '>10'
	end
Faixa
,
count(Num_Proc_LiO) Processo,
'LCL',month(dt_conclusao),
Isnull(Id_DC,0) LI
from 
	llp_imp_out
	Join House_imp_out hou on hou.num_proc_hio=num_proc_lio
	Join Localidade DST on DST.cd_local=cd_dst_hio
	Join Tarefas_Processos TF on num_proc_lio=TF.num_proc and TF.ID_Task=4 and TF.Dt_conclusao is not null
	Left Join PO_HIO LI on num_proc_lio=li.num_proc_hio and ID_DC=23
Where
	TF.Dt_Conclusao between @DataInicial and @DataFinal AND ATA_LIO is not null
	and tipo_lio='R'
Group by 	Nome_Local,Isnull(Canal_LIO,'Green'),
	cast((Dt_Conclusao - ATA_Lio) as int),	Case 
		When  cast((Dt_Conclusao - ATA_Lio) as int) between 1 and 3 then '1-3'
		when  cast((Dt_Conclusao - ATA_Lio) as int) between 4 and 6 then '4-6'
		When  cast((Dt_Conclusao - ATA_Lio) as int) between 7 and 10 then '7-10'
		When  cast((Dt_Conclusao - ATA_Lio) as int) > 10 then '>10'
	end, Isnull(Canal_LIo,'Green'), dt_conclusao,ata_lio,
Isnull(Id_DC,0) 






GO
