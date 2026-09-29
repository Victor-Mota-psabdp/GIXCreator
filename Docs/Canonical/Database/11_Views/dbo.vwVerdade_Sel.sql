SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help VERDADE
CREATE VIEW [dbo].[vwVerdade_Sel]
AS
select Id [Code],Descricao from Verdade CP with(nolock)
--select Id,Descricao from Verdade CP with(nolock)


GO
