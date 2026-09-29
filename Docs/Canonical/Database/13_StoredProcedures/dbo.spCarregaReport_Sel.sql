SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spCarregaReport_Sel
	@cd_usuario varchar(20),
	@Report_Name varchar(100)
AS
	select top 1 
		ID, regra, Tipo, Envia_Email 
	from 
		report R 
		left join report_acesso RA on RA.id_report = R.id and RA.cd_usuario = @cd_usuario
	where 
		report_name=@Report_Name
	order by
		Envia_Email desc



GO
