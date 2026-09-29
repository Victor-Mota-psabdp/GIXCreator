SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--0
--1
--2 - cancel

--select * from [dbo].[vwNF_FaturaValidas] where ID = '173560'
CREATE VIEW [dbo].[vwNF_Fatura_ALL]
AS

	SELECT		
		F.Numero_Fat FatCod
		, F.Cd_Pes AS Cd_Pes_Fat
		, I.Num_Proc
		, I.Cd_Tp_Tx
		, I.DC
		, I.Cd_Tp_Moeda
		, I.Vlr_Org
		, I.Vlr_RS
		, I.Paridade
		, I.Vlr_Cont_Item
		, F.Emissao FatDtEmissao
		, F.Vencimento FatDtVenc
		, F.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
		, F.Dt_Canc
		,F.ID
		,F.Nota_Fiscal FNota_Fiscal
		,F.Ref_Acesso FRef_Acesso
		,F.Cd_Status FCd_Status
	FROM dbo.NF_Fatura F 
	INNER JOIN dbo.NF_Fatura_Item I ON I.ID = F.ID
	--WHERE   (F.Cd_Status <> 2)

GO
