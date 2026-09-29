SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgSolicitacao_RetificacaoHistAut_Upd] ON [dbo].[Solicitacao_Retificacao] 
FOR  UPDATE
AS
	Declare @Processo					varchar(16)
	Declare @NUM_SOLRET					varchar(16)
	Declare @ID_Status					BIGINT
	Declare @ID_StatusAnterior			BIGINT	
	Declare @MSG						Varchar(1000)
	Declare @STATUS_DESCRICAO			Varchar(50)
	Declare @STATUS_DESCRICAOANTERIOR	Varchar(50)	
	Declare @data						DateTime
 
	select @ID_StatusAnterior=ID_STATUS from deleted
	Select @Processo = Num_Proc from inserted 
	Select @NUM_SOLRET = NUM_SOLRET from inserted 
	Select @ID_Status=ID_STATUS from inserted

	set @STATUS_DESCRICAO  = (select Status_Descricao from Tipo_Status_Solicitacao_Retificacao where ID_Status = @ID_Status)
	set @STATUS_DESCRICAOANTERIOR = (select Status_Descricao from Tipo_Status_Solicitacao_Retificacao where ID_Status = @ID_StatusAnterior)
	Set @data = (select GETDATE())
	
	if @ID_StatusAnterior <> @ID_Status
		BEGIN
			Set @MSG = 'Solicitação de Retificação :' + @NUM_SOLRET + ' alterada do Status: ' + @STATUS_DESCRICAOANTERIOR + ' para o Status: ' + @STATUS_DESCRICAO							
			exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'Solicitacao de Retificação do CE',@MSG ,@data,null ,'ATL System','N','U',null 				
		END
		

	


GO
ALTER TABLE [dbo].[Solicitacao_Retificacao] ENABLE TRIGGER [TrgSolicitacao_RetificacaoHistAut_Upd]
GO
