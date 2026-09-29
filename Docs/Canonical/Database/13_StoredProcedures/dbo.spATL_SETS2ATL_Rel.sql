SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_SETS2ATL_Rel]'2021-01-01'
CREATE procedure [dbo].[spATL_SETS2ATL_Rel]
(
	@Date datetime
 )

as

--declare @Date datetime
--set @Date = '2021-01-01'

select
	S.ReferenceNumber [JOB Received],E.eventDate [Date Received],
	E.EventCode [Event Code],E.EventDescription [Descrição],
	VA.num_proc [JOB],VA.HAWB,VA.MAWB,VA.Booking_Number,
	SD.Status [Sets Notes], SD.dt_upd [Sets Update Date],US.nome_usuario [Customer Name]	
from ATL_INT.dbo.XML315_Event E with(nolock)
	join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
	left join SETS_Dates SD with(nolock) on  E.ID_Event = SD.ID_Event
	Join vwHouse_Imp VA with(nolock) on VA.num_proc = S.ReferenceNumber	
	join Usuario US with(nolock) on US.cd_usuario = VA.cd_usuario
Where
	E.Eventcode in ('ARRV','DEPV')
	and E.eventDate > @Date
	and SD.dt_upd > '2020-01-01'
union all
select
	S.ReferenceNumber [JOB Received],E.eventDate [Date Received],
	E.EventCode [Event Code],E.EventDescription [Descrição],
	VA.num_proc [JOB],VA.HAWB,VA.MAWB,VA.Booking_Number,
	SD.Status [Sets Notes], SD.dt_upd [Sets Update Date],US.nome_usuario [Customer Name]	
from ATL_INT.dbo.XML315_Event E with(nolock)
	join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
	left join SETS_Dates SD with(nolock) on  E.ID_Event = SD.ID_Event
	Join vwHouse_Exp VA with(nolock) on VA.num_proc = S.ReferenceNumber	
	join Usuario US with(nolock) on US.cd_usuario = VA.cd_usuario
Where
	E.Eventcode in ('ARRV','DEPV')
	and E.eventDate > @Date
	and SD.dt_upd > '2020-01-01'
Order by
	 1,3




GO
