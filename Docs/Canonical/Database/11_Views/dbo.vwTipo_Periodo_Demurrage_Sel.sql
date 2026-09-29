SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Periodo_Demurrage_Sel]
AS
select Cd_Periodo AS Code,Ds_Periodo AS [Demurrage Period Type Name] from Tipo_Periodo_Demurrage with(nolock)

GO
