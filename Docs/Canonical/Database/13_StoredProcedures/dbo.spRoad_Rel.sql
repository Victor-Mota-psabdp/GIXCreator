SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE      Procedure	spRoad_Rel  --'10-1-2007'


(
	
	@Data datetime
)

As	


	select
		HOU.Dt_Emis_HEO		Register_Date,
		HOU.Num_Proc_HEO	Processo,
		P.Num_Pedido		Order_Number,
		OC.Apelido		Customer,
		DS.Pais_Local		Country,
		DPP.GMID_Descr_Curta	Product,
		PS.QTY			Unit_QTY,
		PD.Peso_Item		Net,
	--	GRS
		(PS.QTY * PD.Peso_Item)	Net_Weight,
	--	Groos Weigtht
		PD.Vlr_Item		Unit_Price,
		(PS.QTY * PD.Vlr_Item)	FOB,
		HOU.Cd_Tp_Oper		Incoterms,
		P.Dt_Pedido		Order_Date,
		P.Num_Pedido		Goods_Issue,
		LLP.ETA_LEO		ETA,
		LLP.ATD_LEO 		ATD,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_exp_OUT HOU

	Left Outer Join LLP_Exp_OUT	LLP	on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEO = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HEO = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_Exp_OUT		VOL	on HOU.Num_Proc_HEO = VOl.Num_Proc_HEO
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HEO,105) > @Data and LLP.Tipo_Leo = 'T'

Union All

	select
		HOU.Dt_Emis_HIO		Register_Date,
		HOU.Num_Proc_HIO	Processo,
		P.Num_Pedido		Order_Number,
		OC.Apelido		Customer,
		DS.Pais_Local		Country,
		DPP.GMID_Descr_Curta	Product,
		PS.QTY			Unit_QTY,
		PD.Peso_Item		Net,
	--	GRS
		(PS.QTY * PD.Peso_Item)	Net_Weight,
	--	Groos Weigtht
		PD.Vlr_Item		Unit_Price,
		(PS.QTY * PD.Vlr_Item)	FOB,
		HOU.Cd_Tp_Oper		Incoterms,
		P.Dt_Pedido		Order_Date,
		P.Num_Pedido		Goods_Issue,
		LLP.ETA_LIO		ETA,
		LLP.ATD_LIO 		ATD,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_IMP_OUT HOU

	Left Outer Join LLP_IMP_OUT	LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIO = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIO = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_IMP_OUT		VOL	on HOU.Num_Proc_HIO = VOl.Num_Proc_HIO
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data and LLP.Tipo_LIO = 'T'




GO
