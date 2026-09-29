SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	
CREATE procedure [dbo].[spATL_FreteIAeIM]--'','',''

	@Pessoa	varchar(50),
	@Dt_inicial datetime,
	@Dt_final datetime

AS
	select 
		HOU.num_proc_him JOB,
		FRT.vlr_org_hia [Valor Frete], 
		dbo.valor(PRO.vlr_org_hia,PRO.dc_hia) [Valor Divisao de Lucros],
		LO.nome_local	[Origem]
		from house_imp_mar HOU
		join vwCta_Cte FRT on HOU.num_proc_him = FRT.num_proc_hia and FRT.cd_tp_tx='FRT' and FRT.dc_hia='D'
		join vwCta_Cte PRO on HOU.num_proc_him = PRO.num_proc_hia and PRO.cd_tp_tx in ('PBD','PSA','DVC')
		join pessoa P on cd_pes = HOU.cd_consig_him
		join LLP_imp_mar LLP on LLP.num_proc_lim = HOU.num_proc_him
		join Localidade LO on LLP.cd_planta_lim = LO.cd_local
	where 
		P.apelido like @Pessoa and
		convert(datetime,dt_emis_him,103) between @dt_inicial and @dt_final

--	P.apelido like 'dupont%'
--	and convert(datetime,dt_emis_him,103) > '2011-01-01'

	union all

	select 
		HOU.num_proc_hia JOB,
		FRT.vlr_org_hia [Valor Frete], 
		dbo.valor(PRO.vlr_org_hia,PRO.dc_hia) [Valor Divisao de Lucros],
		LO.nome_local	[Origem]
		from house_imp_aer HOU
		join vwCta_Cte FRT on HOU.num_proc_hia = FRT.num_proc_hia and FRT.cd_tp_tx='FRT' and FRT.dc_hia='D'
		join vwCta_Cte PRO on HOU.num_proc_hia = PRO.num_proc_hia and PRO.cd_tp_tx in ('PBD','PSA','DVC')
		join pessoa P on cd_pes = HOU.cd_consig_hia
		join LLP_imp_aer LLP on LLP.num_proc_lia = HOU.num_proc_hia
		join Localidade LO on LLP.cd_planta_lia = LO.cd_local
	where 
		P.apelido like @Pessoa
		and convert(datetime,dt_emis_hia,103) between @dt_inicial and @dt_final

--	P.apelido like 'dupont%'
--	and convert(datetime,dt_emis_hia,103) > '2011-01-01'

--
--
--select num_proc_hia,vlr_org_hia from vwcta_cte V
--	join house_imp_mar HOU on HOU.num_proc_him = V.num_proc_hia
--	join pessoa P on cd_pes = HOU.cd_consig_him
--where P.apelido like 'dupont%'
--and cd_tp_tx='FRT' and dc_hia='D'
--and convert(datetime,dt_emis_him,103) > '2011-01-01'
--
--select V.num_proc_hia, vlr_org_hia from vwcta_cte V
--	join house_imp_aer HOU on HOU.num_proc_hia = V.num_proc_hia
--	join pessoa P on cd_pes = HOU.cd_consig_hia
--where P.apelido like 'dupont%'
--and cd_tp_tx='FRT' and dc_hia='D'
--and convert(datetime,dt_emis_hia,103) > '2011-01-01'
--
--select num_proc_hia,dbo.valor(vlr_org_hia,dc_hia) from vwcta_cte V
--	join house_imp_mar HOU on HOU.num_proc_him = V.num_proc_hia
--	join pessoa P on cd_pes = HOU.cd_consig_him
--where P.apelido like 'dupont%'
--and cd_tp_tx in ('PBD','PSA','DVC')
--and convert(datetime,dt_emis_him,103) > '2011-01-01'
--
--select V.num_proc_hia,dbo.valor(V.vlr_org_hia,V.dc_hia) from vwcta_cte V
--	join house_imp_aer HOU on HOU.num_proc_hia = V.num_proc_hia
--	join pessoa P on cd_pes = HOU.cd_consig_hia
--where P.apelido like 'dupont%'
--and cd_tp_tx in ('PBD','PSA','DVC')
--and convert(datetime,dt_emis_hia,103) > '2011-01-01'
GO
