SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_SETS2ATL_Upd]
(
@ID bigint,
@Status varchar(500)
)

as

update SETS_Dates set Status = @Status, Dt_Upd = GETDATE()
where ID = @ID


GO
