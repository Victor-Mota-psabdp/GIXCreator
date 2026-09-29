SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Regime_LI
CREATE VIEW [dbo].[vwTipo_Regime_LI_Sel]
AS
Select ID_Regime_LI [Code], Regime_LI_Descricao [Type of Regime] from Tipo_Regime_LI	with(nolock)

GO
