SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_System_Code
CREATE PROCEDURE [dbo].[spATL_Tipo_System_Code_InsUpd]
(
	@ID_System_Code		BIGINT,
	@Name_System_Code	VARCHAR(100),
	@Ativo				BIT,
	@Cd_Usuario			VARCHAR(6),
	@dt_ins				DATETIME
)

AS

Begin Transaction

	If  exists (select ID_System_Code from ATL_INT.dbo.Tipo_System_Code where ID_System_Code=@ID_System_Code)
		Begin
			Update
				ATL_INT.dbo.Tipo_System_Code
			Set
				Name_System_Code=@Name_System_Code,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				ID_System_Code=@ID_System_Code
		End
	Else
		Begin
			Insert ATL_INT.dbo.Tipo_System_Code
				(Name_System_Code,Ativo,Cd_Usuario,dt_ins)
			Values
				(@Name_System_Code,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
