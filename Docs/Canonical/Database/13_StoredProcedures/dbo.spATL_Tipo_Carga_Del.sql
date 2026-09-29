SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Carga
CREATE procedure [dbo].[spATL_Tipo_Carga_Del]
(
	@Cd_Tp_Carga INT
)
as
	if exists(select Cd_Tp_Carga from Tipo_Carga where Cd_Tp_Carga= @Cd_Tp_Carga) 
	begin
		UPDATE Tipo_Carga SET Ativo_TP = 'N' where Cd_Tp_Carga= @Cd_Tp_Carga
	end

GO
