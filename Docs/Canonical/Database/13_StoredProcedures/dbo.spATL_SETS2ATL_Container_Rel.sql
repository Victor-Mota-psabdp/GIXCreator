SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_SETS2ATL_Container_Rel]'2019-01-01'
--select * from vwCliente_Alerta where num_proc = 'IMATL202101217BR'
--spATL_HIM_SEl 'IMATL202101217BR','D'
--select * from usuario where nome_usuario like 'diego%'
CREATE procedure [dbo].[spATL_SETS2ATL_Container_Rel]
(
	@Date datetime
 )

as

select
	S.ReferenceNumber [JOB Received],E.eventDate [Date Received],Q.EquipmentInitial+Q.EquipmentNumber [Container Number Received],
	E.EventCode [Event Code],E.EventDescription [Descrição],
	ATL.num_proc [JOB],ATL.Num_Cont [Container Number no ATL],ATL.Dt_Devol [Dt Retorno]
	,SE.Status [Sets Notes], SE.dt_upd [Sets Update Date],US.nome_usuario [Customer Name],
	VA.HAWB,VA.MAWB
	
from ATL_INT.dbo.XML315_Event E with(nolock)
	join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
	join ATL_INT.dbo.XML315_Event_Equipment Q with(nolock) on E.ID_Event = Q.ID_Event
	left join vwATL_Container ATL with(nolock) on ATL.num_proc = S.ReferenceNumber	and Q.EquipmentInitial+Q.EquipmentNumber = replace(ATL.num_cont,'-','') 
	left join SETS_Dates_Container SE with(nolock) on SE.ReferenceNumber=ATL.num_proc and SE.equipment = replace(ATL.num_cont,'-','')
	Join vwCliente_Alerta VA with(nolock) on VA.num_proc = S.ReferenceNumber	
	join Usuario US with(nolock) on US.cd_usuario = VA.cd_usuario
Where 
--S.ReferenceNumber = 'EMARC202012006BR' and 
E.eventcode in ('MTRD')
and S.ReferenceNumber like 'I%'
and E.eventDate > @Date

--and ATL.Dt_Devol is null
--and E.eventDate > '2019-01-01' --@Date
--and ATL.num_proc is null
--and VA.cd_usuario= 'dsf'
Order by
	 1,3





GO
