SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--select * from pedido_ship where num_proc='IOCSR20080206501'
--select * from pedido_det

--		select dbo.fBusca_UoM('IOCSR20080206501',3646, 289,'0001','UOM')

CREATE      function fBusca_UoM(
@Processo	varchar(16),
@Cd_Pedido	int,
@Cd_Produto	int,
@Item		varchar(5),
@Campo		varchar(15)
)
RETURNS Varchar(20)

BEGIN
	Declare @Resultado Varchar(20)

	IF @Campo = 'Qty'
		Begin
			SET @Resultado=(
					Select top 1 PD.Qty from Pedido_Det PD
					join Pedido_Ship PS on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
					where PS.num_proc = @Processo and PD.cd_pedido = @Cd_Pedido and PD.cd_produto = @Cd_Produto and PS.Item = @Item
					)
		End
	IF @Campo = 'UOM'
		Begin
			SET @Resultado=(
					Select top 1 PD.UOM from Pedido_Det PD
					join Pedido_Ship PS on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
					where PS.num_proc = @Processo and PD.cd_pedido = @Cd_Pedido and PD.cd_produto = @Cd_Produto and PS.Item = @Item
					)
		End

	RETURN @Resultado

END








GO
