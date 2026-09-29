SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Tarefas_Processos_Alerta
CREATE procedure [dbo].[spATL_Log_Tarefas_Processos_Alerta_Sel] 
(	
	@ID_Alerta			bigint,
	@Num_Proc			varchar(16),
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

--sp_help Log_Tarefas_Processos_Alerta
IF @Tipo = 'A' or @Tipo = 'B' 
	Begin
		select distinct	
			TP.Id_Log				[Code],
			TP.ID_Alerta			[Alert Code],
			TP.Num_Proc				[JOB],
			TP.ID_Task				[Task Type Code],
			TT.Nome_Task			[Task Type Name],
			TP.Dt_Conclusao			[Conclusion Date],
			TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Ins				[Insert Date],
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],	
			TP.Dt_Log				[Log Date],
			TP.Log_Message			[Message]			
		from Log_Tarefas_Processos_Alerta   TP	with(nolock)	
			join Tipo_Tarefas				TT  with (nolock) on TP.Id_Task = TT.Id_Task and TT.Modal = LEFT(TP.Num_Proc,2)
			Join Usuario					US	with (nolock) on TP.cd_usuario=US.cd_usuario	
		Where
			TP.ID_Alerta =@ID_Alerta 		
	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select distinct	
			TP.Id_Log				[Code],
			TP.ID_Alerta			[Alert Code],
			TP.Num_Proc				[JOB],
			TP.ID_Task				[Task Type Code],
			TT.Nome_Task			[Task Type Name],
			TP.Dt_Conclusao			[Conclusion Date],
			TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Ins				[Insert Date],
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],	
			TP.Dt_Log				[Log Date],
			TP.Log_Message			[Message]			
		from Log_Tarefas_Processos_Alerta   TP	with(nolock)	
			join Tipo_Tarefas				TT  with (nolock) on TP.Id_Task = TT.Id_Task and TT.Modal = LEFT(TP.Num_Proc,2)
			Join Usuario					US	with (nolock) on TP.cd_usuario=US.cd_usuario	
		Where
			TP.ID_Alerta =@ID_Alerta and TP.Num_Proc =@Num_Proc 
	End






GO
