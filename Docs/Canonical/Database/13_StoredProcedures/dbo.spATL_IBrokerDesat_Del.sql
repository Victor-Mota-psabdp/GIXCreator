SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_IBrokerDesat_Del(
@ID bigint
)
as

Update IBROKER_CAPI_V2 set [Status] = 0
where ID = @ID
GO
