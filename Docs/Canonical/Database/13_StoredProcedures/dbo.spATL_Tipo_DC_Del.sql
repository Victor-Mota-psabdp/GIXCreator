SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_DC
CREATE procedure [dbo].[spATL_Tipo_DC_Del]
(
	@Cd_Tp_DC char(1)
)
as
	UPDATE Tipo_DC SET ATIVO= 0 where Cd_Tp_DC= @Cd_Tp_DC

GO
