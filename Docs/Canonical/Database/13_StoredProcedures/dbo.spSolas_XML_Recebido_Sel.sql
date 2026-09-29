SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolas_XML_Recebido_Sel]--'EMCSR201608003BR'
(	
	@Num_Proc		Varchar(16)
)
as
	
	select  distinct
		'Dados recebidos no arquivo : '	+ Nome_arquivo + '||' +			
		'ForwarderReferenceNumber: ' + isnull(ForwarderReferenceNumber,'') + '|' +
		'EquipmentInitial: ' + isnull(EquipmentInitial,'') + '|' +
		'EquipmentNumber: ' + isnull(EquipmentNumber,'') + '|' +
		'DocsRcvdDate: ' + isnull(DocsRcvdDate,'') + '|' [Mensagem],
		
		US.Email + ';br.sao.sistemas@bdpint.com;vgm.br@bdpint.com' [Email],		
		'Recebimento do Armador VGM - JOB: ' +  TP.Num_Proc Assunto, 
		'br.sao.sistemas@bdpint.com' ResponderPara,
		TP.Dt_Conclusao
	from 
		Tarefas_Processos TP 
		join Solas_XML_Recebido S on S.ForwarderReferenceNumber = TP.Num_Proc
		join Job_Exp_Mar JOB on JOB.Num_Proc_HEM = TP.Num_Proc
		join Usuario US on US.Cd_Usuario = JOB.Cd_Usuario
	where 
		ID_Task =188 
		and TP.Dt_Conclusao is not null
		and	Num_Proc = @Num_Proc 
		
		

	
	
GO
