SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spServico_HBO_InsUpd]
			
	@ID_Servico_HBO			int,
	@Numero_Servico_HBO		Varchar(80),
	@Data_Servico_HBO		Datetime,
	@Num_Proc_HBO			VarChar(16),
	@Nome_Servico			VarChar(100),
	@cd_usuario				varchar(20)

AS

BEGIN TRANSACTION

	
	Declare @ID_Servico Int
	set @ID_Servico = (select ID_Servico from Servico where Nome_servico=@Nome_Servico)
	
	Declare @ID Int
	set @ID = (select ID_Servico_HBO from Servico_HBO where Id_Servico=@Id_Servico and Num_Proc_HBO=@Num_Proc_HBO)

	if @ID is not null
		BEGIN
			UPDATE
				Servico_HBO
			SET
				Data_Servico_HBO = @Data_Servico_HBO,
				Numero_Servico_HBO = @Numero_Servico_HBO,
				Id_Servico = @Id_Servico,
				cd_usuario = @cd_usuario, 
				dt_ins = getdate()
			WHERE
				ID_Servico_HBO = @ID and Num_Proc_HBO = @Num_Proc_HBO
		END
	ELSE
		BEGIN
			--SET @ID=(select Isnull(max(ID_Servico_HBO),0)+1 from Servico_HBO where Num_Proc_HBO=@Num_Proc_HBO)
			INSERT INTO
				Servico_HBO
				(
					Num_Proc_HBO,ID_Servico_HBO,Numero_Servico_HBO,Data_Servico_HBO,Id_Servico,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HBO,@ID_Servico_HBO,@Numero_Servico_HBO,@Data_Servico_HBO,@Id_Servico,@cd_usuario,getdate()
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION
	















GO
