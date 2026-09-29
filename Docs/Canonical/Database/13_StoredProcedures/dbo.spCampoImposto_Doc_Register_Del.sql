SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCampoImposto_Doc_Register_Del]
(
@ID			int,
@CdSite		char(1)
)
AS

Begin Transaction

	Delete Campo_Impostos_Doc_Register where ID = @ID and Cd_Site = @CdSite

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

commit Transaction



GO
