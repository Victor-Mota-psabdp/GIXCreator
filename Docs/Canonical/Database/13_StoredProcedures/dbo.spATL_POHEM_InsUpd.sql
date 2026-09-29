SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create        procedure [dbo].[spATL_POHEM_InsUpd]
			
	@ID_PO_hem int,
	@Numero_PO_hem Varchar(80),
	@Data_PO_hem Datetime,
	@Num_Proc_hem VarChar(16),
	@Id_DC	int,
	@CdUsuario varchar(10)

AS

BEGIN TRANSACTION

	--Alessandra 23/03/2020 
	-- Não funciona no novo server, ver mais tarde se precisa mesmo e como recuperar a informação e passar via app
	-- Já estava desabilitado

	--Pegar o usuario q inseriu a inf.
	--declare @Host varchar(20) --SYSNAME --
	--declare @session_id int
	--select @Host = Client_Net_Address, @session_id = con.most_recent_session_id from sys.dm_exec_connections con   
	--INNER JOIN sys.dm_exec_sessions sess on con.session_id = sess.session_id   
	--where Sess.Session_ID = @@Spid

	--declare @cd_usuario varchar(20)
	--set @cd_usuario = (select top 1 cd_usuario from tmpLOG with(nolock) where job=@num_proc_hem and host = @Host and session_id = @session_id)


	Declare @ID Int
	set @ID_PO_HEM = (select ID_PO_HEM from PO_HEM where ID_DC=@ID_DC and Num_Proc_HEM=@Num_Proc_HEM and Numero_PO_HEM=@Numero_PO_HEM)

	if @ID_PO_hem is not null
		BEGIN
			UPDATE
				PO_hem
			SET
				Data_PO_hem = @Data_PO_hem,
				Numero_PO_hem = @Numero_PO_hem,
				Id_DC = @Id_DC,
				cd_usuario = @cdusuario,
				dt_ins = getdate()
			WHERE
				id_po_hem = @ID_PO_hem and Num_Proc_hem = @Num_Proc_hem
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_hem),0)+1 from po_hem where Num_Proc_hem=@Num_Proc_hem )
			INSERT INTO
				PO_hem
				(
					Num_Proc_hem,
					ID_PO_hem,	
					Numero_PO_hem,
					Data_PO_hem,
					Id_DC,
					cd_usuario,
					dt_ins
				)
			VALUES
				(
					@Num_Proc_hem,
					@ID,
					@Numero_PO_hem,
					@Data_PO_hem,
					@Id_DC,
					@cdusuario,
					getdate()
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	














GO
