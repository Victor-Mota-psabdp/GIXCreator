SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT LBO.Id_TP_Servico,* FROM LLP_BDP_OUT LBO
--	join House_BDP_OUT H on H.Num_Proc_HBO = LBO.Num_Proc_LBO
--	join Campo_Processo cp on cp.Num_Proc = lbo.Num_Proc_LBO and id_campo =143
--	left join JOB_HBO J on J.Num_Proc_HBO =LBO.Num_Proc_LBO
--WHERE
--	J.Num_Proc is null  and LBO.Id_TP_Servico = 1
--	and ID_Status <> 9
	
--select * from Tipo_Campo_Cliente where Descr_Campo like '%product%'	
CREATE procedure [dbo].[spATL_JOB_BO_Amarrado_Sel]--'BOCSR201804004BR'
(
	@JOB varchar(16)
)
as

select V.Num_Proc , HAWB, MAWB,V.ID_Status  from vwALL_JOBs V with(nolock) 
	left join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO COLLATE DATABASE_DEFAULT =V.Num_Proc COLLATE DATABASE_DEFAULT
	left join JOB_HBO J on J.Num_Proc_HBO =LBO.Num_Proc_LBO
where 
	V.Num_Proc = @JOB		
	and
	(
		J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		or
		J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
	)

GO
