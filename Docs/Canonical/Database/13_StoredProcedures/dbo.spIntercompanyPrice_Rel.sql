SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE	  Procedure	 [dbo].[spIntercompanyPrice_Rel]  --'01-01-2008'


(
	
	@Data datetime
)

As

	select 
		HOU.Num_Proc_Hem	BDP_Reference,
		convert(datetime,HOU.Dt_Emis_Hem,105)		Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,	
		Left(HOU.Num_Proc_Hem,2) Mode_Transportation,
		LLP.ATD_Lem		Sailing_Date,
		LLP.ATA_Lem		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_Exp_Mar HOU with(nolock)

	Left Outer Join LLP_Exp_Mar	LLP	 with(nolock)on HOU.Num_Proc_Hem = LLP.Num_Proc_LEM
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HEM = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock)	on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_hem = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_Hem = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Hem = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Hem = Dt.Cd_Local

	
	where 
		convert(datetime,Dt_Emis_Hem,105) > @Data
Union All

	select 
		HOU.Num_Proc_HIM	BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIM,105)		Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,	
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,		
		Left(HOU.Num_Proc_HIM,2) Mode_Transportation,
		LLP.ATD_LIM		Sailing_Date,
		LLP.ATA_LIM		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_IMP_Mar HOU with(nolock)

	Left Outer Join LLP_IMP_Mar	LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock)	on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_HIM = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_HIM = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Him = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Him = Dt.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data
Union ALL

	select 
		HOU.Num_Proc_HEA	BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HEA,105)		Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,	
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,		
		Left(HOU.Num_Proc_HEA,2) Mode_Transportation,
		LLP.ATD_LEA		Sailing_Date,
		LLP.ATA_LEA		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_Exp_AER HOU with(nolock)

	Left Outer Join LLP_Exp_AER	LLP with(nolock)	on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HEA = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock)	on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_HEA = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_HEA = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Hea = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Hea = Dt.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HEA,105) > @Data

Union All

	select 
		HOU.Num_Proc_HIA	BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIA,105)		Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,	
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,		
		Left(HOU.Num_Proc_HIA,2) Mode_Transportation,
		LLP.ATD_LIA		Sailing_Date,
		LLP.ATA_LIA		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_IMP_AER HOU with(nolock)

	Left Outer Join LLP_IMP_AER	LLP with(nolock)	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock) on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_HIA = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_HIA = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Hia = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Hia = Dt.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data

Union All

	select 
		HOU.Num_Proc_HIO	BDP_Reference,
convert(datetime,HOU.Dt_Emis_HIO,105)	Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,	
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,		
		Left(HOU.Num_Proc_HIO,2) Mode_Transportation,
		LLP.ATD_LIO		Sailing_Date,
		LLP.ATA_LIO		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_IMP_OUT HOU with(nolock)

	Left Outer Join LLP_IMP_OUT	LLP with(nolock)	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock)	on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_HIO = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_HIO = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Hio = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Hio = Dt.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data

Union All

	select 
		HOU.Num_Proc_HEO	BDP_Reference,
convert(datetime,HOU.Dt_Emis_HEO,105)	Register_Date,
		P.Num_PO		PO_Number,
		P.Num_Pedido		Sap_Order_Number,
		DPP.Business_Code	Business_Code,
		DPP.Business_Descr	Business_Descr,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Product_Description,
		OG.Pais_Local		Delivering_Country,
		DC.Planta_Nome		Delivering_Planta,	
		DT.Pais_Local		Country_Destination,		
		RC.Planta_Nome		Receiving_Planta,
		CS.Apelido		Consignee,	
		OG.Nome_Local		Loading,	
		DT.Nome_Local		Arrival,		
		Left(HOU.Num_Proc_HEO,2) Mode_Transportation,
		LLP.ATD_LEO		Sailing_Date,
		LLP.ATA_LEO		Date_Arrival,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido,
		NC.Nota_Fiscal		Nr_Nota_Fiscal,
		NC.Emissao		Data_NF
		
	from
		House_EXP_OUT HOU

	Left Outer Join LLP_EXP_OUT	LLP with(nolock)	on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HEO = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Pessoa_LLP	RC with(nolock)	on P.Cd_Buyer = RC.Cd_Pes
	Left Outer Join Pessoa_LLP	DC with(nolock)	on P.Cd_Seller = DC.Cd_Pes
	Left Outer Join Pessoa		RCC with(nolock)	on RC.Cd_Pes = RCC.Cd_Pes
	Left Outer Join Pessoa		CS with(nolock)	on HOU.Cd_Consig_HEO = CS.Cd_Pes
	Left Outer Join Nota_Cliente	NC with(nolock)	on HOU.Num_Proc_HEO = NC.Num_Proc
	Left Outer Join Localidade	OG with(nolock)	on HOU.Cd_Org_Heo = OG.Cd_Local
	Left Outer Join Localidade	Dt with(nolock)	on HOU.Cd_Dst_Heo = Dt.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HEO,105) > @Data











GO
