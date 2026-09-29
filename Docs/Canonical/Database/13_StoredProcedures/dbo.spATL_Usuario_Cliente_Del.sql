SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Usuario_Cliente
CREATE procedure [dbo].[spATL_Usuario_Cliente_Del]
(
	@Cd_Usuario		varchar(20),
	@Cd_Cliente		varchar(10)
)
as

	If  exists (select Cd_Usuario from Usuario_Cliente where Cd_Usuario=@Cd_Usuario AND Cd_Cliente = @Cd_Cliente)
		Begin
			UPDATE Usuario_Cliente SET Ativo='N' where Cd_Usuario=@Cd_Usuario AND Cd_Cliente = @Cd_Cliente
		End

GO
