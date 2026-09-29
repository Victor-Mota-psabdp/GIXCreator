SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spLog_WebService_Migo_Ins]
	@ID varchar(5),
	@strNota varchar(20),
	@dtDataEntrega varchar(50),
	@MSG varchar(500)
AS

	declare @tmpRef_BDP varchar(16)
	set @tmpRef_BDP = 'ID: ' + @ID

	declare @tmpRef_Cliente varchar(50)
	set @tmpRef_Cliente = 'NF: ' + @strNota

	declare @tmpReferencia varchar(50)
	set @tmpReferencia = 'Entrega na Planta = ' + @dtDataEntrega

	Begin
		exec spLog_WebService_Ins 
		@Interface = 'MIGO',
		@Mensagem = @MSG,
		@Ref_BDP = @tmpRef_BDP,
		@Ref_Cliente = @tmpRef_Cliente,
		@Referencia = @tmpReferencia,
		@Email = 'klira@bdp.com.br;cmartins@bdp.com.br;sistemas@bdp.com.br'
	End

GO
