SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_RetificacaoDI]
AS
SELECT 
	tp.ID_TP_RET AS ID, 
	tp.NOME_TP_RET AS Description, 
	us.Nome_Usuario AS User_Name, 
	tp.Ativo AS Enable
FROM dbo.Tipo_RetificacaoDI AS tp INNER JOIN
     dbo.Usuario AS us ON tp.Cd_Usuario = us.Cd_Usuario



GO
