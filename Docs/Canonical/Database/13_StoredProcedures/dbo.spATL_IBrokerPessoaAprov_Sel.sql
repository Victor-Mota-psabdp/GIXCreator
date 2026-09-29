SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_IBrokerPessoaAprov_Sel(
@ID bigint,
@Tipo varchar(1)
)

as

Select 
Cd_Pes,
Ibroker,
Apelido,
Detalhe
from 
IBROKER_Pessoa_V2
where ID = @ID and Tipo = @Tipo
GO
