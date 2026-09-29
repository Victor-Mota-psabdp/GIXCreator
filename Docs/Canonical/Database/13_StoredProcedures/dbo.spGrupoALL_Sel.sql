SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGrupoALL_Sel]

as
		select 'GRUPO ALL' apelido 
			union ALL 
		select apelido 
			from pessoa PP
		with(nolock) 
			where --desat_pes='N' and 
			apelido like 'GRUPO%'

GO
