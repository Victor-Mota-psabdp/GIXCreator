SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spLOG_AX_Servicos_Ins]
	
	@Grupo	varchar(20),
	@Taxa	varchar(50),
	@cd_usuario varchar(6),
	@Tipo		varchar(1)

AS

Begin Transaction

Declare @cd_grupo as varchar(10)
Declare @cd_tp_tx as varchar(3)

	Set @cd_grupo =(select cd_pes from Grupo G join Pessoa P on P.cd_pes=G.cd_pes_grupo and P.Desat_Pes='N' where Apelido = @Grupo)
	SET @cd_tp_tx=(select cd_tp_tx from tipo_taxa where nome_tp_tx=@Taxa)

		INSERT
			Log_AX_Servicos(cd_grupo,cd_tp_tx,cd_usuario,dt_ins,tipo)
		Values
			(@cd_grupo,@cd_tp_tx,@cd_usuario,getdate(),@tipo)	

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION


GO
