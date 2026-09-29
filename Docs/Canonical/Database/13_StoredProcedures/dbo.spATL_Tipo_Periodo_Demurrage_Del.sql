SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Tipo_Periodo_Demurrage_Del](
	@Cd_Periodo int
)
as
if exists(select Cd_Periodo from Tipo_Periodo_Demurrage where Cd_Periodo= @Cd_Periodo)
begin
	delete Tipo_Periodo_Demurrage where Cd_Periodo= @Cd_Periodo
end



GO
