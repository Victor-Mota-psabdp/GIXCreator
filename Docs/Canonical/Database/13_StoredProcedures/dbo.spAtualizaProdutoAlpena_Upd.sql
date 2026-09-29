SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu - 18/07/2016 - inclui para nao ver os produtos q jã etao com o grupo 'P17842'
CREATE Procedure [dbo].[spAtualizaProdutoAlpena_Upd]

AS
/**
	PROCEDURE ATUALIZA CD_CLIENTE DOS PRODUTOS QUE ESTÃO COMO GRUPO DOW E DEVERIAM ESTAR COMO DOW-ALPENA
**/

update 
	produto_cliente set cd_cliente='P17842'
from 
	produto_cliente 
	Join Projeto_dowalpena PA on pa.cd_produto_cliente=cd_proc_cliente
where 
	cd_cliente='1'
	and cd_Proc_Cliente not in (select cd_produto_cliente from Projeto_dowalpena)
	
	


GO
