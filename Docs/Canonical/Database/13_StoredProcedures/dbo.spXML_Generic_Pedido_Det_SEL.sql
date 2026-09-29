SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spXML_Generic_Pedido_Det_SEL]
(
	@PrimaryKey as varchar(50),
	@ID_Req		as bigint,
	@Tipo as char 
)
as

if @Tipo = 'A'
begin
--Ashland
SELECT DISTINCT
    G.ID_Req                        [ID_Req],
    G.PrimaryKey                    [Primary_Key],
    P.ProductCode                   [Nome_Produto],     
    'UN'                            [Lote],
    P.LineItemNo                    [Item],
    ''                              [Requerimento],     
    (CASE WHEN P.BilledQuantity IS NULL THEN 1 ELSE CONVERT(FLOAT, P.BilledQuantity) END) [Qty], -- Corrigido
    (CASE WHEN P.BilledQuantityUnit IS NULL THEN 'KG' ELSE P.BilledQuantityUnit END) [UOM], -- Corrigido
    (CASE WHEN P.Price IS NULL THEN 1 ELSE CONVERT(FLOAT, P.Price) END) [Vlr_Item], -- Corrigido
    (CASE WHEN P.ProductAmount IS NULL THEN 1 ELSE CONVERT(FLOAT, P.ProductAmount) END) [Vlr_Total_Item], -- Corrigido   
    NULL                            [Peso_Item],
    NULL                            [UOM_PRC],
    (CASE WHEN P.PriceUnit IS NULL THEN 'KG' ELSE P.PriceUnit END) [Peso_UOM], -- Corrigido
    (CASE WHEN M.MeasurementValue IS NULL THEN 1 ELSE CONVERT(FLOAT, M.MeasurementValue) END) [Peso_Bruto_TOT], -- Corrigido
    (CASE WHEN M.MeasurementValue IS NULL THEN 1 ELSE CONVERT(FLOAT, M.MeasurementValue) END) [Peso_Liquido_TOT], -- Corrigido
    NULL                            [Peso_Invoice],
    NULL                            [SAP_Company],
    NULL                            [Contract],
    NULL                            [NATOP],
    NULL                            [Finalidade],
    NULL                            [PO_GRP],
    NULL                            [In_Progress],
    NULL                            [Requision],
    (CASE WHEN P.Compliance_ClassificationNumber IS NULL THEN 0 ELSE P.Compliance_ClassificationNumber END) [NCM], -- Corrigido
    (CASE WHEN P.FreightCharge IS NULL THEN 0 ELSE P.FreightCharge END) [UPC], -- Corrigido
    (CASE WHEN P.NoOfPkgs IS NULL THEN 0 ELSE P.NoOfPkgs END) [Qtde], -- Corrigido
    (CASE WHEN PKG.Nome_Tp_Embal IS NULL THEN 0 ELSE PKG.Nome_Tp_Embal END) [Embalagem], -- Corrigido
    'ATL System'                    [Usuario],
    NULL                            [Fabricante],
    Country.Nome_Pais               [Pais_Fabricante],
    NULL                            [Vlr_FOB],   
    P.CurrencyCode                  [Cd_Tp_Moeda],
    G.SystemCode,
    ISNULL(REPLACE(REPLACE(P.Marks, 'PR OF ', ''), 'Country of origin', 'MADE IN'), '') [Marks]
FROM 
    ATL_INT.DBO.GIX_Request_Header G WITH(NOLOCK)
    JOIN PessoaGIX GR ON GR.GIX_HT_CUSTOMER = G.Customer
    JOIN ATL_INT.DBO.GIX_Detail D WITH(NOLOCK) ON D.ID_Req = G.ID_Req
    JOIN ATL_INT.DBO.GIX_Detail_ProductDetail P WITH(NOLOCK) ON P.ID_Req = D.ID_Req AND P.ID_Detail = D.ID_Detail             
    LEFT JOIN ATL_INT.DBO.GIX_Detail_ProductDetail_Measurements M WITH(NOLOCK) ON P.ID_Req = M.ID_Req AND M.type LIKE 'Grs%' AND P.ID_Detail = M.ID_Detail
    LEFT JOIN Pedido PD WITH(NOLOCK) ON PD.Num_Pedido = G.PrimaryKey COLLATE Latin1_General_CI_AS AND PD.Cd_Grupo = GR.Cd_Pes
    LEFT JOIN Pais Country ON P.CountryofOriginCode = Country.Cd_Pais
    LEFT JOIN Tipo_Embalagem PKG ON PKG.ISO_CODE = P.TypePkgCode
WHERE  
	--PrimaryKey ='3280056193' --@PrimaryKey
	--and	
	G.ID_Req = @ID_Req --150166 
	--and G.SystemCode = '16'
	--and P.LineItemNo is not null
	

	end



GO
