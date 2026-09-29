SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spSaidaRMShipperMAster_Rel] 
	@Num_Proc varchar(16)
	as	
		
		select SHP.Apelido	 Master from house_exp_aer HOU with(nolock)
		left join Master_Exp_Aer MAS with(nolock) on MAS.Num_Proc_MEA = HOU.Num_Proc_Mea
		left join Pessoa SHP		with(nolock)  on SHP.cd_Pes = MAS.cd_Export_mea
		where num_proc_hea = @Num_Proc and HOU.num_proc_mea <> 'JOB'
	
	union all

		select SHP.Apelido	 Master from house_exp_mar HOU with(nolock)
		left join Master_Exp_Mar MAS with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_Mem
		left join Pessoa SHP	with(nolock)	 on SHP.cd_Pes = MAS.cd_Export_mem
		where num_proc_hem = @Num_Proc and HOU.num_proc_mem <> 'JOB'
	
	union all
	
		select SHP.Apelido	 Master from house_imp_aer HOU with(nolock)
		left join Master_Imp_Aer MAS with(nolock) on MAS.Num_Proc_MIA = HOU.Num_Proc_Mia
		left join Pessoa SHP		with(nolock) on SHP.cd_Pes = MAS.cd_Export_mia
		where num_proc_hia = @Num_Proc and HOU.num_proc_mia <> 'JOB'

	union all

		select SHP.Apelido	 Master from house_imp_mar HOU with(nolock)
		left join Master_Imp_MAR MAS with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_Mim
		left join Pessoa SHP		with(nolock)  on SHP.cd_Pes = MAS.cd_Export_mim
		where num_proc_him = @Num_Proc and HOU.num_proc_mim <> 'JOB'




GO
