SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado o historico pra ser disp ao cliente = S
--19-07-2018 - cadu - retirado o RollBack Transaction  pq nao estava deiando criar a solicitação
CREATE procedure [dbo].[spSolicitacao_Retificacao_InsUpd]

	@NUM_SOLRET				varchar(12),
	@DT_SOLICITACAO			datetime,
	@NOME_SOLICITANTE		varchar(50),	
	@NOME_TP_SOLRET			varchar(50),
	@NUM_PROC				varchar(16),
	@NOME_OPERADOR			varchar(50),
	@NR_RETIFICACAO			varchar(10),
	@NOME_TP_USUARIO_SOLRET	varchar(50),
	@NOME_FUNCIONARIO		varchar(50),
	@DT_RETIFICACAO			datetime,
	@STATUS_DESCRICAO		varchar(50),	
	@DT_RCTO_AUTO_INFRACAO	datetime,
	@NR_AUTO_INFRACAO		varchar(50),
	@VL_AUTO_INFRACAO		decimal(18,2),	
	@DT_ENV_ADVOGADO		datetime,
	@NM_ESCRITORIO_ADVOCATICIO varchar(100),
	@ATIVO					bit,
	@NUM_SOLRETN			varchar(13) output	

AS

Declare @CD_SOLICITANTE		varchar(10)
Declare @ID_TP_SOLRET		bigint 
Declare @CD_OPERADOR		varchar(10)
Declare @ID_TP_USUARIO_SOLRET	bigint
Declare @ID_STATUS			bigint
Declare @CD_FUNCIONARIO		varchar(10)

Declare @Text Varchar(200)
Declare @data datetime
Set @data = (select GETDATE())

	set @CD_SOLICITANTE = (select cd_usuario from Usuario where Nome_Usuario = @NOME_SOLICITANTE)
	set @ID_TP_SOLRET = (select ID_TP_SOLRET from Tipo_Solicitacao_Retificacao where NOME_TP_SOLRET = @NOME_TP_SOLRET)
	set @CD_OPERADOR = (select cd_usuario from Usuario where Nome_Usuario = @NOME_OPERADOR)
	set @ID_TP_USUARIO_SOLRET = (select ID_TP_USUARIO_SOLRET from Tipo_Usuario_Solicitacao_Retificacao where Nome_TP_USUARIO_SOLRET = @NOME_TP_USUARIO_SOLRET)
	set @ID_STATUS = (select ID_STATUS from Tipo_Status_Solicitacao_Retificacao where STATUS_DESCRICAO = @STATUS_DESCRICAO)
	set @CD_FUNCIONARIO = (select cd_usuario from Usuario where Nome_Usuario = @NOME_FUNCIONARIO)


BEGIN
	Begin Transaction
		if not exists(select NUM_SOLRET from Solicitacao_Retificacao where NUM_SOLRET=@NUM_SOLRET)
			Begin
				Declare @novo  varchar(13)
				set @novo = (select cast(isnull(max(right(NUM_SOLRET,4)),0) + 1 as varchar(5)) FROM Solicitacao_Retificacao where left(NUM_SOLRET,8) = 'SR' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0'+ CAST(MONTH(GETDATE()) AS VARCHAR(2)),2))
				set @novo = '00000' + @novo
				set @novo = 'SR' + convert(varchar,year(getdate()),4) + right('0' + convert(varchar,month(getdate()),2),2) + right(@novo,4)				
			Insert Into 
				Solicitacao_Retificacao
				(NUM_SOLRET,DT_SOLICITACAO,CD_SOLICITANTE,ID_TP_SOLRET,NUM_PROC,CD_OPERADOR,NR_RETIFICACAO,
				ID_USUARIO_SOLRET,DT_RETIFICACAO,ID_STATUS,DT_RCTO_AUTO_INFRACAO,NR_AUTO_INFRACAO,
				VL_AUTO_INFRACAO,DT_ENV_ADVOGADO,NM_ESCRITORIO_ADVOCATICIO,ATIVO,CD_FUNCIONARIO)
			Values 
				(@novo,@DT_SOLICITACAO,@CD_SOLICITANTE,@ID_TP_SOLRET,@NUM_PROC,@CD_OPERADOR,@NR_RETIFICACAO,
				@ID_TP_USUARIO_SOLRET,@DT_RETIFICACAO,@ID_STATUS,@DT_RCTO_AUTO_INFRACAO,@NR_AUTO_INFRACAO,
				@VL_AUTO_INFRACAO,@DT_ENV_ADVOGADO,@NM_ESCRITORIO_ADVOCATICIO,1,@CD_FUNCIONARIO)		

		Set @NUM_SOLRETN = @novo
		
				Set @Text = 'Solicitação de Retificação :' + @novo + ' criada pelo usuario: ' + @NOME_SOLICITANTE + 'Status: ' + @STATUS_DESCRICAO							
				exec dbo.[spHistG_InsUPD] @NUM_PROC,Null ,Null,'Solicitacao de Retificação do CE',@Text ,@data,null ,'ATL System','S','U',null 

			End
		else
			BEGIN
				Set @NUM_SOLRETN = @NUM_SOLRET

					UPDATE
						Solicitacao_Retificacao
					SET						
						ID_TP_SOLRET = @ID_TP_SOLRET,
						NUM_PROC = @NUM_PROC,
						CD_OPERADOR = @CD_OPERADOR,
						NR_RETIFICACAO = @NR_RETIFICACAO,
						ID_USUARIO_SOLRET = @ID_TP_USUARIO_SOLRET,
						DT_RETIFICACAO = @DT_RETIFICACAO,
						ID_STATUS = @ID_STATUS,
						DT_RCTO_AUTO_INFRACAO = @DT_RCTO_AUTO_INFRACAO,
						NR_AUTO_INFRACAO = @NR_AUTO_INFRACAO,
						VL_AUTO_INFRACAO = @VL_AUTO_INFRACAO,
						DT_ENV_ADVOGADO = @DT_ENV_ADVOGADO,
						NM_ESCRITORIO_ADVOCATICIO = @NM_ESCRITORIO_ADVOCATICIO,
						ATIVO = @ATIVO,
						CD_FUNCIONARIO = @CD_FUNCIONARIO					
					WHERE
						NUM_SOLRET = @NUM_SOLRET						
					
			END

		--If @@RowCount <> 1 
		--	Begin 
		--		RollBack Transaction 
		--		Return -1 
		--	End 	
	Commit Transaction
END





















GO
