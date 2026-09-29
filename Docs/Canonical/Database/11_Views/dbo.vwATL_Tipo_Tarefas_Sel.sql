SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Tarefas
CREATE VIEW [dbo].[vwATL_Tipo_Tarefas_Sel]
AS
select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			M.CD_TP_MODAL			[Modal Type Code],
			T.Modal					[Modal Type Name],
			T.Ativo					[Enabled],
			T.dias					[Days], 
			D.Id_tp_data			[Type Date Code],
			T.tipo_data				[Type Date Name],
			T.Smart_Previsao		[Smart Estimated],	 
			T.Smart_Conclusao		[Smart Actual], 
			T.Cd_Pes_Grupo			[Group Code],
			G.apelido				[Group Name],
			T.Standard				[Standard],
			T.Opcional				[Opcional],
			T.Dt_Criacao			[Creation Date],
			T.cd_usuario			[User Code],
			U.Nome_Usuario			[User Name],			
			T.descr_tarefa			[Task Description],
			T.Smart_GenericDates	[Smart_GenericDates]			
		from
			Tipo_Tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		--order by 1,2

GO
