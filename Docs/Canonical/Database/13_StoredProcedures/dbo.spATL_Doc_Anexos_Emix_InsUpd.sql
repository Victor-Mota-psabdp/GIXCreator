SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Doc_Anexos_Emix_InsUpd]

	@Num_Proc	VarChar(16),
	@Item_Doc 	int,
	@Nome_Doc	Varchar(25),
	@Nome_Arquivo Varchar(30),
	@Status Varchar(200),
	@Usuario	Varchar(30)

AS

BEGIN TRANSACTION

	Declare @Id_DC	int
	Declare @Cd_Usuario varchar(6)

	Set @Cd_Usuario = (select top 1 Cd_Usuario from Usuario with(nolock) where Nome_Usuario=@Usuario and Ck_Ativo='1')
	Set @Id_DC = (select Id_DC from Tipo_Doc_Cliente with(nolock) where nome_dc=@Nome_Doc)
	Set @Item_Doc = (select Item_Doc from Doc_Anexos_Emix with(nolock) where Num_Proc = @Num_Proc and Id_DC = @Id_DC 
					and Nome_Arquivo = @Nome_Arquivo)--and Status = @Status)

--sp_help Doc_Anexos_Emix
	if @Item_Doc is not null
		BEGIN
			UPDATE
				Doc_Anexos_Emix
			SET
				--Nome_Arquivo = @Nome_Arquivo,
				Status = @Status
				--Dt_Envio = null,
				--Cd_Usuario = @Cd_Usuario,
				--Dt_ins = getdate()
			WHERE
				Item_Doc = @Item_Doc and Num_Proc = @Num_Proc and Id_DC = @Id_DC
						and Nome_Arquivo = @Nome_Arquivo
		END
	ELSE
		BEGIN
			SET @Item_Doc=(select Isnull(max(Item_Doc),0)+1 from Doc_Anexos_Emix with(nolock) where Num_Proc=@Num_Proc
				and Id_DC = @Id_DC )
			INSERT INTO
				Doc_Anexos_Emix
				(
					Num_Proc,
					Item_Doc,	
					Id_DC,
					Nome_Arquivo,
					Status,
					Cd_Usuario,
					Dt_Ins
					
				)
			VALUES
				(
					@Num_Proc,
					@Item_Doc,
					@Id_DC,
					@Nome_Arquivo,
					@Status,
					@Cd_Usuario,
					getdate()
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION







GO
