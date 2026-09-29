SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_LI
CREATE procedure [dbo].[spATL_Tipo_LI_Del](
	@ID_Tipo	int
)
as
	delete Tipo_LI where ID_Tipo= @ID_Tipo

GO
