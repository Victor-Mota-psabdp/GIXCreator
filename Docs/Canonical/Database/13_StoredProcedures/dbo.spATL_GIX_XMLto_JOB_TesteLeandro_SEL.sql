SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_TesteLeandro_SEL] --'4','BDPJobNumber' spATL_GIX_XMLto_JOB_Pibernat_SEL
(
	@SystemCode VARCHAR(25),
	@Ref_Type VARCHAR(100)
)

as

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock) 
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
	and ImportForwarderRefNbr.Ref_Type = @Ref_Type --'BDPJobNumber'
	join vwALL_JOBs V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number

where
	DT_INS_JOB is null and 
	Request.SystemCode = @SystemCode
	and isnull(v.ID_Status,0) not in ('9','5')
 	and Request.ID_Req = 24661668

order by
	2
GO
