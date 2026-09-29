SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDailyPosition]
AS
BEGIN
	select 
		HOU.navio_him					Vessel,
		HOU.viagem_him					Voyage,
		Dest.Nome_local					Dischange,
		LLP.ETA_lim						ETA,
		LLP.ETD_lim						ETD,
		ARM.nome_armador				Carrier,
		TER.nome_terminal				Berth
	
from house_imp_mar HOU
		left join job_imp_mar			JOB on JOB.Num_proc_him = HOU.Num_proc_him
		left join llp_imp_mar			LLP on LLP.num_proc_lim = HOU.num_proc_him
		left join terminal				TER on TER.cd_terminal = LLP.cd_terminal
		left join Localidade			Dest on Dest.cd_local = Hou.cd_dst_him
		left join armador				ARM	on ARM.cd_armador = JOB.cd_armador
END


GO
