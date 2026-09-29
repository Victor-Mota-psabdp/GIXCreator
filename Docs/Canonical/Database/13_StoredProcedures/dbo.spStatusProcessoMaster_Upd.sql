SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spStatusProcessoMaster_Upd]
(
	@Status int,
	@Processo varchar(14)
)
as

Begin Transaction

	UPDATE
		LLP_Master
	SET
		ID_Status = @Status
	Where
		Num_Proc_Master = @Processo

	If @@Error <> 0
		Begin
			ROLLBACK TRANSACTION
			RETURN -1
		End
Commit Transaction




GO
