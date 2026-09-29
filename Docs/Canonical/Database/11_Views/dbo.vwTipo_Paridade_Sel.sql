SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Paridade
CREATE  VIEW [dbo].[vwTipo_Paridade_Sel]
AS

select 
	Cd_Tp_Par	[Code],			
	Nome_Tp_Par	[Exchange Rates Type Name],
	Parametro	[Parameter],
	Padrao		[Standard],
	[Status]	[Enabled] 
from 
	Tipo_Paridade with(nolock)
	

GO
