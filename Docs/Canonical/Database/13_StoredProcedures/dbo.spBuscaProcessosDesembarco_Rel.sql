SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from E_MIX_XML

CREATE  procedure [dbo].[spBuscaProcessosDesembarco_Rel]


AS

	SET NOCOUNT ON;
	--select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	--where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
	----and excprocesso = 'IMCSR20081124001' ---and substring(excprocesso,3,7) = 'CSR2013'
	--and substring(excprocesso,3,3) in ('CSR')
	--group by  excprocesso 
	
	
	--Union ALL


	select distinct excprocesso Job,max(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	Join Tarefas_Processos TP with(nolock) on TP.num_proc=excprocesso and dt_conclusao >=getdate()-20 and id_task in (4,59) 
	where    excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
	--and ExcProcesso = 'IMSLA201506008BR'
	group by  excprocesso 
	
		union all
	/*
	select distinct excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	Join Hist_Geral_UltimoHistorico HU with(nolock) on HU.HSGProcesso=excprocesso and  HSGData >=getdate()-4 and Disp_Cliente = 'S'
	where    excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16  and SUBSTRING(ExcProcesso,3,3)  not in ('GVD','GVA')--('GVD','GVA','LVS') 
	group by  excprocesso 
	
	Union ALL
	*/
	--select distinct excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	--Join Tarefas_Processos TP with(nolock) on TP.num_proc=excprocesso and id_task in (4) and dt_conclusao >=getdate()-3
	--where    excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
	--group by  excprocesso 
	
	--UNION ALL
	
	select distinct excprocesso Job,max(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	Join vwcliente VW with(nolock) on VW.num_proc=excprocesso and Data >=getdate()-3
	where   excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16  and left(excprocesso,1) = 'E'
	group by  excprocesso --order by 3 desc,2 

	Union
	
		select distinct excprocesso Job,max(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	Join vwcliente VW with(nolock) on VW.num_proc=excprocesso and Data between GETDATE()-10 and GETDATE()+10
	where   excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16  and left(excprocesso,1) = 'I'
	group by  excprocesso order by 3 desc,2 
	

/*
	select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	where   excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 and substring(excprocesso,3,7) = 'CSR2013'
	--and substring(excprocesso,3,3) in ('FMC') --and left(excprocesso,1)='I'

	group by  excprocesso order by 3 desc,2 
*/
--	select excprocesso Job,min(excdataalt) Data from exchange with(nolock) where  excreportmanager is null and excdataalt>=getdate()-30  and left(excprocesso,2)='EM' group by  excprocesso order by 2
	--seelct excprocesso from exchange where 
/*

	select excprocesso Job from exchange where excreportmanager is null and  excprocesso like 'I%ROB2011%'    group by  excprocesso,excdataalt order by excdataalt

	select distinct 
		(select top 1 excdataalt from atlantis.dbo.exchange where excprocesso = E1.excprocesso order by 1 desc) excdataalt, excprocesso JOB
	from 
		atlantis.dbo.exchange E1 
	where 
		excreportmanager is null
	order by 1
*/


























GO
