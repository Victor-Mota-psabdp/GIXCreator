SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spVerificaPessoa_ATL_AX_Sel]
	@Apelido	 Varchar(100),
	@Pais		 Varchar(50)

as

select 
	apelido 
from 
	pessoa PP  with(nolock)
	join endereco ed with(nolock) on ed.cd_pes=pp.cd_pes and cd_tp_end='COM' 
	Join Pessoa_ATL_AX AX on AX.Cd_Pes = PP.Cd_Pes and AX.Tipo='C'
where 
	desat_pes='N' 
	AND (Pais like @Pais) 
	and PP.Apelido = @Apelido 

GO
