SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spATL_FTP_Interfaces_Sel]
(  
	@ID_FTP				int,
	@FTP_Descricao		VARCHAR(500),	
	@Tipo				CHAR(1)  
)  
AS 

IF @Tipo = 'A' OR @Tipo = 'B'  
	BEGIN  
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
	END  
  
IF @Tipo = 'C' OR @Tipo = 'D'  
	BEGIN 
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
		WHERE 
			FTP.ID_FTP =@ID_FTP    
	END  

IF @Tipo = 'N'  OR @Tipo = 'O'  
	BEGIN  
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
		WHERE			
			FTP.FTP_Descricao = @FTP_Descricao 
	END


  

GO
