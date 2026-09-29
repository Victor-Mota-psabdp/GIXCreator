SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Complementar_Temp_New
CREATE VIEW [dbo].[vwPedido_Det_Temp_New_Sel]
AS

	select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Cd_Pedido],
			Pedido_Det.Cd_Produto				[Cd_Produto],
			Produto_Cliente.cd_Proc_Cliente		[Product Code],
			Produto_Cliente.Produto_Descr		[Product Description],
			Pedido_Det.Name_Produto				[Product Description XML],
			Pedido_Det.Lote						[2ª Ref. (Delivery Note)],
			Pedido_Det.Item						[Item],          
			Pedido_Det.Requerimento				[Requeriment],		
			Pedido_Det.Qty						[Qty],
			Pedido_Det.Vlr_Item					[Unit Price],
			Pedido_Det.Vlr_Total_Item			[Total Price],
			Pedido_Det.UOM_PRC					[UoM Product],
			Pedido_Det.Peso_UOM					[UoM Weight],
			Pedido_Det.Peso_Item				[Unit Weight],
			Pedido_Det.Peso_Bruto_TOT			[Gross Weight],
			Pedido_Det.Peso_Liquido_TOT			[Net Weight],
			Pedido_Det.Peso_Invoice				[Invoice Weight],
			Pedido_Det.Contract					[Contract],
			Pedido_Det.NATOP					[NATOP],
			Pedido_Det.Finalidade				[Purpose],		
			Pedido_Det.PO_GRP					[PO Group],
			Pedido_Det.In_Progress				[In Progress],
			Pedido_Det.Requision				[Requisition],	
			Pedido_Det.NCM						[NCM],
			Pedido_Det.Vlr_Frete				[Freight],
			Pedido_Det_Compl.Vlr_FOB			[FOB Value],			
			Pedido_Det.UoM						[UoM],
			Pedido_Det.Name_UoM					[UoM Xml],	
			--Pedido_Det.SAP_Company,			
			--Pedido_Det.DN_Valida,		
			--Pedido_Det.Total_Invoice_USD,
			--Pedido_Det.Total_Invoice_Local,
			--Pedido_Det.UPC,		
			Pedido_Det_Compl.Cd_Pais_Fabricante		[Country of Manufact. Code],
			Pais.Nome_Pais							[Country of Manufact. Name],
			Pedido_Det_Compl.Name_Pais_Fabricante	[Country of Manufact. Name XML],
			Pedido_Det_Compl.Cd_Pes_Fabricante		[Manufacturer Code],
			Fabricante.Apelido						[Manufacturer Name],
			Pedido_Det_Compl.Name_Pes_Fabricante	[Manufacturer Name XML],			
			Pedido_Det.Qtde_Embal					[Qty Packet],
			Pedido_Det.Cd_Tp_Embal					[Type Packet Code],
			Tipo_Embalagem.Nome_Tp_Embal			[Type Packet Name],
			Pedido_Det.Name_Embal					[Type Packet XML],						
			Pedido_Det_Compl.ID_TP_AC				[Agreement Code],
			AC.NOME_TP_AC							[Agreement Name],
			Pedido_Det_Compl.Name_AC				[Agreement Name XML]
		from Pedido_Det_Temp_New Pedido_Det
			left join Pedido_Temp_New		Pedido_Temp	on Pedido_Temp.ID = Pedido_Det.ID
			--left join Produto_Cliente		Produto_Cliente	on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto
			left join Produto_Cliente		Produto_Cliente on Produto_Cliente.cd_Proc_Cliente = Pedido_Det.Name_Produto 
				and Produto_Cliente.cd_Cliente =Pedido_Temp.Cd_Grupo 
			left join Tipo_Embalagem		Tipo_Embalagem	on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			LEFT JOIN Pedido_Det_Complementar_Temp_New Pedido_Det_Compl on Pedido_Det_Compl.ID = Pedido_Det.ID
			left join Pessoa				Fabricante	on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC

GO
