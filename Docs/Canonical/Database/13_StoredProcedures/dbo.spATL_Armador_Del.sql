SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Armador
CREATE procedure [dbo].[spATL_Armador_Del]
(
	@Cd_Armador		varchar(3)
)
as

	--If  exists (select Cd_Armador from Armador where Cd_Armador=@Cd_Armador)
		--Begin
		--	--delete Armador where Cd_Armador	= @Cd_Armador
		--End

GO
