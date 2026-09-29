SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spJobxGrupo_Rel] 

as

Begin	
	select 
		LLP.Num_Proc_LIM									Job,
		apelido,
		TERM.Nome_terminal									Terminal,
		ata_lim												ata,
		cast(getdate() - ata_lim as int)					dia,
		dbo.fBusca_TipoDocCliente ('D',LLP.Num_Proc_LIM,5)	DtDi,
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,4)				DtDesembaraco

	from llp_imp_mar LLP
		join grupo			G on g.grupo = right(left(num_proc_lim,5),3)
		join pessoa			P on p.cd_pes = g.cd_pes_grupo
		join terminal		TERM on TERM.cd_terminal = LLP.cd_terminal
		left join localidade Loc on Loc.cd_local = LLP.cd_dstfinal_lim
		
	where 
		ata_lim is not null
		and dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,4) >= getdate()-2
		--and dbo.fBusca_Tarefa(LLP.Num_Proc_LIM,7) is null
		and LLP.cd_dstfinal_lim = 'SSZ'

	union all

	select 
		LLP.Num_Proc_LIA									Job,
		apelido,
		TERM.Nome_terminal									Terminal,
		ata_lia												ata,
		cast(getdate() - ata_lia as int)					dia,
		dbo.fBusca_TipoDocCliente ('D',LLP.Num_Proc_LIA,5)	DtDi,	
		dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,4)				DtDesembaraco
		
	from llp_imp_aer LLP
		join grupo		G on g.grupo = right(left(num_proc_lia,5),3) 
		join pessoa		P on p.cd_pes = g.cd_pes_grupo
		join terminal	TERM on TERM.cd_terminal = LLP.cd_terminal
	where 
		ata_lia is not null
		--and dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,4) >= getdate()-2
		and dbo.fBusca_Tarefa(LLP.Num_Proc_LIA,7) is null
End




GO
