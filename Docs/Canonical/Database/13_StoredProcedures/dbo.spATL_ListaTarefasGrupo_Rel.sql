SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC spATL_ListaTarefasGrupo_Rel 'Grupo ALL'

EXEC spATL_ListaTarefasGrupo_Rel ''

EXEC spATL_ListaTarefasGrupo_Rel NULL



EXEC spATL_ListaTarefasGrupo_Rel 'GRUPO BDP'

EXEC spATL_ListaTarefasGrupo_Rel 'Grupo DOW'




*/

CREATE procedure [dbo].[spATL_ListaTarefasGrupo_Rel]
(
	@Grupo varchar(50)
)

as

declare @Cd_Grupo varchar(20)

if isnull(@Grupo,'') = ''
	Begin
		set @Cd_Grupo = '%'
	End
else if @Grupo = 'Grupo ALL'
	Begin
		set @Cd_Grupo = '%'
	End
else if @Grupo = 'GRUPO BDP'
	Begin
		set @Cd_Grupo = '10017'
	End
else if @Grupo <> 'Grupo ALL'
	Begin
		set @Cd_Grupo = (select cd_pes from Pessoa where Apelido = @Grupo)
	End
else 
	set @Cd_Grupo = '%'

Select 
ID_Task										as [Codigo da Task]
,Nome_Task									as [Nome da Task]

,case when Cd_Pes_Grupo = '10017' 
then 'TODOS' 
else cd_pes_grupo end						as [Código do Grupo]
,Case when Apelido = 'BDP (SÃO PAULO)'
then 'TODOS GRUPOS'
else Apelido end							as [Nome do Grupo]

,isnull(Modal,'')							as [Modal]
,Case when Ativo = 'S' then 'Sim'
else 'Não' end								as [Task Ativa]
,Dias										as [Qtd Dias Previsão]
,Tipo_Data									as [Tipo Data Previsão]
,isnull(Smart_Previsao,'')					as [Campo Smart Previsão]
,isnull(Smart_Conclusao,'')					as [Campo Smart Conclusao]
,isnull(Smart_GenericDates,'')				as [Campo Smart Outras Datas]

--,Standard				as []
--,Opcional				as []
--,Dt_Criacao				as []
--,Cd_Usuario				as []
--,Descr_Tarefa				as []
--,Smart_GenericDates				as []
from tipo_tarefas (nolock)
inner join Pessoa (nolock)
	on cd_pes_grupo = cd_pes

where Cd_Pes_Grupo like @Cd_Grupo

order by ID_Task,ativo
GO
