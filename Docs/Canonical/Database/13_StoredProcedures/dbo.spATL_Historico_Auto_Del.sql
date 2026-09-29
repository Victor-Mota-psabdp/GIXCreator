SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Historico_Auto
create procedure [dbo].[spATL_Historico_Auto_Del]
(
	@ID_Task		int,
	@cd_pes_grupo	varchar(10),	
	@Modal			char(2)	
)
as
	if exists (select * from Historico_Auto where id_task = @ID_Task and Modal = @Modal and Cd_Pes_Grupo = @Cd_Pes_Grupo) 
	BEGIN
		update 
			Historico_Auto 
		set 
			Ativo = 'N' 
		where 
			id_task = @ID_Task 
			and Modal = @Modal 
			and Cd_Pes_Grupo = @Cd_Pes_Grupo
	END

GO
