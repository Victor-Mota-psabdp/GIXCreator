SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spDemurrage_ATL_Upd]
		@Fatura	VarChar(17)

as	

		UPDATE
			DEMURRAGE_ATL
		SET					
			dt_envio = GETDATE()					
		WHERE
			processo=left(@Fatura ,16)
			and fatura=right(@Fatura,1)




GO
