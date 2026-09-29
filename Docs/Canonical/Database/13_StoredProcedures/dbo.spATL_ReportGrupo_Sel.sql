SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_ReportGrupo_Sel
AS
	select 
		UPPER(Apelido) Grupo
	from 
		grupo G 
		join pessoa P on P.cd_pes=G.cd_pes_grupo and P.Desat_Pes = 'N' 

	UNION ALL
	select 'CHB' Grupo

	order by 
		1

GO
