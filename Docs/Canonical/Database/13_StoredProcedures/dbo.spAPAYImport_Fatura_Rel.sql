SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from fatura_chb where processo_pc like 'IaCSR200801009%'
select * from Cta_Cte_Hou_Imp_Aer where num_proc_hia like 'IaCSR20080100901'

IACSR20080100201
IACSR20080100401
IACSR20080100701
IACSR20080100901
*/

CREATE           Procedure	[dbo].[spAPAYImport_Fatura_Rel] -- '01-01-2008'
(
	@Data datetime
)
As
	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_HIA 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_Aer HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_hia = FCHB.Processo_PC
	Join Pessoa			CONS with(nolock)	on HOU.Cd_Consig_HIA = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIA = PT.Cd_Pes
	left Join Cta_Cte_Hou_Imp_Aer	CTA with(nolock)	on HOU.Num_Proc_hia = CTA.Num_Proc_hia and CTA.DC_HIA = 'D'
	where
		convert(datetime,Dt_Emis_HIA,105) > @Data and CTA.Num_NF_HIA is null
	Group by
		FCHB.Fatura_PC,
		FCHB.Data_PC,
		CONS.Num_CPF_CNPJ,
		HOU.Num_Proc_HIA ,
		PT.Planta_Nome,
		P.Num_Pedido,
		P.PO_Responsible,
		PS.Cd_Produto,
		PS.Cd_Pedido

Union All
	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_HIM 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_MAR HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_him = FCHB.Processo_PC
	Join Pessoa			CONS with(nolock)	on HOU.Cd_Consig_HIM = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP	 with(nolock) on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIM = PT.Cd_Pes 
--	Join Nota_Cliente		NOTA	on HOU.num_proc_him = NOTA.Num_Proc
	Left Join Cta_Cte_Hou_Imp_Mar	CTA with(nolock)	on HOU.Num_Proc_him = CTA.Num_Proc_him and CTA.DC_HIM = 'D'
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data and CTA.Num_NF_HIM is null
	Group by
		FCHB.Fatura_PC,
		FCHB.Data_PC,
		CONS.Num_CPF_CNPJ,
		HOU.Num_Proc_HIM ,
		PT.Planta_Nome,
		P.Num_Pedido,
		P.PO_Responsible,
		PS.Cd_Produto,
		PS.Cd_Pedido

Union All

	Select
		'1058637'		DESPACHANTE,
		FCHB.Fatura_PC		Fatura,
		FCHB.Data_PC		Data_Fatura,
		CONS.Num_CPF_CNPJ	CNPJ,
--		P.Num_Pedido		Ref_Cliente,
		HOU.Num_Proc_HIO 	Ref_BDP,
		PT.Planta_Nome		Planta,
		P.Num_Pedido		Pedido_SAP,
--		NOTA.Nota_Fiscal	NFE,
		P.PO_Responsible	Especialista,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_IMP_OUT HOU with(nolock)
	inner Join Fatura_CHB		FCHB with(nolock)	on HOU.num_proc_hio = FCHB.Processo_PC
	Join Pessoa			CONS with(nolock)	on HOU.Cd_Consig_HIO = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det			PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP	PT with(nolock)	on HOU.Cd_Consig_HIO = PT.Cd_Pes 
--	Join Nota_Cliente		NOTA	on HOU.num_proc_hio = NOTA.Num_Proc
	Left Join Cta_Cte_Hou_Imp_Out	CTA with(nolock)	on HOU.Num_Proc_hio = CTA.Num_Proc_hio and CTA.DC_HIO = 'D'
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data and CTA.Num_NF_HIO is null
	Group by
		FCHB.Fatura_PC,
		FCHB.Data_PC,
		CONS.Num_CPF_CNPJ,
		HOU.Num_Proc_HIO ,
		PT.Planta_Nome,
		P.Num_Pedido,
		P.PO_Responsible,
		PS.Cd_Produto,
		PS.Cd_Pedido








GO
