SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_NFe_RPS_Cancelamento_Upd]

	@RPS_NFE	varchar(8),
	@Site		char(1),
	@dt_Cancel_Prefeitura	datetime
	
as

BEGIN TRANSACTION

	Update
		base_nota_fiscal
	Set
		dt_Cancel_Prefeitura = @dt_Cancel_Prefeitura
	where 
		RPS_NFE = @RPS_NFE and ref_acesso = @site
		



	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
