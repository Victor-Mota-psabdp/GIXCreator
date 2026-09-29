SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--100-462584 : Service Request - Por favor religar a rotina do Sets na Importação apenas.
--select * from SETS_Dates  where Dt_Upd is null and EventDate < '2024-07-01' order by EventDate
--UPDATE SETS_Dates set Dt_Upd ='2010-01-01' where Dt_Upd is null and EventDate < '2024-07-01' 
--UPDATE SETS_Dates set Dt_Upd ='2010-01-01' where Dt_Upd is null and ReferenceNumber like 'E%'

--select ReferenceNumber [JOB],EventCode,EventDescription,Convert(date,EventDate) EventDate
--from SETS_Dates  where Dt_Upd ='2010-01-01' and Dt_Ins >='2024-07-01' and ReferenceNumber like 'I%'  
--order by EventDate

--sp_help SETS_Dates
CREATE procedure [dbo].[spATL_SETS2ATL_Sel]

as

Declare @Temp Table
(
	ReferenceNumber	varchar(16),
	ID_Event	bigint,
	EventCode	varchar(200),
	EventDescription	varchar(200),
	EventDate datetime,
	Dt_Ins	datetime,
	Dt_Upd	datetime,
	Status	varchar(500)
)
insert @Temp
	select 
		S.ReferenceNumber,
		E.ID_Event,
		E.EventCode,
		E.EventDescription,
		E.EventDate,
		GETDATE(),
		NULL,
		NULL
		from ATL_INT.dbo.XML315_Event E with(nolock)
			join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
			left join SETS_Dates SD with(nolock) on  E.ID_Event = SD.ID_Event
		where 
		S.ReferenceNumber like 'I%' and --100-462584 : Service Request - Por favor religar a rotina do Sets na Importação apenas.
		E.dt_ins >='2021-01-01' --getdate()-60 	
		and SD.ReferenceNumber is null
		and E.Eventcode in ('ARRV','DEPV')


insert SETS_Dates
	select * from @Temp

select 
	ID,
	ReferenceNumber,
	ID_Event,
	EventCode,
	EventDescription,
	EventDate,
	Dt_Ins,
	Dt_Upd,
	Status
from 
	SETS_Dates with(nolock) 
where
	Dt_Upd is null
	and eventdate <=getdate()
Order by
	EventDate







GO
