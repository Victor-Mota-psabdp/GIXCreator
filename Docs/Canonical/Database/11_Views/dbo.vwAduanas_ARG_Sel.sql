SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAduanas_ARG_Sel]
AS
select CodAduana AS Code,Nome_Aduana AS [Custom Name] from Aduanas_ARG with(nolock)
             

GO
