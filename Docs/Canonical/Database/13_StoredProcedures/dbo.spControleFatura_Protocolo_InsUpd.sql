SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_Protocolo_InsUpd]--'','900003/2012','Admin',''

	@cd_protocolo			varchar(12),
	@cd_controlefatura		varchar(12),	
	@cd_usuario				varchar(20),	
	@cd_protocolo_Ret		varchar(12) OUTPUT

AS

	Begin Transaction	

	Declare @Lote varchar(15)
	Declare @int as int			
	
IF @cd_protocolo = ''
	
	BEGIN
			
	Set @Int=(Select isnull(max(right(left(cd_protocolo,6),5))+1,1) from Controle_Fatura_Protocolo	where year(dt_creacao) = year(getdate()))
	Set @Lote= convert(nchar(10),getdate(),103)
	Set @cd_protocolo = 'P' + right('00000'+ Cast(@int as VarChar),5) + right(@lote,5)

			INSERT
				Controle_Fatura_Protocolo(
				cd_protocolo,cd_controlefatura,email,dt_creacao,cd_usuario
				)
			Values
				(@cd_protocolo,@cd_controlefatura,'N',getdate(),@cd_usuario
				)
			
			set @cd_protocolo_Ret = @cd_protocolo
		END		
	ELSE
		BEGIN
			INSERT
				Controle_Fatura_Protocolo(
				cd_protocolo,cd_controlefatura,email,dt_creacao,cd_usuario
				)
			Values
				(@cd_protocolo,@cd_controlefatura,'N',getdate(),@cd_usuario
				)	
		END	

	

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction


GO
