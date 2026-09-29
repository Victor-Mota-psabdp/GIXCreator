SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE          Procedure	spBSCPCostData_Rel --'01-01-2008'
(
	@Data datetime
)
As
	select 
		HOU.Num_Proc_Hea	Processo,
		convert(Datetime,HOU.Dt_Emis_HEA,105) Emissao,
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		LLP.ATA_LEA 		Date_Of_Arrival,
		sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido		
	from 
		House_exp_aer HOU
	Left Outer Join LLP_Exp_Aer	LLP	on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_Hea = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_Hea = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_Hea = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_Hea,105) > @Data
	Group by

		HOU.Num_Proc_Hea,
		convert(Datetime,HOU.Dt_Emis_HEA,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY ,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LEA,
		PS.Cd_Produto,
		PS.Cd_Pedido	
Union all
	select 
		HOU.Num_Proc_HIA	Processo,
		convert(Datetime,HOU.Dt_Emis_HIA,105) Emissao, 
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		LLP.ATA_LIA 		Date_Of_Arrival,
		Sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from 
		House_IMP_aer HOU
	Left Outer Join LLP_IMP_Aer	LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIA = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_HIA = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIA = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data

	Group by

		HOU.Num_Proc_Hia,
		convert(Datetime,HOU.Dt_Emis_HIA,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY ,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LIA,
		PS.Cd_Produto,
		PS.Cd_Pedido	

union all
	select 
		HOU.Num_Proc_HEM	Processo,
		convert(Datetime,HOU.Dt_Emis_HEM,105) Emissao, 
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		LLP.ATA_LEM 		Date_Of_Arrival,
		Sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from 
		House_EXP_MAR HOU
	Left Outer Join LLP_EXP_MAR	LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_HEM = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HEM = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_HEM,105) > @Data
	Group by

		HOU.Num_Proc_HeM,
		convert(Datetime,HOU.Dt_Emis_HEM,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY ,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LEM,
		PS.Cd_Produto,
		PS.Cd_Pedido	

Union All
	select 
		HOU.Num_Proc_HIM	Processo,
		convert(Datetime,HOU.Dt_Emis_HIM,105) Emissao, 
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,		LLP.ATA_LIM 		Date_Of_Arrival,
		Sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto 		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from 
		House_IMP_MAR HOU
	Left Outer Join LLP_IMP_MAR	LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_HIM = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIM = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data
	Group by

		HOU.Num_Proc_HIM,
		convert(Datetime,HOU.Dt_Emis_HIM,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY ,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LIM,
		PS.Cd_Produto,
		PS.Cd_Pedido	

Union All
 	select 
		HOU.Num_Proc_HEO	Processo,
		convert(datetime,HOU.Dt_Emis_HEO,105)		Emissao, 
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		LLP.ATA_LEO 		Date_Of_Arrival,
		Sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from 
		House_EXP_OUT HOU
	Left Outer Join LLP_EXP_OUT	LLP	on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEO = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_HEO = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HEO = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_HEO,105) > @Data

	Group by

		HOU.Num_Proc_HeO,
		convert(Datetime,HOU.Dt_Emis_HEO,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LEO,
		PS.Cd_Produto,
		PS.Cd_Pedido	
Union All
	select 
		HOU.Num_Proc_HIO	Processo,
		convert(datetime,HOU.Dt_Emis_HIO,105)		Emissao, 
		DPP.Business_Descr 	Business_Name, 
		CS.Nome_Raz_Soc 	Consignne_Name,
		DS.Pais_Local 		Country_Destination,
		DPP.Value_Center_Descr 	Value_Center,
		DPP.GMID 		GMID,
		DPP.GMID_Descr_Curta 	Product,
		PS.QTY Quantity,
	--	Unit_Description
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		LLP.ATA_LIO 		Date_Of_Arrival,
		Sum(PS.Qty * PD.Vlr_Item) 	FOB,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from 
		House_IMP_OUT HOU
	Left Outer Join LLP_IMP_OUT	LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIO = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa		CS	on HOU.Cd_Consig_HIO = CS.Cd_Pes
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIO = DS.Cd_Local
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data
	Group by

		HOU.Num_Proc_HIO,
		convert(Datetime,HOU.Dt_Emis_HIO,105),
		DPP.Business_Descr, 
		CS.Nome_Raz_Soc,
		DS.Pais_Local,
		DPP.Value_Center_Descr,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PS.QTY ,
		P.Num_PO,
		P.Num_Pedido,
		LLP.ATA_LIO,
		PS.Cd_Produto,
		PS.Cd_Pedido	



GO
