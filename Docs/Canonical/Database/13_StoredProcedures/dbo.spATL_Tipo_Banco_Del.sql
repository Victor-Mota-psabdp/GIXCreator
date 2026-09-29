SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Banco
CREATE procedure [dbo].[spATL_Tipo_Banco_Del]
(
	@id_tp_banco BIGINT
)
as
	Update Tipo_Banco SET ATIVO= 0 where id_tp_banco= @id_tp_banco

GO
