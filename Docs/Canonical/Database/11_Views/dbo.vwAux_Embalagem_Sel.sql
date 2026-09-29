SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAux_Embalagem_Sel]
AS
	select 
			T.Cd_Embal_Ofc		[Code],
			T.Nome_Embalagem		[Package Name]						
		from 
			Aux_Embalagem T with(nolock)

GO
