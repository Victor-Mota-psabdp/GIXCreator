SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spPgtoClienteAX_Upd]

@ID bigint,
@Status varchar(max)
as
Update Pgto_Cliente_AX set Dt_Upd_ATL = GETDATE(), Status = @Status
where ID = @ID



GO
