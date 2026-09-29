SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwTipo_NC_Cliente_Sel]
AS
SELECT     Code,[cd_grupo],Descricao,[Descricao_ENG],[Descricao_PT]
FROM         (SELECT  Cd_NC AS Code,Cd_Pes_Grupo as [cd_grupo], Descricao_nC as [Descricao]
, Descricao_NC_ENG as [Descricao_ENG], Descricao_NC_PTG as [Descricao_PT]
                       FROM          dbo.Tipo_NC_Cliente
				where Ativo = 'S') AS Alias





GO
