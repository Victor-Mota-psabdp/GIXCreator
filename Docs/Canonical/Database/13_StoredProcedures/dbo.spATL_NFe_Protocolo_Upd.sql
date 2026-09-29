SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 23/6/2020 included the if exists
CREATE Procedure [dbo].[spATL_NFe_Protocolo_Upd]

	@Nota_Fiscal		varchar(8),
	@Site				char(1),
	@DataRecebimento	Datetime,
	@Protocolo			varchar(50)

as

BEGIN TRANSACTION

	if exists(select protocolo from base_nota_fiscal where nota_fiscal = @Nota_Fiscal and ref_acesso = @site 
		and protocolo is null)
		BEGIN
			Update
				base_nota_fiscal
			Set
				dt_Protocolo = @DataRecebimento,
				protocolo = @Protocolo		
			where 
				nota_fiscal = @Nota_Fiscal and ref_acesso = @site
		END

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
