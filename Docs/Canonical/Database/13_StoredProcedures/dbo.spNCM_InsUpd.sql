SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE         procedure spNCM_InsUpd --'1','EMCSR2008100501','01011100'
			
	@Id_NCM_Proc int,
	@Num_Proc VarChar(16),
	@NCM varchar(8)

AS

BEGIN TRANSACTION

Declare @Id_NCM Int 
Declare @ID Int

	set @Id_NCM = (select Id_NCM from NCM where ncm = @NCM)

	if @ID_NCM_Proc is not null
		BEGIN
			UPDATE
				Proc_NCM
			SET
				Id_NCM = @Id_NCM
			WHERE
				Id_NCM_Proc = @Id_NCM_Proc and Num_Proc = @Num_Proc
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(Id_NCM_Proc),0)+1 from Proc_NCM where Num_Proc = @Num_Proc)
			INSERT INTO
				Proc_NCM
				(
					Id_NCM_Proc,
					Num_Proc,
					Id_NCM
				)
			VALUES
				(
					@Id,
					@Num_Proc,
					@Id_NCM
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	








GO
