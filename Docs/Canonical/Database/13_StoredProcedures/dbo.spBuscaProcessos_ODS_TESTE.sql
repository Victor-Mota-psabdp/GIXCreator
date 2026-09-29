SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBuscaProcessos_ODS_TESTE]
AS

	SET NOCOUNT ON;

	select top 14000 excprocesso Processo,min(excdataalt) Data from ATL_INT.dbo.Exchange_ODS O with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	where O.excdtenvio is null 
		and len(O.excprocesso)=16 
		and ExcDataAlt = '2017-09-08 17:38:14.643'
	group by  O.excprocesso order by 2
	/*
	ExcProcesso = 'IMCSR201512277BR' and
	excprocesso  in ('IMFMC201407037BR',
'IMCSR201409258BR',
'EMCSR201409035BR',
'IMCSR201304485BR',
'IMCSR201409283BR',
'IMFMC201407061BR',
'IACBT201409001BR',
'IACBT201409003BR',
'IOCSR201409010BR',
'IMCSR201409392BR',
'IOCSR201408038BR',
'EAOXT201403001BR') and 
*/
----	select excprocesso Job,min(excdataalt) Data from exchange with(nolock) where  excreportmanager is null and excdataalt>=getdate()-30  and left(excprocesso,2)='EM' group by  excprocesso order by 2

/*

	select excprocesso Job from exchange where excreportmanager is null and  excprocesso like 'I%ROB2011%'    group by  excprocesso,excdataalt order by excdataalt

	select distinct 
		(select top 1 excdataalt from atlantis.dbo.exchange where excprocesso = E1.excprocesso order by 1 desc) excdataalt, excprocesso JOB
	from 
		atlantis.dbo.exchange E1 
	where 
		excreportmanager is null
	order by 1
	
	select * from exchange where excprocesso='EMOXT201601103BR'
*/


























GO
