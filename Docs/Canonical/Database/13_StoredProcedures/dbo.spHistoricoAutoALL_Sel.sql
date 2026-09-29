SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spHistoricoAutoALL_Sel]

as

	select distinct
		Id_Hist_Auto, 
		(case 
			when H.Id_Task > 0 then Nome_Task
			when H.Id_Task = -1 then 'ETD'
			when H.Id_Task = -2 then 'ATD'
			when H.Id_Task = -3 then 'ETA'
			when H.Id_Task = -4 then 'ATA'
		end) Nome_Task, 
		H.Modal, 
		G.Apelido, 
		Mensagem, 
		H.Ativo 
	from
		Historico_Auto H
		left join Tipo_Tarefas T on T.Id_Task = H.Id_Task and T.Modal = H.Modal
		join Pessoa G on G.cd_pes = H.Cd_Pes_Grupo
GO
