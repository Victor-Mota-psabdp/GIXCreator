SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Doc_Cliente
CREATE procedure [dbo].[spATLDN_Tipo_Doc_Cliente_Del](
	@ID_DC INT
)
as
	delete Tipo_Doc_Cliente where ID_DC= @ID_DC

GO
