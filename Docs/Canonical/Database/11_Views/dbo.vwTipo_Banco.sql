SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Banco]
AS
SELECT 
	tp.id_tp_banco AS ID, 
	tp.nome_tp_banco AS Nome, 
	tp.Nome_full_banco AS Nome_completo,
	us.Nome_Usuario AS User_Name, 
	tp.Ativo AS Enable
FROM dbo.Tipo_Banco AS tp INNER JOIN
     dbo.Usuario AS us ON tp.Cd_Usuario = us.Cd_Usuario





GO
