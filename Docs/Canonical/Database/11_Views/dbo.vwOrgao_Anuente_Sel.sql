SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Orgao_Anuente
CREATE VIEW [dbo].[vwOrgao_Anuente_Sel]
AS
select 
	ID_Orgao [Code],
	Nome_Orgao_Anuente [Orgao Anuente Name] 
from Orgao_Anuente with(nolock)


GO
