SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaUsuarioGTNEXUS_Sel](
	@Num_Proc	varchar(16),
	@Tipo_Envio	varchar(1)
)
as

select 
	U.Nome_Usuario,
	U.Email	
from exchange_GTNEXUS E
	join usuario U on U.Cd_Usuario = E.Cd_Usuario
where	
	E.Num_Proc = @Num_Proc and
	E.Tipo_Envio = @Tipo_Envio




GO
