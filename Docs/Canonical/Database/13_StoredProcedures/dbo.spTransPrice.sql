SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spTransPrice]

as
Select
		distinct PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta) Planta, cd_proc_Cliente GMID, Produto_Descr,
		PP.Nome_Raz_Soc Cia,Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		Peso_Bruto Quantidade,ATD_LIM ATD, TF.Dt_Conclusao Desemb, 'Maritimo' Modal,
		Upper(Navio_HIM) Navio, Org.Nome_Local Origem,Nome_tp_carga  cd_tp_carga, dbo.fBusca_HistoricoDescr(LLP.Num_proc_LIM, 0,getdate()) Hist,
		ALIQ_II, ALIQ_IPI,ALIQ_ICMS, Paridade,Payment, dst.Nome_Local, PS.cd_produto,
		Peso_bruto_him Peso_house

From
		Pedido_Ship PS with(nolock)
		Join Pedido							PD with(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP with(nolock) on cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC with(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL with(nolock) on SL.cd_pes=cd_seller
		Left Join Nota_Cliente				NC with(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Left Join Nota_Fiscal_Cliente_Det	NCD with(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_Mar					LLP with(nolock) on num_proc_lim=ps.num_proc
		Join House_Imp_Mar					HOU with(nolock) on hou.num_proc_him=ps.num_proc
		Join Tarefas_Processos				TF with(nolock)	on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org with(nolock) on Org.cd_local=cd_org_him
		Join Localidade						Dst with(nolock) on dst.cd_local=cd_dst_him
		LEFT Join Pessoa_LLP						PLA with(nolock)	on PLA.cd_pes=cd_consig_him
		LEFT Join PessoA_LLP						SLP with(nolock) on SLP.cd_pes=cd_seller
		Join Tipo_Carga						TC with(nolock) on TC.cd_Tp_carga=LLP.cd_tp_carga
		Left Join PO_HIM					DI with(nolock) on DI.num_proc_him=num_proc_lim and ID_DC=5

Where
		TF.Dt_conclusao is not null and ps.num_proc like 'IMROB%'
		and TF.dt_conclusao >='01-01-2010'
		and numero_po_him not like 'Courier' 

union all

Select
		distinct PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta), cd_proc_Cliente GMID, Produto_Descr,
		PP.Nome_Raz_Soc Cia,Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		Peso_Bruto Quantidade,ATD_lio ATD, TF.Dt_Conclusao Desemb, 'Others' Modal,
		'N/A' Navio, Org.Nome_Local Origem,tipo_lio, dbo.fBusca_HistoricoDescr(LLP.Num_proc_lio, 0,getdate()) Hist,
		ALIQ_II, ALIQ_IPI,ALIQ_ICMS, Paridade,Payment, dst.Nome_Local, PS.cd_produto,
		peso_bruto_hio Peso_house
From
		Pedido_Ship PS with(nolock)
		Join Pedido							PD with(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP with(nolock) on cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC with(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL with(nolock) on SL.cd_pes=cd_seller
		Left Join Nota_Cliente				NC with(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Left Join Nota_Fiscal_Cliente_Det	NCD with(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_out					LLP with(nolock) on num_proc_lio=ps.num_proc
		Join House_Imp_out					HOU with(nolock) on hou.num_proc_hio=ps.num_proc
		Join Tarefas_Processos				TF with(nolock)	on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org with(nolock) on Org.cd_local=cd_org_hio
		Join Localidade						Dst with(nolock) on dst.cd_local=cd_dst_hio
		Join Pessoa_LLP						PLA with(nolock)	on PLA.cd_pes=cd_consig_hio
		Join PessoA_LLP						SLP with(nolock) on SLP.cd_pes=cd_seller

Where
		TF.Dt_conclusao is not null and ps.num_proc like 'IOROB%'
		and TF.dt_conclusao >='01-01-2010'

union all

Select
		distinct PS.Num_Proc Job, Isnull(PD.Planta,PLA.cd_planta) , cd_proc_Cliente GMID, Produto_Descr,
		PP.Nome_Raz_Soc Cia,Isnull(PD.Cd_Vendor,SLP.cd_vendor) Vendor,SL.nome_raz_Soc Seller,
		Peso_Bruto Quantidade,ATD_lia ATD, TF.Dt_Conclusao Desemb, 'Aéreo' Modal,
		Upper(voo_hia) Navio, Org.Nome_Local Origem,cast('Aereo' as varchar(10)), dbo.fBusca_HistoricoDescr(LLP.Num_proc_lia, 0,getdate()) Hist,
		ALIQ_II, ALIQ_IPI,ALIQ_ICMS, Paridade,Payment, dst.Nome_Local, PS.cd_produto,
		Peso_bruto_hia

From 
		Pedido_Ship PS with(nolock)
		Join Pedido							PD with(nolock) on PD.cd_pedido=PS.cd_Pedido
		Join Pessoa							PP with(nolock) on cd_buyer=pp.cd_pes
		Join Produto_Cliente				PC with(nolock) on PC.cd_prod=PS.cd_produto
		Join Pessoa							SL with(nolock) on SL.cd_pes=cd_seller
		Join PessoA_LLP						SLP with(nolock) on SLP.cd_pes=cd_seller
		Left Join Nota_Cliente				NC with(nolock) on NC.num_proc=PS.num_proc and nota_fiscal <> '1'
		Left Join Nota_Fiscal_Cliente_Det	NCD with(nolock) on NCD.Id_NF=NC.ID_NF and NC.cd_cliente=NCD.cd_cliente and PS.cd_produto=NCD.cd_produto 
		Join LLP_Imp_aer					LLP with(nolock) on num_proc_lia=ps.num_proc
		Join House_Imp_aer					HOU with(nolock) on hou.num_proc_hia=ps.num_proc
		Join Tarefas_Processos				TF with(nolock)	on TF.num_proc=PS.num_proc and Tf.id_task=4	
		Join Localidade						Org with(nolock) on Org.cd_local=cd_org_hia
		Join Localidade						Dst with(nolock) on dst.cd_local=cd_dst_hia
		Join Pessoa_LLP						PLA with(nolock) on PLA.cd_pes=cd_consig_hia
		Left Join PO_HIa					DI with(nolock) on DI.num_proc_hia=num_proc_lia and ID_DC=5

Where
		TF.Dt_conclusao is not null and ps.num_proc like 'IAROB%'
		and TF.dt_conclusao >='01-01-2010'
		and numero_po_hia not like 'Courier'





















GO
