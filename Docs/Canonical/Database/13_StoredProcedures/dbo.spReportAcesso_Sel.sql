SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spReportAcesso_Sel]
	@ID int
AS

	select nome_usuario [User Name], cd_area [Area] from report_acesso RA 
	left join usuario U on U.cd_usuario = RA.cd_usuario
	where 
		id_report = @ID and U.Ck_Ativo = 1
	order by
		1
GO
