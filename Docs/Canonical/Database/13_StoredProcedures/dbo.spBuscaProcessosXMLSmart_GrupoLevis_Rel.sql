SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBuscaProcessosXMLSmart_GrupoLevis_Rel]
AS

	SET NOCOUNT ON;

	select top 1400 excprocesso Processo,min(excdataalt) Data from exchange with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc=excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null	
	where  
	--excdtenvio is null and	
	len(excprocesso)=16 
	and substring(excprocesso,3,3) = 'LVS'
	and left(excprocesso,2) not in('EA','IA','EM','IM','IO','EO') 	
	group by  excprocesso order by 2
	
	--select 'IALVS201409001BR' processo union all 
	--select 'IALVS201409002BR' union all 
	--select 'IMLVS201408001BR' union all 
	--select 'IMLVS201409001BR'
	
--select * from exchange  where excprocesso = 'IALVS201409002BR' order by 4 desc
--dt_envio_
	
	
	



























GO
