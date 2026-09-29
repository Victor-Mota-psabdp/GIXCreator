SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       procedure [dbo].[spATL_TaxaCashFlow_InsUpd]

	@ChargeCode varchar(3),
	@ChargeName	varchar(50),
	@ChargeNameING	varchar(50),
	@TypeCashFlow	varchar(100),
	@Cd_Usuario varchar(6)
	
AS

Declare @ID_TypeExpense int
 set @ID_TypeExpense = (Select ID_TypeExpense  from Type_Expense where Type_Expense = @TypeCashFlow)

Begin Transaction

	IF  exists(
		SELECT
			cd_tp_tx
		FROM
			Taxa_CashFlow
		WHERE
			Cd_tp_tx = @ChargeCode
		)

	BEGIN
		UPDATE
			Taxa_CashFlow
		SET
			ID_TypeExpense = @ID_TypeExpense,
			dt_Insert = getdate()
		WHERE
			Cd_Tp_Tx=@ChargeCode

	END
	ELSE
		INSERT
			Taxa_CashFlow(
				Cd_Tp_Tx,
				ID_TypeExpense,
				Dt_Insert,
				Cd_Usuario
				)
		Values
			(
				@ChargeCode,
				@ID_TypeExpense,
				getdate(),
				@Cd_usuario
			)
	

Commit Transaction











GO
