SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_ReportXLS_Rel] 'ALL'
CREATE procedure [dbo].[spATL_ReportXLS_Rel] 
	@all varchar(3)
AS

select 
R.Report_Name [Nome Report],
U.Nome_Usuario [Usuarios com Acessos], 
RE.Email [Lista de e-mail de disparo automático] 
from report R with(nolock)
Left Join Report_Acesso RA	with(nolock) on R.ID = RA.ID_Report
Join Usuario U				with(nolock) on RA.Cd_Usuario = U.Cd_Usuario
Left Join Report_Email RE	with(nolock) on  R.ID = RE.Id_Alerta
where R.Ativo = 'S' and RE.Disable = 0 and U.Ck_Ativo = 1 and U.Nome_Usuario <> 'Administrador'
order by 1
GO
