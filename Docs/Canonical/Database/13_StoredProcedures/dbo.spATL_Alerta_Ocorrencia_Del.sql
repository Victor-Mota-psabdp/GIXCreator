SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Alerta_Ocorrencia
CREATE procedure [dbo].[spATL_Alerta_Ocorrencia_Del]
(
	@Cd_Pes_Grupo	varchar(10),
	@Cd_Tp_Ocor		int,
	@Modal			char(2),
	@Ativo			Bit
)
as
	
	
	BEGIN TRANSACTION

		--DELETE	from 
		--	Alerta_Ocorrencia 
		--where
		--	Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo
		update Alerta_Ocorrencia 
			set ativo = @Ativo
		where
			Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo

		if @@Error <> 0
			Begin
				ROLLBACK TRANSACTION
				Return -1
			End

	COMMIT TRANSACTION

GO
