SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spJobUsuario_Sel] --'con'

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	select 
		nome_usuario [User], JOB.num_proc_him JOB, convert(datetime,dt_emis_him,103) [Creation Date]
	from 
		usuario U
		left join job_imp_mar		JOB on JOB.cd_usuario = U.cd_usuario
		left join House_Imp_mar		HOU on HOU.num_proc_him = JOB.num_proc_him
	where
		right(left(JOB.num_proc_him,5),3) = @Grupo
		and convert(datetime,dt_emis_him,103) between @DtInicial and @DtFinal

	UNION ALL
	select 
		nome_usuario, JOB.num_proc_hia JOB, convert(datetime,dt_emis_hia,103) DATA
	from
		usuario U
		left join job_imp_aer		JOB on JOB.cd_usuario = U.cd_usuario
		left join house_imp_aer		HOU on HOU.num_proc_hia = JOB.num_proc_hia
	where
		right(left(JOB.num_proc_hia,5),3) = @Grupo
		and convert(datetime,dt_emis_hia,103) between @DtInicial and @DtFinal

	UNION ALL
	select
		nome_usuario, LLP.num_proc_lio JOB, convert(datetime,dt_emis_hio,103) DATA
	from
		usuario U
		left join llp_imp_out		LLP on LLP.cd_usuario = U.cd_usuario
		left join house_imp_out		HOU on HOU.num_proc_hio = LLP.num_proc_lio
	where
		right(left(LLP.num_proc_lio,5),3) = @Grupo
		and convert(datetime,dt_emis_hio,103) between @DtInicial and @DtFinal

	UNION ALL
	select 
		nome_usuario,JOB.num_proc_hem JOB, convert(datetime,dt_emis_hem,103) DATA
	from 
		usuario U
		left join job_exp_mar		JOB on JOB.cd_usuario = U.cd_usuario
		left join House_exp_mar		HOU on HOU.num_proc_hem = JOB.num_proc_hem
	where
		right(left(JOB.num_proc_hem,5),3) = @Grupo
		and convert(datetime,dt_emis_hem,103) between @DtInicial and @DtFinal

	UNION ALL
	select 
		nome_usuario,JOB.num_proc_hea JOB, convert(datetime,dt_emis_hea,103) DATA
	from 
		usuario U
		left join job_exp_aer		JOB on JOB.cd_usuario = U.cd_usuario
		left join House_exp_aer		HOU on HOU.num_proc_hea = JOB.num_proc_hea
	where
		right(left(JOB.num_proc_hea,5),3) = @Grupo
		and convert(datetime,dt_emis_hea,103) between @DtInicial and @DtFinal

	UNION ALL
	select
		nome_usuario, LLP.num_proc_leo JOB, convert(datetime,dt_emis_heo,103) DATA
	from
		usuario U
		left join llp_exp_out		LLP on LLP.cd_usuario = U.cd_usuario
		left join house_exp_out		HOU on HOU.num_proc_heo = LLP.num_proc_leo
	where
		right(left(LLP.num_proc_leo,5),3) = @Grupo
		and convert(datetime,dt_emis_heo,103) between @DtInicial and @DtFinal




GO
