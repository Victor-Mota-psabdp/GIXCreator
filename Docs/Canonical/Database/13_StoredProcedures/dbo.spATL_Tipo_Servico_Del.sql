SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Servico
CREATE procedure [dbo].[spATL_Tipo_Servico_Del]
(
	@Id_TP_Servico		bigint
)
as
	update Tipo_Servico set ativo = 'N' where Id_TP_Servico= @Id_TP_Servico

GO
