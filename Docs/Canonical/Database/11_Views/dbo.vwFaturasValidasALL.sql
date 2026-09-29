SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create VIEW [dbo].[vwFaturasValidasALL]
AS

	SELECT		
		I.FatCod
		, F.Cd_Pes AS Cd_Pes_Fat
		, I.Num_Proc
		, I.Cd_Tp_Tx
		, I.DC
		, I.Cd_Tp_Moeda
		, I.Vlr_Org
		, I.Vlr_RS
		, I.Paridade
		, I.Vlr_Cont_Item
		, F.FatDtEmissao
		, F.FatDtVenc
		, F.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
		, F.Dt_Canc
		, F.dt_envio_canc_ax
	FROM dbo.Fatura F 
	INNER JOIN dbo.Item_Fat I 
		ON I.FatCod = F.FatCod
	WHERE     (F.FatStatus <> 0)

GO
