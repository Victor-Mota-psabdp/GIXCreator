SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Status_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Status_Retificacao_Del]
(
	@ID_Status		BigInt
)
as

Begin Transaction

	UPDATE 
		Tipo_Status_Retificacao
	SET 
		ATIVO = 0 
	where 
		ID_Status= @ID_Status
		
Commit Transaction

GO
