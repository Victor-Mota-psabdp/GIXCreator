SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Tarefas
--select * from Tipo_Tarefas where nome_task  ='Solicitação de LI'
--[spATLDN_Tipo_Tarefas_Sel] NULL,'IM','P000031345','Solicitação de LI','Q'
CREATE procedure [dbo].[spATLDN_Tipo_Tarefas_Sel]--'','','B'
(	
	@ID_Task			int,
	@CD_TP_MODAL		varchar(2),
	@Cd_Pes_Grupo		varchar(10),
	@Nome_Task			varchar(30),
	@Tipo				char(1)
)
as
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
S e L para Solicitacao de LI
*/

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		order by 1,2
	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.ID_Task = @ID_Task
		order by 1,2
	End
	
IF @Tipo = 'N' 
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.ID_Task = @ID_Task and T.Modal = @CD_TP_MODAL
		order by 1,2
	End

IF @Tipo = 'O'
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.ID_Task = @ID_Task and T.Modal = @CD_TP_MODAL
			and T.Ativo = 'S'
		order by 1,2
	End	

IF @Tipo = 'P' 
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.Nome_Task = @Nome_Task and T.Modal = @CD_TP_MODAL
			and T.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and T.Ativo = 'S'
		order by 1,2
	End	

IF @Tipo = 'Q'
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.Nome_Task = @Nome_Task and T.Modal = @CD_TP_MODAL
			and (T.Cd_Pes_Grupo = @Cd_Pes_Grupo or  T.Cd_Pes_Grupo = '10017')
			and T.Ativo = 'S'
		order by 1,2
	End		

IF @Tipo = 'R'
	Begin
		select
			T.id_task				[Code], 
			T.nome_task				[Task Name],
			T.Modal					[Modal Type Code],			
			M.Nome_TP_MODAL			[Modal Type Name],
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
			tipo_tarefas T with (nolock)
			join pessoa G with (nolock) on G.cd_pes = T.cd_pes_grupo
			left join Tipo_Modal_Imp_Exp M with (nolock) on M.CD_TP_MODAL = T.Modal
			left join Tipo_Data D with (nolock) on D.Nome_tp_data = T.Tipo_Data
			left join Usuario U with (nolock) on U.Cd_Usuario = T.Cd_Usuario
		where			
			T.ID_Task = @ID_Task and T.Modal = @CD_TP_MODAL
			and (T.Cd_Pes_Grupo = @Cd_Pes_Grupo or  T.Cd_Pes_Grupo = '10017')
			and T.Ativo = 'S'
		order by 1,2
	End	

--if @Tipo = 'Z' 
--	Begin
--		select 
--			Cd_Tp_Ocor				[Code],
--			Nome_Tp_Ocor			[Occurrence Type Name],
--			Previsao_Obrigatoria	[Mandatory Forecast Date],
--			Permite_Dias_Anteriores [Allows Previous Days]
--		from 
--			Tipo_Tarefas with(nolock)
--		where 
--			Nome_Tp_Ocor = @Nome_Tp_Ocor AND Cd_Tp_Ocor <> @Cd_Tp_Ocor
--	End	
	


GO
