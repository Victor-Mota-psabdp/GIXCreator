SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tela_ATL
CREATE PROCEDURE [dbo].[spATL_Tela_ATL_InsUpd]
		@Cd_Tela char(3),
		@Nome_Tela varchar(50)

AS

Begin Transaction

	If  exists (select Cd_Tela from Tela_ATL where Cd_Tela=@Cd_Tela)
	Begin
		Update
			Tela_ATL
		Set
			Nome_Tela=@Nome_Tela
		Where
			Cd_Tela=@Cd_Tela
	End
	Else
		Insert
			Tela_ATL(Cd_Tela,Nome_Tela,dt_criacao)
		Values
			(@Cd_Tela,@Nome_Tela,getdate())
	

Commit Transaction

GO
