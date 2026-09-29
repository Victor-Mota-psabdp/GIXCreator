SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBuscaProcessos_Rel_New]
AS

	SET NOCOUNT ON;

select excprocesso Job,min(excdataalt) Data,substring(excprocesso,6,4) from exchange with(nolock) 
	where  excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16 
	and excprocesso like ('%CSR%')
	group by  excprocesso order by 2
	
--select excprocesso Job,min(excdataalt) Data, substring(excprocesso,6,4) from exchange with(nolock) 
--	--join hist_geral HG  with(nolock)  on E.excprocesso = HG.hsgprocesso and Cd_Tp_Ocor <> 103
--	where  excreportmanager is null and excdataalt>=getdate()-30   and len(excprocesso)=16  
--	group by  excprocesso order by 2
	--select excprocesso Job,min(excdataalt) Data from exchange with(nolock)
	--where  excreportmanager is null 
	--and excdataalt>=getdate()-30   
	--and excprocesso in ('IMLYB201608001BR')
	--group by  excprocesso order by 2

























GO
