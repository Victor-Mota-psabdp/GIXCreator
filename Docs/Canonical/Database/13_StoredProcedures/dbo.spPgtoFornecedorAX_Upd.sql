SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spPgtoFornecedorAX_Upd]

@ID bigint,
@Status varchar(max)
as
Update Pgto_Fornecedor_AX set Dt_Upd_ATL = GETDATE(), Status = @Status
where ID = @ID



GO
