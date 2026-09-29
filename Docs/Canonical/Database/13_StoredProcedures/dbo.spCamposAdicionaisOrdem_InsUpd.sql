SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spCamposAdicionaisOrdem_InsUpd]
	
	@cd_pedido		int,
	@Descr_Campo	varchar(30),
	@Campo_Dados	Varchar(500),
	@cd_usuario     varchar(6)

AS

--BEGIN TRANSACTION

	Declare @ID_Campo int
	Declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo = (select cd_grupo from pedido where cd_pedido = @cd_pedido)
	set @ID_Campo = (select ID_Campo from Tipo_Campo_Ordem where Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes_Grupo or cd_pes_grupo='10017'))

	if exists(select Tipo from tipo_campo_Ordem where tipo='F' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

	declare @Host varchar(20) --SYSNAME --
	declare @session_id int

	--Alessandra 23/03/2020 - Não funciona no novo server, ver mais tarde se precisa mesmo e como recuperar a informação e passar via app
	--select @Host = Client_Net_Address, @session_id = con.most_recent_session_id from sys.dm_exec_connections con   
	--INNER JOIN sys.dm_exec_sessions sess on con.session_id = sess.session_id   
	--where Sess.Session_ID = @@Spid

	if exists (select Campo_Dados from Campo_Ordem where Id_Campo=@Id_Campo and cd_pedido=@cd_pedido)
		if @Campo_Dados=''
			BEGIN
				DELETE
					Campo_Ordem
				WHERE
					Id_Campo=@Id_Campo and cd_pedido=@cd_pedido
			END
		Else
			BEGIN
				UPDATE
					Campo_Ordem
				SET
					Campo_Dados	= @Campo_Dados, Dt_Ins_Upd = Getdate(), cd_usuario = @cd_usuario
				WHERE
					Id_Campo=@Id_Campo and cd_pedido=@cd_pedido
			END
	ELSE
		if @Id_Campo is NOT null or @Id_Campo <> ''
			BEGIN
				INSERT INTO
					Campo_Ordem
					(
						cd_pedido,
						Id_Campo,	
						Campo_Dados,
						Dt_Ins_Upd,
						cd_usuario
					)
				VALUES
					(
						@cd_pedido,
						@Id_Campo,
						@Campo_Dados,
						getdate(),
						@cd_usuario
					)
			END

--IF @@Error <> 0
--	BEGIN
--		ROLLBACK TRANSACTION
--		RETURN -1
--	END
--
--
--COMMIT TRANSACTION






GO
