SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Status_Master
CREATE PROCEDURE [dbo].[spATL_Tipo_Status_Master_InsUpd]
(
	@Cd_Tp_Status_Master	VARchar(3),
	@Nome_Tp_Status_Master	varchar(20)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Status_Master from Tipo_Status_Master where Cd_Tp_Status_Master=@Cd_Tp_Status_Master)
		Begin
			Update
				Tipo_Status_Master
			Set
				Nome_Tp_Status_Master=@Nome_Tp_Status_Master
			Where
				Cd_Tp_Status_Master=@Cd_Tp_Status_Master
		End
	Else
		Insert
			Tipo_Status_Master(Cd_Tp_Status_Master,Nome_Tp_Status_Master)
		Values
			(@Cd_Tp_Status_Master,@Nome_Tp_Status_Master)
	

Commit Transaction

GO
