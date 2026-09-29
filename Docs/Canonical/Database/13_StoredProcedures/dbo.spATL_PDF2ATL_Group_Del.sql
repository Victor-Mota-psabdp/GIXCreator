SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PDF2ATL_Group
CREATE procedure [dbo].[spATL_PDF2ATL_Group_Del]
(
	@Id_Dc			int,
	@Cd_Pes_Grupo	varchar(10),	
	@CD_TP_MODAL	char(2)
)
as
	
	
	BEGIN TRANSACTION

		update 
			PDF2ATL_Group 
		set 
			ativo = 0
		where
			CD_TP_MODAL = @CD_TP_MODAL and ID_DC = @ID_DC and Cd_Pes_Grupo = @cd_pes_grupo

		if @@Error <> 0
			Begin
				ROLLBACK TRANSACTION
				Return -1
			End

	COMMIT TRANSACTION

GO
