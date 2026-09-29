SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spTransfereOrdem_Disponiveis_Sel]--'IMROB201202086BR' 
	@JOB varchar(16)
	
AS

	select distinct
		num_proc JOB, num_pedido Ordem
	from pedido P 
		join pedido_ship PS on PS.cd_pedido = P.cd_pedido		
		join llp_imp_mar LLP on LLp.num_proc_lim = PS.num_proc
		where P.cd_consignee = (select cd_consig_him from house_imp_mar where Num_proc_him = @job and convert(datetime,dt_emis_him,103) > '2012-01-01') 
			and P.cd_seller = (select cd_export_him from house_imp_mar where Num_proc_him = @job and convert(datetime,dt_emis_him,103) > '2012-01-01')
		and dt_pedido >= '2012-01-01'
		and (isnull(id_status,0) in (1,2,3,4))



GO
