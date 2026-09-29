SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPrecoTransferencia_Rel]

as
select 
	DISTINCT LLP.Num_Proc_LIM JOB, 
	'00'+ right(Left(Planta,5),2) cd_rfgl__41, 
	right(Left(Planta,5),2) cd_rf__41, 
	OCN.Nome_Raz_Soc no_companhia__41, 
	Num_PO nu_purchase__35, 
	PC.Cd_proc_Cliente cd_gmid__52, 
	PC.Produto_Descr dc_produto__52,
	PC.Produto_Descr dc_nome_cml__52, 
	VD.cd_Vendor cd_dow__6, 
	EXPO.Nome_Raz_Soc dc_fornecedor__6, 	
	Isnull(NCD.peso_bruto,0) SumOfvl_quantidade__36,
	'KG'dc_unidade__34, 
	DI.Numero_PO_HIM nu_di__35, 
	LLP.ATD_lim dt_embarque__35,
	TP.Dt_Conclusao dt_desemb__35,
	'MARITIMO'dc_via_transporte__47, 
	HOU.Navio_him no_navio__35,
	ORG.Nome_local no_porto_origem__8,
	CASE LLP.Cd_Tp_carga when 3 then 'Vessel-BULK' ELSE 'Vessel-Container' END no_modal_transp__48,
	dbo.fBusca_HistoricoDescr(LLP.Num_proc_LIM, 0,getdate()) dc_obs_processo__35,
	'TAX' no_local_arquivo__44,
	'TAX' nu_caixa_arquivo__35,
	P.Num_pedido nu_ordem__35,
	Isnull(PD.Vlr_total_Item,NCD.Vlr_Total_ITEM)  vl_fob_me__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'FRETE%') vl_frete_me__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'AFRMM%') vl_afrmm__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'THC%') vl_capatazia__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'TUP%') vl_tup__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'LI - CHB%') + dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'LICENÇA DE IMPORTAÇÃO%') vl_li__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'Direitos Antidumping%')+ dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, '%multa%') vl_outras__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'CPMF%') vl_cpmf__36,
	isnull(NCD.Aliq_II,0) vl_aliq_ii__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'Imposto de IMP%') vl_ii__36,
	isnull(NCD.aliq_IPI,0) vl_aliq_ipi__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'IPI%') vl_ipi__36,
	isnull(NCD.Vl_base_icms,0) vl_icms_base__36,
	isnull(NCD.aliq_Icms,0) vl_aliq_icms__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'ICMS%') vl_icms__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'movimen%') vl_tra_1__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, '%Siscomex%') vl_siscomex__36,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, '%Despacho%') + dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'Tracking and Trace%') + dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'Order Entry%') vl_dpc_servico__36, 
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto, 'ARMAZENAGEM%') + dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'demurrage%') vl_dpc_acessorias__36,
	isnull(NC.Paridade,0) vl_taxa_moeda__35,
	'BDP South America LTDA' no_despachante__46,
	P.Payment cd_dow__30,
	NF.Data_PO_him dc_dt_nf__35,
	'DD' cd_tipo_ordem_imp__35,
	INV.Numero_PO_Him dc_nu_fatura__35,
	NF.Numero_PO_Him dc_nu_nf__35,
	right(Left(Planta,7),2) cd_dow__29,
	PL.Planta_Nome dc_planta__29,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'PIS%') vl_PIS,
	dbo.fBusca_Custo(LLP.Num_proc_Lim, PS.Cd_pedido, PS.Cd_produto,'Cofins%') vl_COFINS
	--Port_Dest.Nome_local Destino
from 
	LLP_IMP_MAR LLP
	Join Pedido_Ship PS on LLP.Num_Proc_LIM = PS.Num_Proc 
	Left Outer Join Pedido P on PS.Cd_Pedido = P.Cd_Pedido 
	LEft Outer Join Pedido_Det PD on PS.cd_pedido = PD.cd_pedido and PS.cd_produto = PD.Cd_produto and PS.Item = PD.Item --and PS.Lote = PD.Lote  
	Left Outer Join Pessoa OCN on P.Cd_Buyer = OCN.Cd_Pes
	--Left Outer Join PO_HIM PO on LLP.Num_proc_Lim = PO.Num_Proc_Him and PO.ID_DC = 1
	Left Outer Join Produto_Cliente PC on PS.cd_produto = PC.Cd_prod and cd_cliente = '1'
	Left Outer Join Pessoa_LLP VD on P.cd_Seller = VD.Cd_pes
	Left Outer Join House_imp_mar HOU on LLP.Num_proc_lim = HOU.Num_proc_him  
	Left Outer Join Pessoa EXPO on HOU.Cd_Export_him = EXPO.Cd_Pes
	Left Outer Join PO_HIM DI on LLP.Num_proc_Lim = DI.Num_Proc_Him and DI.ID_DC = 5
	Left Outer Join Tarefas_Processos TP on LLP.Num_proc_lim = TP.Num_proc and ID_Task = 4
	Left Outer Join Localidade ORG on HOU.Cd_Org_Him = ORG.Cd_Local
	Left Outer Join Nota_Cliente NC on LLP.Num_Proc_Lim = NC.Num_Proc
	Left Outer Join Nota_Fiscal_Cliente_Det NCD on NC.ID_NF = NCD.ID_NF and NC.Cd_Cliente = NCD.Cd_Cliente and PS.Cd_Pedido = NCD.Cd_pedido and PS.Cd_Produto = NCD.Cd_produto  
	Left Outer Join PO_HIM NF on LLP.Num_proc_Lim = NF.Num_Proc_Him and NF.ID_DC = 10
	Left Outer Join PO_HIM INV on LLP.Num_proc_Lim = INV.Num_Proc_Him and INV.ID_DC = 2
	Left Outer Join Pessoa_LLP PL on P.cd_buyer = PL.Cd_pes
--	Left Outer Join Localidade PORT_DEST on HOU.Cd_Dst_him = PORT_DEST.Cd_Local
where 
	num_proc_Lim like '%CSR%' and TP.Dt_Conclusao is not Null
/**
Union ALL

select 
LLP.Num_Proc_LIA JOB,
'00'+ right(Left(Planta,5),2) cd_rfgl__41, 
right(Left(Planta,5),2) cd_rf__41, 
OCN.Nome_Raz_Soc no_companhia__41,
PO.Numero_PO_HIA nu_purchase__35,
PC.Cd_proc_Cliente cd_gmid__52,
PC.Produto_Descr dc_produto__52,
PC.Produto_Descr dc_nome_cml__52,
VD.cd_Vendor cd_dow__6,
EXPO.Nome_Raz_Soc dc_fornecedor__6,
Isnull(NCD.Quantidade,0) SumOfvl_quantidade__36,
'KG'dc_unidade__34,
DI.Numero_PO_HIA nu_di__35,
LLP.ATD_LIA dt_embarque__35,
Dt_Conclusao dt_desemb__35,
'AEREO' dc_via_transporte__47,
HOU.VOO_HIA no_navio__35,
ORG.Nome_local no_porto_origem__8,
'AER' no_modal_transp__48,
dbo.fBusca_HistoricoDescr(LLP.Num_proc_LIA, 0,getdate()) dc_obs_processo__35,
'TAX' no_local_arquivo__44,
'TAX' nu_caixa_arquivo__35,
P.Num_pedido nu_ordem__35,
Isnull(PD.Vlr_total_Item,NCD.Vlr_Total_ITEM)  vl_fob_me__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'FRETE%') vl_frete_me__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'AFRMM%') vl_afrmm__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'THC%') vl_capatazia__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'TUP%') vl_tup__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'LI - CHB%') + dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'LICENÇA DE IMPORTAÇÃO%') vl_li__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'Direitos Antidumping%')+ dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, '%multa%') vl_outras__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'CPMF%') vl_cpmf__36,
isnull(NCD.Aliq_II,0) vl_aliq_ii__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'Imposto de IMP%') vl_ii__36,
isnull(NCD.aliq_IPI,0) vl_aliq_ipi__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'IPI%') vl_ipi__36,
isnull(NCD.Vl_base_icms,0) vl_icms_base__36,
isnull(NCD.aliq_Icms,0) vl_aliq_icms__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'ICMS%') vl_icms__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'movimen%') vl_tra_1__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, '%Siscomex%') vl_siscomex__36,
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, '%Despacho%') + dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'Tracking and Trace%') + dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'Order Entry%') vl_dpc_servico__36, 
dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto, 'ARMAZENAGEM%') + dbo.fBusca_Custo(LLP.Num_proc_LIA, PS.Cd_pedido, PS.Cd_produto,'demurrage%') vl_dpc_acessorias__36,
isnull(NC.Paridade,0) vl_taxa_moeda__35,
'BDP South America LTDA' no_despachante__46,
P.Payment cd_dow__30,
NF.Data_PO_HIA dc_dt_nf__35,
'DD' cd_tipo_ordem_imp__35,
INV.Numero_PO_HIA dc_nu_fatura__35,
NC.Nota_Fiscal dc_nu_nf__35,
right(Left(Planta,7),2) cd_dow__29,
PL.Planta_Nome dc_planta__29,
dbo.fBusca_Custo(LLP.Num_proc_Lia, PS.Cd_pedido, PS.Cd_produto,'PIS%') vl_PIS,
dbo.fBusca_Custo(LLP.Num_proc_Lia, PS.Cd_pedido, PS.Cd_produto,'Cofins%') vl_COFINS,
Port_Dest.Nome_local Destino
from LLP_IMP_AER LLP
 Join Pedido_Ship PS on LLP.Num_Proc_LIA = PS.Num_Proc 
Left Outer Join Pedido P on PS.Cd_Pedido = P.Cd_Pedido 
LEft Outer Join Pedido_Det PD on PS.cd_pedido = PD.cd_pedido and PS.cd_produto = PD.Cd_produto and PS.Item = PD.Item and PS.Lote = PD.Lote  
Left Outer Join Pessoa OCN on P.Cd_Buyer = OCN.Cd_Pes
Left Outer Join PO_HIA PO on LLP.Num_proc_LIA = PO.Num_Proc_HIA and PO.ID_DC = 1
Left Outer Join Produto_Cliente PC on PS.cd_produto = PC.Cd_prod and cd_cliente = 1
Left Outer Join Pessoa_LLP VD on P.cd_Seller = VD.Cd_pes
Left Outer Join House_imp_AER HOU on LLP.Num_proc_LIA = HOU.Num_proc_HIA  
Left Outer Join Pessoa EXPO on HOU.Cd_Export_HIA = EXPO.Cd_Pes
Left Outer Join PO_HIA DI on LLP.Num_proc_LIA = DI.Num_Proc_HIA and DI.ID_DC = 5
Left Outer Join Tarefas_Processos TP on LLP.Num_proc_LIA = TP.Num_proc and ID_Task = 4
Left Outer Join Localidade ORG on HOU.Cd_Org_HIA = ORG.Cd_Local
Left Outer Join Nota_Cliente NC on LLP.Num_Proc_LIA = NC.Num_Proc
Left Outer Join Nota_Fiscal_Cliente_Det NCD on NC.ID_NF = NCD.ID_NF and NC.Cd_Cliente = NCD.Cd_Cliente and PS.Cd_Pedido = NCD.Cd_pedido and PS.Cd_Produto = NCD.Cd_produto  
Left Outer Join PO_HIA NF on LLP.Num_proc_LIA = NF.Num_Proc_HIA and NF.ID_DC = 10
Left Outer Join PO_HIA INV on LLP.Num_proc_LIA = INV.Num_Proc_HIA and INV.ID_DC = 2
Left Outer Join Pessoa_LLP PL on P.cd_buyer = PL.Cd_pes
Left Outer Join Localidade PORT_DEST on HOU.Cd_Dst_hia = PORT_DEST.Cd_Local
where num_proc_LIA like '%CSR%' and TP.Dt_Conclusao is not Null

Union ALL

select 
LLP.Num_Proc_LIO JOB,
'00'+ right(Left(Planta,5),2) cd_rfgl__41, 
right(Left(Planta,5),2) cd_rf__41, 
OCN.Nome_Raz_Soc no_companhia__41,
PO.Numero_PO_HIO nu_purchase__35,
PC.Cd_proc_Cliente cd_gmid__52,
PC.Produto_Descr dc_produto__52,
PC.Produto_Descr dc_nome_cml__52,
VD.cd_Vendor cd_dow__6,
EXPO.Nome_Raz_Soc dc_fornecedor__6,
Isnull(NCD.Quantidade,0) SumOfvl_quantidade__36,
'KG'dc_unidade__34,
DI.Numero_PO_HIO nu_di__35,
LLP.ATD_LIO dt_embarque__35,
Dt_Conclusao dt_desemb__35,
CASE LLP.Tipo_lio when 'T' then 'TRUNCK' ELSE 'RAIL' END dc_via_transporte__47,
' ' no_navio__35,
ORG.Nome_local no_porto_origem__8,
CASE LLP.Tipo_lio when 'T' then 'TRUNCK' ELSE 'RAIL' END no_modal_transp__48,
dbo.fBusca_HistoricoDescr(LLP.Num_proc_LIO, 0,getdate()) dc_obs_processo__35,
'TAX' no_local_arquivo__44,
'TAX' nu_caixa_arquivo__35,
P.Num_pedido nu_ordem__35,
Isnull(PD.Vlr_total_Item,NCD.Vlr_Total_ITEM)  vl_fob_me__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'FRETE%') vl_frete_me__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'AFRMM%') vl_afrmm__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'THC%') vl_capatazia__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'TUP%') vl_tup__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'LI - CHB%') + dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'LICENÇA DE IMPORTAÇÃO%') vl_li__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'Direitos Antidumping%')+ dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, '%multa%') vl_outras__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'CPMF%') vl_cpmf__36,
isnull(NCD.Aliq_II,0) vl_aliq_ii__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'Imposto de IMP%') vl_ii__36,
isnull(NCD.aliq_IPI,0) vl_aliq_ipi__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'IPI%') vl_ipi__36,
isnull(NCD.Vl_base_icms,0) vl_icms_base__36,
isnull(NCD.aliq_Icms,0) vl_aliq_icms__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'ICMS%') vl_icms__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'movimen%') vl_tra_1__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, '%Siscomex%') vl_siscomex__36,
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, '%Despacho%') + dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'Tracking and Trace%') + dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'Order Entry%') vl_dpc_servico__36, 
dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto, 'ARMAZENAGEM%') + dbo.fBusca_Custo(LLP.Num_proc_LIO, PS.Cd_pedido, PS.Cd_produto,'demurrage%') vl_dpc_acessorias__36,
isnull(NC.Paridade,0) vl_taxa_moeda__35,
'BDP South America LTDA' no_despachante__46,
P.Payment cd_dow__30,
NF.Data_PO_HIO dc_dt_nf__35,
'DD' cd_tipo_ordem_imp__35,
INV.Numero_PO_HIO dc_nu_fatura__35,
NC.Nota_Fiscal dc_nu_nf__35,
right(Left(Planta,7),2) cd_dow__29,
PL.Planta_Nome dc_planta__29,
dbo.fBusca_Custo(LLP.Num_proc_Lio, PS.Cd_pedido, PS.Cd_produto,'PIS%') vl_PIS,
dbo.fBusca_Custo(LLP.Num_proc_Lio, PS.Cd_pedido, PS.Cd_produto,'Cofins%') vl_COFINS,
Port_Dest.Nome_local Destino
from LLP_IMP_OUT LLP
 Join Pedido_Ship PS on LLP.Num_Proc_LIO = PS.Num_Proc 
Left Outer Join Pedido P on PS.Cd_Pedido = P.Cd_Pedido 
LEft Outer Join Pedido_Det PD on PS.cd_pedido = PD.cd_pedido and PS.cd_produto = PD.Cd_produto and PS.Item = PD.Item and PS.Lote = PD.Lote  
Left Outer Join Pessoa OCN on P.Cd_Buyer = OCN.Cd_Pes
Left Outer Join PO_HIO PO on LLP.Num_proc_LIO = PO.Num_Proc_HIO and PO.ID_DC= 1
Left Outer Join Produto_Cliente PC on PS.cd_produto = PC.Cd_prod and cd_cliente = 1
Left Outer Join Pessoa_LLP VD on P.cd_Seller = VD.Cd_pes
Left Outer Join House_imp_OUT HOU on LLP.Num_proc_LIO = HOU.Num_proc_HIO  
Left Outer Join Pessoa EXPO on HOU.Cd_Export_HIO = EXPO.Cd_Pes
Left Outer Join PO_HIO DI on LLP.Num_proc_LIO = DI.Num_Proc_HIO and DI.ID_DC = 5
Left Outer Join Tarefas_Processos TP on LLP.Num_proc_LIO = TP.Num_proc and ID_Task = 4
Left Outer Join Localidade ORG on HOU.Cd_Org_HIO = ORG.Cd_Local
Left Outer Join Nota_Cliente NC on LLP.Num_Proc_LIO = NC.Num_Proc
Left Outer Join Nota_Fiscal_Cliente_Det NCD on NC.ID_NF = NCD.ID_NF and NC.Cd_Cliente = NCD.Cd_Cliente and PS.Cd_Pedido = NCD.Cd_pedido and PS.Cd_Produto = NCD.Cd_produto  
Left Outer Join PO_HIO NF on LLP.Num_proc_LIO = NF.Num_Proc_HIO and NF.ID_DC = 10
Left Outer Join PO_HIO INV on LLP.Num_proc_LIO = INV.Num_Proc_HIO and INV.ID_DC = 2
Left Outer Join Pessoa_LLP PL on P.cd_buyer = PL.Cd_pes
Left Outer Join Localidade PORT_DEST on HOU.Cd_Dst_hio = PORT_DEST.Cd_Local
where num_proc_LIO like '%CSR%' and TP.Dt_Conclusao is not Null








**/
GO
