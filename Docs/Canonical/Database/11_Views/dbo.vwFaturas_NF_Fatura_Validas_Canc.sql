SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----select * from item_fat where num_proc = 'IMSOL202601074BR' and cd_tp_tx = 'srv'
----select * from fatura where fatcod = 'IMSOL202601074BRB'

CREATE VIEW [dbo].[vwFaturas_NF_Fatura_Validas_Canc]
AS

	SELECT		
		isnull(convert(varchar(20),NFI.FatCod),F.FatCod)	AS	FatCod
		,isnull(NFI.Cd_Pes_Fat,F.Cd_Pes)					AS Cd_Pes_Fat
		,isnull(NFI.Num_Proc,I.Num_Proc)			AS Num_Proc
		,isnull(NFI.Cd_Tp_Tx,I.Cd_Tp_Tx)			AS Cd_Tp_Tx
		,isnull(NFI.DC,I.DC)						AS DC
		,isnull(NFI.Cd_Tp_Moeda,I.Cd_Tp_Moeda)		AS Cd_Tp_Moeda
		,isnull(NFI.Vlr_Org,I.Vlr_Org)				AS Vlr_Org
		,isnull(NFI.Vlr_RS,I.Vlr_RS)				AS Vlr_RS
		,isnull(NFI.Paridade,I.Paridade)			AS Paridade
		,isnull(NFI.Vlr_Cont_Item,I.Vlr_Cont_Item)	AS Vlr_Cont_Item
		,isnull(NFI.FatDtEmissao,F.FatDtEmissao)			AS FatDtEmissao
		,isnull(NFI.FatDtVenc,F.FatDtVenc)			AS FatDtVenc
		,isnull(NFI.FatVendorInvoiceNumber,F.FatVendorInvoiceNumber) AS FatVendorInvoiceNumber
		,isnull(NFI.Dt_Canc,F.Dt_Canc)				AS Dt_Canc
		--,isnull(NFI.dt_envio_canc_ax,F.dt_envio_canc_ax) AS Dt_Envio_Canc_Ax
		--,isnull(NFI.FCd_Status,F.FatStatus)			AS FatStatus		
	FROM dbo.Fatura F with(nolock) 
	JOIN dbo.Item_Fat I with(nolock)  ON I.FatCod = F.FatCod
	Left join [dbo].[vwNF_FaturaValidas_Canc] NFI with(nolock)  ON NFI.Num_Proc = I.Num_Proc and NFI.Cd_Tp_Tx = I.Cd_Tp_Tx and NFI.DC = I.DC 
	--Left join dbo.NF_Fatura NF ON NF.ID = NFI.ID
	WHERE	
		--F.FatCod in ('IMATN202603005BRA','IMATN202603005BRB')	AND 
		(F.FatStatus = '0')
		-- or NF.Cd_Status <> 2)



GO
