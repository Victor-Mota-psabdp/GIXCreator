SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE	Procedure	[dbo].[spPlasticosT9_Rel] --'01-01-2008'
(
@Data datetime
)
As
	Select 
		HOU.Num_Proc_HIM				BDP_Reference,
convert(datetime,HOU.Dt_Emis_HIM,105)	Register_Date,
		P.Num_Pedido					PU,
--		DPP.GMID						GMID,
--		DPP.GMID_Descr_Curta			Produto,
		PD.Peso_Liquido_Tot	Peso_Liquido,
		LLP.ATD_LIM						Data_Embarque,
		LLP.ATA_LIM						Atracacao,
		HOU.Navio_HIM					Navio,
		LLP.ETA_LIM						Previsao,
		PS.Cd_Produto					Cd_Produto,
		P.Cd_Pedido						Cd_Pedido,
		P.Planta
	from
		House_IMP_MAR HOU
		Join LLP_IMP_MAR		LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
		Join Pedido_Det			PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido				P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
		Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data 
		and (P.Planta IN ('05031WQ','05031WJ'))
		--PD.PO_GRP IN ('041') and HOU.Cd_Dst_HIM = 'SSZ'
	Group by
		HOU.Num_Proc_HIM,
		HOU.Dt_Emis_HIM,
		P.Num_Pedido,
		DPP.GMID,
		DPP.GMID_Descr_Curta,
		PD.Peso_Liquido_Tot,
		LLP.ATD_LIM,
		LLP.ATA_LIM,
		HOU.Navio_HIM,
		LLP.ETA_LIM,
		PS.Cd_Produto,
		P.Cd_Pedido,
		P.Num_Pedido,
		P.Planta








GO
