SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Moeda
CREATE procedure [dbo].[spATL_Tipo_Moeda_Del]
(
	@Cd_Tp_Moeda			varChar(3)
)
as
if exists(select Cd_Tp_Moeda from Tipo_Moeda where Cd_Tp_Moeda= @Cd_Tp_Moeda)
	begin
		update Tipo_Moeda set ativo = 0 where Cd_Tp_Moeda= @Cd_Tp_Moeda
	end

GO
