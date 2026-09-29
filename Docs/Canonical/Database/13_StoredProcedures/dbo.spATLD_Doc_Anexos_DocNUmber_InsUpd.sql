SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SP_HELP Doc_Anexos
CREATE procedure [dbo].[spATLD_Doc_Anexos_DocNUmber_InsUpd]
(
	@Item_Doc 	int,
	@Num_Proc	VarChar(16),
	@Id_DC		int,
	@Nome_Arquivo Varchar(30),
	@Cd_Usuario varchar(6),
	@Numero_Doc Varchar(200)
)

AS

BEGIN TRANSACTION
	
	Declare @Multiplos varchar(1)
	Set @Multiplos =  (select isnull(Multiplos,'N') from Tipo_Doc_Cliente with(nolock) where ID_DC=@Id_DC)
	if @Multiplos ='S'
		begin
			Set @Item_Doc = (select Item_Doc from Doc_Anexos with(nolock) where Num_Proc = @Num_Proc and Id_DC = @Id_DC and Item_Doc = @Item_Doc)
		end
	else
		begin
			Set @Item_Doc = (select Item_Doc from Doc_Anexos with(nolock) where Num_Proc = @Num_Proc and Id_DC = @Id_DC)
		End

	--Set @Item_Doc = (select Item_Doc from Doc_Anexos where Num_Proc = @Num_Proc 
	--				and Id_DC = @Id_DC)

	if @Item_Doc is not null
		BEGIN
			UPDATE
				Doc_Anexos
			SET
				Nome_Arquivo = @Nome_Arquivo,
				Dt_Envio = null,
				Cd_Usuario = @Cd_Usuario,
				Anexado_Em = getdate(),
				Numero_Doc = @Numero_Doc
			WHERE
				Item_Doc = @Item_Doc and Num_Proc = @Num_Proc and Id_DC = @Id_DC
		END
	ELSE
		BEGIN
			SET @Item_Doc=(select Isnull(max(Item_Doc),0)+1 from Doc_Anexos where Num_Proc=@Num_Proc)
			INSERT INTO
				Doc_Anexos
				(
					Num_Proc,Item_Doc,Id_DC,Nome_Arquivo,Cd_Usuario,Anexado_Em,dt_creacao,
					cd_usuario_creacao,Numero_Doc				
				)
			VALUES
				(
					@Num_Proc,@Item_Doc,@Id_DC,@Nome_Arquivo,@Cd_Usuario,getdate(),getdate(),
					@Cd_Usuario,@Numero_Doc
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION














GO
