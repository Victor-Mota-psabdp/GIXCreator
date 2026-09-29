SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Termo_Container
CREATE VIEW [dbo].[vwTermo_Container_Sel]
AS
Select cd_termo [Code], empresa [Complete Name] from Termo_Container with(nolock)

GO
