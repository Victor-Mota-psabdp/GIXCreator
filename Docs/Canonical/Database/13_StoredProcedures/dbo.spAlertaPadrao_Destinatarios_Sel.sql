SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlertaPadrao_Destinatarios_Sel]
(
	@JOB varchar(16),
	@cd_usuario varchar(10)
)
AS
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_him),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_him),'')
	from 
		house_imp_mar HOU
	where 
		num_proc_him = @JOB
UNION ALL
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_hem),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_hem),'')
	from 
		house_exp_mar HOU
	where 
		num_proc_hem = @JOB
UNION ALL
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_hea),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_hea),'')
	from 
		house_exp_aer HOU
	where 
		num_proc_hea = @JOB
UNION ALL
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_hia),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_hia),'')
	from 
		house_imp_aer HOU
	where 
		num_proc_hia = @JOB
UNION ALL
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_heo),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_heo),'')
	from 
		house_exp_out HOU
	where 
		num_proc_heo = @JOB
UNION ALL
	select
		(select email from usuario where cd_usuario = @cd_usuario) + '; '
		+ isnull(dbo.fConcatena('',cd_export_hio),'') + '; ' 
		+ isnull(dbo.fConcatena('',cd_consig_hio),'')
	from 
		house_imp_out HOU
	where 
		num_proc_hio = @JOB
GO
