SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spATL_JobDescricao_Rel --'EOROB201307010BR'
(
 @JOB varchar(16)
)
as
select Num_proc [JOB],Cd_Proc_cliente [GMID],dbo.FRemoveCaracteresEspeciais (Descricao_Longa) [Descrição Longa] from Pedido_Ship PS with(nolock) 
left join Produto_CHB PC with(nolock)  on PS.cd_produto= PC.Cd_Prod
Join Produto_Cliente PCI with(nolock) on  PS.Cd_Produto = PCI.cd_prod
where num_proc = @JOB


GO
