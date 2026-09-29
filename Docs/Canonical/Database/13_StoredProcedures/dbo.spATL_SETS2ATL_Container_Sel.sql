SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--delete SETS_Dates_Container

--100-462584 : Service Request - Por favor religar a rotina do Sets na Importação apenas.
--select * from SETS_Dates_Container  where Dt_Upd is null and EventDate < '2024-07-01' order by EventDate
--UPDATE SETS_Dates_Container set Dt_Upd ='2010-01-01' where Dt_Upd is null and EventDate < '2024-07-01' 
--select * from SETS_Dates_Container  where Dt_Upd is null and EventDate < '2024-07-01' 


--select * from SETS_Dates_Container  where Dt_Upd ='2010-01-01' and Dt_Ins >='2024-07-01' order by EventDate

--select ReferenceNumber [JOB],Equipment,EventCode,EventDescription,Convert(date,EventDate) EventDate
--from SETS_Dates_Container  where Dt_Upd ='2010-01-01' and Dt_Ins >='2024-07-01' and ReferenceNumber like 'I%'  
--order by EventDate

CREATE procedure [dbo].[spATL_SETS2ATL_Container_Sel]

as

Declare @Temp Table
(
	ReferenceNumber	varchar(16),
	Equipment	varchar(25),
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
		Q.EquipmentInitial+Q.EquipmentNumber,
		E.ID_Event,
		E.EventCode,
		E.EventDescription,
		E.EventDate,
		GETDATE() dt_ins,
		NULL,
		NULL
		from ATL_INT.dbo.XML315_Event E with(nolock)
			join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
			join ATL_INT.dbo.XML315_Event_Equipment Q with(nolock) on E.ID_Event = Q.ID_Event
			left join SETS_Dates_Container SD with(nolock) on  E.ID_Event = SD.ID_Event
		where 
		S.ReferenceNumber like 'I%' and 
		E.dt_ins >='2021-01-01' --getdate()-60 	
		and SD.ReferenceNumber is null
		and E.Eventcode in ('MTRD')

insert SETS_Dates_Container
	select * from @Temp

select 
	ID,
	ReferenceNumber,
	Equipment,
	ID_Event,
	EventCode,
	EventDescription,
	EventDate,
	Dt_Ins,
	Dt_Upd,
	Status
from 
	SETS_Dates_Container with(nolock) 
where
	Dt_Upd is null
	and eventdate <=getdate()

	--and ReferenceNumber in ('IMATL202101217BR','IMCSR202102055BR','IMCSR202102055BR','IMCSR202102055BR')
	--and ReferenceNumber in 	('IMMTE202104003BR','IMATL202102053BR','IMATL202101105BR')
Order by
	EventDate





GO
