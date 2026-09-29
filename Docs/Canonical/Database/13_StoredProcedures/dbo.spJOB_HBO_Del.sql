SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spJOB_HBO_Del] 

	@Num_Proc_HBO	VarChar(16),
	@Num_Proc		VarChar(16),	
	@cd_usuario		varchar(25)
AS

BEGIN TRANSACTION

	IF EXISTS(SELECT Num_Proc_HBO FROM job_hbo H where H.Num_Proc_HBO = @Num_Proc_HBO and H.Num_proc = @Num_Proc)
		BEGIN
			delete JOB_HBO WHERE Num_Proc_HBO = @Num_Proc_HBO and Num_proc = @Num_Proc
		END
		
		
	if exists(select Id_Campo from Campo_Processo where Id_Campo=143 and Num_Proc = @Num_Proc_HBO)
		begin
			delete Campo_Processo where Num_Proc = @Num_Proc_HBO and Id_Campo=143
		end
		
	if exists(select cd_tp_oper from House_BDP_OUT where Num_Proc_HBO = @Num_Proc_HBO)
		begin
			update House_BDP_OUT set cd_tp_oper = null where Num_Proc_HBO = @Num_Proc_HBO
		end
		
	

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION

GO
