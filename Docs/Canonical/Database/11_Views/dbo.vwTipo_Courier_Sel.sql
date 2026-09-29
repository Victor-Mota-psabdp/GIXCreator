SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Courier
CREATE  VIEW [dbo].[vwTipo_Courier_Sel]
AS

		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
	

GO
