SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spJOB_HBO_Disponiveis_Sel]
(
	@cd_cliente		VarChar(16)
)
AS
	select V.num_proc from vwClienteALLJOBS_BO_Sel V
		--left join JOB_HBO J on J.Num_Proc = V.num_proc
	where		
		v.cd_cliente = @cd_cliente
		--and convert(datetime,V.Dt_Criacao,103) > GETDATE() -1500
		and (V.ID_Status = 8 or V.ID_Status = 5)	
	order by 1
	
	--select V.num_proc, * from vwClienteALLJOBS V
	--	left join JOB_HBO J on J.Num_Proc_HBO = V.num_proc		
	--where
	--	V.cd_cliente = @cd_cliente	
	--	--and convert(datetime,V.Dt_Criacao,103) > GETDATE() -720
	--	and J.Num_Proc_HBO is null
	--	and (V.ID_Status = 8 or V.ID_Status = 5)
		

	
GO
