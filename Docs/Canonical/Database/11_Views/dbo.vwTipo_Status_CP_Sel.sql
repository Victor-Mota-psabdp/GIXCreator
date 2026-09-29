SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Status_CP_Sel]
AS
select 
	ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
from Tipo_Status_CP T with(nolock)
where
	ativo = 'S'

GO
