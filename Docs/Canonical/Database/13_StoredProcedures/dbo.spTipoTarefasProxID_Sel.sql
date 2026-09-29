SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spTipoTarefasProxID_Sel]
	@Tipo char(1) --H = House, M = Master
As

	declare @ProxID int
	declare @Stop int

	set @Stop = 1
	set @ProxID = 3

	If @Tipo = 'H'
		Begin
			while (@Stop <> 0)
				Begin
					if NOT exists(select top 1 id_task from tipo_tarefas where id_task = @ProxID)
						set @Stop = 0
					else
						set @ProxID = @ProxID + 1
				End
		End
	Else
		Begin
			while (@Stop <> 0)
				Begin
					if NOT exists(select top 1 id_task from tipo_tarefas_master where id_task = @ProxID)
						set @Stop = 0
					else
						set @ProxID = @ProxID + 1
				End
		End

	select @ProxID ProxID
GO
