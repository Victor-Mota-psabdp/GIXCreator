SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNFToNota_Cliente_Email_Sel]--'EMCSR201608003BR'
(	
	@Num_Proc		Varchar(16)
)
as	
	select  distinct
		'NF criada no JOB : '	+ JOB.Num_Proc + '||' [Mensagem],		
		US.Email + ';br.sao.sistemas@bdpint.com' [Email],
		--US.Email [Email],		
		'Dados da Nota Fiscal incluidos' Assunto, 
		'br.sao.sistemas@bdpint.com' ResponderPara
	from vwHouse_Imp JOB
		join Usuario US on US.Cd_Usuario = JOB.Cd_Usuario
	where 
		JOB.Num_Proc = @Num_Proc
		
		
		
		

	
	
GO
