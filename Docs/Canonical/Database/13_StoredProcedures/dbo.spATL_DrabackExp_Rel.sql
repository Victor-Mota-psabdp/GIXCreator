SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spATL_DrabackExp_Rel
	@CNPJ Varchar(20),
	@NumeroAto varchar(50)

as

select 

	P24.Numero_PO_HEM [ATO Concessorio],
	Num_Proc_Lem [BDP REF.],
	SH.Nome_Raz_Soc [Exportador],
	Num_Pedido [Sales Order],
	Produto_Descr [Descrição do Produto],
	PS.Qty	[Quantidade],
	P.Cd_Tp_Moeda [Moeda],
	Vlr_Total_Item [Valor Fob],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,4) [Numero do RE],
	ETD_LEM		[ETD],
	ATD_LEM		[ATD],
	Num_CPF_CNPJ [CNPJ]

 from	llp_exp_mar L with(nolock)
		Join House_Exp_mar H with(nolock) on H.num_proc_hem=L.num_proc_lem
		Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lem
		Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
		Join Po_Hem P24 with(nolock) on P24.num_proc_hem=Num_Proc_Lem and P24.id_dc=24
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
		Join Pessoa SH with(nolock) on SH.cd_pes=cd_export_hem
		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.lote=PS.lote and PD.cd_produto=PS.cd_produto and PD.item=PS.item
Where
		(Num_CPF_CNPJ=@CNPJ or @CNPJ='') and (P24.numero_po_hem=@NumeroAto or @NumeroAto='')


GO
