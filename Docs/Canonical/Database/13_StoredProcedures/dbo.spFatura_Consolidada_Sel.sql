SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from  fatura_consolidada where id = 1 and ativo =1 
--select * from  fatura_consolidada_det where id = '1'
--select * from usuario
CREATE procedure [dbo].[spFatura_Consolidada_Sel]--1
(
@ID int
)

AS

select
	convert(varchar,Data,103)				[Data],
	G.Apelido			[Grupo],
	P.Apelido			[Cliente],
	convert(varchar,dt_vencimento,103)		[Vencimento]
from fatura_consolidada FC	
	join Pessoa G  with(nolock) on G.Cd_Pes=FC.Cd_grupo
	join pessoa	P  with(nolock) on P.cd_pes=FC.Cd_cliente
 where	
	FC.ID = @ID and ativo = 1


GO
