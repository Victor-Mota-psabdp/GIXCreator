SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spRPSRec_Upd]

	@Nota_Fiscal	varchar(8),
	@Site			char(1),
	@RPS_Data		datetime,
	@RPS_NFE		varchar(9),
	@RPS_NFE_Verif	varchar(8),
	@CdsId			int,
	@SitId			char(1),
	@Aliq_ISS_Rps	decimal(5,2),
	@RPS_Envio		bit


as

BEGIN TRANSACTION

	Update
		base_nota_fiscal
	Set
		RPS_Data = @RPS_Data,
		RPS_NFE = @RPS_NFE,
		RPS_NFE_Verif = @RPS_NFE_Verif,
		CdsId = @CdsId,
		SitId = @SitId,
		Aliq_ISS_Rps = @Aliq_ISS_Rps,
		RPS_Envio = @RPS_Envio
	where 
		nota_fiscal = @Nota_Fiscal and ref_acesso = @site
		



	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
