SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     Procedure [dbo].[spInvoiceDET_SUN_Rel] --'2402'

	@ID_Inv	int
AS

select
	isnull(DP.GMID,ProD.cd_Proc_Cliente) GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	isnull(DP.P_Descricao,PROD.Produto_Descr) P_Descricao,
	isnull(DP.S_Descricao,PROD.Produto_Descr) S_Descricao,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	INV_DET.Incluso,
	HOU.Vlr_Frete_Tot_HEA,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	INV_CLI.Obs_PL Sh_Marks,
	HOU.Tp_Frete_HEA Tipo_Frete,
	PS.Item,
	HOU.Cd_Tp_Oper Incoterm,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	'A'	Modal,
	isnull(PDet.NCM,PROD.NCM_Cliente) NCM,
	EndShip.Pais Ship_Pais,
	PO.Numero_PO_Hea Num_PO,
	RE.Numero_PO_hea NumRE,
	HOU.Vol_Tot_HEA	Volume_M3,
	VOL.qtd_Vol_EA			Vol_Qtd,
	Inv_Det.Item,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	'' Carga,
	Inv_Cli.OBS_INV,
	dbo.fBusca_Custo(INV_CLI.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') custo_documentation

from
	Invoice_Det INV_DET
	Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente		PROD		on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join Tipo_Embalagem			TE			on TE.Cd_Tp_Embal 	=INV_DET.Cd_Embalagem
	Join House_Exp_Aer			HOU			on HOU.Num_Proc_HEA	=INV_CLI.Num_Proc
	join llp_exp_aer			LLP			on LLP.Num_proc_Lea = HOU.Num_Proc_Hea
	left outer join DE_Para_Produto	DP	on Dp.gmid=PROD.cd_proc_cliente
	Join Pedido_Ship			PS			on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc and INV_DET.Item=convert(int,PS.Item)
	Left Join Pedido			P	 		on P.cd_pedido 		=INV_DET.cd_pedido 
	Left Join Pedido_Det		PDet		on PDet.cd_pedido	=INV_DET.cd_pedido and PDet.cd_produto=INV_DET.cd_produto and INV_DET.Item=convert(int,PDet.Item)
	Left Join volume_exp_aer	VOL		on VOL.Num_Proc_HEA	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EA)
	Left Join Tipo_Embalagem	VE			on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
	Join Tipo_Oper TC on TC.cd_tp_oper=HOU.cd_tp_oper
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_HEA
	Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	join Invoice_Cliente InvCLI on InvCLI.Num_Proc = HOU.Num_Proc_HEA
	Left Join PO_hea	PO		on PO.Num_Proc_hea 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_hea	RE		on RE.Num_Proc_hea 	=InvCLI.Num_Proc and RE.ID_DC = '4'
Where
	 INV_DET.ID_Inv= @ID_Inv and INV_DET.Incluso='S'

UNION

select 
	isnull(DP.GMID,ProD.cd_Proc_Cliente) GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	isnull(DP.P_Descricao,PROD.Produto_Descr) P_Descricao,
	isnull(DP.S_Descricao,PROD.Produto_Descr) S_Descricao,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	INV_DET.Incluso,
	HOU.Vlr_Frete_Tot_HEM,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	INV_CLI.Obs_PL,
	HOU.Tp_Frete_HEM Tipo_Frete,
	PS.Item,
	HOU.Cd_Tp_Oper Incoterm,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	'O' Modal,
	isnull(PDet.NCM,PROD.NCM_Cliente) NCM,
	EndShip.Pais Ship_Pais,
	PO.Numero_PO_HEM Num_PO,
	RE.Numero_PO_hem NumRE,
	HOU.Vol_Tot_HEM	Volume_M3,
	VOL.qtd_Vol_EM			Vol_Qtd,
	Inv_Det.Item,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	LLP.cd_tp_carga carga,
	Inv_Cli.OBS_INV,
	dbo.fBusca_Custo(INV_CLI.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') custo_documentation
from 
	Invoice_Det INV_DET
	Join Invoice_Cliente	Inv_CLI	on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente	PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join Tipo_Embalagem		TE		on TE.Cd_Tp_Embal 	=INV_DET.Cd_Embalagem
	Join House_Exp_Mar		HOU		on HOU.Num_Proc_HEM	=INV_CLI.Num_Proc
	join llp_exp_mar			LLP			on LLP.Num_proc_Lem = HOU.Num_Proc_Hem
	left outer join DE_Para_Produto	DP		on Dp.gmid			=PROD.cd_proc_cliente
	left Join Pedido_Ship		PS		on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc and INV_DET.Item=convert(int,PS.Item)
	Left Join Pedido		P	 	on P.cd_pedido 		=INV_DET.cd_pedido
	Left Join Pedido_Det		PDet		on PDet.cd_pedido	=INV_DET.cd_pedido and PDet.cd_produto=INV_DET.cd_produto and INV_DET.Item=convert(int,PDet.Item)
	Left Join volume_exp_mar VOL	on VOL.Num_Proc_HEM	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EM)
	Left Join Tipo_Embalagem VE		on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
	Join Tipo_Oper TC on TC.cd_tp_oper=HOU.cd_tp_oper
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_HEM
	Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	join Invoice_Cliente InvCLI on InvCLI.Num_Proc = HOU.Num_Proc_HEM
	Left Join PO_heM	PO		on PO.Num_Proc_hem 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_hem	RE		on RE.Num_Proc_hem 	=InvCLI.Num_Proc and RE.ID_DC = '4'
Where
	 INV_DET.ID_Inv=@ID_Inv and INV_DET.Incluso='S'

union

select 
	isnull(DP.GMID,ProD.cd_Proc_Cliente) GMID,
	PROD.Produto_Descr GMID_Descr_Curta,
	isnull(DP.P_Descricao,PROD.Produto_Descr) P_Descricao,
	isnull(DP.S_Descricao,PROD.Produto_Descr) S_Descricao,
	INV_DET.Quantidade,
	TE.Nome_Tp_Embal,
	INV_DET.Capacidade,
	INV_DET.Peso_Bruto,
	INV_DET.Peso_Liquido,
	INV_DET.Tipo_Unid,
	INV_DET.Preco_Unit,
	INV_DET.Incluso,
	HOU.Vlr_Frete_efet_heo,
	isnull(INV_CLI.Vlr_Seguro,0) Vlr_Seguro,
	INV_CLI.Re_Marks,
	INV_CLI.Obs_PL,
	HOU.Tp_Frete_HEO Tipo_Frete,
	PS.Item,
	HOU.Cd_Tp_Oper Incoterm,
	Inv_CLI.Linguagem,
	INV_DET.Descr_Adicional,
	VE.Nome_Tp_Embal	Embalagem_VOL,
	LLP.Tipo_Leo Modal,
	isnull(PDet.NCM,PROD.NCM_Cliente) NCM,
	EndShip.Pais Ship_Pais,
	PO.Numero_PO_Heo Num_PO,
	RE.Numero_PO_heo NumRE,
	HOU.Vol_Tot_HEO	Volume_M3,
	VOL.qtd_Vol_EO			Vol_Qtd,
	Inv_Det.Item,
	dbo.fBusca_EmbalagensVOL(INVcli.id_inv)	Pack,
	''		Carga,
	Inv_Cli.OBS_INV,
	dbo.fBusca_Custo(INV_CLI.Num_Proc,PS.CD_Pedido, PS.Cd_Produto,'Custo de Documentação') custo_documentation
from 
	Invoice_Det INV_DET
	Join Invoice_Cliente	Inv_CLI	on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	Join Produto_Cliente	PROD	on PROD.Cd_Prod 	=INV_DET.Cd_Produto
	Join Tipo_Embalagem		TE		on TE.Cd_Tp_Embal 	=INV_DET.Cd_Embalagem
	Join House_Exp_out		HOU		on HOU.Num_Proc_heo	=INV_CLI.Num_Proc
	Join LLP_Exp_out		LLP		on LLP.Num_Proc_leo	=INV_CLI.Num_Proc
	left outer join De_Para_Produto	DP		on Dp.gmid			=PROD.cd_proc_cliente
	Join Pedido_Ship		PS		on PS.cd_pedido		=INV_DET.cd_pedido and PS.cd_produto=INV_DET.cd_produto and PS.Num_Proc=INV_CLI.Num_Proc and INV_DET.Item=convert(int,PS.Item)
	Left Join Pedido		P	 	on P.cd_pedido 		=INV_DET.cd_pedido
	Left Join Pedido_Det		PDet		on PDet.cd_pedido	=INV_DET.cd_pedido and PDet.cd_produto=INV_DET.cd_produto and INV_DET.Item=convert(int,PDet.Item)
	Left Join volume_exp_out VOL	on VOL.Num_Proc_HEO	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EO)
	Left Join Tipo_Embalagem VE		on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
	Join Tipo_Oper TC on TC.cd_tp_oper=HOU.cd_tp_oper
	Join Pessoa			SHIP	on SHIP.cd_pes		=HOU.cd_export_HEO
	Left Join Endereco	EndShip on EndShip.cd_pes	=Ship.Cd_Pes and EndShip.cd_tp_end = 'INV'
	join Invoice_Cliente InvCLI on InvCLI.Num_Proc = HOU.Num_Proc_HEO
	Left Join PO_heo	PO		on PO.Num_Proc_heo 	=InvCLI.Num_Proc and PO.ID_DC = '1'
	Left Join PO_heo	RE		on RE.Num_Proc_heo 	=InvCLI.Num_Proc and RE.ID_DC = '4'

Where
	 INV_DET.ID_Inv=@ID_Inv and INV_DET.Incluso='S'

Order By
	PS.Item


























GO
