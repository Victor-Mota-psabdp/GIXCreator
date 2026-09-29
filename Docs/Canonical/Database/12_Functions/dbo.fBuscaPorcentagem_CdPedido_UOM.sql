SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select [dbo].[fBuscaPorcentagem_CdPedido_UOM] ('EOCSR202206024BR','CH','369202') 0,378378378378378
--select [dbo].[fBuscaPorcentagem_CdPedido_UOM] ('EOCSR202206024BR','DR','369202') 0,621621621621622
--select * from Pedido_ship where num_proc = 'EOCSR202206024BR'
--select sum(qty) from Pedido_det where cd_pedido = 369202 and UoM = 'CH' -- 14
--select sum(qty) from Pedido_det where cd_pedido = 369202 and UoM = 'DR' --23
--select distinct UoM from Pedido_det where cd_pedido = 369202

CREATE function [dbo].[fBuscaPorcentagem_CdPedido_UOM] 
(
	@Num_Proc Char(16),
	@UoM	Varchar(10),
	@Cd_Pedido int
)

returns
	Float
as
	Begin
		
		Declare @qtyPedido as Float
		Declare @qtyTotal as Float
	
		Set @qtypedido=(
						select 
							sum(pd.qty) from PEDIDO_DET pd
							Join Pedido P on P.cd_pedido=pd.cd_pedido
							INNER JOIN Pedido_Ship PS (NOLOCK)	ON PS.CD_PEDIDO = PD.CD_PEDIDO and PS.cd_produto = PD.cd_produto 
								and PS.Item = PD.Item  and PS.lote = PD.lote  and PS.Num_proc = @Num_Proc
						Where
							PD.Cd_pedido=@Cd_Pedido							
							and PD.UoM=@UoM 
						)
		set @qtytotal= (
						select sum(ps.qty) from pedido_ship ps
						Join Pedido P on P.cd_pedido=Ps.cd_pedido
						Where
							--PS.Cd_pedido=@Cd_pedido	and
							PS.num_proc=@num_proc
					)

--			Begin
				Return (@qtypedido/@qtytotal)

		END























GO
