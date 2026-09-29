SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal
CREATE VIEW [dbo].[vwTipo_Modal_Sel]
AS
select 
	Id [Code],Modal [Type of Modal]
from 
	Tipo_Modal with(nolock)

GO
