SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Modal_Imp_Exp_Sel]
AS
select 
	CD_TP_MODAL [Code], Nome_TP_MODAL [Modal Type Name],Status [Enabled],
	T.Cd_Usuario [User Code],U.Nome_Usuario [User Name],dt_ins [Insert Date]
from Tipo_Modal_Imp_Exp T with(nolock)
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
