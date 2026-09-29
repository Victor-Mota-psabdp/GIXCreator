SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_IBrokerFTDI_SelIns](
 @ID_ITDI bigint
)--[spATL_IBrokerFTDI_SelIns] 1
as
insert IBROKER_FTDI
select
@ID_ITDI, 
dbo.PreencheStringV2('FTDI',4,' ') [01],
dbo.PreencheStringV2('1',4,'0') [02],
dbo.PreencheStringV2('',232,' ') [03]



GO
