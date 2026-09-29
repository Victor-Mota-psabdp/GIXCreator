SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Cia_Aerea
CREATE procedure [dbo].[spATL_Cia_Aerea_Del]
(
	@Cd_Cia_Aer	varchar(3)
)
as

	--If  exists (select Cd_Cia_Aer from Cia_Aerea where Cd_Cia_Aer=@Cd_Cia_Aer)
	--	Begin
	--		delete Cia_Aerea where Cd_Cia_Aer= @Cd_Cia_Aer
	--	End

GO
