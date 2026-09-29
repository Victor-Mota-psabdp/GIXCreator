SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Navio_LLP
CREATE procedure [dbo].[spATLDN_Navio_LLP_Del]
(
	@Id_Navio			Int
)

as

	--If  exists (select Id_Navio from Navio_LLP where Id_Navio=@Id_Navio)
	--	Begin
	--		delete Navio_LLP where Id_Navio= @Id_Navio
	--	End

GO
