SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spProcessosDesembaracados_Rel --'I'
(
	@Modais char(1)
)

AS

IF @Modais = 'I' 
	Begin
		select 
			Num_Proc_Lim, nome_raz_soc, DST.nome_local, month(dt_conclusao) mes
		from 
			LLP_Imp_Mar LLP
			join house_imp_mar HOU on HOU.num_proc_HIM = LLP.num_proc_lim
			left join localidade DST on DST.cd_local = HOU.cd_dst_him
			join tarefas_processos TP on TP.num_proc = LLP.num_proc_lim and id_task=4 and dt_conclusao > '2008-12-31'
			join pessoa CSN on CSN.cd_pes = cd_consig_him
		--where 
		--	cd_dst_him in ('SSZ','GRU','VCP')

		union

		select 
			Num_Proc_lia, nome_raz_soc, DST.nome_local, month(dt_conclusao) mes
		from 
			LLP_Imp_aer LLP
			join house_imp_aer HOU on HOU.num_proc_hia = LLP.num_proc_lia
			left join localidade DST on DST.cd_local = HOU.cd_dst_hia
			join tarefas_processos TP on TP.num_proc = LLP.num_proc_lia and id_task=4 and dt_conclusao > '2008-12-31'
			join pessoa CSN on CSN.cd_pes = cd_consig_hia
		--where 
		--	cd_dst_hia in ('SSZ','GRU','VCP')
		
		order by 
			4
	END

ELSE
	Begin
		select 
			Num_Proc_lem, nome_raz_soc, nome_local, month(dt_conclusao) mes
		from 
			LLP_exp_Mar LLP
			join house_exp_mar HOU on HOU.num_proc_hem = LLP.num_proc_lem
			left join localidade ORG on ORG.cd_local = HOU.cd_org_hem
			join tarefas_processos TP on TP.num_proc = LLP.num_proc_lem and id_task=4 and dt_conclusao > '2008-12-31'
			join pessoa CSN on CSN.cd_pes = cd_export_hem
		--where 
		--	cd_org_hem in ('SSZ','GRU','VCP')

		union

		select 
			Num_Proc_lea, nome_raz_soc, nome_local, month(dt_conclusao) mes
		from 
			LLP_exp_aer LLP
			join house_exp_aer HOU on HOU.num_proc_hea = LLP.num_proc_lea
			left join localidade ORG on ORG.cd_local = HOU.cd_org_hea
			join tarefas_processos TP on TP.num_proc = LLP.num_proc_lea and id_task=4 and dt_conclusao > '2008-12-31'
			join pessoa CSN on CSN.cd_pes = cd_export_hea
		--where 
		--	cd_org_hea in ('SSZ','GRU','VCP')

		order by 
			4
	END







GO
