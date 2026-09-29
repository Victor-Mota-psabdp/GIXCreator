SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	FUNCTION [dbo].[fBusca_Container_Produto_COALESCE]
(
@Processo	Varchar(16),
@Num_Cont		Varchar(50)
)
RETURNS Varchar(400) 
AS
BEGIN 
	--Declare @nDOC	VarChar(400)
	Declare @ProdutoDescr	varchar(500) 


	select  @ProdutoDescr = COALESCE(@ProdutoDescr +char(13)+char(10),'') + PCLI.Produto_Descr from Pedido_Ship_Container PC with(nolock)
	join Produto_Cliente PCLI with(nolock) on PC.cd_produto = PCLI.cd_prod 
	where PC.Num_Proc = @Processo and PC.Num_Cont = @Num_Cont


return @ProdutoDescr
	
END








GO
