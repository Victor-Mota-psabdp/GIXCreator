SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pLogUsuario_Ins 
(
@Cd_Usuario		VarChar(6)
)
AS
	If not Exists(Select * From Log_Usuario Where Cd_Usuario = @Cd_Usuario)
		Begin 
			Insert Into Log_Usuario values (@Cd_Usuario, getdate())
		End 
	Else
		Begin 
			Update Log_Usuario set LusUltAcesso = getDate() Where Cd_Usuario = @Cd_Usuario 
		End 

GO
