SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from FMC_Miro where Dt_Envio > GETDATE() -10
--08/07/2019 12:28
CREATE Procedure [dbo].[spFMCMiro_InsUpd]

		@Id_Miro	Int,
		@NF_Miro	Varchar(20),
		@Dt_Envio	Datetime,
		@Status		Char(1),
		@Dt_Retorno	Datetime,
		@Fatura_PC	Varchar(17),
		@Vlr_Miro	Float,
		@ID_Evento	char(1),
		@ID_New		Int	Output
AS

Begin Transaction

IF @ID_Evento = 'I'
 SET @Dt_Envio = GETDATE()

	if @id_miro is null
		Begin	
			Set @Id_New=(select isnull(max(id_miro),0)+1 from fmc_miro)
			INSERT INTO
				FMC_MIRO
					(
						ID_Miro,
						NF_Miro,
						Dt_Envio,
						Status,
						Dt_Retorno,
						Fatura_PC,
						Vlr_Miro,
						ID_Evento
					)
				VALUES
					(
						@ID_NEW,
						@NF_Miro,
						@Dt_Envio,
						@Status,
						@Dt_Retorno,
						@Fatura_PC,
						@Vlr_Miro,
						@ID_Evento
					)
		End

	ELSE
		
		BEGIN
			set @ID_New = @Id_Miro

			UPDATE 
				FMC_MIRO
			SET
				NF_Miro=@NF_Miro,
				Dt_Envio=@Dt_Envio,
				Status=@Status,
				Dt_Retorno=@Dt_Retorno,
				Fatura_PC=@Fatura_PC,
				Vlr_Miro=@Vlr_Miro,
				ID_Evento=@ID_Evento
			WHERE
				ID_MIRO=@ID_MIRO
		END
	
	update fmc_miro set status='E' where id_miro=@ID_New and Dt_Envio <'09-01-2013'

	
	if @ID_Evento='F' 
		Begin
			update fmc_miro set status='E' where id_miro=@ID_New
		End



	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION				



GO
