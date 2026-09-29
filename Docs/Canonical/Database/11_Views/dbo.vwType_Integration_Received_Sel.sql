SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwType_Integration_Received_Sel]
AS

select 
	T.Id_Integration_Received		[Code],
	T.Name_Integration_Received		[Integration Received Name],
	T.Cd_Pes_Grupo					[Group Code],
	P.Apelido						[Group Name],
	T.Status						[Enabled],
	T.Cd_Usuario					[User Code],
	U.Nome_Usuario					[User Name],
	T.Dt_Ins						[Insert Date]
from Type_Integration_Received T with(nolock)
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo

GO
