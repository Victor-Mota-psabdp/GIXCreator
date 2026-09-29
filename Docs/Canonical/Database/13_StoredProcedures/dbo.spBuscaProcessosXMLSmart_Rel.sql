SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBuscaProcessosXMLSmart_Rel]
AS

	SET NOCOUNT ON;

	select top 1400 excprocesso Processo,min(excdataalt) Data from exchange with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc=excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	--where  excdtenvio is null and len(excprocesso)=16 and left(excprocesso,2) not in('EA','IA','EM','IM','IO','EO')  group by  excprocesso order by 2
	where  excdtenvio is null 
	and len(excprocesso)=16 
	and ExcProcesso in ('EMATL201508007BR',
'EMATL201605027BR',
'EMATL201606050BR',
'EMOXT20100804201',
'EMOXT20101120601',
'EMOXT201103084BR',
'EMOXT201104017BR',
'EMOXT201108130BR',
'EMOXT201112111BR',
'EMOXT201206131BR',
'EMOXT201208181BR',
'EMOXT201210153BR',
'EMOXT201304139BR',
'EMOXT201306085BR',
'EMOXT201306145BR',
'EMOXT201404248BR',
'EMSEL201203001BR',
'EMSEL201205005BR') 
	group by  excprocesso order by 2
--	select excprocesso Job,min(excdataalt) Data from exchange with(nolock) where  excreportmanager is null and excdataalt>=getdate()-30  and left(excprocesso,2)='EM' group by  excprocesso order by 2

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
