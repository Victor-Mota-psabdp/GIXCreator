SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolas_XML_Nao_Recebido_Sel]

as

select
	G.Dt_Send Dt_Send,
	DATEADD(Hour, 3, G.Dt_Send) Dt_Send_3,
	getdate() [date],

 
	'Urgente - Recebimento do Armador VGM - Não Recebido - JOB: ' + G.Num_Proc [Mensagem],
	US.Email + ';vgm.br@bdpint.com;br.sao.sistemas@bdpint.com' [Email],		
	'Urgente - Recebimento do Armador VGM - Não Recebido - JOB:' + G.Num_Proc [Assunto], 
	'br.sao.sistemas@bdpint.com' ResponderPara,	
	G.Num_Proc
from Exchange_GTNEXUS G
	join Tarefas_Processos TP on tp.Num_Proc = G.Num_Proc and TP.ID_Task = 188
	join LLP_Exp_Mar LLp on LLp.Num_Proc_Lem = G.Num_Proc
	join Job_Exp_Mar JOB on LLp.Num_Proc_Lem = JOB.Num_Proc_HEM
	join Usuario US on US.Cd_Usuario = JOB.Cd_Usuario
where 
	G.Tipo_Envio = 9 and
	TP.DT_conclusao is null
	--and G.Dt_Send < DATEADD(Hour, -3, getdate())
	and DATEADD(Hour, 3, G.Dt_Send) < getdate()
	and cd_armador_lem = 'HAP'


	
	
	

GO
