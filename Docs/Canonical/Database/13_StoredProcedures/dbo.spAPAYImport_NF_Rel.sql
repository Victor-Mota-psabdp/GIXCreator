SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure	[dbo].[spAPAYImport_NF_Rel]  --'01-01-2008'
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
		HOU.Num_Proc_HIA 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_Aer HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_hia = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS with(nolock)	on HOU.Cd_Consig_HIA = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIA = PT.Cd_Pes
	Join Cta_Cte_Hou_Imp_Aer	CTA with(nolock)	on HOU.Num_Proc_hia = CTA.Num_Proc_hia
	Join Base_Nota_Fiscal		NOTA with(nolock)	on CTA.num_NF_hia = NOTA.Nota_Fiscal and CTA.Ref_Acesso_NF_HIA=NOTA.Ref_Acesso

	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data 

Union All
	Select
		'1058637'		DESPACHANTE,
		NOTA.Nota_Fiscal	Nota_Fiscal,
		NOTA.Emissao		Emissao,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_HIM 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_MAR HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_him = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS with(nolock)	on HOU.Cd_Consig_HIM = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIM = PT.Cd_Pes 
	Join Nota_Cliente		NOTA with(nolock)	on HOU.num_proc_him = NOTA.Num_Proc
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data

Union All

	Select
		'1058637'		DESPACHANTE,
		NOTA.Nota_Fiscal	Nota_Fiscal,
		NOTA.Emissao		Emissao,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_HIO 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_OUT HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_hio = FCHB.Processo_PC
	Left Outer Join Pessoa		CONS with(nolock)	on HOU.Cd_Consig_HIO = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIO = PT.Cd_Pes 
	Join Cta_Cte_Hou_Imp_Out	CTA with(nolock)	on HOU.Num_Proc_hio = CTA.Num_Proc_hio
	Join Base_Nota_Fiscal		NOTA with(nolock)	on CTA.num_NF_hio = NOTA.Nota_Fiscal and CTA.Ref_Acesso_NF_HIO=NOTA.Ref_Acesso

	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data









GO
