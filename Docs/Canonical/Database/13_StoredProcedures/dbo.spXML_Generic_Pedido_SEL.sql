SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spXML_Generic_Pedido_SEL]
(
	@strSystemCode varchar(10)
)
as


	if @strSystemCode = '21'
	BEGIN
		select distinct
			G.ID_Req,
            P.Cd_pedido							[Cd_pedido],
            G.PrimaryKey						[Num_Pedido],           
        
			LEFT(Consignee.PartyName, 20 - LEN(ISNULL(Consignee.PartyPostalCode, 'XXXX')) - 1) 
			+ '-' + ISNULL(Consignee.PartyPostalCode, 'XXXX') [Buyer],
			(Case when ShipFrom.PartyName = 'ASHLAND GLOBAL' then (select apelido from pessoa where cd_pes = 'P000045622') end)	[Seller],		
			'CIF'							[Incoterm],
            --left(Transp.method,1)			[cd_modal],
			'O'								[cd_modal],
            ProductDetail.CurrencyCode		[cd_tp_moeda],            
            null							[vlr_pedido],	
			
            isnull(ISNULL(convert(datetime,
				BuyerReferenceNumber.ReferenceDate,102),
                convert(datetime,ExportReferenceNumber.ReferenceDate,102)),
				GETDATE())  [Dt_Pedido],
           
            (case when len(isnull(RequiredETADestinationDate.StatusDate,'0')) <> 8 then getdate() else
				 (case when left(RequiredETADestinationDate.StatusDate,1) = '0' then getdate()
				else  
				convert(datetime, left(RequiredETADestinationDate.StatusDate,4)
				+ '-' + substring(RequiredETADestinationDate.StatusDate,5,2) + '-' +
				right(RequiredETADestinationDate.StatusDate,2),102)
				end) end) [DL_Chegada],
                    
            'Ashland IntegraGIX2ATL Integration'	[Obs_PC],
            NULL									[Cd_Pes_CTT],
            NULL									[Cd_Tp_Cont],
            NULL									[Contato],
            3										[Cd_tipo],
			--1										[Cd_tipo],
			--'All'									[Nome_tipo],
            Org.Nome_Pais							[Nome_Pais_Origem],
            DST.Nome_Pais							[Nome_Pais_Destino],            
            (CASE WHEN PS.Cd_pedido IS Not NULL THEN 'C' ELSE 'O' END) [Status],
            NULL									[Cd_USERID],
            NULL									[Cd_CSRID],
            GR.APELIDO								[Grupo],
			GR.Cd_Pes								[Cd_Grupo],
			G.PrimaryKey							[Num_PO], -- P preencher na ordem o campo PO com o numero que vem no PK do GIX
			G.PrimaryKey							[Customer_PO], -- P preencher na ordem o campo PO com o numero que vem no PK do GIX 
            NULL									[Payment],
            NULL									[Order_Type],         		 
			LEFT(Consignee.PartyName, 20 - LEN(ISNULL(Consignee.PartyPostalCode, 'XXXX')) - 1) 
			+ '-' + ISNULL(Consignee.PartyPostalCode, 'XXXX') Consignee,
			
			G.UniqueMessageID						[Selling_SAP], --Adicionei o Booking Id neste campo para casos Ashland
            NULL									[PO_Responsible],
            NULL									[Planta],            
            G.ID_Req
						
        from ATL_INT.DBO.GIX_Request_Header G with(nolock)
            --Join Pessoa GR with(nolock) on GR.GIX_HT_CUSTOMER=G.Customer
			--JOIN Pessoa GR WITH (NOLOCK) ON UPPER(LTRIM(RTRIM(REPLACE(GR.Apelido, 'GRUPO ', '')))) = UPPER(LTRIM(RTRIM(G.Customer)))
			join PessoaGIX GR WITH (NOLOCK) on GR.GIX_HT_CUSTOMER=G.Customer
            left join ATL_INT.DBO.GIX_Header_Parties Exporter with(nolock) on Exporter.ID_Req = G.ID_Req	
                and (Exporter.Parties_Type = 'Exporter' or Exporter.Parties_Type = 'ExporterShipper')

            left join ATL_INT.DBO.GIX_Header_Parties ShipFrom with(nolock) on ShipFrom.ID_Req = G.ID_Req	
                and (ShipFrom.Parties_Type = 'ShipFrom' or ShipFrom.Parties_Type = 'Shipper')
           
            left join ATL_INT.DBO.GIX_Header_Parties Consignee with(nolock) on Consignee.ID_Req = G.ID_Req 
                and (Consignee.Parties_Type = 'Consignee')               
            
            left join ATL_INT.DBO.GIX_Header_Parties UltimateConsignee with(nolock) on UltimateConsignee.ID_Req = G.ID_Req 
                and ( UltimateConsignee.Parties_Type = 'UltimateConsignee')
            
            left join ATL_INT.DBO.GIX_Header_References BuyerReferenceNumber with(nolock) on G.ID_Req = BuyerReferenceNumber.ID_Req  
                AND BuyerReferenceNumber.Ref_Type = 'BuyerReferenceNumber'	
				
			left join ATL_INT.DBO.GIX_Header_References ShipmentNumber with(nolock) on G.ID_Req = ShipmentNumber.ID_Req  
                AND ShipmentNumber.Ref_Type = 'ShipmentNumber'	

			left join ATL_INT.DBO.GIX_Header_References MainLeg with(nolock) on G.ID_Req = MainLeg.ID_Req  
                AND MainLeg.Ref_Type = 'MainLegBOL'	
                
            left join ATL_INT.DBO.GIX_Header_References ExportReferenceNumber with(nolock) on G.ID_Req = ExportReferenceNumber.ID_Req  
                AND ExportReferenceNumber.Ref_Type ='ExportReferenceNumber'
            
            left join ATL_INT.DBO.GIX_Header_References HouseBillofLadingNumber with(nolock) on G.ID_Req = HouseBillofLadingNumber.ID_Req  
                AND HouseBillofLadingNumber.Ref_Type = 'MasterBillOfLading'
            
            left join ATL_INT.DBO.GIX_Header_Transportation Transp with(nolock) on Transp.ID_Req = G.ID_Req	
                            
            left join ATL_INT.DBO.GIX_Header_Transportation_ReferenceType RF with(nolock) on Transp.ID_Req = RF.ID_Req  
                AND Transp.ID_Trans = RF.ID_Trans AND RF.type = 'MasterBillOfLading'
                            
            left join ATL_INT.DBO.GIX_Header_Status RequiredETADestinationDate with(nolock) on RequiredETADestinationDate.ID_Req = G.ID_Req			
                AND RequiredETADestinationDate.StatusType = 'RequiredETADestinationDate'
            
            left join ATL_INT.DBO.GIX_Detail Detail with(nolock) on Detail.ID_Req = G.ID_Req
            left join ATL_INT.DBO.GIX_Detail_ProductDetail ProductDetail with(nolock) on Detail.ID_Req = ProductDetail.ID_Req
            and Detail.ID_Detail = ProductDetail.ID_Detail
            
            left join Pais ORG with(nolock) on ORG.Cd_Pais = TRANSP.OriginCountryCode
            left join Pais DST with(nolock) on DST.Cd_Pais = TRANSP.DestinationCountryCode 
                    
            left join Pedido P with (nolock) on P.Num_Pedido = G.PrimaryKey collate Latin1_General_CI_AS and Cd_Grupo = GR.Cd_Pes 
            left join Pedido_Ship PS with (nolock) on P.Cd_pedido= PS.Cd_pedido
            Left Join  ATL_INT.[dbo].[GIX_Header_Commercial_Invoice] CI with(nolock) on G.ID_Req=CI.id_req
        where

			--G.ID_Req = 182841 and             
			SystemCode = @strSystemCode			 
    AND G.DT_INS_PEDIDO IS NULL

    AND EXISTS (
        SELECT 1
        FROM ATL_INT.DBO.GIX_Header_Parties HP WITH (NOLOCK)
        WHERE HP.ID_Req = G.ID_Req
          AND HP.PartyName IS NOT NULL
          AND HP.Parties_Type IN ('Exporter', 'ExporterShipper', 'ShipFrom', 'Shipper')
    )

    AND EXISTS (
        SELECT 1
        FROM ATL_INT.DBO.GIX_Header_Parties HP WITH (NOLOCK)
        WHERE HP.ID_Req = G.ID_Req
          AND HP.PartyName IS NOT NULL
          AND HP.Parties_Type IN ('Consignee', 'UltimateConsignee')
    )

    AND PS.Item IS NULL
          
        order by G.ID_Req
	END
GO
