SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgDemurrage_ATL_Upd] ON  [dbo].[Demurrage_ATL]    AFTER UPDATE
AS 
BEGIN


	Declare @Num_proc				varchar(16)
	Declare @Fatura					char(1)
	Declare @ID_Status				int
	Declare @ID_Status_Novo			int
	Declare @Status_Descricao		varchar(200)
	Declare @Status_Descricao_Novo	varchar(200)
	
	--Numero do Job
	select @num_proc=Processo,@Fatura=Fatura,@ID_Status=ID_Status from deleted	
	select @ID_Status_Novo=ID_Status from inserted		
		
	if @ID_Status <> @ID_Status_Novo	
		Begin
			set @Status_Descricao = (select Status_Descricao from [Tipo_Status_Demurrage] where ID_Status = @ID_Status)
			set @Status_Descricao_Novo = (select Status_Descricao from [Tipo_Status_Demurrage] where ID_Status = @ID_Status_Novo)
			Declare @MSG Varchar(2000)
			Set @MSG=@num_proc + @Fatura + ' alterada de: ' + @Status_Descricao + ' para ' + @Status_Descricao_Novo
			exec spHistG_InsUPD @Num_Proc,Null,Null,'Alteração de Invoice',@MSG,'01-01-2010',Null,'ATL System','N','U',Null

		End

END

GO
ALTER TABLE [dbo].[Demurrage_ATL] ENABLE TRIGGER [TrgDemurrage_ATL_Upd]
GO
