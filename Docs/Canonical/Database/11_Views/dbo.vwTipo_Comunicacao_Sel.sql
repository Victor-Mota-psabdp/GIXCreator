SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Comunicacao_Sel]
AS
select 
	Cd_Tp_Com [Code], Nome_Tp_Com [Communication Type Name]
from Tipo_Comunicacao T with(nolock)

--SELECT     Code, [Type Contact]
--FROM         (SELECT Cd_Tp_Com AS Code,Nome_Tp_Com AS [Type Contact]
--				FROM  dbo.tipo_comunicacao) AS ALIAS
             
                       






GO
