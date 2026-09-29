SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spTranspFerro_Rel --'10-25-2007'
(
@Data datetime
)
As
Select
	HOU.Num_Proc_HEO	Ref_BDP,
	convert(datetime,HOU.Dt_Emis_HEO,105)	Register_Date,
	SHIP.Apelido		Shipper,
	CONS.Apelido		Consignee,
	HOU.HAWB_HEO		TIF_HAWB,
	HOU.Qtd_Tot_Vol_HEO	Qtd,
	ORIG.Apelido		Origem,
	DEST.Apelido		Destino,
--	Buscar Referencia do Shipment no VB
	P.Num_Pedido		PO,
--	Buscar Task no VB
	LLP.ATA_LEO		ATA
from
	House_EXP_OUT HOU
	Left Outer Join LLP_EXP_OUT	LLP	on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Left Outer Join Pessoa		SHIP 	on HOU.Cd_Export_HEO = SHIP.Cd_Pes
	Left Outer Join Pessoa		CONS	on HOU.Cd_Consig_HEO = CONS.Cd_Pes
	Left Outer Join Pessoa		ORIG	on HOU.Cd_Org_HEO = ORIG.Cd_Pes
	Left Outer Join Pessoa		DEST	on HOU.Cd_Dst_HEO = DEST.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HEO = PS.Num_Proc
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
where 
	convert(datetime,Dt_Emis_HEO,105) > @Data



GO
