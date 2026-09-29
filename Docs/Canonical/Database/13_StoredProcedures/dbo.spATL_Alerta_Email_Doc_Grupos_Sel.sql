SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Alerta_Email_Doc_Grupos_Sel]--'Chegada de Docs'
	@Nome_Task	varchar(50)
AS	
	select distinct 
		convert(varchar(1),'') [Select],
		Apelido [Group Name] 
		
	from Pessoa P
	left join Tipo_Tarefas T on P.cd_pes=T.cd_pes_grupo or T.Cd_Pes_Grupo = '10017'
	join Grupo G with(nolock) on G.cd_pes_grupo=P.cd_pes
where 	
	Ativo = 'S'
	and Nome_Task = @Nome_Task
	and Cd_Pes <> '10017'
	and P.Desat_Pes = 'N'
	
union all
	select convert(varchar(1),'') [Select],'ALL GROUPS' [Group Name]
	

	order by apelido
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
/*teste
ALTER Procedure [dbo].[spATL_Alerta_Email_Doc_Grupo_Sel]--'Pre-Alert Sending'
	@Nome_Task	varchar(50)
AS	
	select distinct 
		Apelido 
	from Pessoa P
	left join Tipo_Tarefas T  on P.cd_pes=T.cd_pes_grupo or T.Cd_Pes_Grupo = '10017'
	left join Alerta_Email_Doc_Automatico A on A.id_task = T.id_task and A.Cd_Pes_Grupo = T.Cd_Pes_Grupo
	join Grupo	G with(nolock) on G.cd_pes_grupo=P.cd_pes
where 	
	T.Ativo = 'S'
	and T.Nome_Task = @Nome_Task	
	and A.id_task is null
	order by apelido
*/
			
		
		




GO
