SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Banco_Del]
(
	@Cd_Banco varchar(3)
)
as
	if exists(select Cd_Banco from Banco Where Cd_Banco =  @Cd_Banco)
	Begin
		update Banco set Ativo = 0 Where Cd_Banco =  @Cd_Banco
	End
GO
