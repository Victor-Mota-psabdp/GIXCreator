SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Dep_Acesso
CREATE Procedure [dbo].[spATL_Dep_Acesso_Del]--'','','B'
(
	@Cd_Area		varchar(3),
	--@Nome_Area		varchar(30),
	@Cd_Tela		varchar(3)
	--@Nome_Tela		varchar(50),
)

as

	BEGIN
		delete Dep_Acesso where Cd_Tela= @Cd_Tela AND Cd_Area = @Cd_Area
	End

GO
