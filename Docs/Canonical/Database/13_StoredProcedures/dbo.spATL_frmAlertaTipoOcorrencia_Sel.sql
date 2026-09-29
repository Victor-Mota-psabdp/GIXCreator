SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_frmAlertaTipoOcorrencia_Sel] 
(
	@Grupo varchar(20),
	@TipoOcor varchar(50),
	@Modal char(2)
)
as
	declare @Cd_Pes_Grupo varchar(10)
	declare @Cd_Tp_Ocor int

	set @Cd_Pes_Grupo = (select cd_pes from pessoa with(nolock) where apelido = @Grupo and desat_pes='N')
	set @Cd_Tp_Ocor = (select cd_tp_ocor from tipo_ocorrencia with(nolock) where nome_tp_ocor = @TipoOcor)

	select 
		ResponderPara, Assunto, Emails
	from 
		Alerta_Ocorrencia with(nolock)
	where
		Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo


GO
