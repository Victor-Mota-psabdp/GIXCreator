SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGrupo_Sel]

as
	select Apelido from grupo G
	 join pessoa P on P.cd_pes = G.cd_pes_grupo 
	where 
		P.desat_pes = 'N'
		--and P.Cd_Pes not in ('10017')
GO
