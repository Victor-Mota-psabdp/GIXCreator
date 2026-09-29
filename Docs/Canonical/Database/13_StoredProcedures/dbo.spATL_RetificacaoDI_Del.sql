SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Retificacao_DI
CREATE procedure [dbo].[spATL_RetificacaoDI_Del]
(
	@Num_Proc			varchar(16),
	@Id_Tp_Proc_Adm		BigInt
)
as

Begin Transaction

	UPDATE 
		Retificacao_DI
	SET 
		ATIVO = 0 
	where 
		NUM_PROC = @Num_Proc and Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm	
		
Commit Transaction

GO
