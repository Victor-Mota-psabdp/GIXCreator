SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Master
CREATE PROCEDURE [dbo].[spATL_Tipo_Master_InsUpd]
(
	@Cd_Tp_Master		varchar(3),
	@Nome_Tp_Master	varchar(30)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Master from Tipo_Master with(nolock) where Cd_Tp_Master=@Cd_Tp_Master)
		Begin
			Update
				Tipo_Master
			Set
				Nome_Tp_Master=@Nome_Tp_Master
			Where
				Cd_Tp_Master=@Cd_Tp_Master
		End
	Else
		Begin
			Insert Tipo_Master
				(Cd_Tp_Master,Nome_Tp_Master)
			Values
				(@Cd_Tp_Master,@Nome_Tp_Master)
		End

Commit Transaction

GO
