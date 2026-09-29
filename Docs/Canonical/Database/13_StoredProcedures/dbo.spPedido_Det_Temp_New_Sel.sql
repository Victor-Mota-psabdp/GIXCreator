SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Temp_New 
--SP_HELP Pedido_Det_Complementar_Temp_New
--[spPedido_Det_Temp_New_Sel]'190','D'

--select * from Pedido_Det_Temp_New where ID =12
--select * from Pedido_Det_Complementar_Temp_New WHERE ID =12
CREATE procedure[dbo].[spPedido_Det_Temp_New_Sel]--4664,'D'
(
	@ID	bigint,
	@Tipo	char(1)
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

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select
			convert(varchar(25),'Saved')		[Status],
			Pedido_Det.Cd_Pedido				[Cd_Pedido],
			Pedido_Det.Cd_Produto				[Cd_Produto],
			PD.cd_Proc_Cliente					[Product Code],
			PD.Produto_Descr					[Product Description],
			
			--Pedido_Det.Cd_Produto				[Cd_Produto],
			--Produto_Cliente.lcd_Proc_Cliente		[Product Code],
			--Produto_Cliente.Produto_Descr		[Product Description],
			(case when House_Temp.SystemCode = '2' then 
				Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto
			else  
				Pedido_Det.Name_Produto	
			end)								[Product Description XML],
			--Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto				[Product Description XML],
			isnull(Pedido_Det.Lote,'UN')		[2ª Ref. (Delivery Note)],
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
			isnull(Pedido_Det.NCM,PD.NCM_Cliente)	[NCM],
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
			Pedido_Det_Compl.Name_AC				[Agreement Name XML],
			
			Pedido_Det.ID_House_Temp,
			Pedido_Det.ID_Req,
			Pedido_Det.Intl_Reference,
			House_Temp.Num_Proc
		from Pedido_Temp_New		Pedido_Temp with(nolock)
			join Pedido_Det_Temp_New Pedido_Det with(nolock)	on Pedido_Temp.ID = Pedido_Det.ID
			--left join Produto_Cliente		Produto_Cliente	on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto
			left join Tipo_Embalagem		Tipo_Embalagem	with(nolock) on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			LEFT JOIN Pedido_Det_Complementar_Temp_New Pedido_Det_Compl with(nolock) on Pedido_Det_Compl.ID = Pedido_Det.ID 
				AND Pedido_Det_Compl.Item = Pedido_Det.Item
			left join Pessoa				Fabricante	with(nolock) on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	with(nolock) on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	with(nolock) on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC
			left join Produto_Cliente		PD with(nolock) on PD.cd_Proc_Cliente = Pedido_Det.Name_Produto	and PD.cd_Cliente =Pedido_Temp.Cd_Grupo 
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = PEdido_Temp.ID_House_Temp
			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select
			convert(varchar(25),'Saved')		[Status],
			Pedido_Det.Cd_Pedido				[Cd_Pedido],
			Pedido_Det.Cd_Produto				[Cd_Produto],
			PD.cd_Proc_Cliente					[Product Code],
			--PD.Produto_Descr					[Product Description],
			
			(case when House_Temp.SystemCode = '2' and PD.cd_Proc_Cliente Is null then 
				Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto
			else  
				PD.Produto_Descr end)			[Product Description],					
			
			--Pedido_Det.Cd_Produto				[Cd_Produto],
			--Produto_Cliente.lcd_Proc_Cliente		[Product Code],
			--Produto_Cliente.Produto_Descr		[Product Description],
	
			Pedido_Det.Name_Produto				[Product Description XML],
			--(case when House_Temp.SystemCode = '2' and PD.cd_Proc_Cliente Is null then 
			--	Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto
			--else  
			--	Pedido_Det.Name_Produto	
			--end)								[Product Description XML],
			isnull(Pedido_Det.Lote,'UN')		[2ª Ref. (Delivery Note)],
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
			isnull(Pedido_Det.NCM,PD.NCM_Cliente)	[NCM],
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
			Pedido_Det_Compl.Name_AC				[Agreement Name XML],
			
			Pedido_Det.ID_House_Temp,
			Pedido_Det.ID_Req,
			Pedido_Det.Intl_Reference,
			House_Temp.Num_Proc
		from Pedido_Temp_New		Pedido_Temp with(nolock) 
			join Pedido_Det_Temp_New Pedido_Det 	with(nolock) on Pedido_Temp.ID = Pedido_Det.ID
			--left join Produto_Cliente		Produto_Cliente	on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto
			left join Tipo_Embalagem		Tipo_Embalagem	with(nolock) on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			JOIN Pedido_Det_Complementar_Temp_New Pedido_Det_Compl with(nolock) on Pedido_Det_Compl.ID = Pedido_Det.ID 
				AND Pedido_Det_Compl.Item = Pedido_Det.Item
			left join Pessoa				Fabricante	with(nolock) on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	with(nolock) on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	with(nolock) on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC
			left join Produto_Cliente		PD with(nolock) on PD.cd_Proc_Cliente = Pedido_Det.Name_Produto	and PD.cd_Cliente =Pedido_Temp.Cd_Grupo 
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = PEdido_Temp.ID_House_Temp
		Where
			Pedido_Temp.ID=@ID
	End
	
if @Tipo = 'P'  or @Tipo = 'Q'
	Begin
		select
			convert(varchar(25),'Saved')		[Status],
			Pedido_Det.Cd_Pedido				[Cd_Pedido],
			Pedido_Det.Cd_Produto				[Cd_Produto],
			PD.cd_Proc_Cliente					[Product Code],
			--PD.Produto_Descr					[Product Description],
			
			(case when House_Temp.SystemCode = '2' and PD.cd_Proc_Cliente Is null then 
				Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto
			else  
				PD.Produto_Descr end)			[Product Description],					
			
			--Pedido_Det.Cd_Produto				[Cd_Produto],
			--Produto_Cliente.lcd_Proc_Cliente		[Product Code],
			--Produto_Cliente.Produto_Descr		[Product Description],
	
			Pedido_Det.Name_Produto				[Product Description XML],
			--(case when House_Temp.SystemCode = '2' and PD.cd_Proc_Cliente Is null then 
			--	Pedido_Det.Cd_Produto + ' | ' + Pedido_Det.Name_Produto
			--else  
			--	Pedido_Det.Name_Produto	
			--end)								[Product Description XML],
			isnull(Pedido_Det.Lote,'UN')		[2ª Ref. (Delivery Note)],
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
			isnull(Pedido_Det.NCM,PD.NCM_Cliente)	[NCM],
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
			Pedido_Det_Compl.Name_AC				[Agreement Name XML],
			
			Pedido_Det.ID_House_Temp,
			Pedido_Det.ID_Req,
			Pedido_Det.Intl_Reference,
			House_Temp.Num_Proc
		from Pedido_Temp_New		Pedido_Temp with(nolock) 
			join Pedido_Det_Temp_New Pedido_Det 	with(nolock) on Pedido_Temp.ID = Pedido_Det.ID
			--left join Produto_Cliente		Produto_Cliente	on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto
			left join Tipo_Embalagem		Tipo_Embalagem	with(nolock) on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			JOIN Pedido_Det_Complementar_Temp_New Pedido_Det_Compl with(nolock) on Pedido_Det_Compl.ID = Pedido_Det.ID 
				AND Pedido_Det_Compl.Item = Pedido_Det.Item
			left join Pessoa				Fabricante	with(nolock) on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	with(nolock) on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	with(nolock) on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC
			left join Produto_Cliente		PD with(nolock) on PD.cd_Proc_Cliente = Pedido_Det.Name_Produto	and PD.cd_Cliente =Pedido_Temp.Cd_Grupo 
			left join House_Temp			House_Temp with(nolock) on House_Temp.ID = PEdido_Temp.ID_House_Temp
		Where
			Pedido_Temp.ID_House_temp=@ID
	End
	
	

	
GO
