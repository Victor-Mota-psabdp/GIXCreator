SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLog_LerXML_InsUpd] 
(
@Usuario varchar(30),
@Tipo char(1)
)
as

--/* Ratueira Desabilitada por Performance em 16-08-2010
Begin Transaction

	declare @Host varchar(50) --SYSNAME --

	--Alessandra 23/03/2020 - Não funciona no novo server, ver mais tarde se precisa mesmo e como recuperar a informação e passar via app
	--SELECT @Host = Client_Net_Address FROM sys.dm_exec_connections con   
	--INNER JOIN sys.dm_exec_sessions sess ON con.session_id = sess.session_id   
	--WHERE Sess.Session_ID = @@Spid

	Declare @Cd_Usuario	varchar(6)
	set @Cd_Usuario = (Select top 1 Cd_usuario from Usuario with (nolock) where nome_usuario = @Usuario)

--	print  @Host

	If @Tipo = '1'
		Begin
			if exists(select * from Log_LerXML with (nolock) where cd_usuario=@cd_usuario and Closed is null)
				Begin
					Update Log_LerXML
					Set Closed = getdate()
					Where cd_usuario=@cd_usuario and Host=@Host and Closed is null
				End

			Insert into Log_LerXML (cd_usuario, Host, Start, Closed, Origem)
			Values (@cd_usuario, @Host, getdate(), null,'Ler XML')
		End
	
	Else
		if @tipo='0'
			Begin
				Update Log_LerXML
				Set Closed = getdate()
				Where cd_usuario=@cd_usuario and Host=@Host and Closed is null
			End
		else
			if @tipo='3'
			Begin
				set @Cd_Usuario = @Usuario

				Insert into Log_LerXML (cd_usuario, Host, Start, Closed, Origem)
				Values (@cd_usuario, @Host, getdate(),GEtdate(),'Ler XML')
			END
	if @@Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION



--*/




GO
