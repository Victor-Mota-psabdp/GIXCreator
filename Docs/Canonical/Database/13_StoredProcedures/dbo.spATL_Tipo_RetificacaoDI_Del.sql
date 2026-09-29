SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_RetificacaoDI
CREATE procedure [dbo].[spATL_Tipo_RetificacaoDI_Del]
(
	@ID_TP_RET		BigInt
)
as

Begin Transaction
	UPDATE 
		Tipo_RetificacaoDI
	SET 
		ATIVO = 0 
	where 
		ID_TP_RET= @ID_TP_RET
Commit Transaction

GO
