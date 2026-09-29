SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAutomaticJob_Report '2021-12-06','2022-03-16' ,'%'    
--cadu 16/12/2021 - alterado p usar o distinct
 --select top 10 * from  ATL_INT.[dbo].[GIX_Header_Parties]
  --select * from ATL_INT.[dbo].Tipo_House_Temp
CREATE  Procedure [dbo].[spAutomaticJob_Report] --spAutomaticJob_Report '2020-06-01','2020-06-20' ,'%'    
 @StartDate as Datetime,      
 @EndDate As Datetime,      
 @Consignee Varchar(60)      
As      
      
select Distinct
  HOUSE.[Intl_Reference] [Intl Reference],HOUSE.HAWB [AWB/BL Number],HOUSE.MAWB [MAWB/BL Number],HOUSE.Name_Export  Shipper,      
  HOUSE.Name_Consig  Consignee,
  Consig.PartyGlobalCode [Consignee Global Code],     
  HOUSE.Name_Org Origin,HOUSE.Name_Dst  Destination,HOUSE.Name_Armador Carrier,      
  HOUSE.Name_Navio Vessel, HOUSE.Name_Viagem Voyage,      
  HOUSE.ETD,HOUSE.ETA,HOUSE.ATD,HOUSE.ATA,HOUSE.Modal,AI.Ref_Number PurchaseOrderNumber
  ,P.Numero_PO_Temp  [BDPTransportYN]    
from [dbo].[House_Temp] HOUSE      
 Left Join ATL_INT.[dbo].[GIX_Header_References] AI on HOUSE.ID_Req = AI.ID_Req and AI.Ref_Type in ('PurchaseOrderNumber','BuyerReferenceNumber','SellerReferenceNumber')    
 left JOIN  PO_Temp P ON HOUSE.ID = P.ID and P.Name_Reference = 'bdptransportYN'
 left join ATL_INT.[dbo].[GIX_Header_Parties] Consig on HOUSE.ID_Req = Consig.ID_Req and Consig.Parties_Type in ('Consignee','Buyer')    
Where      
 convert(datetime,HOUSE.etd,103) between @StartDate and @EndDate and HOUSE.num_proc is null  
 --convert(datetime,HOUSE.etd,103) between '2020-06-01' and '2020-06-20' and HOUSE.num_proc is null 
 --and (Name_Consig  like @Consignee or @Consignee='') 
 


-- select       
--  HOUSE.[Intl_Reference] [Intl Reference],HOUSE.HAWB [AWB/BL Number],HOUSE.MAWB [MAWB/BL Number],HOUSE.Name_Export  Shipper,      
--  HOUSE.Name_Consig  Consignee,
--  Consig.PartyGlobalCode [Consignee Global Code],     
--  HOUSE.Name_Org Origin,HOUSE.Name_Dst  Destination,HOUSE.Name_Armador Carrier,      
--  HOUSE.Name_Navio Vessel, HOUSE.Name_Viagem Voyage,      
--  HOUSE.ETD,HOUSE.ETA,HOUSE.ATD,HOUSE.ATA,HOUSE.Modal,AI.Ref_Number PurchaseOrderNumber
--  ,P.Numero_PO_Temp  [BDPTransportYN] ,
--   JOB.Num_Proc [JOB]
--from [dbo].[House_Temp] HOUSE      
-- Left Join ATL_INT.[dbo].[GIX_Header_References] AI on HOUSE.ID_Req = AI.ID_Req and AI.Ref_Type in ('PurchaseOrderNumber','BuyerReferenceNumber','SellerReferenceNumber')    
-- left JOIN  PO_Temp P ON HOUSE.ID = P.ID and P.Name_Reference = 'bdptransportYN'
-- left join ATL_INT.[dbo].[GIX_Header_Parties] Consig on HOUSE.ID_Req = Consig.ID_Req and Consig.Parties_Type in ('Consignee','Buyer')    
-- left join [dbo].[vwHouse_Imp] JOB on JOB.Intl_Ref = House.intl_reference
--Where      
-- --convert(datetime,HOUSE.etd,103) between @StartDate and @EndDate and HOUSE.num_proc is null 
--  convert(datetime,HOUSE.etd,103) between '2020-06-01' and '2020-12-31' and HOUSE.num_proc is null  
--  and  JOB.Num_Proc is not null

-- --convert(datetime,HOUSE.etd,103) between '2020-06-01' and '2020-06-20' and HOUSE.num_proc is null 
-- --and (Name_Consig  like @Consignee or @Consignee='') 


--select       
--  HOUSE.[Intl_Reference] [Intl Reference],HOUSE.HAWB [AWB/BL Number],HOUSE.MAWB [MAWB/BL Number],HOUSE.Name_Export  Shipper,      
--  HOUSE.Name_Consig  Consignee,
--   JOB.Num_Proc [JOB]
--from [dbo].[House_Temp] HOUSE 
-- left join [dbo].[vwHouse_Imp] JOB on JOB.Intl_Ref = House.intl_reference
--Where 
--  convert(datetime,HOUSE.etd,103) between '2020-06-01' and '2020-12-31' and HOUSE.num_proc is null  
--  and  JOB.Num_Proc is not null


GO
