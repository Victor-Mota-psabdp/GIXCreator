SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Fatura_Consolidada
--select * from Fatura_Consolidada_Det
CREATE Procedure [dbo].[spFatura_Consolidada_InsUpd]

		@ID	 			Int,
		@Data			Datetime,
		@Grupo			VarChar(50),
		@Cliente		VarChar(50),
		@dtVencimento	Datetime,
		@cd_usuario		varchar(6),		
		@new			int output

as

BEGIN TRANSACTION
		DECLARE @CD_Grupo		VARCHAR(10)
		DECLARE @CD_Cliente		VARCHAR(10)
	
		SET @CD_Grupo=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@Grupo)
		SET @CD_Cliente=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@Cliente)
	
		IF @ID IS NULL
			BEGIN
				SET @NEW=(SELECT ISNULL(MAX(ID),0) + 1 FROM Fatura_Consolidada)
				INSERT INTO
					Fatura_Consolidada
					(
					ID,
					Data,
					Cd_grupo,
					Cd_cliente,
					dt_vencimento,
					cd_usuario,
					ativo
					)			
				VALUES
					(
					@New,
					getdate(),
					@Cd_grupo,
					@Cd_cliente,
					@dtvencimento,
					@cd_usuario,
					1
					)			
			END
		ELSE
		 	BEGIN
				UPDATE Fatura_Consolidada
					SET
						Data = @Data,
						Cd_grupo = @Cd_grupo,
						Cd_cliente = @Cd_cliente,
						dt_vencimento = @dtvencimento,
						cd_usuario = @cd_usuario			
					WHERE 
						ID=@ID
			  END
	IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION














GO
