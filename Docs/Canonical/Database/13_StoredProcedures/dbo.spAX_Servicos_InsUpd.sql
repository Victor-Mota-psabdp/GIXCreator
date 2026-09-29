SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAX_Servicos_InsUpd]
	
	@Grupo	varchar(20),
	@Taxa	varchar(50),
	@cd_usuario varchar(6)

AS

Begin Transaction

Declare @cd_grupo as varchar(10)
Declare @cd_tp_tx as varchar(3)

	Set @cd_grupo =(select cd_pes from Grupo G join Pessoa P on P.cd_pes=G.cd_pes_grupo and P.Desat_Pes='N' where Apelido = @Grupo)
	SET  @cd_tp_tx=(select cd_tp_tx from tipo_taxa where nome_tp_tx=@Taxa)

	IF exists(SELECT cd_grupo,cd_tp_tx FROM AX_Servicos WHERE cd_grupo = @cd_grupo and cd_tp_tx = @cd_tp_tx)
		BEGIN
			UPDATE
				AX_Servicos
			SET			
				cd_usuario = @cd_usuario,
				dt_ins = getdate() 
			WHERE
				cd_grupo = cd_grupo 
				and cd_tp_tx = cd_tp_tx
		END
	ELSE
		INSERT
			AX_Servicos(cd_grupo,cd_tp_tx,cd_usuario,dt_ins)
		Values
			(@cd_grupo,@cd_tp_tx,@cd_usuario,getdate())

Commit Transaction


GO
