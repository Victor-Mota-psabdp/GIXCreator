SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE      procedure [dbo].[spOrdersCSR_Rel] 
			@cd_Status char(1),
			@Modal	char(1)
		as
if @Modal='I' 
BEGIN
	select 
		Vlr_Pedido,Num_Pedido,Status,DP6.Data Planned_Goods_Issue_Dt, Org.Nome_Pais Origem,Dst.Nome_Pais Destino, PP.Nome_raz_soc Buyer ,SE.Nome_RAZ_Soc Seller,incoterm,DL_Chegada, 
		DP1.DATA Confirmed_Order_Item_Delivery_Date,DP2.DATA Audit_Date,DP3.DATA Shipment_Planning_Date_ORD, DP4.DATA Material_Provision_Date,DP5.DATA DATA_Start_Loading_Date,Num_PO,Customer_PO,order_type, NUM_PROC
	from 
		pedido PE
		LEFT Join Pais Org with(nolock) on ORg.cd_pais=cd_pais_org
		LEFT Join Pais Dst with(nolock) on DST.cd_pais=cd_pais_dst
		LEFT Join Pessoa PP with(nolock) on PP.cd_pes=cd_buyer
		LEFT Join Pessoa SE with(nolock) on SE.cd_pes=cd_seller
		lEFT Join Data_Pedidos DP6 with(nolock) on PE.cd_pedido=DP6.cd_pedido and DP6.id_ref=6
		lEFT Join Data_Pedidos DP1 with(nolock) on PE.cd_pedido=DP1.cd_pedido and DP1.id_ref=1
		LEFT Join Data_Pedidos DP2 with(nolock) on PE.cd_pedido=DP2.cd_pedido and DP2.id_ref=2
		LEFT Join Data_Pedidos DP3 with(nolock) on PE.cd_pedido=DP3.cd_pedido and DP3.id_ref=3
		LEFT Join Data_Pedidos DP4 with(nolock) on PE.cd_pedido=DP4.cd_pedido and DP4.id_ref=4
		LEFT Join Data_Pedidos DP5 with(nolock) on PE.cd_pedido=DP5.cd_pedido and DP5.id_ref=4
		LEFT Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PE.cd_pedido
	Where 
		status like @cd_status AND DST.NOME_PAIS='BRAZIL'  
		and (dp6.data >='01-15-2008' or dp6.data is null)
	Group by 
		Vlr_Pedido,Num_Pedido,status,DP6.Data,  Org.Nome_Pais,Dst.Nome_Pais , PP.Nome_raz_soc  ,SE.Nome_RAZ_Soc ,incoterm,DL_Chegada, 
		DP1.DATA ,DP2.DATA,DP3.DATA, DP4.DATA,DP5.DATA, Num_PO,Customer_PO,order_type,num_proc
end
else
BEGIN
	select 
		Vlr_Pedido,Num_Pedido,Status,DP6.Data Planned_Goods_Issue_Dt, Org.Nome_Pais Origem,Dst.Nome_Pais Destino, PP.Nome_raz_soc Buyer ,SE.Nome_RAZ_Soc Seller,incoterm,DL_Chegada, 
		DP1.DATA Confirmed_Order_Item_Delivery_Date,DP2.DATA Audit_Date,DP3.DATA Shipment_Planning_Date_ORD, DP4.DATA Material_Provision_Date,DP5.DATA DATA_Start_Loading_Date,Num_PO,Customer_PO,order_type, NUM_PROC
	from 
		pedido PE with(nolock)
		LEFT Join Pais Org with(nolock) on ORg.cd_pais=cd_pais_org
		LEFT Join Pais Dst with(nolock) on DST.cd_pais=cd_pais_dst
		LEFT Join Pessoa PP with(nolock) on PP.cd_pes=cd_buyer
		LEFT Join Pessoa SE with(nolock) on SE.cd_pes=cd_seller
		lEFT Join Data_Pedidos DP6 with(nolock) on PE.cd_pedido=DP6.cd_pedido and DP6.id_ref=6
		lEFT Join Data_Pedidos DP1 with(nolock) on PE.cd_pedido=DP1.cd_pedido and DP1.id_ref=1
		LEFT Join Data_Pedidos DP2 with(nolock) on PE.cd_pedido=DP2.cd_pedido and DP2.id_ref=2
		LEFT Join Data_Pedidos DP3 with(nolock) on PE.cd_pedido=DP3.cd_pedido and DP3.id_ref=3
		LEFT Join Data_Pedidos DP4 with(nolock) on PE.cd_pedido=DP4.cd_pedido and DP4.id_ref=4
		LEFT Join Data_Pedidos DP5 with(nolock) on PE.cd_pedido=DP5.cd_pedido and DP5.id_ref=4
		LEFT Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PE.cd_pedido
	Where 
		status like @cd_status AND org.NOME_PAIS='BRAZIL' and 
		(dp3.data >='01-15-2008' )
	Group by 
		Vlr_Pedido,Num_Pedido,status,DP6.Data,  Org.Nome_Pais,Dst.Nome_Pais , PP.Nome_raz_soc  ,SE.Nome_RAZ_Soc ,incoterm,DL_Chegada, 
		DP1.DATA ,DP2.DATA,DP3.DATA, DP4.DATA,DP5.DATA, Num_PO,Customer_PO,order_type, num_proc

end











GO
