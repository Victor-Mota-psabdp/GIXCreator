SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spLog_FollowUp_Envio_Ins](
	@Num_Proc		varchar(16),
	@Assunto		varchar(200),
	@CorpoMSG		varchar(max),
	@Anexo			varchar(200),
	@Destinatario	varchar(200)
)
as
--sp_help [Log_FollowUp_Envio]
Insert dbo.Log_FollowUp_Envio
		(Num_Proc,Dt_Envio,Assunto,CorpoMSG,Anexo,Destinatario)
	values
		(@Num_Proc,GETDATE(),@Assunto,@CorpoMSG,@Anexo,@Destinatario)
						
						

GO
