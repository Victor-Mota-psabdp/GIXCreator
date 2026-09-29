SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spFaturaBDP_VendorInvoice_Upd]
		@FatCod 					VarChar(17),
		@FatVendorInvoiceNumber		VarChar(17) -- Alessandra 17/06/2020 - AX10
AS

if @FatCod is not null
		UPDATE
			FATURA
		SET
			FatVendorInvoiceNumber = @FatVendorInvoiceNumber -- Alessandra 17/06/2020 - AX10
		WHERE
			FatCod=@FatCod





GO
