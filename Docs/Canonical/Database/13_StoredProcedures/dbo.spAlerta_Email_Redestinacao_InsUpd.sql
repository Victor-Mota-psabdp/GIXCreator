SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spAlerta_Email_Redestinacao_InsUpd]
(
	@Grupo [varchar](60),
	@Nome_Tp_Alerta [varchar](200),	
	@Dia [int],
	@DiaFim [int],	
	@Emails [varchar](MAX),
	@CopyBDP [varchar](MAX),	
	@Ativo bit,		
	@Cd_Usuario [varchar](6),
	@Mensagem[varchar](MAX)	
)
AS

Declare @ID_TP_Alerta int
Declare @Cd_Pes_Grupo [varchar](10)

set @ID_TP_Alerta = (Select ID_TP_Alerta from Tipo_Alerta_Redestinacao with(nolock) where Nome_TP_Alerta = @Nome_Tp_Alerta)
set @Cd_Pes_Grupo = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Grupo)

If NOT exists (select * from Alerta_Email_Redestinacao 
				where ID_TP_Alerta = @ID_TP_Alerta and Cd_Pes_Grupo = @Cd_Pes_Grupo 
				and Dia = @Dia and DiaFim = @DiaFim)						
		BEGIN				
			insert into Alerta_Email_Redestinacao
			(
				ID_TP_Alerta,CD_Pes_Grupo,Email,Dia,Status,Cd_Usuario,Dt_Ins,Email_CC,Mensagem,DiaFim
			)
			values
			(			
				@ID_TP_Alerta,@Cd_Pes_Grupo,@Emails,@Dia,@Ativo,@Cd_Usuario,GETDATE(),@CopyBDP,@Mensagem,@DiaFim
			)
		END
else
		BEGIN
			UPDATE
				Alerta_Email_Redestinacao
			SET
				Email =@Emails,
				Status = @Ativo,
				Email_CC=@CopyBDP,
				Mensagem= @Mensagem
			where ID_TP_Alerta = @ID_TP_Alerta and Cd_Pes_Grupo = @Cd_Pes_Grupo and Dia = @Dia
			and DiaFim = @DiaFim
		END
							
							
GO
