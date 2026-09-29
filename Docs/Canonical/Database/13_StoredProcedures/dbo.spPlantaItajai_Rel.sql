SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE          PROCEDURE [dbo].[spPlantaItajai_Rel]-- '01/01/2008'
--Utilizada na geração de relatório em Excel

(
	@Data	datetime
)

AS
	Select 
		Num_Pedido			Order_Reference,
		Num_PO				PO,
		Customer_PO,
		Cd_Proc_Cliente		GMID,
		QTY,
		Sllr.Apelido 		Seller,
		Byr.Apelido			Buyer,
		Org.Nome_Pais		Pais_Origem,
		Dst.Nome_Pais		Pais_Destino,
		Cnsgn.Apelido		Consignee,
		Dt_Pedido			Order_Date,
		Dl_Chegada			PO_Req_Deliv,
		DTPDD.DATA			Shipment_Planning,
		Cd_Modal			Modal			
	From
		Pedido P
	Left Outer Join Pedido_Det		PD		on P.Cd_Pedido = PD.Cd_pedido
	Left Outer Join Produto_cliente PC		on PD.Cd_Produto = PC.cd_prod
	Left Outer Join Pessoa			Sllr 	on P.Cd_Seller = Sllr.Cd_Pes
	Left Outer Join Pessoa 			Byr 	on P.Cd_Buyer = Byr.Cd_Pes
	Left Outer Join Pais 			Org		on P.Cd_Pais_Org = Org.Cd_Pais
	Left Outer Join Pais 			Dst		on P.Cd_Pais_Dst = Dst.Cd_Pais
	Left Outer Join Pessoa 			Cnsgn 	on P.Cd_Consignee = Cnsgn.Cd_Pes
	Left Outer Join data_pedidos	DTPDD	on P.cd_pedido = DTPDD.Cd_Pedido and ID_Ref = 3
	where Planta = '05031WJ' and Dl_Chegada >= @Data





GO
