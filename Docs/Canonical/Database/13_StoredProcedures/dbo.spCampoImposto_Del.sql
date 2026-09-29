SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCampoImposto_Del]
(
@NotaFiscal varchar (8),
@CdSite		char(1)
)
AS

Begin Transaction

	Delete Campo_Impostos where Nota_Fiscal = @NotaFiscal and Cd_Site = @CdSite

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

commit Transaction




GO
