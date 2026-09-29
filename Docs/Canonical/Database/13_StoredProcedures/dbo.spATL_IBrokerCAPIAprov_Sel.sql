SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAPIAprov_Sel] (
@ID bigint
)
as
select 
ID,
JOB [JOB],
Order_Reference [Order Reference] ,
convert(Varchar(10),Order_Date,103)  [Order Date],
Code_Modal_RM [Code Modal(RM)],
Modal_Description_RM [Modal Description(RM)],
Code_Origin_Country [Code Origin Country],
Origin_Country [Origin Country],
House [House] ,
Master [Master], 
convert(Varchar(10),Act_Carrier_Payment_Date,103)[Act. Carrier Payment Date],
convert(Varchar(10),ATA_Date,103) [ATA Date],
Gross_Weigth [Gross Weigth],
Net_Weigth [Net Weigth],
chkRef		,
chkPessoa	,
chkLocal	,
chkTotal	,
chkItem	,
chkDoc		,
Status_Doc,
Status
from 
IBROKER_CAPI_V2 
where ID = @ID
GO
