SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_Type_Doc_Received_By_Email_Rules]
AS
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario


GO
