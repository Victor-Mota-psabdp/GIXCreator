SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_AirFreight_XML_Recebido_Email_Sel]--'001-82480204','Teste de Erro'
(	
	@HAWB_MAWB		Varchar(200),
	@Erro			Varchar(200)
)
as	
	select  distinct
		'Efreight com erro no HAWB: ' + V.HAWB + ' MAWB : '	+ V.MAWB + '||'  +
		'Erro: ' + @Erro + '||' [Mensagem],			
		US.Email + ';br.sao.sistemas@bdpint.com' [Email],				
		'Urgente - EFREIGHT - Urgente' Assunto, 
		'br.sao.sistemas@bdpint.com' ResponderPara
	from vwALL_JOBs V
		join Job_Exp_Aer JOB on JOB.Num_Proc_HEA = V.Num_proc
		join Usuario US on US.Cd_Usuario = JOB.Cd_Usuario
	where 
		(V.HAWB = @HAWB_MAWB or V.MAWB = @HAWB_MAWB)

	
	
GO
