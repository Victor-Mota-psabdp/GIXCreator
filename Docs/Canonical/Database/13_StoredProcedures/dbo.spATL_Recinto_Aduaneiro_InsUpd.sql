SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Recinto_Aduaneiro
CREATE PROCEDURE [dbo].[spATL_Recinto_Aduaneiro_InsUpd]
(
	@ID				BigInt,	
	@Cd_Recinto		varchar(10),
	@Nome_Recinto	varchar(MAX),
	@Cd_Local		varchar(3),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(6),
	@dt_ins			DATETIME
)

AS

Begin Transaction

	If  exists (select Cd_Recinto from Recinto_Aduaneiro where Cd_Recinto=@Cd_Recinto)
		Begin
			Update
				Recinto_Aduaneiro
			Set
				Nome_Recinto=@Nome_Recinto,
				Cd_Local = @Cd_Local,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Recinto=@Cd_Recinto
		End
	Else
		Begin
			Insert Recinto_Aduaneiro
				(Cd_Recinto,Nome_Recinto,Cd_Local,Ativo,Cd_Usuario)
			Values
				(@Cd_Recinto,@Nome_Recinto,@Cd_Local,@Ativo,@Cd_Usuario)
		End

Commit Transaction

GO
