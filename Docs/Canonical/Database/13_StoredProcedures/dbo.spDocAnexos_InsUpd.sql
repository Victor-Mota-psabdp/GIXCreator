SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Doc_Anexos add dt_creacao datetime
--alter table Doc_Anexos add cd_usuario_creacao varchar(6)

CREATE procedure [dbo].[spDocAnexos_InsUpd]

	@Num_Proc	VarChar(16),
	@Item_Doc 	int,
	@Nome_Doc	Varchar(25),
	@Nome_Arquivo Varchar(30),
	@Usuario	Varchar(30)

AS

BEGIN TRANSACTION

	Declare @Id_DC	int
	Declare @Cd_Usuario varchar(6)

	Set @Cd_Usuario = (select top 1 Cd_Usuario from Usuario with(nolock) where Nome_Usuario=@Usuario and Ck_Ativo='1')
	Set @Id_DC = (select Id_DC from Tipo_Doc_Cliente with(nolock) where nome_dc=@Nome_Doc)
	Set @Item_Doc = (select Item_Doc from Doc_Anexos with(nolock) where Num_Proc = @Num_Proc and Id_DC = @Id_DC)

	if @Item_Doc is not null
		BEGIN
			UPDATE
				Doc_Anexos
			SET
				Nome_Arquivo = @Nome_Arquivo,
				Dt_Envio = null,
				Cd_Usuario = @Cd_Usuario,
				Anexado_Em = getdate()
			WHERE
				Item_Doc = @Item_Doc and Num_Proc = @Num_Proc and Id_DC = @Id_DC
		END
	ELSE
		BEGIN
			SET @Item_Doc=(select Isnull(max(Item_Doc),0)+1 from Doc_Anexos where Num_Proc=@Num_Proc)
			INSERT INTO
				Doc_Anexos
				(
					Num_Proc,
					Item_Doc,	
					Id_DC,
					Nome_Arquivo,
					Cd_Usuario,
					Anexado_Em,
					dt_creacao,
					cd_usuario_creacao
					
				)
			VALUES
				(
					@Num_Proc,
					@Item_Doc,
					@Id_DC,
					@Nome_Arquivo,
					@Cd_Usuario,
					getdate(),
					getdate(),
					@Cd_Usuario
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION







GO
