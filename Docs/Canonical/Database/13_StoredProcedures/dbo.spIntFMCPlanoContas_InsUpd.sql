SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spIntFMCPlanoContas_InsUpd](
	@Nome_Tp_Tx		varchar	(50),
	@Apelido			varchar	(50),
	@Conta_Debito	varchar (7),
	@Conta_Credito	varchar	(7)
)
as
Begin Transaction
	Declare @Cd_Tp_Tx varchar(3)
	Declare @Cd_Pes  varchar(10)

	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @Nome_Tp_Tx)
	Set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)

	If Not Exists(Select Cd_Tp_Tx from IntFMC_Plano_Contas where Cd_Tp_Tx = @Cd_Tp_Tx and Cd_Pes = @Cd_Pes)
		Begin
			Insert into IntFMC_Plano_Contas (
											Cd_Tp_Tx,
											Cd_Pes,
											Conta_Debito,
											Conta_Credito
											)
										Values
											(
											@Cd_Tp_Tx,
											@Cd_Pes,
											@Conta_Debito,
											@Conta_Credito
											)
		End
	else
		Begin
				Update IntFMC_Plano_Contas Set
											Cd_Tp_Tx = @Cd_Tp_Tx,
											Cd_Pes = @Cd_Pes,
											Conta_Debito = @Conta_Debito,
											Conta_Credito = @Conta_Credito													
				where	
					Cd_Tp_Tx = @Cd_Tp_Tx and Cd_Pes = @Cd_Pes
		End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
COMMIT TRANSACTION
GO
