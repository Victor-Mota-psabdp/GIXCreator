SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRetificacaoDI_InsUpd]

	@NUM_PROC				varchar(16),
	@DT_SOLICITACAO			datetime,
	@NOME_SOLICITANTE		varchar(50),	
	@NUM_DI					varchar(16),
	@NOME_DESPACHANTE		varchar(50),
	@NR_RETIFICACAO			varchar(25),
	@DT_RETIFICACAO			datetime,
	@NOME_TP_RET			varchar(MAX),
	@NOME_TP_USUARIO_RET	varchar(50),
	@VL_TOTAL_IMPOSTOS		decimal(18,2),
	@VL_TOTAL_IMPOSTOS_RECOLHIDOS	decimal(18,2),
	@NOME_TAX_CLIENTE			varchar(100),
	@NOME_ITO_CLIENTE			varchar(100),
	@QTDE_ADICOES_DI			bigint,
	@QTDE_ADICOES_RETIFICADA	bigint,
	@STATUS_DESCRICAO		varchar(50),
	@DT_ULTIMA				datetime,
	@ATIVO					bit,
	@DE						varchar(250),
	@PARA					varchar(250)		

AS

Declare @CD_SOLICITANTE		varchar(10)
Declare @ID_TP_RET			bigint 
Declare @CD_DESPACHANTE		varchar(10)
Declare @ID_TP_USUARIO_RET	bigint
Declare @ID_STATUS			bigint

Declare @Text Varchar(200)
Declare @data datetime
Set @data = (select GETDATE())

	set @CD_SOLICITANTE = (select cd_usuario from Usuario where Nome_Usuario = @NOME_SOLICITANTE)
	set @ID_TP_RET = (select ID_TP_RET from Tipo_RetificacaoDI where NOME_TP_RET = @NOME_TP_RET)
	set @CD_DESPACHANTE = (select cd_usuario from Usuario where Nome_Usuario = @NOME_DESPACHANTE)
	set @ID_TP_USUARIO_RET = (select ID_TP_USUARIO_RET from Tipo_Usuario_Retificacao where Nome_TP_USUARIO_RET = @NOME_TP_USUARIO_RET)
	set @ID_STATUS = (select ID_STATUS from Tipo_Status_Retificacao where STATUS_DESCRICAO = @STATUS_DESCRICAO)
	
--BEGIN
--	Begin Transaction
		if not exists(select NUM_DI from Retificacao_DI where NUM_PROC=@NUM_PROC)
			Begin			
				Insert Into 
					Retificacao_DI
					(NUM_PROC,DT_SOLICITACAO,CD_SOLICITANTE,CD_DESPACHANTE,NR_RETIFICACAO,DT_RETIFICACAO,
					ID_TP_RET,ID_TP_USUARIO_RET,VL_TOTAL_IMPOSTOS,VL_TOTAL_IMPOSTOS_RECOLHIDOS,NOME_TAX_CLIENTE,
					NOME_ITO_CLIENTE,QTDE_ADICOES_DI,QTDE_ADICOES_RETIFICADA,ID_STATUS,DT_ULTIMA,ATIVO,DE,PARA,NUM_DI)
				Values 
					(@NUM_PROC,@DT_SOLICITACAO,@CD_SOLICITANTE,@CD_DESPACHANTE,@NR_RETIFICACAO,@DT_RETIFICACAO,
					@ID_TP_RET,@ID_TP_USUARIO_RET,@VL_TOTAL_IMPOSTOS,@VL_TOTAL_IMPOSTOS_RECOLHIDOS,@NOME_TAX_CLIENTE,
					@NOME_ITO_CLIENTE,@QTDE_ADICOES_DI,@QTDE_ADICOES_RETIFICADA,@ID_STATUS,@DT_ULTIMA,1,@DE,@PARA,@NUM_DI)					
			
					--Set @Text = 'Retificação :' + @NUM_DI + ' criada pelo usuario: ' + @NOME_SOLICITANTE + 'Status: ' + @STATUS_DESCRICAO							
					--exec dbo.[spHistG_InsUPD] @NUM_PROC,Null ,Null,'Retificação de DIE',@Text ,@data,null ,'ATL System','N','U',null 

			End
		else
			BEGIN		
				UPDATE
					Retificacao_DI
				SET
					CD_DESPACHANTE = @CD_DESPACHANTE,
					NR_RETIFICACAO = @NR_RETIFICACAO,
					DT_RETIFICACAO = @DT_RETIFICACAO,
					ID_TP_RET = @ID_TP_RET,
					ID_TP_USUARIO_RET = @ID_TP_USUARIO_RET,
					VL_TOTAL_IMPOSTOS = @VL_TOTAL_IMPOSTOS,
					VL_TOTAL_IMPOSTOS_RECOLHIDOS = @VL_TOTAL_IMPOSTOS_RECOLHIDOS,
					NOME_TAX_CLIENTE = @NOME_TAX_CLIENTE,
					NOME_ITO_CLIENTE = @NOME_ITO_CLIENTE,
					QTDE_ADICOES_DI = @QTDE_ADICOES_DI,
					QTDE_ADICOES_RETIFICADA= @QTDE_ADICOES_RETIFICADA,
					ID_STATUS = @ID_STATUS,
					DT_ULTIMA = @DT_ULTIMA,
					ATIVO = @ATIVO,
					DE = @DE,
					PARA= @PARA	,
					NUM_DI = @NUM_DI							
				WHERE
					NUM_PROC = @NUM_PROC						
					
			END

--		If @@RowCount <> 1 
--			Begin 
--				RollBack Transaction 
--				Return -1 
--			End 	
--	Commit Transaction
--END





















GO
