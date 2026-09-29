SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--15/08/2023 - Incluido o LOte
CREATE Procedure [dbo].[spINT_Invoice] --'EMCSR20100906001'
			(
			@num_proc	varchar(16)
	)
as

select 
	replace(cd_proc_cliente,'&','') GMID,  Produto_descr BrandName, 
	Case
		When (Quantidade < Peso_liquido and Tipo_Unid='KG') Then Peso_Liquido
		Else Quantidade
	End Quantidade,
	--Quantidade,
	Tipo_Unid,Peso_liquido,Peso_bruto, Preco_unit, 
	iSNULL(Capacidade,1) Capac ,Nome_Tp_Embal,cd_Smart cd_embalagem ,
	Tipo_Unid Lote
from 
	invoice_det IDE with(nolock)
join Pedido PED with(nolock) on PED.cd_pedido=IDE.cd_pedido
Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
Left Join Tipo_Embalagem TE with(nolock) on IDE.cd_embalagem=TE.cd_tp_embal
Join Invoice_Cliente INV with(nolock) on INV.ID_INV=IDE.ID_INV
where
	num_proc=@num_proc


GO
