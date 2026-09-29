SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolicitacaoLIProduto_Del]

	@Num_Solicitacao	Varchar(13),
	@Num_Proc			Varchar(16),
	@Cd_Prod_Cliente	Varchar(50)

AS

Declare @Cd_Prod as int
Declare @Cd_Pes_Grupo as varchar(10)

set @Cd_Pes_Grupo = (select cd_pes_grupo from grupo where grupo = right(left(@Num_Proc,5),3))
set @Cd_Prod = (select cd_prod from Produto_cliente where cd_Cliente = @Cd_Pes_Grupo and cd_proc_cliente=@cd_prod_Cliente)
--set @Cd_Prod = (select top 1 cd_produto from pedido_Ship PS Join Produto_cliente PC on PC.cd_prod=PS.cd_produto where num_proc=@num_proc and cd_proc_cliente=@cd_prod_Cliente)

Delete Solicitacao_Li_Produto where num_solicitacao=@num_solicitacao and cd_produto=@cd_prod



GO
