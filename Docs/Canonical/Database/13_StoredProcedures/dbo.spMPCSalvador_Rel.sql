SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE       Procedure	spMPCSalvador_Rel  --'01-24-2007'


(
	
	@Data datetime
)

As	


	select
convert(datetime,HOU.Dt_Emis_HEA,105)	Register_Date,
		HOU.Num_Proc_HEA	Processo,
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
		LLP.ETD_LEA 		ETD,
		LLP.ATD_LEA 		ATD,
		LLP.ETA_LEA 		ETA,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_exp_AER HOU

	Left Outer Join LLP_Exp_AER	LLP	on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEA = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HEA = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_Exp_AER		VOL	on HOU.Num_Proc_HEA = VOl.Num_Proc_HEA
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HEA,105) > @Data

Union All


	select
convert(datetime,HOU.Dt_Emis_HIA,105)	Register_Date,
		HOU.Num_Proc_HIA	Processo,
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
		LLP.ETD_LIA 		ETD,
		LLP.ATD_LIA 		ATD,
		LLP.ETA_LIA 		ETA,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_IMP_AER HOU

	Left Outer Join LLP_IMP_AER	LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIA = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIA = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_IMP_AER		VOL	on HOU.Num_Proc_HIA = VOl.Num_Proc_HIA
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data
Union All


	select
convert(datetime,HOU.Dt_Emis_HEM,105)	Register_Date,
		HOU.Num_Proc_HEM	Processo,
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
		LLP.ETD_LEM 		ETD,
		LLP.ATD_LEM 		ATD,
		LLP.ETA_LEM 		ETA,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_EXP_MAR HOU

	Left Outer Join LLP_EXP_MAR	LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HEM = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_EXP_MAR		VOL	on HOU.Num_Proc_HEM = VOl.Num_Proc_HEM
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HEM,105) > @Data

Union All


	select
convert(datetime,HOU.Dt_Emis_HIM,105)	Register_Date,
		HOU.Num_Proc_HIM	Processo,
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
		LLP.ETD_LIM 		ETD,
		LLP.ATD_LIM		ATD,
		LLP.ETA_LIM 		ETA,
		TE.Nome_tp_Embal	Package,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido	
		
	from 
		house_IMP_MAR HOU

	Left Outer Join LLP_IMP_MAR	LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join Pedido_Ship 	PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Outer Join Pedido_Det	PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Left Outer Join Localidade	DS	on HOU.Cd_Dst_HIM = DS.Cd_Local
	Left Outer Join Pessoa		OC 	on LLP.Cd_Order = OC.Cd_Pes
	Join Volume_IMP_MAR		VOL	on HOU.Num_Proc_HIM = VOl.Num_Proc_HIM
	Join Tipo_Embalagem		TE	on Vol.Cd_Tp_Embal = TE.cd_Tp_Embal
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data

Union All

	select
convert(datetime,HOU.Dt_Emis_HEO,105)	Register_Date,
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
		LLP.ETD_LEO 		ETD,
		LLP.ATD_LEO 		ATD,
		LLP.ETA_LEO 		ETA,
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
		convert(datetime,Dt_Emis_HEO,105) > @Data

Union All

	select
convert(datetime,HOU.Dt_Emis_HIO,105)	Register_Date,
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
		LLP.ETD_LIO 		ETD,
		LLP.ATD_LIO 		ATD,
		LLP.ETA_LIO 		ETA,
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
		convert(datetime,Dt_Emis_HIO,105) > @Data


--update house_exp_out set dt_emis_heo = '24-01-2008'
--where num_proc_heo = 'EOCSR20080100901'


GO
