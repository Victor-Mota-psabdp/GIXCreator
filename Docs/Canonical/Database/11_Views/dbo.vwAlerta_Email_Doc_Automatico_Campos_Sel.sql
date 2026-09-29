SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwAlerta_Email_Doc_Automatico_Campos_Sel]
AS

select 
	ID				[Code],
	Nome_Campo		[Field Name],
	Ativo			[Enabled],
	T.Cd_Usuario	[User Code],
	U.Nome_Usuario	[User Name],
	dt_ins			[Insert Date]
from Alerta_Email_Doc_Automatico_Campos T with(nolock)
	left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
