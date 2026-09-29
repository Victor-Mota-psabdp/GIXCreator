SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Temp_New 
--SP_HELP Pedido_Det_Complementar_Temp_New
CREATE procedure [dbo].[spPedido_Det_Complementar_Temp_New_Sel]
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
			'Saved' Status,
			Pedido_Det.Cd_Pedido,
			Pedido_Det.Cd_Produto,
			Produto_Cliente.cd_Proc_Cliente,
			Produto_Cliente.Produto_Descr,
			Pedido_Det.Name_Produto,
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
			Pedido_Det.UoM						[UoM],
			Pedido_Det.Name_UoM					[UoM Xml],	
			--Pedido_Det.SAP_Company,			
			--Pedido_Det.DN_Valida,		
			--Pedido_Det.Total_Invoice_USD,
			--Pedido_Det.Total_Invoice_Local,
			--Pedido_Det.UPC,		
			Pedido_Det.Qtde_Embal			[Qty Packet],
			Pedido_Det.Cd_Tp_Embal			[Type Packet Code],
			Tipo_Embalagem.Nome_Tp_Embal	[Type Packet Name],
			Pedido_Det.Name_Embal					[Type Packet XML],
			Pedido_Det_Compl.Cd_Pes_Fabricante [Manufacturer Code],
			Fabricante.Apelido						[Manufacturer Name],
			Pedido_Det_Compl.Name_Pes_Fabricante	[Manufacturer Name XML],
			Pedido_Det_Compl.Cd_Pais_Fabricante		[Country of Manufact. Code],
			Pais.Nome_Pais							[Country of Manufact. Name XML],
			Pedido_Det_Compl.Name_Pais_Fabricante	[Country of Manufact. Name XML],
			Pedido_Det_Compl.Vlr_FOB				[FOB Value],
			Pedido_Det_Compl.ID_TP_AC				[Agreement Code],
			AC.NOME_TP_AC							[Agreement Name],
			Pedido_Det_Compl.Name_AC				[Agreement Name XML]
		from Pedido_Det_Temp_New Pedido_Det
			left join Pedido_Temp_New		Pedido_Temp	on Pedido_Temp.ID = Pedido_Det.ID
			left join Produto_Cliente		Produto_Cliente	on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto
			left join Tipo_Embalagem		Tipo_Embalagem	on Tipo_Embalagem.Cd_Tp_Embal = Pedido_Det.Cd_Tp_Embal
			LEFT JOIN Pedido_Det_Complementar_Temp_New Pedido_Det_Compl on Pedido_Det_Compl.ID = Pedido_Det.ID
			left join Pessoa				Fabricante	on Fabricante.Cd_Pes = Pedido_Det_Compl.Cd_Pes_Fabricante
			left join Pais					Pais	on Pais.Cd_Pais = Pedido_Det_Compl.Cd_Pais_Fabricante
			left join Tipo_Acordo_Comercial AC	on AC.ID_TP_AC = Pedido_Det_Compl.ID_TP_AC
			
	End

--if @Tipo = 'C'  or @Tipo = 'D'
--	Begin
--		select
--			Pedido_Det.ID_Batch						[ID_Batch],
--			Pedido_Det.Cd_pedido						[ID],			
--			Pedido_Det.Num_Pedido						[Number],						
--			Pedido_Det.vlr_pedido						[Order Value],
			
--			Pedido_Det.Cd_Tipo							[Type Code],
--			Type_Order.Nome_Tp_Pedido			[Type Name],
--			Pedido_Det.Name_Tipo						[Type XML],
			
--			Pedido_Det.Incoterm						[Incoterm Code],
--			Incoterm.Nome_Tp_Oper				[Incoterm Name],
--			Pedido_Det.Name_Incoterm					[Incoterm XML],
			
--			Pedido_Det.Cd_Tp_Moeda						[Currency Code],
--			Currency.Nome_Tp_Moeda				[Currency Name],
--			Pedido_Det.Name_Moeda						[Currency XML],
			
--			Pedido_Det.Status							[Status Code],
--			Status.Nome_Tp_Status_Pedido		[Status Name],
--			Pedido_Det.Name_Status						[Status XML],
			
--			Pedido_Det.Cd_Seller						[Seller Code],
--			Seller.Apelido						[Seller Name],
--			Pedido_Det.Name_Seller						[Seller XML],			
				
--			Pedido_Det.Cd_Buyer						[Buyer Code],
--			Buyer.Apelido						[Buyer Name],		
--			Pedido_Det.Name_Buyer						[Buyer XML],

--			Pedido_Det.Cd_Shipper						[Shipper Code],
--			Shipper.Apelido						[Shipper Name],		
--			Pedido_Det.Name_Shipper					[Shipper XML],			
			
--			Pedido_Det.Cd_Consignee					[Consignee Code],
--			Consignee.Apelido					[Consignee Name],
--			Pedido_Det.Name_Consignee					[Consignee XML],
			
--			Pedido_Det.Cd_Grupo						[Group Code],
--			Grupo.Apelido						[Group Name],
--			Pedido_Det.Name_Grupo						[Group XML],
			
--			Pedido_Det.Cd_Pais_Org						[Origin Code],
--			Origin_Country.Nome_Pais			[Origin Name],		
--			Pedido_Det.Name_Pais_Org					[Origin XML],
			
--			Pedido_Det.Cd_Pais_Dst						[Destination Code],
--			Destination_Country.Nome_Pais		[Destination],		
--			Pedido_Det.Name_Pais_Dst					[Destination XML],
			
--			Pedido_Det.Num_PO							[PO],
--			Pedido_Det.Customer_PO						[Customer PO],
			
--			Pedido_Det.Dt_Pedido						[Order Date],
--			Pedido_Det.DL_Chegada						[PO Req. Deliv.],
--			Pedido_Det.Selling_SAP						[Selling SAP],
--			Pedido_Det.Planta							[Plant ID],
--			Pedido_Det.Cd_Pes_CTT						[Contact],
			
--			Pedido_Det.Cd_CSRID						[CSR Name Code],
--			CSR_Name.Nome_Usuario				[CSR Name],		
--			Pedido_Det.Name_CSRID						[CSR Name XML],
			
--			Pedido_Det.Cd_USERID						[USER ID Code],
--			USERID.Nome_Usuario					[USER ID Name],		
--			Pedido_Det.Name_USERID						[USER ID XML],
			
--			Pedido_Det.PO_Responsible					[Responsible PO Code],
--			Responsible_PO.Nome_Usuario			[Responsible PO Name],		
--			Pedido_Det.Name_Responsible				[Responsible PO XML],
			
--			Pedido_Det.Cd_Modal						[Modal Code],
--			Modal.Modal							[Modal Name],		
--			Pedido_Det.Name_Modal						[Modal XML]	
			
----Obs_PC
----cd_tp_cont
----Payment
----Order_Type
----Status_Entrega
----Pedido_Retorno
----Pedido_Invoice_Only
----Cd_Vendor
----DN_R

--		from Pedido_Temp_New HOU
--			left join Tipo_Pedido			Type_Order	on Type_Order.cd_Tp_Pedido = Pedido_Det.Cd_Tipo
--			left join Tipo_Oper				Incoterm	on Incoterm.Cd_Tp_Oper = Pedido_Det.Incoterm
--			left join Tipo_Moeda			Currency	on Currency.Cd_Tp_Moeda  = Pedido_Det.Cd_Tp_Moeda
--			left join Tipo_Status_Predido	Status		on Status.Cd_Tp_Status_Pedido  = Pedido_Det.Status
--			left join Pessoa				Seller		on Seller.Cd_Pes = Pedido_Det.Cd_Seller
--			left join Pessoa				Buyer		on Buyer.Cd_Pes = Pedido_Det.Cd_Buyer
--			left join Pessoa				Shipper		on Shipper.Cd_Pes = Pedido_Det.Cd_Shipper
--			left join Pessoa				Consignee	on Consignee.Cd_Pes = Pedido_Det.Cd_Consignee
--			left join Pais					Origin_Country		on Origin_Country.Cd_Pais = Pedido_Det.Cd_Pais_Org
--			left join Pais					Destination_Country on Destination_Country.Cd_Pais = Pedido_Det.Cd_Pais_Dst
--			left join Pessoa				Grupo		on Grupo.Cd_Pes = Pedido_Det.Cd_Grupo
			
--			left join Usuario_Cliente		CSR_Name		on CSR_Name.Cd_Cliente = Pedido_Det.Cd_CSRID
--			left join Usuario_Cliente		USERID			on USERID.Cd_Cliente = Pedido_Det.Cd_USERID
--			left join Usuario_Cliente		Responsible_PO	on Responsible_PO.Cd_Cliente = Pedido_Det.PO_Responsible
--			left join Tipo_Modal			Modal			on Modal.Id  = Pedido_Det.Cd_Modal
--		Where
--			[ID_Batch] = @ID_Batch
--	End

GO
