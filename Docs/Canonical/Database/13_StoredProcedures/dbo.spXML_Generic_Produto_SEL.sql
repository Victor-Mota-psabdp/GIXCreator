SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spXML_Generic_Produto_SEL]--'16','P000001460'
(
	@strSystemCode varchar(10)
)

as

SELECT distinct
				P.ProductCode													[cd_Proc_Cliente],
				GRP.cd_pes 														[Cd_Cliente],
				--Isnull(R.ProductReferenceNumber,P.[BrandName ])				[Produto_Descr],
				replace(Isnull(P.InvoiceDesc,P.[BrandName ]),'''','')			[Produto_Descr],				
				''																[NCM_Cliente],
				G.ID_Req														[AccountNum],
				G.SystemCode													[System_Code]
			from ATL_INT.dbo.GIX_Request_Header G with(nolock)
				join ATL_INT.dbo.GIX_Detail D with(nolock) on D.ID_Req = G.ID_Req
				join ATL_INT.dbo.GIX_Detail_ProductDetail P with(nolock) on P.ID_Req = D.ID_Req AND P.ID_Detail = D.ID_Detail
				--Left join ATL_INT.dbo.GIX_Detail_ProductReferences R with(nolock) on P.ID_Req = R.ID_Req AND P.ID_Detail = R.ID_Detail
				--	 and R.ProductReferences_Type = 'ProductDescription'			
				--Left Join Pessoa GRP with(nolock) on GRP.GIX_HT_Customer=G.Customer //GRP.GIX_HT_Customer não tenho em PROD
				LEFT JOIN Pessoa GRP WITH (NOLOCK) ON UPPER(LTRIM(RTRIM(REPLACE(GRP.Apelido, 'GRUPO ', '')))) = UPPER(LTRIM(RTRIM(G.Customer)))
			where  
		
				G.SystemCode = @strSystemCode				
				and G.DT_INS_PRODUTO is null
GO
