SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spIntFMCPlanoContas_Del 'Acerto Ctas. Desp.-SeaAir(3)',' BDPT TRANSPORT '
create procedure [dbo].[spIntFMCPlanoContas_Del](
	@Nome_Tp_Tx		varchar	(50),
	@Apelido			varchar	(50)
)
as
Begin Transaction
	Declare @Cd_Tp_Tx varchar(3)
	Declare @Cd_Pes  varchar(10)

	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @Nome_Tp_Tx)
	Set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)

	Delete IntFMC_Plano_Contas where Cd_Tp_Tx = @Cd_Tp_Tx and Cd_Pes = @Cd_Pes

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
COMMIT TRANSACTION
GO
