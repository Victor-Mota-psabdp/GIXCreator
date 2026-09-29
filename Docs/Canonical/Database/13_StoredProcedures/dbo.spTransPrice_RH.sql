SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tipo_taxa where nome_tp_tx like 'sda%'
--select * from custo_cliente where cd_tp_tx= 'XAI' and substring(num_proc,3,3) in ('SLA')

--select dbo.fTransfPriceCusto('IMSLA201210034BR',53518,'SDA')
--select * from Pedido_Ship where num_proc = 'IMSLA201210034BR'
--select * from custo_cliente where num_proc = 'IMSLA201210034BR' and cd_tp_tx= 'XAI'
--select * from tipo_taxa where cd_tp_tx= 'XAI'
--select * from tipo_taxa where cd_tp_tx = 'THC'
--
--select * from tipo_taxa where nome_tp_tx like 'sda%'
--update tipo_taxa 
--set codigotp = 'SDA'
--where nome_tp_tx like 'sda%'

--[spTransPrice_RH]'2012-01-01','2012-01-31'

CREATE  Procedure [dbo].[spTransPrice_RH]-- '2012-02-01','2012-07-31'
	@DataInicial	Datetime,
	@DataFinal		Datetime

as


--	Declare @DataInicial	Datetime
--	Declare @DataFinal		Datetime
--
--	Set @DataInicial='2012-01-03'
--	Set @DataFinal='2012-01-31'

--DELETE TransPrice_RH_2012
--select * from TransPrice_RH_2012_JAN where fvlr_sda <> 0 order by 9
insert TransPrice_RH_2012_JAN
	Select
		PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta) Planta, cd_proc_Cliente GMID, Produto_Descr,
--		PP.Nome_Raz_Soc Cia,
		P.Nome_Raz_Soc Cia,
		Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		ATD_LIM ATD, TF.Dt_Conclusao Desemb, 'Maritimo' Modal,
		Upper(Navio_HIM) Navio, Org.Nome_Local Origem,Nome_tp_carga  cd_tp_carga, dbo.fBusca_HistoricoDescr(LLP.Num_proc_LIM, 0,getdate()) Hist,
		NCD.ALIQ_II, 
		NCD.ALIQ_IPI,
		NCD.ALIQ_ICMS,
		(case when isnull(Paridade,0) = 0 then PAR.campo_dados else Paridade end) Paridade,
		Payment, dst.Nome_Local, PS.cd_produto,
		Peso_bruto_him Peso_house,dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'III') fVLR_II,dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'AFR') fVLR_AFR,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'THC') fVLR_THC,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'TUP') fVLR_TUP,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'LII') fVLR_LII,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'IPI') fVLR_IPI,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'ICM') fVLR_ICMS,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'TRA') fVLR_TRA,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'SIS') fVLR_SIS,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'DEM') fVLR_DEM,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'WHS') fVLR_WHS,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'BRO') fVLR_BRO,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'PIS') fVLR_PIS,
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'CFN') fVLR_CFN,Numero_PO_HIM DI,
		(case when num_proc_mim = 'JOB' then Null else num_proc_mim end) [Consolidada],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'Quantidade')	[SumOfvl_quantidade__36],	
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'FOB-Frete')[vl_fob_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'Frete')[vl_frete_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'FOB') [vl_cfr_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'Base_ICMS') [vl_icms_base__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'qtyNF')[NFs],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIM,'PO')[nu_purchase__35],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIM,'Pedido')[nu_ordem__35],
		dbo.fbusca_docs_po_modal(Num_Proc_LIM,'2')[dc_nu_fatura__35],	
		dbo.fbusca_docs_po_modal(Num_Proc_LIM,'10')	[dc_nu_nf__35],
		dbo.fTransfPriceCusto(Num_Proc_LIM,PS.cd_Produto,'SDA') fVLR_SDA,
--		PP.num_cpf_cnpj CIA_CNPJ,
		P.num_cpf_cnpj CIA_CNPJ,
		dbo.fbusca_docs_po_modal(Num_Proc_LIM,'10') NFE,
		dbo.fbusca_DATA_po_modal(Num_Proc_LIM,'10') NFE_DATE,
		NC.CFOP CFOP,
		HOU.cd_tp_oper Incoterm,
		NCD.NCM NCM,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'Seguro') Seguro,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIM,cd_proc_Cliente,'Acrescimo') Acrescimos,
		DATA_PO_HIM DI_DATE,
		0
--		IT.LI_PERIODICIDADE					
	From
		Pedido_Ship PS With(nolock)
		Join Pedido							PD With(nolock) on  PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP With(nolock) on  cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC With(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL With(nolock) on SL.cd_pes=cd_seller
		Join Nota_Cliente					NC With(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Join Nota_Fiscal_Cliente_Det		NCD With(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_Mar					LLP With(nolock) on num_proc_lim=ps.num_proc
		Join House_Imp_Mar					HOU With(nolock) on hou.num_proc_him=ps.num_proc
		Join Pessoa							P With(nolock) on  cd_consig_him=pp.cd_pes
		Join Tarefas_Processos				TF	With(nolock) on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org With(nolock) on Org.cd_local=cd_org_him
		Join Localidade						Dst With(nolock) on dst.cd_local=cd_dst_him
		LEFT Join Pessoa_LLP				PLA	With(nolock) on PLA.cd_pes=cd_consig_him
		LEFT Join PessoA_LLP				SLP With(nolock) on SLP.cd_pes=cd_seller
		Join Tipo_Carga						TC With(nolock) on TC.cd_Tp_carga=LLP.cd_tp_carga
		Left Join PO_HIM					DI With(nolock) on DI.num_proc_him=num_proc_lim and ID_DC=5
		left join campo_processo			PAR with(nolock) on PAR.num_proc=PS.num_proc and id_campo=31
--		left join di_item_br				IT with(nolock) on IT.num_proc = PS.num_proc and PS.cd_produto = IT.cd_produto
	Where
--		ps.num_proc like 'IMCSR20100904701%'
		TF.Dt_Conclusao between @DataInicial and @DataFinal
		and numero_po_him <> 'Courier' 
		and substring(ps.num_proc,3,3) in ('STB','CSR','ROB')
--		and substring(ps.num_proc,3,3) in ('SLA')
		AND ISNULL(LLP.ID_STATUS,0) <> 9

union all

	Select --distinct
		PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta), cd_proc_Cliente GMID, Produto_Descr,
--		PP.Nome_Raz_Soc Cia,
		P.Nome_Raz_Soc Cia,	
		Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		ATD_lio ATD, TF.Dt_Conclusao Desemb, 'Others' Modal,
		'N/A' Navio, Org.Nome_Local Origem,tipo_lio, dbo.fBusca_HistoricoDescr(LLP.Num_proc_lio, 0,getdate()) Hist,
		NCD.ALIQ_II, 
		NCD.ALIQ_IPI,
		NCD.ALIQ_ICMS, (case when isnull(Paridade,0) = 0 then PAR.campo_dados else Paridade end) Paridade,
		Payment, dst.Nome_Local, PS.cd_produto,
		peso_bruto_hio Peso_house, dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'III') fVLR_II,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'AFR') fVLR_AFR,
		dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'THC') fVLR_THC,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'TUP') fVLR_TUP,
		dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'LII') fVLR_LII,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'IPI') fVLR_IPI,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'ICM') fVLR_ICMS,
		dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'TRA') fVLR_TRA,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'SIS') fVLR_SIS,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'DEM') fVLR_DEM,
		dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'WHS') fVLR_WHS,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'BRO') fVLR_BRO,dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'PIS') fVLR_PIS,
		dbo.fTransfPriceCusto(Num_Proc_lio,PS.cd_Produto,'CFN') fVLR_CFN,Numero_PO_HIo DI,
		Null [Consolidada],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'Quantidade')	[SumOfvl_quantidade__36],	
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'FOB-Frete')[vl_fob_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'Frete')[vl_frete_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'FOB') [vl_cfr_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'Base_ICMS') [vl_icms_base__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'qtyNF')[NFs],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIO,'PO')[nu_purchase__35],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIO,'Pedido')[nu_ordem__35],
		dbo.fbusca_docs_po_modal(Num_Proc_LIO,'2')[dc_nu_fatura__35],	
		dbo.fbusca_docs_po_modal(Num_Proc_LIO,'10')	[dc_nu_nf__35],
		dbo.fTransfPriceCusto(Num_Proc_LIO,PS.cd_Produto,'SDA') fVLR_SDA,
--		PP.num_cpf_cnpj CIA_CNPJ,
		P.num_cpf_cnpj CIA_CNPJ,
		dbo.fbusca_docs_po_modal(Num_Proc_LIO,'10') NFE,
		dbo.fbusca_DATA_po_modal(Num_Proc_LIO,'10') NFE_DATE,
		NC.CFOP CFOP,
		HOU.cd_tp_oper Incoterm,
		NCD.NCM NCM,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'Seguro') Seguro,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIO,cd_proc_Cliente,'Acrescimo') Acrescimos,
		DATA_PO_HIO DI_DATE,
		0
--		IT.LI_PERIODICIDADE	
	From
		Pedido_Ship PS
		Join Pedido							PD With(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP  With(nolock) on cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC With(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL  With(nolock) on SL.cd_pes=cd_seller
		Join Nota_Cliente				NC  With(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Join Nota_Fiscal_Cliente_Det	NCD  With(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_out					LLP With(nolock) on num_proc_lio=ps.num_proc
		Join House_Imp_out					HOU  With(nolock) on hou.num_proc_hio=ps.num_proc
		Join Pessoa							P With(nolock) on  cd_consig_hio=pp.cd_pes
		Join Tarefas_Processos				TF	With(nolock) on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org With(nolock) on Org.cd_local=cd_org_hio
		Join Localidade						Dst With(nolock) on dst.cd_local=cd_dst_hio
		Join Pessoa_LLP						PLA	With(nolock) on PLA.cd_pes=cd_consig_hio
		Join PessoA_LLP						SLP With(nolock) on SLP.cd_pes=cd_seller
		Left Join PO_HIO					DI With(nolock) on DI.num_proc_hio=num_proc_lio and ID_DC=5
		left join campo_processo			PAR with(nolock) on PAR.num_proc=PS.num_proc and id_campo=31
--		left join di_item_br				IT with(nolock) on IT.num_proc = PS.num_proc and PS.cd_produto = IT.cd_produto
	Where
		--and ps.num_proc like 'IOROB%'
		TF.Dt_Conclusao between @DataInicial and @DataFinal
		and numero_po_hio <> 'Courier' 
		and substring(ps.num_proc,3,3) in ('STB','CSR','ROB')
--		and substring(ps.num_proc,3,3) in ('SLA')
		AND ISNULL(LLP.ID_STATUS,0) <> 9

union all

	Select --distinct
		PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta) , cd_proc_Cliente GMID, Produto_Descr,
--		PP.Nome_Raz_Soc Cia,
		P.Nome_Raz_Soc Cia,
		Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		ATD_lia ATD, TF.Dt_Conclusao Desemb, 'Aéreo' Modal,
		Upper(voo_hia) Navio, Org.Nome_Local Origem,cast('Aereo' as varchar(10)), dbo.fBusca_HistoricoDescr(LLP.Num_proc_lia, 0,getdate()) Hist,
		NCD.ALIQ_II, 
		NCD.ALIQ_IPI,
		NCD.ALIQ_ICMS, (case when isnull(Paridade,0) = 0 then PAR.campo_dados else Paridade end) Paridade,
		Payment, dst.Nome_Local, PS.cd_produto,
		Peso_bruto_hia, dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'III') fVLR_II,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'AFR') fVLR_AFR,
		dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'THC') fVLR_THC,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'TUP') fVLR_TUP,
		dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'LII') fVLR_LII,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'IPI') fVLR_IPI,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'ICM') fVLR_ICMS,
		dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'TRA') fVLR_TRA,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'SIS') fVLR_SIS,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'DEM') fVLR_DEM,
		dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'WHS') fVLR_WHS,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'BRO') fVLR_BRO,dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'PIS') fVLR_PIS,
		dbo.fTransfPriceCusto(Num_Proc_lia,PS.cd_Produto,'CFN') fVLR_CFN,Numero_PO_HIA DI,
		(case when num_proc_mia = 'JOB' then Null else num_proc_mia end) [Consolidada],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'Quantidade')	[SumOfvl_quantidade__36],	
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'FOB-Frete')[vl_fob_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'Frete')[vl_frete_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'FOB') [vl_cfr_me__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'Base_ICMS') [vl_icms_base__36],
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'qtyNF')[NFs],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIA,'PO')[nu_purchase__35],
		[dbo].[fBusca_PO_NumPedido](Num_Proc_LIA,'Pedido')[nu_ordem__35],
		dbo.fbusca_docs_po_modal(Num_Proc_LIA,'2')[dc_nu_fatura__35],	
		dbo.fbusca_docs_po_modal(Num_Proc_LIA,'10')	[dc_nu_nf__35],
		dbo.fTransfPriceCusto(Num_Proc_LIA,PS.cd_Produto,'SDA') fVLR_SDA,
--		PP.num_cpf_cnpj CIA_CNPJ,
		P.num_cpf_cnpj CIA_CNPJ,
		dbo.fbusca_docs_po_modal(Num_Proc_LIA,'10') NFE,
		dbo.fbusca_DATA_po_modal(Num_Proc_LIA,'10') NFE_DATE,
		NC.CFOP CFOP,
		HOU.cd_tp_oper Incoterm,
		NCD.NCM NCM,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'Seguro') Seguro,
		[dbo].[fBusca_TransPriceNFTotal](Num_Proc_LIA,cd_proc_Cliente,'Acrescimo') Acrescimos,
		DATA_PO_HIA DI_DATE,
		0
--		IT.LI_PERIODICIDADE	
	From
		Pedido_Ship PS
		Join Pedido							PD With(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP With(nolock) on cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC With(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL With(nolock) on SL.cd_pes=cd_seller
		Join PessoA_LLP						SLP With(nolock) on SLP.cd_pes=cd_seller
		Join Nota_Cliente					NC With(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Join Nota_Fiscal_Cliente_Det		NCD With(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_aer					LLP With(nolock) on num_proc_lia=ps.num_proc
		Join House_Imp_aer					HOU With(nolock) on hou.num_proc_hia=ps.num_proc
		Join Pessoa							P With(nolock) on  cd_consig_hia=pp.cd_pes
		Join Tarefas_Processos				TF	With(nolock) on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org With(nolock) on Org.cd_local=cd_org_hia
		Join Localidade						Dst With(nolock) on dst.cd_local=cd_dst_hia
		Join Pessoa_LLP						PLA	With(nolock) on PLA.cd_pes=cd_consig_hia
		Left Join PO_HIa					DI With(nolock) on DI.num_proc_hia=num_proc_lia and ID_DC=5
		left join campo_processo			PAR with(nolock) on PAR.num_proc=PS.num_proc and id_campo=31
--		left join di_item_br				IT with(nolock) on IT.num_proc = PS.num_proc and PS.cd_produto = IT.cd_produto
	Where
		--and ps.num_proc like 'IAROB%'
		TF.Dt_Conclusao between @DataInicial and @DataFinal
		and numero_po_hia <>'Courier' 
		and substring(ps.num_proc,3,3) in ('STB','CSR','ROB')
--		and substring(ps.num_proc,3,3) in ('SLA')
		AND ISNULL(LLP.ID_STATUS,0) <> 9



/* novos campos pra marcia

--- CNPJ do importador - cnpj do buyer

update TransPrice_RH_2012
	set
		CIA_CNPJ=PP.num_cpf_cnpj
	from TransPrice_RH_2012_teste TS
		join pedido_ship		PS	with(nolock) on PS.num_proc = TS.JOB
		Join Pedido	PD with(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa	PP with(nolock) on cd_buyer=pp.cd_pes
alter table TransPrice_RH_2012 add CIA_CNPJ varchar(15)
--mudou o esquema pra pegar o consignee e o cnpj do consignee do house
update TransPrice_RH_2012
	set cia = P.Nome_Raz_Soc,
		CIA_CNPJ=P.num_cpf_cnpj
	from TransPrice_RH_2012 TS
	join house_imp_out HOU with(nolock) on HOU.num_proc_hio = TS.JOB
	join pessoa P on P.cd_pes = HOU.cd_consig_hio
update TransPrice_RH_2012
	set cia = P.Nome_Raz_Soc,
		CIA_CNPJ=P.num_cpf_cnpj
	from TransPrice_RH_2012 TS
	join house_imp_aer HOU with(nolock) on HOU.num_proc_hia = TS.JOB
	join pessoa P on P.cd_pes = HOU.cd_consig_hia
update TransPrice_RH_2012
	set cia = P.Nome_Raz_Soc,
		CIA_CNPJ=P.num_cpf_cnpj
	from TransPrice_RH_2012 TS
	join house_imp_mar HOU with(nolock) on HOU.num_proc_him = TS.JOB
	join pessoa P on P.cd_pes = HOU.cd_consig_him

- Nr da Nota fiscal de entrada (NFE) - po_him 10
- Data da NFE - função
update TransPrice_RH_2012
	set
		NFE = dbo.fbusca_docs_po_modal(job,'10'),
		NFE_DATE = dbo.fbusca_DATA_po_modal(job,'10')
	from TransPrice_RH_2012

alter table TransPrice_RH_2012 add NFE varchar(200)
alter table TransPrice_RH_2012 add NFE_Date datetime

--- CFOP - nota_fiscal_cliente_det
update TransPrice_RH_2012
	set
		CFOP=NC.CFOP
	from TransPrice_RH_2012 TS
		join nota_cliente NC on NC.num_proc = TS.job
alter table TransPrice_RH_2012 add CFOP varchar(10)

 --Incoterm - job referencia
update TransPrice_RH_2012
	set
		Incoterm = HI.cd_tp_oper
	from TransPrice_RH_2012 TS
	join house_imp_mar HI with(nolock) on HI.num_proc_him = TS.JOB
	join house_imp_aer HI with(nolock) on HI.num_proc_hia = TS.JOB	
	join house_imp_out HI with(nolock) on HI.num_proc_hio = TS.JOB
alter table TransPrice_RH_2012 add Incoterm varchar(3)

-- NCM - nota fiscal
update TransPrice_RH_2012
	set
		NCM=NCD.NCM
	from TransPrice_RH_2012 TS
		join pedido_ship	PS	with(nolock) on PS.num_proc = TS.JOB
		Join Nota_Cliente	NC With(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Join Nota_Fiscal_Cliente_Det	NCD With(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto

alter table TransPrice_RH_2012 add NCM varchar(20)

--- Vlr do Seguro - custos
--Valor das despesas aduaneiras que integram a base de cálculo do ICMS - acresimos no nota cliente
alter table TransPrice_RH_2012 add Acrescimos float
alter table TransPrice_RH_2012 add Seguro float

update TransPrice_RH_2012
	set
		Seguro = [dbo].[fBusca_TransPriceNFTotal](Num_Proc,cd_proc_Cliente,'Seguro'),
		Acrescimos = [dbo].[fBusca_TransPriceNFTotal](Num_Proc,cd_proc_Cliente,'Acrescimo')
	from 
	TransPrice_RH_2012
	join pedido_ship PS	with(nolock) on PS.num_proc = TS.JOB
	Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto


- Numero da adição - nao temos
- Numero sequencial do item dentro da adição - não temos
- Valor do desconto do item da DI adição - nao tem
- Valor das despesas aduaneiras que não integram a base de cálculo do ICMS - nao tem
- Valor do Imposto sobre Operações Financeiras - nao tem(iof)
*/



GO
