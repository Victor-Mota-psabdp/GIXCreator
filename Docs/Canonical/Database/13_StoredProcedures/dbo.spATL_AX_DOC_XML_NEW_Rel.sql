SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help AX_DOC_XML_New
--[spATL_AX_DOC_XML_New_Sel]'','','','','N' --113
CREATE PROCEDURE [dbo].[spATL_AX_DOC_XML_NEW_Rel]
(	
	@StartDate			Datetime
)
as


select
	E.ID_AX								[Code],
	E.num_proc							[JOB],
	E.Cd_tp_Tx_ATL						[Charge Type Code],	
	C.Nome_Tp_TX						[Charge Type Name],
	E.DC								[D/C Code],
	D.Descricao_TP_DC							[D/C Name],
	Cancel								[Cancel],
	E.Dt_Envio							[Sent Date],
	--E.XML_DOC							[XML_DOC],
	--E.Nome_Arquivo						[File Name],
	--BR1ATL_V2_AP_dd0967a3-34b0-4a9b-86a8-3844f420d9e8_20230116.xml
	isnull(E.MessageId,RIGht(left(E.Nome_Arquivo,49),36))	[MessageId],
	isnull(E.Verificado,0)				[Verified],
	--E.Dt_Reenvio						[Resend Date],
	--DATEADD(day,1,E.Dt_Envio)			[DATEADD],
	--	DATEADD(MONTH,-1,GETDATE())		[MONTHADD],
	E.ErrorMessage						[ErrorMessage]
from AX_DOC_XML_New E  with(nolock)
	Join  Tipo_Taxa C with(nolock) on E.Cd_tp_Tx_ATL=C.Cd_tp_Tx		
	Join  Tipo_DC D with(nolock) on E.DC=D.Cd_Tp_DC	
where			
	--DATEADD(day,1,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()
	DATEADD(hour,6,E.Dt_Envio) between  DATEADD(MONTH,-1,GETDATE()) and getdate()

	--E.dt_envio between '2023-01-16 00:00:000' and '2023-01-16 23:32:08.240' 
	--DATEADD(day,1,E.Dt_Envio) between  GETDATE()- 2 and getdate()
	and isnull(E.Verificado,0) = 0
order by
	E.Dt_Envio


	

	

GO
