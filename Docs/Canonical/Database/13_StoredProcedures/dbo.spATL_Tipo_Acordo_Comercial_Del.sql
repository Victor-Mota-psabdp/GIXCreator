SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Acordo_Comercial
CREATE procedure [dbo].[spATL_Tipo_Acordo_Comercial_Del]
(
	@ID_TP_AC BIGINT
)
as
	UPDATE Tipo_Acordo_Comercial SET ATIVO= 0 where ID_TP_AC= @ID_TP_AC

GO
