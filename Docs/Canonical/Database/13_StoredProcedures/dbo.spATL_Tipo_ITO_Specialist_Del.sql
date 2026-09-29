SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_ITO_Specialist
CREATE procedure [dbo].[spATL_Tipo_ITO_Specialist_Del]
(
	@ID_TP_ITO_Specialist BIGINT
)
as
	UPDATE Tipo_ITO_Specialist SET ATIVO= 0where ID_TP_ITO_Specialist= @ID_TP_ITO_Specialist
GO
