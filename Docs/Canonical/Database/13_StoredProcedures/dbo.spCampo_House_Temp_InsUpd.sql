SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ATL_INT.dbo.[Campo_House_Temp]
--sp_help Campo_House_Temp
CREATE PROCEDURE [dbo].[spCampo_House_Temp_InsUpd]
(
	@ID_TP_House_Temp	bigint,
	@Id_Campo			int,
	@Update_Field		bit,
	@Email_to_CSR		bit,
	@Historic_in_JOB	bit,
	@Enabled			bit,
	@Cd_Usuario			varchar(10),
	@Dt_Ins				datetime
)

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Container_Temp_Imp_Mar
	BEGIN TRY
	
	Declare @ID_New as bigint;
	
		if not exists(select ID_Campo from ATL_INT.dbo.[Campo_House_Temp] where ID_Campo= @ID_Campo AND
			ID_TP_House_Temp = @ID_TP_House_Temp)
			BEGIN			
				Insert into ATL_INT.dbo.[Campo_House_Temp] 
				(
					ID_TP_House_Temp,Id_Campo,Update_Field,Email_to_CSR,Historic_in_JOB,[Enabled],Cd_Usuario,Dt_Ins
				)
				Values
				(
					@ID_TP_House_Temp,@Id_Campo,@Update_Field,@Email_to_CSR,@Historic_in_JOB,@Enabled,@Cd_Usuario,getdate()
				)
				set @ID_New = @ID_TP_House_Temp;
			END
		ELSE
			BEGIN
					Update
						ATL_INT.dbo.[Campo_House_Temp]
					Set				
						Update_Field=@Update_Field,
						Email_to_CSR=@Email_to_CSR,
						Historic_in_JOB=@Historic_in_JOB,
						Enabled=@Enabled,
						Cd_Usuario=@Cd_Usuario,
						Dt_Ins=@Dt_Ins
					Where
						ID_Campo= @ID_Campo AND
						ID_TP_House_Temp = @ID_TP_House_Temp
						
					set @ID_New = @ID_TP_House_Temp
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
