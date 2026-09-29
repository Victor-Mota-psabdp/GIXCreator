SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure	 [dbo].[spPlasticosT4_Rel] --'01/01/2009'
(
	@Data datetime
)
As
	select 
		HOU.Num_Proc_Him						Ref_BDP,
		P.Num_PO								PO,
		P.Num_Pedido							SAP,
		HOU.Navio_HIM							Navio,
		ARM.Nome_Armador						Armador,
		dbo.fBusca_Tarefa(hou.num_proc_him,14)	DataFatura,
		LC.Nome_Local							Porto,
		NF.Data_DI								Data_DI,
		NF.DI									DI,
		LLP.Canal_LIM							Canal,
		dbo.qty_container(hou.num_proc_him)		QtdContainers,
	--	Taxas
		PS.Cd_Produto  							CD_Produto,
		PS.Cd_Pedido							CD_Pedido,
		P.Planta
	from
		House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar				LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Job_Imp_Mar				JIM with(nolock)	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Left Outer Join Nota_Cliente 	NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc
	Left Outer Join Armador			ARM with(nolock)	on JIM.Cd_Armador   = ARM.Cd_Armador
	Join Pedido_Ship 				PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido						P with(nolock)	on PS.Cd_Pedido	    = P.Cd_Pedido
	Join Pedido_Det					PD  with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Localidade		LC with(nolock)	on Hou.Cd_Dst_HIM   = LC.Cd_Local
	Join Produto_Cliente			PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 			DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	--Left Outer Join PO_HIM		PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data 
		--and PD.PO_GRP IN ('041')
		and (P.Planta IN ('05031WQ','05031WJ'))
	Group by
		HOU.Num_Proc_HIM,
		P.Num_PO,
		P.Num_Pedido,
		HOU.Navio_HIM,
		ARM.Nome_Armador,
		LC.Nome_Local,
		NF.Data_DI,
		NF.DI,
		LLP.Canal_LIM,
		PS.Cd_Produto,
		PS.Cd_Pedido,
		P.Planta

/*
Union All
	select 
		HOU.Num_Proc_Hem	Ref_BDP,
		P.Num_PO		PO,
		P.Num_Pedido		Order_Number,
		HOU.Navio_HEM		Navio,
		ARM.Nome_Armador	Armador,
	--	DataFatura
		LC.Nome_Local		Porto,
		NF.Data_DI		Data_DI,
		NF.DI			DI,
		LLP.Canal_LEM		Canal,
		Count(CO.item_cont_em)	QtdContainers,
	--	Taxas
		PS.Cd_Produto  		CD_Produto, -- para trazer as taxas no VB
		PS.Cd_Pedido		CD_Pedido   -- para trazer as taxas no VB
	from
		House_Exp_Mar HOU
	Join LLP_Exp_Mar		LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Left Outer Join container_hou_exp_mar CO on HOU.Num_Proc_HEM = CO.Num_Proc_HEM
	Left Outer Join Nota_Cliente 	NF	on HOU.Num_Proc_HEM = NF.Num_Proc
	Left Outer Join Armador		ARM	on LLP.Cd_Armador_LEM   = ARM.Cd_Armador
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Join Pedido			P	on PS.Cd_Pedido	    = P.Cd_Pedido
	Left Outer Join Localidade	LC	on Hou.Cd_Dst_HEM   = Lc.Cd_Local
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	--Left Outer Join PO_HEM		PO	on PO.Num_proc_HEM = HOU.Num_proc_HEM and PO.ID_DC = 1
	where 
		convert(datetime,Dt_Emis_Hem,105) > @Data
		and business_group_code in ('00009764','00009777')
	Group by
		HOU.Num_Proc_Hem,
		P.Num_PO,
		P.Num_Pedido,
		HOU.Navio_HEM,
		ARM.Nome_Armador,
		LC.Nome_Local,
		NF.Data_DI,
		NF.DI,
		LLP.Canal_LEM,
		PS.Cd_Produto,
		PS.Cd_Pedido


*/






GO
