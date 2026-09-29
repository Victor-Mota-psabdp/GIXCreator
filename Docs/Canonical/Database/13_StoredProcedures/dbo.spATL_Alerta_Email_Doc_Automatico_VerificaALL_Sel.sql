SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_VerificaALL_Sel]-- ''
(		
	@Grupo [varchar](60),
	@Nome_Task [varchar](30),
	@Modal [varchar](2),	
	@TypeOFCargo varchar(30)
	)	
AS

select ID from Alerta_Email_Doc_Automatico A with(nolock)
	join pessoa	CS  with(nolock) on CS.Cd_Pes = A.cd_pes_grupo
	join Tipo_Tarefas TT with(nolock) on TT.ID_Task =A.Id_Task
	left join Tipo_Carga TC with(nolock) on TC.Cd_Tp_Carga = A.cd_tp_carga
where
	CS.Apelido = @Grupo
	and TT.Nome_Task = @Nome_Task
	and A.Modal = @Modal
	and TC.Nome_Tp_Carga = @TypeOFCargo	
	and A.Ativo = 1

	
GO
