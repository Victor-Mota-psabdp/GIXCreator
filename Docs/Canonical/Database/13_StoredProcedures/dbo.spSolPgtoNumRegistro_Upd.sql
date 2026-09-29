SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolPgtoNumRegistro_Upd]
(
@ID bigint,
@NumRegistro varchar(25)
)
as

Update Sol_Pgto_Cta_Cte set Num_Registro = @NumRegistro
where ID = @ID

GO
