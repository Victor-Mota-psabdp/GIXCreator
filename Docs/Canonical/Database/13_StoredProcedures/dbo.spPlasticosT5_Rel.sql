SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- spPlasticosT5_Rel '10-25-2007'

-- Inclusão do campo Planta 03/08/09 - Rafael

CREATE Procedure	[dbo].[spPlasticosT5_Rel] --'01/01/2009'
(
@Data datetime
)
As

	select 
		CONS.Nome_Raz_Soc						Cliente,
		LC.Nome_Local							Destino,
		CONS.Num_CPF_CNPJ						CGC,
		Null									lk17,
		Org.Nome_Local							Origem,
		Hou.Num_Proc_him						Processo,
		HOU.Navio_HIM							Navio,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)	Desembaraco,			
		Null									Produto,
		Num_PO									RefRepresentante,
		Paridade								TxDolar,		
		Incoterm								Incoterms,
		dbo.fPO_Imp(hou.num_proc_him,2)			Invoices,	
		NF.DI									DI,
		LLP.Canal_LIM							Canal,
		HOU.num_proc_him						Processo,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)	PresencaCarga,
		Null									DataDescarga,
		ETA_LIM									PrevisaoChegada,
		ATA_LIM									DataChegada,
		NF.Nota_Fiscal							NInicial,
		Null									NFinal,
		0										CIFUSD,
		Null									RefImportador,
		dbo.FBusca_FOB(hou.num_proc_him,'I')/Isnull(Paridade,1)		FobUSD,
		Vlr_Frete_efet_him			FreteUSD,
		dbo.FBusca_FOB(hou.num_proc_him,'S')/Isnull(Paridade,1)		SeguroUSD,
		P.Planta
			
	from
		House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar		LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Job_Imp_Mar		JIM with(nolock)	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Left Outer Join container_hou_Imp_mar	CO with(nolock)	on HOU.Num_Proc_HIM = CO.Num_Proc_HIM
	Left Outer Join Nota_Cliente 	NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc
	Left Outer Join Armador		ARM with(nolock)	on JIM.Cd_Armador   = ARM.Cd_Armador
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido			P with(nolock)	on PS.Cd_Pedido	    = P.Cd_Pedido
	Join Pedido_Det			PD with(nolock) 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Localidade	LC with(nolock)	on HOU.Cd_Dst_HIM   = Lc.Cd_Local
	Left Outer Join Localidade	Org with(nolock)	on Org.cd_local=cd_org_him
	Join Pessoa			CONS with(nolock)	on HOU.Cd_Consig_HIM= CONS.Cd_Pes
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto    =PC.Cd_Prod
	Left Outer Join De_Para_Produto DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join PO_HIM		PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data 
		--and PD.PO_GRP IN ('041')
		and (P.Planta IN ('05031WQ','05031WJ'))



















GO
