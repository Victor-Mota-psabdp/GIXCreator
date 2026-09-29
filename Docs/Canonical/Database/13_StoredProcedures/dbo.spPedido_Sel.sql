SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      Procedure [dbo].[spPedido_Sel] --'46000767', 'FMC QUIMICA','FMC CORP (EXP.)'
	
	@Num_Pedido 	varchar(30),
	@Buyer 	    	VarChar(50),
	@Seller			varchar(50)

AS

select 
	cd_pedido,
	Num_Pedido,
	BB.Apelido Buyer, 
	SS.Apelido Seller, 
	cd_tp_moeda, 
	vlr_pedido, 
	dt_pedido, 
	dl_chegada,
	cd_modal,
	cd_tipo, 
	incoterm, 
	org.Nome_Pais Pais_Origem,
	dst.Nome_Pais Pais_Destino,
	Status, 
	Customer_PO,
	Num_PO,
	Cd_Pes_CTT,
	PO.Nome_Usuario PO_Usuario,
	CS.Apelido Consignee,
	Selling_SAP,
	US.Nome_Usuario USI,
	CSR.Nome_usuario CSR_Nome,
	GP.Apelido Grupo,
	Planta,
	SP.Apelido Shipper
from 
	pedido PD with(nolock)
	left Join Pessoa BB with(nolock) on BB.cd_pes=PD.cd_buyer
	left Join Pessoa SS with(nolock) on SS.cd_pes=PD.cd_seller
	left Join Pessoa GP with(nolock) on GP.cd_pes=PD.cd_Grupo
	Left Join Pais Org with(nolock) on Org.cd_pais=PD.cd_pais_org
	left Join Pais Dst with(nolock) on Dst.cd_pais=PD.cd_pais_dst
	Left Outer Join Pessoa CS with(nolock) on PD.Cd_Consignee=CS.Cd_pes
	Left Outer Join Usuario_Cliente PO with(nolock) on PO.cd_usuario=PD.PO_Responsible and PO.Cd_Cliente= PD.cd_Grupo
	Left Outer Join Usuario_Cliente US with(nolock) on US.cd_usuario=PD.Cd_USERID and US.Cd_Cliente= PD.cd_Grupo
	Left Outer Join Usuario_Cliente CSR with(nolock) on CSR.cd_usuario=PD.Cd_CSRID and CSR.Cd_Cliente= PD.cd_Grupo
	Left Outer Join Pessoa SP with(nolock) on PD.Cd_Shipper=SP.Cd_pes
Where
	PD.num_pedido=@num_pedido and bb.apelido like @buyer and ss.apelido like @seller --and PD.Status<>'E'



	









GO
