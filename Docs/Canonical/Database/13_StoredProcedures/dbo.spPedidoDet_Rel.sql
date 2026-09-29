SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[spPedidoDet_Rel] --'44716'

	@Cd_Pedido int
as
	SELECT 
		CD_PROC_CLIENTE,
		Produto_Descr,
		PD.Lote Lote,
		Qty,
		Vlr_Item,
		Peso_Item,
		UoM,
		PD.Item Item, 
		NCM,
		NATOP,
		UOM_PRC,
		SAP_Company,
		Peso_UOM,
		Vlr_Total_Item,
		[Contract],
		Requision,
		PO_GRP,
		Finalidade,
		Vlr_Total_Item,
		Peso_Invoice,
		Peso_Bruto_Tot,
		Peso_Liquido_Tot,
		In_Progress,
		DN_Valida,
		Requerimento,
		vlr_Frete UPC,
		Qtde_Embal,
		Te.Nome_Tp_Embal Embalagem,
		Pes.Apelido Fabricante,
		N.nome_Pais Pais_Fabricante,
		PDC.Vlr_FOB,
		A.NOME_TP_AC
		
	FROM 
		PEDIDO_DET PD with(nolock)
		join Pedido P with(nolock) on PD.Cd_Pedido = P.Cd_Pedido 
		left Join Produto_Cliente PC with(nolock) on PC.CD_PROD=PD.CD_PRODUTO and P.Cd_Grupo = Cd_Cliente
		left join tipo_embalagem TE with(nolock) on Te.cd_tp_embal = PD.cd_tp_embal
		left join Pedido_Det_Complementar PDC with(nolock) on PDC.cd_pedido = PD.Cd_Pedido and PDC.cd_produto = PD.Cd_Produto and PDC.ITEM = PD.Item and PDC.Lote = PD.Lote
		left join Pessoa PES with(nolock) on PES.Cd_Pes = PDC.cd_pes_fabricante
		left join Pais N with(nolock) on N.cd_pais = PDC.cd_pais_fabricante	
		LEFT JOIN Tipo_Acordo_Comercial A with(nolock) on A.ID_TP_AC = PDC.ID_TP_AC		
	where
		P.cd_pedido=@cd_pedido
	order by 
		Item, CD_PROC_CLIENTE









GO
