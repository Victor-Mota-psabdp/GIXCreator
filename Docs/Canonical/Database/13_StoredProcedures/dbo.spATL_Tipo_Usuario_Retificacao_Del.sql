SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Usuario_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Usuario_Retificacao_Del]
(
	@ID_TP_USUARIO_RET		BigInt
)
as

Begin Transaction

	UPDATE 
		Tipo_Usuario_Retificacao
	SET 
		ATIVO = 0 
	where 
		ID_TP_USUARIO_RET= @ID_TP_USUARIO_RET
		
Commit Transaction

GO
