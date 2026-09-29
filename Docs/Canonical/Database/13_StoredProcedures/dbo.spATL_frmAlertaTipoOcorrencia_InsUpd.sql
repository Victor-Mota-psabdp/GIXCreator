SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from alerta_ocorrencia
alter table alerta_ocorrencia add cd_usuario varchar(10)
alter table alerta_ocorrencia add dt_ins datetime
*/

CREATE procedure [dbo].[spATL_frmAlertaTipoOcorrencia_InsUpd] 
(
	@Grupo varchar(20),
	@TipoOcor varchar(50),
	@Modal char(2),
	@ResponderPara varchar(100),
	@Assunto varchar(100),
	@Emails varchar(max),
	@cd_usuario varchar(10)
)
as

Begin Transaction

	declare @Cd_Pes_Grupo varchar(10)
	declare @Cd_Tp_Ocor int

	set @Cd_Pes_Grupo = (select cd_pes from pessoa with(nolock) where apelido = @Grupo and desat_pes='N')
	set @Cd_Tp_Ocor = (select cd_tp_ocor from tipo_ocorrencia with(nolock) where nome_tp_ocor = @TipoOcor)

	If exists(select * from Alerta_Ocorrencia where	Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo)
		Begin
			Update
				Alerta_Ocorrencia
			Set
				ResponderPara = @ResponderPara, Assunto = @Assunto, Emails = @Emails, cd_usuario=@cd_usuario, dt_ins = getdate()
			Where
				Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo
		End
	Else
		Begin
			Insert into Alerta_Ocorrencia
				(Cd_Tp_Ocor, Cd_Pes_Grupo, Modal, Emails, ResponderPara, Assunto, cd_usuario, dt_ins)
			Values
				(@cd_tp_ocor, @cd_pes_grupo, @Modal, @Emails, @ResponderPara, @Assunto, @cd_usuario, getdate())
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction

GO
