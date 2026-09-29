SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Type_Integration_Received
CREATE PROCEDURE [dbo].[spATL_Type_Integration_Received_InsUpd]
(
	@Id_Integration_Received		BIGINT,
	@Name_Integration_Received		VARCHAR(150),
	@Cd_Pes_Grupo					varchar(10),
	@Status							BIT,
	@Cd_Usuario						VARCHAR(6),
	@dt_ins							DATETIME
)

AS

Begin Transaction

	If  exists (select Id_Integration_Received from Type_Integration_Received where Id_Integration_Received=@Id_Integration_Received)
		Begin
			Update
				Type_Integration_Received
			Set
				Name_Integration_Received=@Name_Integration_Received,
				Cd_Pes_Grupo = 	@Cd_Pes_Grupo,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Id_Integration_Received=@Id_Integration_Received
		End
	Else
		Begin
			Insert Type_Integration_Received
				(Name_Integration_Received,Cd_Pes_Grupo,Status,Cd_Usuario,dt_ins)
			Values
				(@Name_Integration_Received,@Cd_Pes_Grupo,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
