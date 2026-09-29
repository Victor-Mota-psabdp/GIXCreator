SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure spCancelaAxDoc_Upd(
@Id_AX bigint
)
as
update Ax_Doc set Dt_Canc = getdate()
where id_ax = @Id_AX

GO
