SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spExchange_Alerta_UPD]

	@Num_Proc		varchar(16),
	@Id_TP_Alerta		varchar(1)

as
BEGIN TRANSACTION

	Update
		Exchange_Alerta
	Set
		Dt_envio= GETDATE()
	where 
		Dt_Envio is null
		and Num_Proc = @Num_Proc
		and Id_TP_Alerta = @Id_TP_Alerta

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
