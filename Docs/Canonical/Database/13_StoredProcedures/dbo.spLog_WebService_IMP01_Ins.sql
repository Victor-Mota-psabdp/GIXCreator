SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--retirado dia 13/6 os emails da debora e andrea, por solicitação da debora
--retirado dia 02/8 os emails da bessie, por solicitação da bessie - 21850
--incluido o email do rafael.ferreira@bdpint.com dia 15/8/13, solicitado pela Roberta


CREATE procedure [dbo].[spLog_WebService_IMP01_Ins]
	@Ref_Cliente varchar(50),
	@Ref_BDP varchar(50),
	@Item varchar(50),
	@MSG varchar(500)
AS
	Begin
		exec spLog_WebService_Ins 
		@Interface = 'IMP01',
		@Mensagem = @MSG,
		@Ref_BDP = @Ref_BDP,
		@Ref_Cliente = @Ref_Cliente,
		@Referencia = @Item,
		--@Email = 'klira@bdp.com.br;sistemas@bdp.com.br;halison.costa@bdpint.com;rafael.ferreira@bdpint.com'
		--Erbson - 03-12-2013: e-mail alterados para o dominio bdpint.
		@Email = 'keity.lira@bdpint.com;br.sao.sistemas@bdpint.com;bruno.brianeze@bdpint.com'
	End

GO
