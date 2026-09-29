SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nivel_Acesso
CREATE Procedure [dbo].[spATL_Nivel_Acesso_Del]--'','','B'
(
	@Cd_Area		varchar(3),
	--@Nome_Area		varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela		varchar(50),
	@Cd_Nivel		varchar(3)
	--@Tipo_Nivel		varchar(30),
	
)
as

	----sp_help Area
	--Declare @Cd_Area	varchar(6)
	--set @Cd_Area = (Select Cd_Area from Area where Nome_Area = @Nome_Area)

	----sp_help Tela_ATL
	--Declare @Cd_Tela varchar(3)
	--set @Cd_Tela = (Select Cd_Tela from Tela_ATL where Nome_Tela = @Nome_Tela)	
	
	----sp_help Nivel
	--Declare @Cd_Nivel	varchar(6)
	--set @Cd_Nivel = (Select Cd_Nivel from Nivel where Tipo_Nivel = @Tipo_Nivel)

	BEGIN
		delete Nivel_Acesso where Cd_Tela= @Cd_Tela AND Cd_Area = @Cd_Area AND Cd_Nivel = @Cd_Nivel
	End

GO
