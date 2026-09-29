SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help FTP_Interfaces
CREATE   procedure [dbo].[spATL_FTP_Interfaces_InsUpd]
(
	@ID_FTP				int,
	@FTP_Descricao		VARCHAR(500),
	@FTP_END			VARCHAR(100),
	@Usuario			VARCHAR(60),
	@Senha				VARCHAR(50),
	@Pasta_Origem		VARCHAR(200),
	@Pasta_Lidos		VARCHAR(200),
	@Host				VARCHAR(200),
	@Port				int,
	@Destination_Folder	VARCHAR(200)
)
AS  
  
BEGIN TRANSACTION
  
	IF EXISTS (SELECT ID_FTP FROM FTP_Interfaces WHERE ID_FTP = @ID_FTP)  
		BEGIN  
			UPDATE  
				FTP_Interfaces   
			SET  
				FTP_Descricao = @FTP_Descricao,
				FTP_END=@FTP_END,
				Usuario=@Usuario,
				Senha=@Senha,
				Pasta_Origem=@Pasta_Origem,
				Pasta_Lidos=@Pasta_Lidos,
				Host = @Host,
				Port =@Port
			WHERE  
				ID_FTP = @ID_FTP

		END
	ELSE  
		BEGIN   
			INSERT FTP_Interfaces
			(  
				FTP_Descricao,FTP_END,Usuario,Senha,Pasta_Origem,Pasta_Lidos,Host,Port
			)  
			VALUES  
			(  
				@FTP_Descricao,@FTP_END,@Usuario,@Senha,@Pasta_Origem,@Pasta_Lidos,@Host,@Port			
			)  
		END  
  
COMMIT TRANSACTION


GO
