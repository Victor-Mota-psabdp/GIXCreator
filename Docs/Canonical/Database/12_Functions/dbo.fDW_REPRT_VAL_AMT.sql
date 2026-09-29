SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fDW_REPRT_VAL_AMT]
(
	@Num_Proc Varchar(16) 
)

RETURNS float

BEGIN
	 Declare @Resultado float

	 set @Resultado =(
				SELECT SUM(QUANTIDADE * preco_unit)
					FROM
					(
						select 	
							PS.Qty QUANTIDADE,
							(Case 
								When Vlr_Item > 10000 then Vlr_Item/100000
								else Vlr_Item
							End) preco_unit,  PS.cd_produto
						from pedido_ship PS With(Nolock)
							Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
							Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
							Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
						Where 
							num_proc=@Num_Proc
						GROUP BY 
							 PS.cd_produto,PS.Qty,PD.Vlr_Item
					) 
					AS Subquery
				)

	 RETURN @Resultado
END


--SELECT SUM(QUANTIDADE * preco_unit)
--				FROM
--				(
--					select 
--						--
					
--						PS.Qty QUANTIDADE,
--						(Case 
--							When Vlr_Item > 10000 then Vlr_Item/100000
--							else Vlr_Item
--						End) preco_unit,  PS.cd_produto
--					from pedido_ship PS With(Nolock)
--						Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
--						Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
--						Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
--					Where 
--						num_proc='EMCBT202407003BR'
--					GROUP BY 
--						 PS.cd_produto,PS.Qty,PD.Vlr_Item
--				) 
--				AS Subquery
		
				




GO
