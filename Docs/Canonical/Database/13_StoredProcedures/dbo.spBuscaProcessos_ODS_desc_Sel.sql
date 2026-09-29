SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--10-01-2018 - retirado o envio do BO - Cadu/Anderson 300-41549
--22/02/18 - cadu - incluido o esquema do bo
create procedure [dbo].spBuscaProcessos_ODS_desc_Sel
AS

	SET NOCOUNT ON;
	
	select   excprocesso Processo,min(excdataalt) Data from ATL_INT.dbo.Exchange_ODS O with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	
	left join LLP_BDP_OUT LBO  with(nolock) on LBO.Num_Proc_LBO COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	left join JOB_HBO J  with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO
	where 
		O.excdtenvio is null 
		and len(O.excprocesso)=16 
		and
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		)
		and left(O.ExcProcesso,2) <> 'BO'
	group by  O.excprocesso order by 2 desc
	


















GO
