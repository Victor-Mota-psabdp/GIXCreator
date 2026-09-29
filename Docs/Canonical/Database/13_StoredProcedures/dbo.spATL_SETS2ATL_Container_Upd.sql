SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_SETS2ATL_Container_Upd]
(
	@ID bigint,
	@Status varchar(500)
)

as
IF EXISTS(SELECT id FROM SETS_Dates_Container WHERE ID = @ID)
begin
	update 
		SETS_Dates_Container 
	set 
		Status = @Status, 
		Dt_Upd = GETDATE() 
	where ID = @ID
END


GO
