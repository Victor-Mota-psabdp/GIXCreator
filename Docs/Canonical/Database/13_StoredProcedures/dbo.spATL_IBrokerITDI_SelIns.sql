SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerITDI_SelIns]


as
Declare @ID_ITDI bigint

set @ID_ITDI =(Select ISNULL(max(ID_ITDI),0)+1  from IBROKER_ITDI)
insert IBROKER_ITDI
select 
@ID_ITDI,
NULL,
'ITDI'[01],
replace(convert(varchar(10),GETDATE(),3),'/','')[02],
replace(convert(varchar(10),GETDATE(),108),':','')[03],
'03706460000209'[04],
dbo.PreencheStringV2('ATL System',20,' ') [05],
'GIP Lite'[06],
dbo.PreencheStringV2('',150,' ') [05]

select ID_ITDI from IBROKER_ITDI where ID_ITDI = @ID_ITDI
GO
