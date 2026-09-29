SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help DE_PARA
CREATE PROCEDURE [dbo].[spATL_De_Para_Del]
	@Cd_Cliente		varchar(10),
	@Cd_Tipo		INT,
	@Cd_Org			varchar(2000)
	
as

	if exists(select Cd_Tipo fROM DE_PARA A with(nolock)where A.Cd_Cliente = @Cd_Cliente 
		AND a.Cd_Tipo  = @Cd_Tipo	and a.Cd_Org = @Cd_Org)
	begin
		update DE_PARA  set ativo = 0 where  Cd_Cliente = @Cd_Cliente 
		AND Cd_Tipo = @Cd_Tipo and Cd_Org = @Cd_Org
	end

GO
