SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Courier_Sel 'EMSUR201108002BR'
CREATE procedure [dbo].[spATL_Courier_Sel]
(
	@Num_Proc varchar(16)
)

as

select 
	ID_Item,
	Nome_Tp_Courier,
	Apelido,
	Num_Courier,
	convert(varchar(10),Dt_Courier,103) Dt_Courier 
from 
	dbo.Courier_Processo C with(nolock)
	join Tipo_Courier	 T with(nolock) on C.ID_Tp_Courier = T.ID_Tp_Courier
	join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
where 
	C.Num_Proc = @Num_Proc



GO
