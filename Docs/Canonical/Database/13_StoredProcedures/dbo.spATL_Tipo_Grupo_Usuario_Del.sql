SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo_Usuario
CREATE procedure [dbo].[spATL_Tipo_Grupo_Usuario_Del](
	@ID_Tp_GR_Usuario varchar(3)
)
as
	delete Tipo_Grupo_Usuario where ID_Tp_GR_Usuario= @ID_Tp_GR_Usuario

GO
