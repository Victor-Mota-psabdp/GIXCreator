SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolicitacaoLI_InsUpd]
	@Num_Solicitacao	Varchar(13),
	@Dt_Solicitacao		Datetime,
	@Tipo_LI			Varchar(30),
	@Usuario_Req		Varchar(50),
	@Usuario_Oper		Varchar(50),
	@Num_LI				Varchar(15),
	@Dt_LI				Datetime,
	@Dt_Aut_Embarque	Datetime,
	@Dt_Deferimento		Datetime,
	@Dt_Vencimento		Datetime,
	@Num_Proc			Varchar(16),
	@Motivo				Varchar(100),
	@Obs_LI				Varchar(300),
	@Protocolo_Transmissao	Varchar(40),
	@Fabricante			Varchar(40),
	@ID_Status			int,
	@Dt_Requerimento	datetime,
	@num_Requerimento	varchar(50),
	@CobrancaCliente bit,
	@ID_Regime			int,
	@Grupo				Varchar(50),
	@cd_usuario			Varchar(10),
	@Num_Solicitacao_New	varchar(13) output
				
AS

BEGIN TRANSACTION 

	Declare @Cd_Fabricante Varchar(10)
	Declare @Cd_Grupo Varchar(10)
	Declare @ID_TIPO_LI INT
	Declare @Cd_Usuario_Req Varchar(10)
	Declare @Cd_Usuario_Oper	Varchar(10)
	Declare @IntI int
	
	Declare @Tipo as char(1)
	
	set @ID_Tipo_Li=(select id_tipo from tipo_li with(nolock) where nome_tp_li=@Tipo_LI)
	Set @Cd_Usuario_Req=(select top 1 cd_usuario from usuario with(nolock) where nome_usuario=@usuario_req)
	Set @cd_Usuario_Oper=(select top 1 cd_usuario from usuario with(nolock) where nome_usuario=@usuario_oper)
	Set @Cd_Fabricante = (select top 1 cd_pes from pessoa with(nolock) where apelido=@Fabricante)
	Set @Cd_Grupo = (select top 1 cd_pes from pessoa with(nolock) where apelido=@Grupo)
	if @Num_Solicitacao is null 
		Begin
			Set @Num_Solicitacao_new = 'SLI' + cast(year(getdate()) as varchar(4)) + right('0'+cast(month(getdate()) as varchar(2)),2)
			Set @IntI = (select max(isnull(right(num_solicitacao,4),0)) from solicitacao_li where left(num_solicitacao,9)=@num_solicitacao_new)
			if @intI is null
				begin
					set @IntI=0
				end
			Set @IntI = @IntI + 1
			Set @num_solicitacao_new=@num_solicitacao_new + right('0000' + cast(@IntI as varchar(4)),4)
			
			set @Tipo = 'I'
			
			Insert into Solicitacao_LI
					(
							Num_Solicitacao,Dt_Solicitacao,	ID_Tipo_LI,
							Cd_Usuario_Req,	Cd_Usuario_Oper,Num_LI,
							Dt_LI,Dt_Aut_Embarque,Dt_Deferimento,Dt_Vencimento,
							Num_Proc,Protocolo_Transmissao,	Motivo,	Obs_LI,
							id_status,cd_fabricante, Dt_Requerimento, Num_Requerimento,CobrancaCliente,
							id_regime,Cd_Grupo
					)
			Values
					(
							@Num_Solicitacao_New,@Dt_Solicitacao,	@ID_Tipo_LI,
							@Cd_Usuario_Req,	@Cd_Usuario_Oper,@Num_LI,
							@Dt_LI,@Dt_Aut_Embarque,@Dt_Deferimento,@Dt_Vencimento,
							@Num_Proc,@Protocolo_Transmissao,@Motivo,	@Obs_LI,
							@ID_Status,@cd_fabricante, @Dt_Requerimento, @Num_Requerimento,@CobrancaCliente,
							@ID_Regime,@Cd_Grupo
					)
		End
	ELSE
		BEGIN
			UPDATE Solicitacao_LI
				SET
					Dt_Solicitacao=@Dt_Solicitacao,	
					ID_Tipo_LI=@ID_Tipo_LI,
					Cd_Usuario_Req=@Cd_Usuario_Req,	
					Cd_Usuario_Oper=@Cd_Usuario_Oper,
					Num_LI=@Num_LI,
					Dt_LI=@Dt_LI,
					Dt_Aut_Embarque=@Dt_Aut_Embarque,
					Dt_Deferimento=@Dt_Deferimento,
					Dt_Vencimento=@Dt_Vencimento,
					Num_Proc=@Num_Proc,
					Protocolo_Transmissao=@Protocolo_Transmissao,	
					Motivo=@Motivo,	
					Obs_LI=@Obs_LI,
					Id_Status=@ID_Status,
					Cd_Fabricante = @cd_fabricante,
					Dt_Requerimento = @Dt_Requerimento,
					Num_Requerimento = @Num_Requerimento,
					CobrancaCliente=@CobrancaCliente,
					id_regime = @ID_Regime,
					Cd_Grupo = @Cd_Grupo
			WHERE
					Num_Solicitacao=@Num_Solicitacao
									
					
			set @Tipo = 'A'
			Set @num_solicitacao_new = @Num_Solicitacao
		END		
					
--LOG
	BEGIN
		insert into [dbo].[Log_Solicitacao_LI]
			(Dt_Ins,Cd_Usuario,Tp_Oper,Num_Solicitacao,Dt_Solicitacao,ID_Tipo_LI,Cd_Usuario_Req,Cd_Usuario_Oper,
			Num_LI,	Dt_LI,Dt_Aut_Embarque,Dt_Deferimento,Dt_Vencimento,Num_Proc,Protocolo_Transmissao,Motivo,
			Obs_LI,Cd_Fabricante,ID_Status,Dt_Requerimento,Num_Requerimento,CobrancaCliente,ID_Regime,cd_grupo)
		Values
			(getdate(),@cd_usuario,@Tipo,@num_solicitacao_new,@Dt_Solicitacao,@ID_Tipo_LI,@Cd_Usuario_Req,@Cd_Usuario_Oper,
			@Num_LI,@Dt_LI,@Dt_Aut_Embarque,@Dt_Deferimento,@Dt_Vencimento,@Num_Proc,@Protocolo_Transmissao,@Motivo,
			@Obs_LI,@cd_fabricante,@ID_Status,@Dt_Requerimento,@Num_Requerimento,@CobrancaCliente,@ID_Regime,@Cd_Grupo)
	END
		
	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		end

COMMIT TRANSACTION






GO
