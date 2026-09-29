SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--select * from base_nota_fiscal  
--select * from Cta_Cte_hou_exp_out where num_proc_hea like 'EACSR%'
CREATE	Procedure	spAPAYExport_NF_Rel -- '01-01-2008'
(
	@Data datetime
)
As
	Select
		'1058637'		DESPACHANTE,
		NOTA.Nota_Fiscal	Nota_Fiscal,
		NOTA.Emissao		Emissao,
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
	Join Cta_Cte_Hou_Exp_Aer	CTA	on HOU.Num_Proc_hea = CTA.Num_Proc_hea
	Join Base_Nota_Fiscal		NOTA	on CTA.num_NF_hea = NOTA.Nota_Fiscal and CTA.Ref_Acesso_NF_HEA=NOTA.Ref_Acesso

	where
		convert(datetime,Dt_Emis_hea,105) > @Data

Union All
	Select
		'1058637'		DESPACHANTE,
		NOTA.Nota_Fiscal	Nota_Fiscal,
		NOTA.Emissao		Emissao,
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
		House_Exp_Mar HOU
	inner Join Fatura_CHB		FCHB	on HOU.num_proc_hem = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS	on HOU.Cd_Export_hem = CONS.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_hem = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT	on HOU.Cd_Export_hem = PT.Cd_Pes
	Join Cta_Cte_Hou_Exp_Mar	CTA	on HOU.Num_Proc_hem = CTA.Num_Proc_hem
	Join Base_Nota_Fiscal		NOTA	on CTA.num_NF_hem = NOTA.Nota_Fiscal and CTA.Ref_Acesso_NF_HEM=NOTA.Ref_Acesso

	where
		convert(datetime,Dt_Emis_hem,105) > @Data

Union All
	Select
		'1058637'		DESPACHANTE,
		NOTA.Nota_Fiscal	Nota_Fiscal,
		NOTA.Emissao		Emissao,
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
		House_Exp_Out HOU
	inner Join Fatura_CHB		FCHB	on HOU.num_proc_heo = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS	on HOU.Cd_Export_heo = CONS.Cd_Pes
	Join Pedido_Ship 		PS	on HOU.Num_Proc_heo = PS.Num_Proc
	Join Pedido_Det			PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT	on HOU.Cd_Export_heo = PT.Cd_Pes
	Join Cta_Cte_Hou_Exp_Out	CTA	on HOU.Num_Proc_heo = CTA.Num_Proc_heo
	Join Base_Nota_Fiscal		NOTA	on CTA.num_NF_heo = NOTA.Nota_Fiscal and CTA.Ref_Acesso_NF_HEO=NOTA.Ref_Acesso

	where
		convert(datetime,Dt_Emis_heo,105) > @Data















GO
