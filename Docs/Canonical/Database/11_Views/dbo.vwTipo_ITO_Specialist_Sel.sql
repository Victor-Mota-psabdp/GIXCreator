SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_ITO_Specialist_Sel]
AS
select 
	ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
from Tipo_ITO_Specialist T with(nolock)
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
where
	ativo = 1


GO
