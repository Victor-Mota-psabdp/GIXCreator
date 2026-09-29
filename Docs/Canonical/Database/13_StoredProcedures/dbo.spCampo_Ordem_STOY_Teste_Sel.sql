SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCampo_Ordem_STOY_Teste_Sel]
(
	@Num_Proc	varchar(16)
)
	
as

select distinct	
	(case when CO.campo_dados is not null then
		(case when CO.campo_dados = 'Y' or CO.campo_dados = 'N' then CO.campo_dados end)			
		else NULL end) [STO Indicator] 
	from Pedido_Ship PS with(nolock)
	left Join  campo_ordem CO with(nolock) on PS.cd_pedido=CO.cd_pedido and CO.id_campo=26
	Where 
	num_proc=@Num_Proc


GO
