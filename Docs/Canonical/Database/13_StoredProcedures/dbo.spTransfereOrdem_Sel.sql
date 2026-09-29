SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTransfereOrdem_Sel] 
	
AS

	select distinct
		num_proc_him JOB 
	from house_imp_mar  hou
		join llp_imp_mar lim with(nolock)on Lim.num_proc_lim = HOU.num_proc_him
		Join Pessoa_LLP PLLP with(nolock) on PLLP.cd_pes=cd_consig_him 
		join pedido_ship PS with(nolock) on PS.num_proc = HOU.num_proc_him
	where 
		Num_proc_mim = 'JOB' 
		and convert(datetime,dt_emis_him,103) > '2012-01-01'
		and (PLLP.cd_pes_grupo = '1' or PLLP.cd_pes_grupo = 'P19015' or PLLP.cd_pes_grupo = 'P20904')
		and (isnull(id_status,0) in (1,2,3,4))

GO
