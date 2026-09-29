SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Alerta_Email_Doc_Modal_Sel 'Carregamento','Grupo Rhodia'
--select * from Tipo_Tarefas where Nome_Task = 'Carregamento'

--select * from Tipo_Tarefas where Nome_Task = '1º DEFERIMENTO' and Ativo = 'S'
CREATE Procedure [dbo].[spATL_Alerta_Email_Doc_Modal_Sel]--'1º DEFERIMENTO','Grupo Rhodia'		
	@Nome_Task	varchar(50),
	@Grupo	varchar(50)
AS	
	select distinct	modal 
	from Tipo_Tarefas TT
	left Join Grupo G on G.Cd_Pes_Grupo = TT.Cd_Pes_Grupo
	Join Pessoa P on P.Cd_Pes = G.Cd_Pes_Grupo
where 	
	Ativo = 'S'
	and Nome_Task = @Nome_Task
	and 
	(Apelido = @Grupo 
	or @Grupo = 'ALL GROUPS'
	or Apelido = 'BDP (SÃO PAULO)')
	order by Modal
			
		
		




GO
