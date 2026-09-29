SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spATL_InsertJOB_Reference_Rules_InsUpd]
(
	@Id								int,
	@Modal							VARCHAR(2),
	@Cd_Pes_Grupo					varchar(10),
	@ID_DC							int,
	@Status							BIT,
	@Cd_Usuario						VARCHAR(6)
)

AS

Begin Transaction

	If  exists (select Id from InsertJOB_Reference_Rules where Id=@Id)
		Begin
			Update
				InsertJOB_Reference_Rules
			Set
				Modal=@Modal,
				Cd_Pes_Grupo = @Cd_Pes_Grupo,
				ID_DC = @ID_DC,
				Status = @Status		
			Where
				Id=@Id
		End
	Else
		Begin
			Insert InsertJOB_Reference_Rules
				(Modal,Cd_Pes_Grupo,ID_DC,Status,Cd_Usuario,dt_ins)
			Values
				(@Modal,@Cd_Pes_Grupo,@ID_DC,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
