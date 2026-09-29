SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--22/02/18 - cadu - incluido o esquema do bo
create procedure [dbo].[spBuscaProcessos_ODS_OLD_Sel]
AS

	SET NOCOUNT ON;

	--select top 1400 excprocesso Processo,min(excdataalt) Data from ATL_INT.dbo.Exchange_ODS O with(nolock) 
	--Join vwcliente C with(nolock) on C.num_proc COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	--Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	--where O.excdtenvio is null 
	--	and len(O.excprocesso)=16
	--group by  O.excprocesso order by 2
	
	
	select top 1400 excprocesso Processo,min(excdataalt) Data from ATL_INT.dbo.Exchange_ODS O with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	
	left join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	left join JOB_HBO J on J.Num_Proc_HBO =LBO.Num_Proc_LBO
	where 
		O.excdtenvio is null 
		and len(O.excprocesso)=16 
		and
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
			--or
			--J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
		)
		
		and  ExcDataAlt between '2018-05-12' and '2018-05-13'
	group by  O.excprocesso order by 2
	


















GO
