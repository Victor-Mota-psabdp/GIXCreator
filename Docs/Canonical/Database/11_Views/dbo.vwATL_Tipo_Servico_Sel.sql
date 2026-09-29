SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Servico
CREATE VIEW [dbo].[vwATL_Tipo_Servico_Sel]
AS
	SELECT 
		TP.Id_TP_Servico		[Code], 
		TP.Nome_TP_Servico		[Service Type Name], 
		TP.Cd_Usuario			[User Code],
		US.Nome_Usuario			[User Name],
		TP.Ativo				[Enabled],
		TP.JOB					[JOB_Enabled]
	FROM 
		Tipo_Servico TP wITH(NOLOCK)
		JOIN Usuario US wITH(NOLOCK) ON TP.Cd_Usuario = us.Cd_Usuario
     


GO
