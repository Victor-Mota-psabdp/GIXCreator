SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spLog_Alerta_Email_Redestinacao_Ins]
(
	@Num_Proc		[varchar](16),
	@Assunto		[varchar](MAX),
	@Emails			[varchar](MAX),	
	@Mensagem		[varchar](MAX)
)	
	
AS
--sp_help Log_Alerta_Email_Redestinacao
BEGIN
	Insert into dbo.Log_Alerta_Email_Redestinacao
		(Num_Proc,Dt_Envio,Emails,Mensagem,Assunto) 
	Values 
		(@Num_Proc, getdate(),@Emails,@Mensagem,@Assunto)
END
							
GO
