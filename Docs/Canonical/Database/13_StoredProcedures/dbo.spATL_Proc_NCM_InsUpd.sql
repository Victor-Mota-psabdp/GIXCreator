SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Proc_NCM
--cadu 02/11/2022 updated 15:51hs
CREATE procedure [dbo].[spATL_Proc_NCM_InsUpd]
			
	@Id_NCM_Proc	int,
	@Num_Proc		VarChar(16),
	@Id_NCM			Int

AS

BEGIN TRANSACTION

Declare @ID Int

	if exists(select Id_NCM from Proc_NCM WHERE Id_NCM_Proc = @Id_NCM_Proc and Num_Proc = @Num_Proc)
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
					Id_NCM_Proc,Num_Proc,Id_NCM
				)
			VALUES
				(
					@Id,@Num_Proc,@Id_NCM
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	









----SP_HELP Proc_NCM
--ALTER procedure [dbo].[spATL_Proc_NCM_InsUpd]
			
--	@Id_NCM_Proc	int,
--	@Num_Proc		VarChar(16),
--	@Id_NCM			Int

--AS

--BEGIN TRANSACTION

--Declare @ID Int

--	if @ID_NCM_Proc is not null
--		BEGIN
--			UPDATE
--				Proc_NCM
--			SET
--				Id_NCM = @Id_NCM
--			WHERE
--				Id_NCM_Proc = @Id_NCM_Proc and Num_Proc = @Num_Proc
--		END
--	ELSE
--		BEGIN
--			SET @ID=(select Isnull(max(Id_NCM_Proc),0)+1 from Proc_NCM where Num_Proc = @Num_Proc)
--			INSERT INTO
--				Proc_NCM
--				(
--					Id_NCM_Proc,Num_Proc,Id_NCM
--				)
--			VALUES
--				(
--					@Id,@Num_Proc,@Id_NCM
--				)
--		END

--IF @@Error <> 0
--	BEGIN
--		ROLLBACK TRANSACTION
--		RETURN -1
--	END

--COMMIT TRANSACTION
	








GO
