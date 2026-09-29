SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spJOB_HBO_InsUpd]

	@Num_Proc_HBO	VarChar(16),
	@Num_Proc		VarChar(16),	
	@cd_usuario		varchar(25)
	
AS

BEGIN TRANSACTION

	--IF EXISTS(SELECT Num_Proc_HBO FROM job_hbo H where H.Num_Proc_HBO = @Num_Proc_HBO and H.Num_proc = @Num_Proc)
	--	BEGIN
	--		UPDATE
	--			JOB_HBO
	--		SET
	--			cd_usuario = @cd_usuario
	--		WHERE
	--			Num_Proc_HBO = @Num_Proc_HBO and Num_proc = @Num_Proc
	--	END
	--ELSE
	
	IF not EXISTS(SELECT Num_Proc_HBO FROM job_hbo H where H.Num_Proc_HBO = @Num_Proc_HBO and H.Num_proc = @Num_Proc)
		BEGIN		
			INSERT INTO				
				JOB_HBO
				(
					Num_Proc_HBO,Num_proc,cd_usuario,dt_ins					
				)
			VALUES
				(
					@Num_Proc_HBO,@Num_Proc,@Cd_Usuario,Getdate()					
				)
		END
		
	if exists(select Id_Campo from Campo_Processo where Id_Campo=143 and Num_Proc = @Num_Proc)
		begin
			if not exists(select Id_Campo from Campo_Processo where Id_Campo=143 and Num_Proc = @Num_Proc_HBO)
				begin
					insert into Campo_Processo
						select @Num_Proc_HBO,Id_Campo,Campo_Dados,GETDATE(),@cd_usuario
							from Campo_Processo where Id_Campo=143 and Num_Proc = @Num_Proc
				End
		end
	
	Declare @Cd_Tp_Oper as Varchar(3) 
	set @Cd_Tp_Oper = (select cd_tp_oper from vwClienteALLJOBS where num_proc = @Num_Proc)	
	
	if not exists(select cd_tp_oper from House_BDP_OUT where Num_Proc_HBO = @Num_Proc_HBO and cd_tp_oper = @Cd_Tp_Oper)
		begin
			update House_BDP_OUT set cd_tp_oper = @Cd_Tp_Oper where Num_Proc_HBO = @Num_Proc_HBO
		end
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION




GO
