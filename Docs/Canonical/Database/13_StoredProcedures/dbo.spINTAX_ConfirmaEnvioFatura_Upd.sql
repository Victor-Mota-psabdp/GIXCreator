SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spINTAX_ConfirmaEnvioFatura_Upd]

AS

Update fatura set dt_envio_ax=getdate() From fatura  fat
Join Ax_Doc AX on AX.invoice_number=fatcod
where
	fat.dt_envio_Ax is null
GO
