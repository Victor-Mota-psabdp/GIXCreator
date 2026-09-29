SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spReportManagerSeguro_Sel]
	@Num_Proc varchar(16)
as
	select top 1 vlr_seguro from invoice_cliente with(nolock) 
	where num_proc = @Num_Proc and left(@Num_Proc,1) = 'E'
	order by id_inv desc

GO
