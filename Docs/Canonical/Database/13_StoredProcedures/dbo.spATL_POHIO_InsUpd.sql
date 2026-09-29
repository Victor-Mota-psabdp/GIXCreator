SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_POHIO_InsUpd]
			
	@ID_PO_HIO int,
	@Numero_PO_HIO Varchar(80),
	@Data_PO_HIO Datetime,
	@Num_Proc_HIO VarChar(16),
	@Id_DC	int,
	@cdUsuario varchar(10)

AS

BEGIN TRANSACTION

	--Alessandra 23/03/2020 
	-- Não funciona no novo server, ver mais tarde se precisa mesmo e como recuperar a informação e passar via app
	-- ja estava desativado

	--Pegar o usuario q inseriu a inf.
	--declare @Host varchar(20) --SYSNAME --
	--declare @session_id int
	--select @Host = Client_Net_Address, @session_id = con.most_recent_session_id from sys.dm_exec_connections con   
	--INNER JOIN sys.dm_exec_sessions sess on con.session_id = sess.session_id   
	--where Sess.Session_ID = @@Spid

	--declare @cd_usuario varchar(20)
	--set @cd_usuario = (select top 1 cd_usuario from tmpLOG where job=@num_proc_hio and host = @Host and session_id = @session_id)

	--Qdo for ID_DC = 10 (Nota Fiscal)
	IF (@Id_DC = 10) and (len(@Numero_PO_hio) < 10)
		Begin
			set @Numero_PO_hio = right('000000000' + @Numero_PO_hio, 10)
		End

	Declare @ID Int

	set @ID_PO_HIO = (select ID_PO_HIO from PO_HIO where ID_DC=@ID_DC and Num_Proc_HIO=@Num_Proc_HIO and Numero_PO_HIO=@Numero_PO_HIO)

	if @ID_PO_HIO is not null
		BEGIN
			UPDATE
				PO_HIO
			SET
				Data_PO_HIO = @Data_PO_HIO,
				Numero_PO_HIO = @Numero_PO_HIO,
				Id_DC = @Id_DC,
				cd_usuario = @cdusuario,
				dt_ins = getdate()
			WHERE
				id_po_HIO = @ID_PO_HIO and Num_Proc_HIO = @Num_Proc_HIO
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc_HIO )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,
					ID_PO_HIO,	
					Numero_PO_HIO,
					Data_PO_HIO,
					Id_DC,
					cd_usuario,
					dt_ins
				)
			VALUES
				(
					@Num_Proc_HIO,
					@ID,
					@Numero_PO_HIO,
					@Data_PO_HIO,
					@Id_DC,
					@cdusuario,
					getdate()
				)
-----Caso D.I. inserir no historico
			If @Id_dc = 5
				Begin
					declare @Agora	datetime
					declare @Descr	varchar(200)

					set @Agora = (select getdate())
					set @Descr = ('Registro da D.I. dia: ' + convert(varchar(10), @Data_PO_hio, 103)  + ', Previsão de Parametrização dia: ' + convert(varchar(10), @Data_PO_hio + 1, 103) + '. Gerado por ATL System.')
					exec dbo.spHistG_InsUPD
								@Num_Proc_hio,
								Null,
								Null,
								'CHB Historico',
								@Descr,
								@Agora,
								Null,
								'ATL System',
								'S',
								'U',
								null
				End

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION
	

















GO
