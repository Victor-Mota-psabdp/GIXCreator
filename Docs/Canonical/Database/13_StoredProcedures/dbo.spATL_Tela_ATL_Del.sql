SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tela_ATL
CREATE procedure [dbo].[spATL_Tela_ATL_Del](
	@Cd_Tela VARCHAR(3)
)
as
	delete Tela_ATL where Cd_Tela= @Cd_Tela

GO
