SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Solicitacao_LI_Produto_Del]

	@Num_Solicitacao	Varchar(13),
	@Cd_Prod_Cliente	Varchar(50)

AS

Declare @Cd_Prod as int
Declare @Cd_Pes_Grupo as varchar(10)

set @Cd_Pes_Grupo = (
	SELECT PLL.Cd_Pes_Grupo FROM Solicitacao_LI LI
	join vwCliente_House vw	with(nolock) on LI.Num_Proc = vw.num_proc
	Join Pessoa_LLP PLL with(nolock) on PLL.Cd_Pes=vw.cd_cliente
	join Grupo G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	join Pessoa P		with(nolock) on PLL.Cd_Pes = P.Cd_Pes
where
	LI.Num_Solicitacao = @Num_Solicitacao)
	
set @Cd_Prod = (select cd_prod from Produto_cliente where cd_Cliente = @Cd_Pes_Grupo and cd_proc_cliente=@cd_prod_Cliente)

if exists(select num_solicitacao from Solicitacao_Li_Produto where num_solicitacao=@num_solicitacao and cd_produto=@cd_prod)
	begin
		Delete Solicitacao_Li_Produto where num_solicitacao=@num_solicitacao and cd_produto=@cd_prod
	end

GO
