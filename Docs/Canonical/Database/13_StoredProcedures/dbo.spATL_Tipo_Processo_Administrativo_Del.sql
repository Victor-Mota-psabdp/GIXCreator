SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Processo_Administrativo
CREATE procedure [dbo].[spATL_Tipo_Processo_Administrativo_Del]
(
	@Id_Tp_Proc_Adm		BigInt
)
as

Begin Transaction

	UPDATE 
		Tipo_Processo_Administrativo
	SET 
		ATIVO = 0 
	where 
		Id_Tp_Proc_Adm= @Id_Tp_Proc_Adm
		
Commit Transaction

GO
