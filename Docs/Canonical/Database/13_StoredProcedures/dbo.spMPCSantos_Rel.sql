SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     Procedure	 spMPCSantos_Rel  --'01-01-2008'


(
	
	@Data datetime
)

As	

	Select 
		HOU.Num_Proc_HEM 			Processo,	
		Convert(datetime,HOU.Dt_Emis_Hem,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight				
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_Lem				ETD,
		LLP.ETA_Lem				ETA,
		LLP.ATD_LEm 				ATD,
		TE.Nome_Tp_Embal			Packagem,
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido		
		
	from
		House_Exp_Mar HOU
	
	Left Outer Join LLP_Exp_Mar	LLP	on HOU.Num_Proc_Hem = LLP.Num_Proc_Lem
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_hem = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_Hem = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_Exp_Mar	EM	On HOU.Num_Proc_Hem = EM.Num_Proc_Hem
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_Hem,105) > @Data

Union All

	Select 
		HOU.Num_Proc_HIM 			Processo,	
		Convert(datetime,HOU.Dt_Emis_HIM,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight				
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_LIM				ETD,
		LLP.ETA_LIM				ETA,
		LLP.ATD_LIM				ATD,
		TE.Nome_Tp_Embal			Packagem,	
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido	
		
	from
		House_IMP_Mar HOU
	
	Left Outer Join LLP_IMP_Mar	LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_HIM = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_IMP_Mar	EM	On HOU.Num_Proc_HIM = EM.Num_Proc_HIM
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data

Union All


	Select 
		HOU.Num_Proc_HEA 			Processo,	
		Convert(datetime,HOU.Dt_Emis_HEA,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight			
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_LEA				ETD,
		LLP.ETA_LEA				ETA,
		LLP.ATD_LEA 				ATD,
		TE.Nome_Tp_Embal			Packagem,	
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido	
		
	from
		House_Exp_AER HOU
	
	Left Outer Join LLP_Exp_AER	LLP	on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_HEA = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HEA = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_Exp_AER	EM	On HOU.Num_Proc_HEA = EM.Num_Proc_HEA
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_HEA,105) > @Data

Union All

	Select 
		HOU.Num_Proc_HIA 			Processo,	
		Convert(datetime,HOU.Dt_Emis_HIA,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight				
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_LIA				ETD,
		LLP.ETA_LIA				ETA,
		LLP.ATD_LIA 				ATD,
		TE.Nome_Tp_Embal			Packagem,	
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido	
		
	from
		House_IMP_AER HOU
	
	Left Outer Join LLP_IMP_AER	LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_HIA = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_IMP_AER	EM	On HOU.Num_Proc_HIA = EM.Num_Proc_HIA
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data

Union ALL

	Select 
		HOU.Num_Proc_HIO 			Processo,	
		convert(datetime,Dt_Emis_HIO,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight				
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_LIO				ETD,
		LLP.ETA_LIO				ETA,
		LLP.ATD_LIO 				ATD,
		TE.Nome_Tp_Embal			Packagem,
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido		
		
	from
		House_IMP_OUT HOU
	
	Left Outer Join LLP_IMP_OUT	LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_HIO = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_IMP_OUT	EM	On HOU.Num_Proc_HIO = EM.Num_Proc_HIO
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data

Union All

	Select 
		HOU.Num_Proc_HEO 			Processo,	
		Convert(datetime,HOU.Dt_Emis_HEO,105) 	Register_Date,
		P.Num_Pedido				Order_Number,
		CM.Apelido				Customer,
		LC.Pais_Local				Country,
		PC.Produto_Descr			Product,
		PD.QTY					Unit_Qty,
--		GRS_KG
		PD.Peso_Item				Net_KG,
--		Gross_Weight	
		(PD.QTY * PD.Peso_Item)			Net_Weight,
		PD.Vlr_Item				Unit_Price,
		(PD.QTY * Pd.Vlr_Item)			FOB,
		HOU.Cd_Tp_Oper				Incoterms,
		P.Dt_Pedido				Order_Date,
		P.Num_Pedido				Goods_Issue,
		LLP.ETD_LEO				ETD,
		LLP.ETA_LEO				ETA,
		LLP.ATD_LEO 				ATD,
		TE.Nome_Tp_Embal			Packagem,
		PS.Cd_Produto  				CD_Produto,
		PS.Cd_Pedido				CD_Pedido		
		
	from
		House_EXP_OUT HOU
	
	Left Outer Join LLP_EXP_OUT	LLP	on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Left Outer Join	Pessoa		CM 	on LLP.Cd_Order = CM.Cd_Pes
	Left Outer Join Localidade	LC	on HOU.Cd_dst_HEO = LC.Cd_Local
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HEO = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto = PC.Cd_Prod
	Left Outer Join Volume_EXP_OUT	EM	On HOU.Num_Proc_HEO = EM.Num_Proc_HEO
	Left Outer Join Tipo_embalagem	TE	On EM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	
	where 
		convert(datetime,Dt_Emis_HEO,105) > @Data







GO
