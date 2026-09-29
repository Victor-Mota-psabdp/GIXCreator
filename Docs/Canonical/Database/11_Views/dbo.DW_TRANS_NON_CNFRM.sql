SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * from [dbo].[DW_TRANS_NON_CNFRM]

CREATE VIEW [dbo].[DW_TRANS_NON_CNFRM]
AS

SELECT 
       TNC.cd_nc									[NON_CNFRM_CD],		--<Request><Header><NonConformance><ReasonCode></ReasonCode></NonConformance></Header></Request>
       '1'											[NON_CNFRM_SEQ_ID],
	   HG.HSGProcesso								[FRWDR_REF_NBR],
	   '01BDPBRSAO'									[BDP_SS_ID],
	   FORMAT(HG.HSGData, 'dd/MM/yy')				[NON_CNFRM_DT],		--<Request><Header><NonConformance><Date></Date></NonConformance></Header></Request>
       FORMAT(HG.HSGData, 'dd/MM/yy')				[NON_CNFRM_DTM],	--<Request><Header><NonConformance><Time></Time></NonConformance>
	   TNC.descricao_nc								[NON_CNFRM_DESC],	--<Request><Header><NonConformance><ReasonDesc></ReasonDesc></NonConformance></Header></Request>
	   NULL											[NON_CNFRM_RESOL_DT],
	   NULL											[NON_CNFRM_RESOL_DTM]

FROM   hist_geral HG WITH(nolock)
       JOIN tipo_nc_cliente TNC WITH(nolock) ON TNC.cd_nc = HG.id_nc

WHERE  
CONVERT(DATETIME, hg.hsgdata, 105) > Getdate() - 120 
and TNC.Ativo = 'S'

GO
