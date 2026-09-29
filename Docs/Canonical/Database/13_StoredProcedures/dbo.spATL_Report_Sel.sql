SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Report_Sel]
	@cd_usuario varchar(20)
AS
	select 
		Report_Name 
	from 
		Report R
		join Report_Acesso RA with(nolock) on RA.ID_Report = R.ID
	where 
		Ativo='S' and cd_usuario = @cd_usuario or cd_usuario = 'ATL' 
	order by
		1

GO
