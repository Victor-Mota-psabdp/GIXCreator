SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Regiao
CREATE PROCEDURE [dbo].[spATL_Regiao_InsUpd]
(
	@Cd_Regiao			varchar(3),
	@Nome_Regiao		varchar(30),
	@LocICS2            bit 
)
				

AS

Begin Transaction

	If  exists (select Cd_Regiao from Regiao where Cd_Regiao=@Cd_Regiao)
		Begin
			Update
				Regiao
			Set
				Nome_Regiao=@Nome_Regiao,
				LocICS2 = @LocICS2
			Where
				Cd_Regiao=@Cd_Regiao
		End
	Else
		Begin
			Insert Regiao
				(Cd_Regiao,Nome_Regiao,LocICS2)
			Values
				(@Cd_Regiao,@Nome_Regiao,@LocICS2)
		End

Commit Transaction

GO
