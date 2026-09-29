SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spReportManagerFOB_InsUpd

as

	Declare @Ordem Varchar(50)
	Declare @Num_PRoc	Varchar(16)
	Declare @codProduto	Varchar(50)
	Declare @Fob	float

Declare cTempProcesso cursor for
	(
		select Num_pedido,NUm_proc,cd_proc_cliente,sum(isnull(vlr_total_item,0)) Fob_Value from pedido_det PD	
		Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto and PS.item=PD.Item and ps.lote=pd.lote
		Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
		Join Pedido PDD on PDD.cd_pedido=PS.cd_pedido
		Where	Num_Proc
			in
				(
					select Distinct excprocesso from atlantis.dbo.exchange where excprocesso like 'I%CSR%' --excdataalt >=getdate()-2
				)

		Group by NUm_proc,cd_proc_cliente,num_pedido
	)
	OPEN cTempProcesso 
	fetch next from cTempProcesso into @Ordem, @Num_proc, @codproduto, @Fob
	While @@Fetch_Status=0
		Begin
			Update
				Dados_Por_Produto
					SET
						[Fob Value]=@Fob
			Where
				[BDP Ref.]=@Num_Proc and [Product ID]=@codproduto and [Sales Order]=@Ordem
			fetch next from cTempProcesso into @Ordem, @Num_proc, @codproduto, @Fob
		End
	close ctempprocesso
	deallocate cTempprocesso

GO
