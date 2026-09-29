SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spINT_PEDIDO 'IMLYB202301010BR'
--19/06/2023 - Cadu Update cd_dst and Descr_org
--18/06/2024 - Cadu included rule for IMLYB
CREATE PROCEDURE [dbo].[spINT_PEDIDO] -- [dbo].[spINT_PEDIDO] 'EMAKZ20080900101'
		(
			@num_proc	varchar(16)
		)
as

if not (exists(select * from invoice_cliente With(Nolock)  where num_proc=@num_proc))

	Begin

		if (LEFT(@num_proc,5) = 'IMLYB')
			BEGIN
				select  
					Peso_Uom, Isnull(LEFT(NCM,6),'')+'00' NCM_CODE,
					isnull(cd_dst,PD.UOM)			cd_dst,
					isnull(Descr_org,PD.UOM)		Descr_org,
					PD.UOM							UOM,
					cd_tp_moeda,replace(cd_proc_cliente,'&','') GMID,replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
					PS.Qty QUANTIDADE,NCM,Natop,UOM Tipo_Unid,UOM_PRC, 
					Case 
						When Vlr_Item > 10000 then Vlr_Item/100000
						else Vlr_Item
					End				
					preco_unit
					,PED.cd_tp_moeda,peso_item Peso_bruto,peso_invoice,peso_bruto_tot,peso_liquido_tot,peso_bruto_tot,ps.lote,
					Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,Isnull(TP.Cd_Termo,'281') cd_Termo,
					'PedidoD',
					TE.ISO_Code,
					TE.Nome_Tp_Embal
				from pedido_ship PS With(Nolock)
					Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
					Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido and PS.Lote = PD.Lote and PS.Item = PD.Item
					Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
					Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
					left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=payment
					Left Join Tipo_Embalagem TE	WITH(nolock)		on TE.cd_tp_embal=PD.cd_tp_embal
				WHERE
					NUM_PROC=@num_proc and cd_proc_cliente is not null
				group by
					UOM,cd_tp_moeda,cd_proc_cliente ,Produto_descr ,PS.Qty ,NCM,Natop,UOM ,UOM_PRC,Vlr_Item ,PED.cd_tp_moeda,peso_item,
					cd_dst,Descr_org,UOM,cd_tp_moeda,peso_invoice,peso_liquido_tot,peso_bruto_tot,LEFT(NCM,6),PS.lote ,
					Peso_Uom,Descricao_Termo,TP.cd_Termo, TE.iso_CODE, TE.Nome_Tp_Embal
			END
		ELSE
			BEGIN
				select  
					Peso_Uom, Isnull(LEFT(NCM,6),'')+'00' NCM_CODE,
					isnull(cd_dst,PD.UOM)			cd_dst,
					isnull(Descr_org,PD.UOM)		Descr_org,
					PD.UOM							UOM,
					cd_tp_moeda,replace(cd_proc_cliente,'&','') GMID,replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
					PS.Qty QUANTIDADE,NCM,Natop,UOM Tipo_Unid,UOM_PRC, 
					Case 
						When Vlr_Item > 10000 then Vlr_Item/100000
						else Vlr_Item
					End				
					preco_unit
					,PED.cd_tp_moeda,peso_item Peso_bruto,peso_invoice,peso_bruto_tot,peso_liquido_tot,peso_bruto_tot,ps.lote,
					Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,Isnull(TP.Cd_Termo,'281') cd_Termo,
					'PedidoD',
					TE.ISO_Code,
					TE.Nome_Tp_Embal
				from pedido_ship PS With(Nolock)
					Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
					Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
					Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
					Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
					left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=payment
					Left Join Tipo_Embalagem TE	WITH(nolock)		on TE.cd_tp_embal=PD.cd_tp_embal
				WHERE
					NUM_PROC=@NUM_PROC and cd_proc_cliente is not null
				group by
					UOM,cd_tp_moeda,cd_proc_cliente ,Produto_descr ,PS.Qty ,NCM,Natop,UOM ,UOM_PRC,Vlr_Item ,PED.cd_tp_moeda,peso_item,
					cd_dst,Descr_org,UOM,cd_tp_moeda,peso_invoice,peso_liquido_tot,peso_bruto_tot,LEFT(NCM,6),PS.lote ,
					Peso_Uom,Descricao_Termo,TP.cd_Termo, TE.iso_CODE, TE.Nome_Tp_Embal
			END
	End 

ELSE

	BEgin
		select 'KG' Peso_UOM,'00' NCM_Code, Cd_Embalagem Cd_dst ,nome_tp_embal Descr_org,Tipo_Unid UOM, 'USD' Cd_Tp_moeda, replace(Cd_Proc_Cliente,'&','') GMID,Produto_Descr BrandName,
		Case
			When Upper(Tipo_unid)='KG' then (Quantidade) 
			else (Quantidade*Capacidade) 
		End
		Quantidade,Null NCM, Null Natop,Tipo_Unid,Null UOM_PRC,Preco_unit,Peso_Bruto,Peso_Liquido Peso_Invoice, Peso_liquido Peso_liquido_tot, 'UN' Lote,Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
		Isnull(TP.Cd_Termo,'281') Cd_Termo,'InvoiceC'
		
		,TE.ISO_Code,
		TE.Nome_Tp_Embal
	From invoice_cliente IC With(Nolock)
		Join Invoice_Det ID With(Nolock) on ID.id_inv=IC.Id_inv
		Left Join Tipo_Embalagem TE With(Nolock) on TE.cd_tp_embal=Cd_Embalagem
		Left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
		left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=IC.cd_termo
		where num_proc=@num_proc and cd_proc_cliente is not null




	End







GO
