SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [Remessa_Boleto] where nome_usuario like 'edilani%'
--sp_help [Remessa_Boleto]
--alter table Boleto add cd_banco varchar(3)
--alter table [Remessa_Boleto] alter column [remessa_file_name] varchar(250)
CREATE PROCEDURE [dbo].[spATL_Remessa_Boleto_InsUpd]
(
	@cd_usuario_emissao_txt		VARCHAR(6),
	@arquivo_txt				VARCHAR(250),
	@cd_boleto					VARCHAR(8),
	@RemessaHeaderLine			VARCHAR(400),
	@RemessaDetailLine			VARCHAR(400),
	@Cd_Boleto_Digito			VARCHAR(8)
)
AS  

BEGIN
	UPDATE 
		boleto 
	SET 
		dt_emissao_txt = GETDATE(),
		cd_usuario_emissao_txt = @cd_usuario_emissao_txt,
		arquivo_txt = @arquivo_txt
	WHERE 
		cd_boleto = @cd_boleto
END

if Not exists(select cd_boleto from [Remessa_Boleto] where cd_boleto = @cd_boleto)
	INSERT INTO [dbo].[Remessa_Boleto]
		(
			[cd_boleto],[remessa_dt_picture],[remessa_cd_user_picture],[remessa_file_name],[remessa_header_line],[remessa_detail_line],
			[remessa_footer_ine],[Cd_Boleto_Digito]
		)
	Values
		(
			@cd_boleto,getdate(),@cd_usuario_emissao_txt,@arquivo_txt,@RemessaHeaderLine,@RemessaDetailLine,
			null,@Cd_Boleto_Digito
		)
GO
