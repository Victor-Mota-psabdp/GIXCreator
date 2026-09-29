SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_NC_Cliente
CREATE procedure [dbo].[spATLDN_Tipo_NC_Cliente_Del]
(
	@Cd_NC			varChar(40),
	@Cd_Pes_Grupo	varChar(10)
)
as
If  exists (select Cd_NC from Tipo_NC_Cliente where Cd_NC=@Cd_NC AND Cd_Pes_Grupo = @Cd_Pes_Grupo)
	begin
		update Tipo_NC_Cliente set ativo = 0 where Cd_NC=@Cd_NC AND Cd_Pes_Grupo = @Cd_Pes_Grupo
	end

GO
