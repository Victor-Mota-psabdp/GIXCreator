SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo
CREATE PROCEDURE [dbo].[spATL_Tipo_Grupo_InsUpd]
(
	@Cd_Tp_Grupo			varchar(3),
	@Nome_Tp_Grupo			varchar(30),
	@Ativo					varchar(1)	
)
				

AS

Begin Transaction

	If  exists (select Cd_Tp_Grupo from Tipo_Grupo where Cd_Tp_Grupo=@Cd_Tp_Grupo)
		Begin
			Update
				Tipo_Grupo
			Set
				Nome_Tp_Grupo=@Nome_Tp_Grupo
			Where
				Cd_Tp_Grupo=@Cd_Tp_Grupo
		End
	Else
		Begin
			Insert Tipo_Grupo
				(Cd_Tp_Grupo,Nome_Tp_Grupo)
			Values
				(@Cd_Tp_Grupo,@Nome_Tp_Grupo)
		End

Commit Transaction

GO
