SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function fCalculoNFC (
	@Num_Proc	Varchar(16),
	@Cd_Pedido	float,
	@Cd_Produto float
)
returns Decimal(10,2)

AS

BEgin
	Declare @Valor Decimal(10,2)


	Set @Valor=(

	select sum(vlr_item_custo*(1+prc_inss)) from fmc_plano_contas_v2 P
	Join Custo_Cliente CC on cc.cd_tp_Tx=P.cd_tp_Tx
	where
		id_evento='F' and num_proc=@Num_PRoc	
	)

	Set @Valor = @Valor -
	isnull((select sum(isnull(vlr_item_custo,0)) from Custo_Cliente P
	where
		cd_Tp_Tx in ('YDI','XDU')
		and num_proc=@Num_PRoc	
	),0)

	return @Valor

End
GO
