SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Carga
CREATE  VIEW [dbo].[vwTipo_Carga_Sel]
AS

select 
	Cd_Tp_Carga		[Code],
	Nome_Tp_Carga	[Type of Cargo], 
	Nome_Tp_Carga	[Cargo Type Name],
	Ativo_TP		[Enabled] 
from 
	Tipo_Carga with(nolock)
	
--select Cd_Tp_Carga AS Code,Nome_Tp_Carga AS [Type of Cargo], Ativo_TP [Enabled] from Tipo_Carga with(nolock)

GO
