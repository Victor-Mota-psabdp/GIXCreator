SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCamposAdicionaisOrdem_ShipTrack_InsUpd]
	
	@Num_Pedido		Varchar(30),
	@Descr_Campo	varchar(30),
	@Campo_Dados	Varchar(500),
	@cd_usuario     varchar(6),
	@Grupo			Varchar(20)

AS

--BEGIN TRANSACTION

	Declare @ID_Campo int
	Declare @Cd_Pes_Grupo varchar(10)
	Declare @CD_PEDIDO int
	Declare @Cd_Grupo		Varchar(10)
	
	SET @CD_Grupo=(SELECT CD_PES FROM PESSOA with(nolock) WHERE APELIDO=@Grupo)
	set @CD_PEDIDO = (select top 1 cd_pedido from pedido with(nolock) where num_pedido = @Num_Pedido and cd_grupo = @CD_Grupo)	
	set @Cd_Pes_Grupo = (select cd_grupo from pedido where cd_pedido = @CD_PEDIDO)
	set @ID_Campo = (select ID_Campo from Tipo_Campo_Ordem where Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes_Grupo or cd_pes_grupo='10017'))

	if exists(select Tipo from tipo_campo_Ordem where tipo='F' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

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
