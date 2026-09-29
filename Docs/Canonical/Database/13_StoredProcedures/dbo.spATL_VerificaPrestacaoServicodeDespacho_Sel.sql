SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_VerificaPrestacaoServicodeDespacho_Sel]
(
	@JOB varchar(16)
)
as

 select Num_Proc_HIA From vwcta_Cte where num_proc_hia=@JOB 
 and cd_Tp_Tx in ('BRO','SRV','SR2') 
 and dc_hia = 'C'
GO
