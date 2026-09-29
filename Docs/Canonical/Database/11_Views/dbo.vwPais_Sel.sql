SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pais
CREATE  VIEW [dbo].[vwPais_Sel]
AS
	select Cd_Pais [Code],  Nome_Pais [Country Name], FORM_A,
		Nome_Pais_PT [Country Name PT],HTS, Paraiso_Fiscal, Proibido [Prohibited], Bloqueado [Blocked], Cd_Pais_IBGE [IBGE], Cd_M49 [M49], Cd_Usuario [User], Ativo [Enabled]
		from Pais with(nolock)

GO
