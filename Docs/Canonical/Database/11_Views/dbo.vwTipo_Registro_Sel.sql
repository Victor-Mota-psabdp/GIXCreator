SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Registro_Sel]
AS
select 
	ID_Registro [Code], Descr_Registro [Register Type Name]
	from Tipo_Registro T with(nolock)

GO
