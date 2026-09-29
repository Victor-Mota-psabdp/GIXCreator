SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_FaturaCHB_Upd(
@Fatura_PC varchar(17),
@Cd_Usuario varchar(6)
)
as
update Fatura_CHB set Cd_Usuario_Print = @Cd_Usuario,Dt_Print = GETDATE()
where Fatura_PC = @Fatura_PC
GO
