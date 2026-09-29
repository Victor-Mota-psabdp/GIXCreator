SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- spATL_Armazenagem_Rel 'GRUPO DOW','2011-01-01','2011-11-30',''

CREATE Procedure [dbo].[spATL_Armazenagem_Rel]
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
AS
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	select
		LLP.Num_Proc_LIM [JOB Number], CSN.apelido [Consignee], TERM.Nome_terminal [Terminal], ata_lim [ATA Date],
		cast(getdate() - ata_lim as int) [Dias], DI.data_po_him [Data da D.I.], T4.dt_conclusao [Data Desembaraço]
	from 
		llp_imp_mar LLP with(nolock)
		join house_imp_mar HOU with(nolock) on HOU.num_proc_him = LLP.num_proc_lim
		join pessoa CSN with(nolock) on CSN.cd_pes = HOU.cd_consig_him
		join terminal TERM with(nolock) on TERM.cd_terminal = LLP.cd_terminal
		left join po_him DI with(nolock) on DI.num_proc_him = LLP.num_proc_lim and DI.id_dc = 5
		join tarefas_processos T4 with(nolock) on T4.num_proc = LLP.num_proc_lim and T4.id_task = 4
	where 
		ata_lim between @DtInicial and @DtFinal and right(left(num_proc_lim,5),3) = @Grupo
		and T4.dt_conclusao >= getdate()-2
		and LLP.cd_dstfinal_lim = 'SSZ'

	UNION ALL

	select
		LLP.Num_Proc_LIA [JOB Number], CSN.apelido [Consignee], TERM.Nome_terminal [Terminal], ata_lia [ATA Date],
		cast(getdate() - ata_lia as int) [Dias], DI.data_po_hia [Data da D.I.], T4.dt_conclusao [Data Desembaraço]
	from 
		llp_imp_aer LLP with(nolock)
		join house_imp_aer HOU with(nolock) on HOU.num_proc_hia = LLP.num_proc_lia
		join pessoa CSN with(nolock) on CSN.cd_pes = HOU.cd_consig_hia
		join terminal TERM with(nolock) on TERM.cd_terminal = LLP.cd_terminal
		left join po_hia DI with(nolock) on DI.num_proc_hia = LLP.num_proc_lia and DI.id_dc = 5
		join tarefas_processos T4 with(nolock) on T4.num_proc = LLP.num_proc_lia and T4.id_task = 4
		join tarefas_processos T7 with(nolock) on T7.num_proc = LLP.num_proc_lia and T7.id_task = 7
	where 
		ata_lia between @DtInicial and @DtFinal and right(left(LLP.num_proc_lia,5),3) = @Grupo
		and T7.dt_conclusao is NULL

	order by
		4,1



GO
