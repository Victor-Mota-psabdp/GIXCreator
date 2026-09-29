SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE         Procedure	spPosicao_Ordens_Itajai_Rel --'01-01-2008'
(
	@Data datetime
)
As
	Select 
		HOU.Num_Proc_Hia	BDP_Reference,
convert(datetime,HOU.Dt_Emis_Hia,105)	Register_Date,
		DV.Planta_Nome		Divisao,
		P.Num_PO		PU,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Produto,
		PD.Peso_Item		Peso_Liquido,
		LLP.ATD_LIA		Data_Embarque,
		LLP.ATA_LIA		Atracacao,
		LLP.ETA_LIA		Previsao,
		PS.Cd_Produto		Cd_Produto,
		P.Cd_Pedido		Cd_Pedido
--		Top 1 HIS.HSDDescricao	Motivo_Atraso			
	from
		House_IMP_Aer HOU
	Left Outer Join LLP_IMP_Aer	LLP	on HOU.Num_Proc_Hia = LLP.Num_Proc_LIA
	Left Outer Join Pessoa_LLP	DV 	on HOU.Cd_Export_Hia = DV.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_Hia = PS.Num_Proc
	Join Pedido_Det			PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join Hist_Geral	HIS	on HOU.Num_Proc_Hia = HIS.Refer_Hist and Cd_TP_Ocor ='40'
	where 
		convert(datetime,Dt_Emis_Hia,105) > @Data and
		business_group_code in ('00009764','00009777')
Union All

	Select 

		HOU.Num_Proc_HIM			BDP_Reference,
convert(datetime,HOU.Dt_Emis_HIM,105)			Register_Date,
		DV.Planta_Nome				Divisao,
		P.Num_Pedido				PU,
		DPP.GMID				GMID,
		DPP.GMID_Descr_Curta			Produto,
		PD.Peso_Item				Peso_Liquido,
		LLP.ATA_LIM				Atracacao,
		LLP.ETA_LIM				Previsao,
		LLP.ETA_LIM				Previsao,
		PS.Cd_Produto				Cd_Produto,
		P.Cd_Pedido				Cd_Pedido
--		Top 1 HIS.HSDDescricao	Motivo_Atraso
	from
		House_IMP_MAR HOU
	Left Outer Join LLP_IMP_MAR	LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join Pessoa_LLP	DV 	on HOU.Cd_Export_HIM = DV.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det			PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join Hist_Geral	HIS	on HOU.Num_Proc_HIM = HIS.Refer_Hist and Cd_TP_Ocor ='40'
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data and
		business_group_code in ('00009764','00009777')

Union All
	Select 
		HOU.Num_Proc_HIO	BDP_Reference,
convert(datetime,HOU.Dt_Emis_HIO,105)	Register_Date,
		DV.Planta_Nome		Divisao,
		P.Num_Pedido		PU,
		DPP.GMID		GMID,
		DPP.GMID_Descr_Curta	Produto,
		PD.Peso_Item		Peso_Liquido,
		LLP.ATD_LIO		Data_Embarque,
		LLP.ATA_LIO		Atracacao,
		LLP.ETA_LIO		Previsao,
		PS.Cd_Produto		Cd_Produto,
		P.Cd_Pedido		Cd_Pedido
--		Top 1 HIS.HSDDescricao	Motivo_Atraso
	from
		House_IMP_OUT HOU
	Left Outer Join LLP_IMP_OUT	LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Left Outer Join Pessoa_LLP	DV 	on HOU.Cd_Export_HIO = DV.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det			PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join Hist_Geral	HIS	on HOU.Num_Proc_HIO = HIS.Refer_Hist and Cd_TP_Ocor ='40'
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data and
		business_group_code in ('00009764','00009777')



GO
