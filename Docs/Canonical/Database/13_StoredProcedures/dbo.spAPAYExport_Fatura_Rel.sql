SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from pedido_ship where num_proc='EACSR20080100101'
--select* from Cta_Cte_Hou_Exp_Aer where num_proc_hea = 'EACSR20080100101'


CREATE Procedure	[dbo].[spAPAYExport_Fatura_Rel]  --'01-01-2008'
(
	@Data datetime
)


As

select 
	'1058637' Codigo,left(processo_pc,2)+left(right(processo_PC,9),6) Fatura,
	Num_CPF_CNPJ,Num_Pedido,FAT.Processo_PC,GMID,PS.Qty,Nome_Usuario 


from fatura_chb FAT with(nolock)
Join Pessoa PP with(nolock) on PP.cd_pes=FAT.cd_pes_PC
Join Pedido_Ship PS with(nolock) on PS.num_proc=processo_pc
Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
Join De_Para_Produto DP with(nolock) on DP.GMID=PC.cd_proc_cliente
Join Usuario_Cliente US with(nolock) on US.cd_usuario=PO_Responsible



/**
	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_hea 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_Aer HOU
	inner Join Fatura_CHB		FCHB	on HOU.num_proc_hea = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS	on HOU.Cd_Export_hea = CONS.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_hea = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT	on HOU.Cd_Export_hea = PT.Cd_Pes
	Left Join Cta_Cte_Hou_Exp_Aer	CTA	on HOU.Num_Proc_hea = CTA.Num_Proc_hea and CTA.DC_HEA = 'D'
	where 
		convert(datetime,Dt_Emis_hea,105) > @Data and  CTA.Num_NF_HEA is null

Union All
	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_hem 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_MAR HOU
	inner Join Fatura_CHB		FCHB	on HOU.num_proc_hem = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS	on HOU.Cd_Export_hem = CONS.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_hem = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT	on HOU.Cd_Export_hem = PT.Cd_Pes 
	Join Nota_Cliente		NOTA	on HOU.num_proc_hem = NOTA.Num_Proc
	Left Join Cta_Cte_Hou_Exp_Mar	CTA	on HOU.Num_Proc_hem = CTA.Num_Proc_hem and CTA.DC_HEM = 'D'
	where 
		convert(datetime,Dt_Emis_hem,105) > @Data and CTA.Num_NF_HEM is null

Union All

	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_heo 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_OUT HOU
	inner Join Fatura_CHB		FCHB	on HOU.num_proc_heo = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS	on HOU.Cd_Export_heo = CONS.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_heo = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT	on HOU.Cd_Export_heo = PT.Cd_Pes 
	Join Nota_Cliente		NOTA	on HOU.num_proc_heo = NOTA.Num_Proc
	Left Join Cta_Cte_Hou_Exp_Out	CTA	on HOU.Num_Proc_heo = CTA.Num_Proc_heo and CTA.DC_HEO = 'D'
	where 
		convert(datetime,Dt_Emis_heo,105) > @Data and CTA.Num_NF_heo is null



**/






GO
