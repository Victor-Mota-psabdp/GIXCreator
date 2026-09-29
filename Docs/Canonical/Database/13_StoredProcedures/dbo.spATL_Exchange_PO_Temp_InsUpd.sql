SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Exchange_PO_Temp_InsUpd]
(
	@ID						BIGINT,				
	@ID_House_Temp			varchar(200),
	@Intl_Reference			varchar(200),
	@Num_Proc				varchar(200),	
	@Dt_Ins					Datetime,
	@Dt_Envio				Datetime,
	@Dt_Retorno				Datetime,
	@Dt_Atd  				Datetime,
	@Dt_Booking				Datetime
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Exchange_PO_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from Exchange_PO_Temp where ID = @ID)
		BEGIN
			insert into Exchange_PO_Temp
			(
				ID,ID_House_Temp,Intl_Reference,Num_Proc,Dt_Ins,Dt_Envio,Dt_Retorno,Dt_Atd,Dt_Booking
			)
			Values
			(
				@ID,@ID_House_Temp,@Intl_Reference,@Num_Proc,Getdate(),@Dt_Envio,@Dt_Retorno,@Dt_Atd,@Dt_Booking
			)			
			set @ID_New = @ID;			
		END
	else
		BEGIN
			update
				Exchange_PO_Temp
			set			
				Dt_Envio = @Dt_Envio,
				Dt_Retorno = @Dt_Retorno,
				Dt_Atd = @Dt_Atd,
				Dt_Booking = @Dt_Booking
			where				
				ID = @ID 				
				
			set @ID_New = @ID		
		END		
	
	Select @ID_New as Retorno;

		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END
GO
