SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [TrgLogUsuario_Ins] ON [dbo].[Log_Usuario] 
FOR INSERT, UPDATE
AS
	Declare @cd_usuario	varchar(6)
	Select @cd_usuario = cd_usuario from inserted 
		Begin 
			exec spLogATL_InsUpd @Cd_Usuario, '3'
			
		End





GO
ALTER TABLE [dbo].[Log_Usuario] ENABLE TRIGGER [TrgLogUsuario_Ins]
GO
