SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Ocorrencia
CREATE procedure [dbo].[spATL_Tipo_Ocorrencia_Del]
(
	@Cd_Tp_Ocor			INT
)
as
--if exists(select Cd_Tp_Ocor from Tipo_Ocorrencia where Cd_Tp_Ocor= @Cd_Tp_Ocor)
--	begin
--		DELETE Tipo_Ocorrencia where Cd_Tp_Ocor= @Cd_Tp_Ocor
--	end

GO
