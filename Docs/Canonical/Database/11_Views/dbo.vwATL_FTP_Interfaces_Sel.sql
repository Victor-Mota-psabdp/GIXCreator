SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vwATL_FTP_Interfaces_Sel]  
AS  
	SELECT 
		FTP.ID_FTP,
		FTP.FTP_Descricao,			
		FTP.FTP_END,
		FTP.Usuario,
		FTP.Senha,
		FTP.Pasta_Origem,
		FTP.Pasta_Lidos,
		FTP.Host,
		FTP.Port,
		FTP.Destination_Folder
	FROM 
		FTP_Interfaces FTP (NOLOCK)			


GO
