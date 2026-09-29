SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure [dbo].[spBuscaProcessos_Rel]
AS

	SET NOCOUNT ON;
	
	select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
	--and excprocesso like ('%CSR%')
	group by  excprocesso order by 2
	
--select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
--	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
--	and substring(excprocesso,3,3) in ('FMC')
--	group by  excprocesso 
--	union all



--select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
--	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
--	and substring(excprocesso,3,3) in ('OXT','RHO')
--	group by  excprocesso 
--	union all 


--select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
--	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
--	and substring(excprocesso,3,3) in ('CSR','FMC')
--	group by  excprocesso 
--	union all 
	

--select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
--	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
--	and substring(excprocesso,3,3) not in ('CSR','FMC','OXT','RHO') and excprocesso <> 'IMUPL201610023BR'

--	group by  excprocesso



























GO
