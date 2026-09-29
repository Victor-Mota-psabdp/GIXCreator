SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Alerta_Ocorrencia
create procedure [dbo].[spATL_Alerta_Ocorrencia_InsUpd]
(
	@Cd_Pes_Grupo	varchar(10),
	@Cd_Tp_Ocor		int,
	@Modal			char(2),
	@Emails			varchar(500),
	@ResponderPara	varchar(100),
	@Assunto		varchar(100),	
	@cd_usuario		varchar(10),
	@Ativo			Bit
)
as
	
	
	Begin Transaction

	Declare @Tp_Oper char(1)
	
	If exists(select * from Alerta_Ocorrencia where	Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo)
		Begin

			Set @Tp_Oper = 'A'
			If @Ativo = '0' 
				Begin
					Set @Tp_Oper = 'D'
				End

			Update
				Alerta_Ocorrencia
			Set
				ResponderPara = @ResponderPara, Assunto = @Assunto, 
				Emails = @Emails, cd_usuario=@cd_usuario, dt_ins = getdate()
				,Ativo= @Ativo
			Where
				Modal = @Modal and cd_tp_ocor = @cd_tp_ocor and Cd_Pes_Grupo = @cd_pes_grupo
		End
	Else
		Begin
			Insert into Alerta_Ocorrencia
				(Cd_Tp_Ocor, Cd_Pes_Grupo, Modal, Emails, ResponderPara, Assunto, cd_usuario, dt_ins,Ativo)
			Values
				(@cd_tp_ocor, @cd_pes_grupo, @Modal, @Emails, @ResponderPara, @Assunto, @cd_usuario, getdate(),@Ativo)
			Set @Tp_Oper = 'I'
		End

--LOg
	--sp_help Log_Alerta_Ocorrencia
	Insert into Log_Alerta_Ocorrencia
		(dt_ins,Tp_Oper,Cd_Tp_Ocor, Cd_Pes_Grupo, Modal, Emails, ResponderPara, Assunto, cd_usuario, Dt_Upd,Ativo)
	Values
		(getdate(),@Tp_Oper,@cd_tp_ocor, @cd_pes_grupo, @Modal, @Emails, @ResponderPara, @Assunto, @cd_usuario, getdate(),@Ativo)
			

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction

GO
