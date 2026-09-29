SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRPSRec_Cancelada_Upd]

	@Nota_Fiscal	varchar(8),
	@Site			char(1),
	@dt_Cancel_Prefeitura	datetime,
	@SitId			char(1)
as

BEGIN TRANSACTION

	Update
		base_nota_fiscal
	Set
		dt_Cancel_Prefeitura = @dt_Cancel_Prefeitura,
		SitId = @SitId
	where 
		nota_fiscal = @Nota_Fiscal 
		and ref_acesso = @site
		



	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
