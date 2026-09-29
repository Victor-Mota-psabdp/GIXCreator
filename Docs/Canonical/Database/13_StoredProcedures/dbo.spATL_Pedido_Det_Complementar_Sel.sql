SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Complementar
CREATE procedure [dbo].[spATL_Pedido_Det_Complementar_Sel]
(
	@Cd_Pedido			int,
	@Cd_Produto			int,
	@Lote				varchar(30),
	@Item				varchar(4),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
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
			--Pedido_Det.Vlr_Frete				[Freight],
			Pedido_Det.UPC						[Freight],
			Pedido_Det_Compl.Vlr_FOB			[FOB Value],			
			Pedido_Det.UoM						[UoM],
			--Pedido_Det.SAP_Company,			
			--Pedido_Det.DN_Valida,		
			--Pedido_Det.Total_Invoice_USD,
			--Pedido_Det.Total_Invoice_Local,
			--Pedido_Det.UPC,	
			--ARG
			--Pedido_Det.Invoice_Qty,
			--Pedido_Det.Invoice_UOM,
			--Pedido_Det.Termo_Pagamento,
	
			Pedido_Det_Compl.Cd_Pais_Fabricante		[Country of Manufact. Code],
			Pais.Nome_Pais							[Country of Manufact. Name],
			Pedido_Det_Compl.Cd_Pes_Fabricante		[Manufacturer Code],
			Fabricante.Apelido						[Manufacturer Name],
			Pedido_Det.Qtde_Embal					[Qty Packet],
			Pedido_Det.Cd_Tp_Embal					[Type Packet Code],
			Tipo_Embalagem.Nome_Tp_Embal			[Type Packet Name],	
			Pedido_Det_Compl.ID_TP_AC				[Agreement Code],
			AC.NOME_TP_AC							[Agreement Name]
		from Pedido_Det Pedido_Det
			left join Pedido		Pedido	on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			LEFT JOIN Pedido_Det_Complementar Pedido_Det_Compl on Pedido_Det_Compl.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Compl.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Compl.Item = Pedido_Det.Item
				and Pedido_Det_Compl.Lote = Pedido_Det.Lote
			left join Produto_Cliente	Produto_Cliente on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto 
				and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 
			left join Tipo_Embalagem		Tipo_Embalagem	on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			
			left join Pessoa				Fabricante	on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
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
			--Pedido_Det.Vlr_Frete				[Freight],
			Pedido_Det.UPC						[Freight],
			Pedido_Det_Compl.Vlr_FOB			[FOB Value],			
			Pedido_Det.UoM						[UoM],
			--Pedido_Det.SAP_Company,			
			--Pedido_Det.DN_Valida,		
			--Pedido_Det.Total_Invoice_USD,
			--Pedido_Det.Total_Invoice_Local,
			--Pedido_Det.UPC,	
			--ARG
			--Pedido_Det.Invoice_Qty,
			--Pedido_Det.Invoice_UOM,
			--Pedido_Det.Termo_Pagamento,
	
			Pedido_Det_Compl.Cd_Pais_Fabricante		[Country of Manufact. Code],
			Pais.Nome_Pais							[Country of Manufact. Name],
			Pedido_Det_Compl.Cd_Pes_Fabricante		[Manufacturer Code],
			Fabricante.Apelido						[Manufacturer Name],
			Pedido_Det.Qtde_Embal					[Qty Packet],
			Pedido_Det.Cd_Tp_Embal					[Type Packet Code],
			Tipo_Embalagem.Nome_Tp_Embal			[Type Packet Name],	
			Pedido_Det_Compl.ID_TP_AC				[Agreement Code],
			AC.NOME_TP_AC							[Agreement Name]
		from Pedido_Det Pedido_Det
			left join Pedido		Pedido	on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			LEFT JOIN Pedido_Det_Complementar Pedido_Det_Compl on Pedido_Det_Compl.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Compl.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Compl.Item = Pedido_Det.Item
				and Pedido_Det_Compl.Lote = Pedido_Det.Lote
			left join Produto_Cliente	Produto_Cliente on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto 
				and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 
			left join Tipo_Embalagem		Tipo_Embalagem	on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			
			left join Pessoa				Fabricante	on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC
		where
			Pedido_Det.Cd_Pedido = @Cd_Pedido and 
			Pedido_Det.Cd_Produto = @Cd_Produto and 
			Pedido_Det.Lote = @Lote and 
			Pedido_Det.Item = @Item

	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
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
			--Pedido_Det.Vlr_Frete				[Freight],
			Pedido_Det.UPC						[Freight],
			Pedido_Det_Compl.Vlr_FOB			[FOB Value],			
			Pedido_Det.UoM						[UoM],
			--Pedido_Det.SAP_Company,			
			--Pedido_Det.DN_Valida,		
			--Pedido_Det.Total_Invoice_USD,
			--Pedido_Det.Total_Invoice_Local,
			--Pedido_Det.UPC,	
			--ARG
			--Pedido_Det.Invoice_Qty,
			--Pedido_Det.Invoice_UOM,
			--Pedido_Det.Termo_Pagamento,
	
			Pedido_Det_Compl.Cd_Pais_Fabricante		[Country of Manufact. Code],
			Pais.Nome_Pais							[Country of Manufact. Name],
			Pedido_Det_Compl.Cd_Pes_Fabricante		[Manufacturer Code],
			Fabricante.Apelido						[Manufacturer Name],
			Pedido_Det.Qtde_Embal					[Qty Packet],
			Pedido_Det.Cd_Tp_Embal					[Type Packet Code],
			Tipo_Embalagem.Nome_Tp_Embal			[Type Packet Name],	
			Pedido_Det_Compl.ID_TP_AC				[Agreement Code],
			AC.NOME_TP_AC							[Agreement Name]
		from Pedido_Det Pedido_Det
			left join Pedido		Pedido	on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			LEFT JOIN Pedido_Det_Complementar Pedido_Det_Compl on Pedido_Det_Compl.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Compl.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Compl.Item = Pedido_Det.Item
				and Pedido_Det_Compl.Lote = Pedido_Det.Lote
			left join Produto_Cliente	Produto_Cliente on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto 
				and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 
			left join Tipo_Embalagem		Tipo_Embalagem	on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			
			left join Pessoa				Fabricante	on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC	
		where
			Pedido_Det.Cd_Pedido = @Cd_Pedido and 
			Pedido_Det.Cd_Produto = @Cd_Produto and 
			Pedido_Det.Lote = @Lote and 
			Pedido_Det.Item = @Item
	End

GO
