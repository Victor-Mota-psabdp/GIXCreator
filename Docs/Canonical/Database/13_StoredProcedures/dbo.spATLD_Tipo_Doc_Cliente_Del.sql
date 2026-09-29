SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_Cliente
CREATE procedure [dbo].[spATLD_Tipo_Doc_Cliente_Del]
(
	@ID_DC INT
)
as
	--if exists(select ID_DC from Tipo_Doc_Cliente where ID_DC= @ID_DC)
	----BEGIN
	----	delete Tipo_Doc_Cliente where ID_DC= @ID_DC
	----END

GO
