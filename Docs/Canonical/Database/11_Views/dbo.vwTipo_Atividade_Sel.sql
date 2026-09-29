SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Atividade
CREATE VIEW [dbo].[vwTipo_Atividade_Sel]
AS
select 
	Cd_Tp_Ativ [Code], Nome_Tp_Ativ [Type of Activity Name]
from 
	Tipo_Atividade T with(nolock)

GO
