SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_Imp_Completo_New_REL]
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	--select * from Report where stored = 'spReport_Imp_Completo'		
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

select
	HOU.Modal										[Modal],
	(datename(mm,TP4.Dt_Conclusao))					[Month of Clearance],	
	HOU.Num_Proc									[BDP Ref.],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')		[PO Number],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Customer PO],
	PD.Peso_Liquido_TOT								[Netweight KG– Shipment],
	PD.Peso_Bruto_TOT								[Gross Weight - Shipment - Value],
	HOU.ETD											[ETD Date],
	HOU.ATD											[ATD Date],
	HOU.Dt_Emis										[Register Date],
	TP16.Dt_Conclusao								[Docs Received Date],
	HOU.ETA											[ETA Date],
	HOU.ATA											[ATA Date],
	TP15.Dt_Conclusao								[Port Entry Date],
	TP4.Dt_Conclusao								[Customs Transmission Date],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')		[Entry Number],	
	HOU.Canal										[Channel],
	T.Nome_Terminal									[Terminal],
	'?'												[Warehouse Payment - Date],
	TP67.Dt_Conclusao								[NFE Draft - Date],	
	TP4.Dt_Conclusao								[Customs Clearance Date],
	dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		[NF Date],
	TP7.Dt_Conclusao								[Transport. Doc Delivery Date],
	SHIP.Apelido									[Shipper],
	LO.Nome_Local									[Origin],
	LD.Nome_Local									[Destination],
	LO.Pais_Local									[Country of Origin],
	HOU.HAWB										[House],
	HOU.MAWB										[Master],
	CONSIG.Num_CPF_CNPJ								[CNPJ],
	P.Incoterm										[Incoterm],	
	CCXAC.Vlr_Item_Custo							[ICMS - Value],
	NFDet.ALIQ_ICMS									[% ICMS],
	CCXAA.Vlr_Item_Custo							[Import Duty Value],
	NFDet.ALIQ_II									[% II],
	CCXAB.Vlr_Item_Custo							[IPI - Value],
	NFDet.ALIQ_IPI									[% IPI], 
	CCXAO.Vlr_Item_Custo							[PIS - Value],
	NFDet.VL_ALIQ_PIS								[% PIS],
	CCXAP.Vlr_Item_Custo							[Cofins - Value],
	NFDet.VL_ALIQ_COFINS							[% Cofins],





	
	
	
TP60.Dt_Conclusao [File Open Date],
HOU.Master [Consol Ref.],

PC.cd_Proc_Cliente [Product ID], 
PD.Lote [Delivery Note],
PG.Apelido [Group Name],
DP.Business_Group_Descr [Business Group],
DP.Business_Descr [Business Name],
PCP.Apelido [Manufacturer],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'3') [Order Date],
(case when P.cd_tipo='2' then 'Third'
		when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
end)   [Order Type],
TP50.Dt_Conclusao [Order Received - Date],



TC.Nome_Tp_Carga	[Type of cargo],

ENDS.Rua		[Shipper Address],
CONSIG.Apelido	[Consignee],
ENDC.Rua		[Consignee Address],
ENDC.Cidade		[City of Consignee],
Case left (CONSIG.Num_CPF_CNPJ,8)
	When '47180625' then '44'
		When '53877627' then '42'
			When '60435351' then '31'
				when '00310651' then '4083' End [Company ID],

LD.Pais_Local [Country of Destination],




LD.Pais_Local [Country of Final Destination],
TP41.Dt_Conclusao [Data Aprov. Draft],

PC.NCM_Cliente [NCM],
[dbo].[fBusca_Containers] (HOU.Num_Proc)	[Containers],
[dbo].[fBusca_Containers_TP] (HOU.Num_Proc)	[Container Type],
[dbo].[Qty_Container](HOU.Num_Proc) [Container Qty],
PC.Produto_Descr [Product Description],
PC.Produto_Descr [Product IDs by Shipment],
ARM.Nome_Armador [Carrier],
HOU.Vessel [Vessel],
dbo.fBusca_TEUS(HOU.Num_Proc) [TEUS Qtys],

dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'13') [Certificado de Origem],
HOU.Moeda_Invoice [Invoice Currency],
HOU.Vlr_Invoice [Invoice Value],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'2') [Invoice Date],
TP40.Dt_Conclusao  [Invoice Sent Date],
VER.Descricao [Necessidade de LI?],
SLI.Dt_Solicitacao [LI Request - Date],
SLI.Dt_LI [LI Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'23') [Import License],
TLI.Nome_Tp_LI [LI - Type],
SLI.Dt_Deferimento [Def.  LI - Date],
TP20.Dt_Conclusao [Deferimento de LI Prévia],
TP153.Dt_Conclusao [AUTORIZAÇÃO DE EMBARQUE],
SLI.Dt_Vencimento [LI Expired - Date],
OA.Nome_Orgao_Anuente [Government Agency],
CCXAU.Vlr_Item_Custo [Import License - Value],
Case when DC23.Id_DC='5' then 'YES' else 'NO' End [PDF - LI],
TP5.Dt_Conclusao [Booking Confirmation Date],
HOU.Peso_Bruto [Qty KG],
HOU.Peso_Liquido [Net Weight KG],
HOU.Peso_Bruto [Gross Weight KG],
NFDet.Peso_Bruto [Gross Weight - NF],

CP31.Campo_Dados [Exchange Rates Value],
TP163.Dt_Conclusao [SELECIONADA P/ INSP. MADEIRA],
TP30.Dt_Conclusao [INSP. MADEIRA CONCLUÍDA],
TP164.Dt_Conclusao [MADEIRA LIBERADA], -- Esse
TP1.Dt_Conclusao  [Pre-Alert Sending - Date],
TP59.Dt_Conclusao [Advanced Request Date],
TP27.Dt_Conclusao [PRE DI Date],

TP155.Dt_Conclusao [RECEB. DOCS. ORIGINAIS CHB],
TP174.Dt_Conclusao [RECEB. DOCS. ORIGINAIS CSR],
TP60.Dt_Conclusao [Data Abertura Pasta],
TP156.Dt_Conclusao [PRESENÇA DE CARGA P/ DI], -- Esse
TP168.Dt_Conclusao [ENTREGA P/ PRÉ-DI],
CCXR6.Vlr_Item_Custo [Courier - Value],
HOU.Tipo_Frete [Freight Type],
(case 
when[Paridade] = 0 OR Isnull(NFDet.vlr_frete,0) = 0 then NULL else
Cast(sum(ISNULL(NFDet.vlr_frete,0)) / [Paridade] as decimal(18,2))End)
[Freight - USD],
HOU.Moeda_invoice [Freight Currency],
HOU.Frete_BL [Freight BL],
NFDet.vlr_frete [Freight Value],
TP39.Dt_Conclusao [Green light - Date],

(datename(mm,HOU.ETA))[Month of Arrival],
CCINC.Vlr_Item_Custo [Insurance Value],
CCXTH.Vlr_Item_Custo [THC Value],
CCXTA.Vlr_Item_Custo [TUP - Value],
TER.Nome_Terminal [Terminal],
TP42.Dt_Conclusao [Data Redest. Container],
TP28.Dt_Conclusao [Data Entr. Terminal],
OPER.Descricao_OP [Terminal Pier Name],

CXA.Dt_Pgto_Rcto_HIA [Advancement Received Date],
TP29.Dt_Conclusao [Unloaded Date],
CCXAF.Vlr_Item_Custo [Desconsolidation Value],
TP104.Dt_Conclusao [Effective Position Container - Date],
CCXDB.Vlr_Item_Custo [Posicionamento - Value],
CCXIP.Vlr_Item_Custo [ISPS Value],
TP25.Dt_Conclusao [AFRMM Payment Date],
CCXAM.Vlr_Item_Custo [AFRMM Value],
Case when DC41.Id_DC='5' then 'YES' else 'NO' End [PDF - AFRMM],
TP176.Dt_Conclusao [BENEFICIO AFRMM],
TP21.Dt_Conclusao [BL Payment Date],
CCXAA.Vlr_Item_Custo [BL Fee Value],
TP20.Dt_Conclusao [Deferimento de LI Pós],

dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5') [REGISTRO DE DI],

CCXAD.Vlr_Item_Custo [Siscomex Value],
(case 
when[Paridade] = 0 then 0 else
Cast(sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)-isnull(NFDet.ACRESCIMOS,0)) /[Paridade] as decimal(18,2))End)  [FOB - USD],
sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)-isnull(NFDet.ACRESCIMOS,0))  [FOB Value],
(case 
when[Paridade] = 0 OR Isnull(NFDet.vlr_frete,0) = 0 then 0 else
Cast(sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)-isnull(NFDet.ACRESCIMOS,0)) /[Paridade] as decimal(18,2)) + Cast(sum(NFDet.vlr_frete) / [Paridade] as decimal(18,2))End) [CFR - USD],
CP110.Campo_Dados [CIF Value],

CCXAA.Vlr_Item_Custo [Import Duties Value by Shipment],

CCXAB.Vlr_Item_Custo [IPI Value by Shipment],

CCXAO.Vlr_Item_Custo [PIS Value by Shipment],

CCXAP.Vlr_Item_Custo [Cofins Value by Shipment],
CCXDV.Vlr_Item_Custo [AntiDumping Value],
CCXDV.Vlr_Item_Custo [AntiDumping Value by Shipment],


Case when DC5.Id_DC='5' then 'YES' else 'NO' End [PDF - DI],
Case when DC6.Id_DC='6' then 'YES' else 'NO' End [PDF - CI],
CCXAG.Vlr_Item_Custo [TP - Despesas Acessorias - Value],
CCXDU.Vlr_Item_Custo [TP - Despesas Calc ICMS - Value],

NFDet.VL_BASE_ICMS [ICMS Base],
TP24.Dt_Conclusao [ICMS Payment Date],
Case when DC40.Id_DC='60' then 'YES' else 'NO' End [PDF - ICMS],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'75')	[ICMS Exonaration Date],
TP142.Dt_Conclusao [Danfe Request - Date],
TP7.Dt_Conclusao [Danfe Receipt - Date - BR only],
TP108.Dt_Conclusao [RECEBIMENTO DE DANFE],
TP169.Dt_Conclusao [REBEB. DANFE CLIENTE],


dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [NF Number],
NC.CFOP [CFOP],
CP112.Campo_Dados [NF Serie],
CP117.Campo_Dados [NF Issue - Value],
Case when DC10.Id_DC='10' then 'YES' else 'NO' End	[PDF - NF],

TP7.Dt_Conclusao [DOCS DISPONÍVEIS P/ TRANSP.],
TP165.Dt_Conclusao [DOCS RETIRADOS PELA TRANSP.],
TP26.Dt_Conclusao [Docs to BDP Billing Date],
CCXFI.Vlr_Item_Custo [Inland Freight Value],
CCXAX.Vlr_Item_Custo [Pesagem - Value],
CCXAH.Vlr_Item_Custo [Warehousing Value],
CXAH.Dt_Pgto_Rcto_HIA [Data Pgto Armazenagem],
TP78.Dt_Conclusao [NF BDP Date],
TP117.Dt_Conclusao [Invoice approval by customer - Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'2') [Invoice],
dbo.fBusca_Custo_Produto(HOU.Num_Proc, PS.cd_produto,'DESPACHO') [Customs Brokerage Value],
--CCB11.Vlr_Item_Custo [Customs Brokerage Value],
Case when DC60.Id_DC='60' then 'YES' else 'NO' End	[PDF - PC],
[dbo].[fBusca_Hist_Geral_Sistema_UltimaAtualizacao] (HOU.Num_Proc,47) [Last Update],
TS.status_descricao [Process Status],
dbo.fBuscaSaldoCaixaSemServicos_Sel(HOU.Num_Proc) [Saldo Processo Valor],
HOU.Notas [Notes],
[dbo].[fBusca_HistoricoDescr](HOU.Num_Proc,0,getdate()) [Last Historic],
[dbo].[FHistoricoLinhas] (HOU.Num_Proc) [Complete Historic],
TP154.Dt_Conclusao [AUDITORIA DATA MANEGMENT],
Case when DC2.Id_DC='2' then 'YES' else 'NO' End [PDF - INVOICE],
Case when DC20.Id_DC='20' then 'YES' else 'NO' End [PDF - CONHECIMENTO DE EMBARQUE],
Case when DC16.Id_DC='16' then 'YES' else 'NO' End [PDF - COA],
Case when DC11.Id_DC='11' then 'YES' else 'NO' End [PDF - PACKING LIST],
TP173.Dt_Conclusao [ENVIO DE COA PARA TRANSPORTADORA],
TP23.Dt_Conclusao [ENVIO DE DOCS PARA CAMBIO],
TP23.Dt_Conclusao [DOCUMENTOS OK PARA REGISTRO]
--into Report_Imp_Completo
from vwHouse_Imp HOU with(nolock)
Left Join Pedido_Ship PS		with(nolock) on HOU.Num_Proc = PS.Num_Proc
left Join Pedido_Det PD				with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto
left Join Pedido P					with(nolock) on PD.cd_pedido = P.Cd_pedido
left Join Produto_Cliente PC			with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod
Left Outer Join DE_Para_Produto DP	with(nolock) on DP.gmid=cd_proc_cliente	
left Join Tipo_Status_Processo TS	with(nolock) on HOU.ID_status = TS.ID_status
left Join Pessoa CONSIG				with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
left join Endereco ENDC				with(nolock) on CONSIG.Cd_Pes = ENDC.Cd_Pes and ENDC.Cd_Tp_End = 'COM'
left Join Pessoa SHIP				with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
left join Endereco ENDS				with(nolock) on SHIP.Cd_Pes = ENDS.Cd_Pes and ENDS.Cd_Tp_End = 'COM'
Left Outer Join Pessoa_LLP PLL	with(nolock) on HOU.Cd_Consig = PLL.Cd_Pes
Left Outer Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
Left Outer Join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Join Localidade LO				with(nolock) on LO.cd_local = HOU.Cd_Org
Join Localidade LD				with(nolock) on LD.cd_local = HOU.Cd_Dst
Left Outer Join Armador	ARM 	with(nolock) on HOU.cd_armador = ARM.cd_Armador
Left Outer Join Terminal TER	with(nolock) on HOU.Cd_Terminal = TER.Cd_Terminal
Left Outer Join Nota_Cliente NC with(nolock) on HOU.Num_Proc = NC.Num_Proc
Left Outer Join Nota_Fiscal_Cliente_Det NFDet with(nolock) on NC.ID_NF = NFDet.ID_NF and NC.CD_Cliente = NFDet.Cd_Cliente and PS.cd_pedido = NFDet.Cd_Pedido and PS.cd_produto = NFDet.Cd_Produto
Left Outer Join Solicitacao_LI SLI  with(nolock) on HOU.Num_Proc = SLI.Num_Proc and SLI.ID_Status <> 12
Left Outer Join Tipo_LI TLI			with(nolock) on SLI.ID_Tipo_LI = TLI.ID_Tipo
Left Outer Join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
Left Outer Join Custo_Cliente CCXAM with(nolock)on HOU.Num_Proc = CCXAM.Num_Proc and CCXAM.Cd_tp_tx = 'XAM' and CCXAM.Cd_Pedido = PS.Cd_pedido and CCXAM.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAP with(nolock)on HOU.Num_Proc = CCXAP.Num_Proc and CCXAP.Cd_tp_tx = 'XAP' and CCXAP.Cd_Pedido = PS.Cd_pedido and CCXAP.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAP.Cd_tp_tx = 'XAD' and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAC with(nolock)on HOU.Num_Proc = CCXAC.Num_Proc and CCXAC.Cd_tp_tx = 'XAC' and CCXAC.Cd_Pedido = PS.Cd_pedido and CCXAC.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCFOB with(nolock)on HOU.Num_Proc = CCFOB.Num_Proc and CCFOB.Cd_tp_tx = 'FOB' and CCFOB.Cd_Pedido = PS.Cd_pedido and CCFOB.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAO with(nolock)on HOU.Num_Proc = CCXAO.Num_Proc and CCXAO.Cd_tp_tx = 'XAO' and CCXAO.Cd_Pedido = PS.Cd_pedido and CCXAO.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXDV with(nolock)on HOU.Num_Proc = CCXDV.Num_Proc and CCXDV.Cd_tp_tx = 'XDV' and CCXDV.Cd_Pedido = PS.Cd_pedido and CCXDV.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAB with(nolock)on HOU.Num_Proc = CCXAB.Num_Proc and CCXAB.Cd_tp_tx = 'XAB' and CCXAB.Cd_Pedido = PS.Cd_pedido and CCXAB.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXDU with(nolock)on HOU.Num_Proc = CCXDU.Num_Proc and CCXDU.Cd_tp_tx = 'XDU' and CCXDU.Cd_Pedido = PS.Cd_pedido and CCXDU.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAG with(nolock)on HOU.Num_Proc = CCXAG.Num_Proc and CCXAG.Cd_tp_tx = 'XAG' and CCXAG.Cd_Pedido = PS.Cd_pedido and CCXAG.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAA with(nolock)on HOU.Num_Proc = CCXAA.Num_Proc and CCXAA.Cd_tp_tx = 'XAA' and CCXAA.Cd_Pedido = PS.Cd_pedido and CCXAA.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCB11 with(nolock)on HOU.Num_Proc = CCB11.Num_Proc and CCB11.Cd_tp_tx = 'B11' and CCB11.Cd_Pedido = PS.Cd_pedido and CCB11.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAX with(nolock)on HOU.Num_Proc = CCXAX.Num_Proc and CCXAX.Cd_tp_tx = 'XAX' and CCXAX.Cd_Pedido = PS.Cd_pedido and CCXAX.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAH with(nolock)on HOU.Num_Proc = CCXAH.Num_Proc and CCXAH.Cd_tp_tx = 'XAH' and CCXAH.Cd_Pedido = PS.Cd_pedido and CCXAH.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXFI with(nolock)on HOU.Num_Proc = CCXFI.Num_Proc and CCXFI.Cd_tp_tx = 'XFI' and CCXFI.Cd_Pedido = PS.Cd_pedido and CCXFI.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXIP with(nolock)on HOU.Num_Proc = CCXIP.Num_Proc and CCXIP.Cd_tp_tx = 'XIP' and CCXIP.Cd_Pedido = PS.Cd_pedido and CCXIP.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXDB with(nolock)on HOU.Num_Proc = CCXDB.Num_Proc and CCXDB.Cd_tp_tx = 'XDB' and CCXDB.Cd_Pedido = PS.Cd_pedido and CCXDB.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAF with(nolock)on HOU.Num_Proc = CCXAF.Num_Proc and CCXAF.Cd_tp_tx = 'XAF' and CCXAF.Cd_Pedido = PS.Cd_pedido and CCXAF.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXTA with(nolock)on HOU.Num_Proc = CCXTA.Num_Proc and CCXTA.Cd_tp_tx = 'XTA' and CCXTA.Cd_Pedido = PS.Cd_pedido and CCXTA.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXTH with(nolock)on HOU.Num_Proc = CCXTH.Num_Proc and CCXTH.Cd_tp_tx = 'XTH' and CCXTH.Cd_Pedido = PS.Cd_pedido and CCXTH.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCINC with(nolock)on HOU.Num_Proc = CCINC.Num_Proc and CCINC.Cd_tp_tx = 'INC' and CCINC.Cd_Pedido = PS.Cd_pedido and CCINC.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXR6 with(nolock)on HOU.Num_Proc = CCXR6.Num_Proc and CCXR6.Cd_tp_tx = 'XR6' and CCXR6.Cd_Pedido = PS.Cd_pedido and CCXR6.Cd_Produto = PS.cd_produto
Left Outer Join Custo_Cliente CCXAU with(nolock)on HOU.Num_Proc = CCXAU.Num_Proc and CCXAU.Cd_tp_tx = 'XAU' and CCXAU.Cd_Pedido = PS.Cd_pedido and CCXAU.Cd_Produto = PS.cd_produto
left Outer Join vwcxas CXA		with(nolock) on HOU.Num_Proc = CXA.Num_Proc_HIA and dc_hia='C' and CXA.cd_tp_Tx in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%')
left Outer Join vwcxas CXAH		with(nolock) on HOU.Num_Proc = CXAH.Num_Proc_HIA and CXAH.DC_HIA='D' and CXAH.cd_tp_Tx in (select cd_tp_Tx from tipo_taxa where Cd_Tp_Tx = 'XAH')
Left Outer Join Doc_Anexos DC2  with(nolock) on Hou.Num_Proc = DC2.Num_Proc and DC2.Id_DC = '2'
Left Outer Join Doc_Anexos DC5  with(nolock) on Hou.Num_Proc = DC5.Num_Proc and DC5.Id_DC = '5'
Left Outer Join Doc_Anexos DC6  with(nolock) on Hou.Num_Proc = DC6.Num_Proc and DC6.Id_DC = '6'
Left Outer Join Doc_Anexos DC10 with(nolock) on Hou.Num_Proc = DC10.Num_Proc and DC10.Id_DC = '10'
Left Outer Join Doc_Anexos DC11 with(nolock) on Hou.Num_Proc = DC11.Num_Proc and DC11.Id_DC = '11'
Left Outer Join Doc_Anexos DC16 with(nolock) on Hou.Num_Proc = DC16.Num_Proc and DC16.Id_DC = '16'
Left Outer Join Doc_Anexos DC20 with(nolock) on Hou.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
Left Outer Join Doc_Anexos DC23 with(nolock) on Hou.Num_Proc = DC23.Num_Proc and DC23.Id_DC = '23'
Left Outer Join Doc_Anexos DC40 with(nolock) on Hou.Num_Proc = DC40.Num_Proc and DC40.Id_DC = '40'
Left Outer Join Doc_Anexos DC41 with(nolock) on Hou.Num_Proc = DC41.Num_Proc and DC41.Id_DC = '41'
Left Outer Join Doc_Anexos DC60 with(nolock) on Hou.Num_Proc = DC60.Num_Proc and DC60.Id_DC = '60'
Left Outer Join Tarefas_Processos TP1  with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task = '1'
Left Outer Join Tarefas_Processos TP4  with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Left Outer Join Tarefas_Processos TP5  with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task = '5'
Left Outer Join Tarefas_Processos TP7  with(nolock) on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task = '7'
Left Outer Join Tarefas_Processos TP15  with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task = '15'
Left Outer Join Tarefas_Processos TP16  with(nolock) on HOU.Num_Proc = TP16.Num_Proc and TP16.ID_Task = '16'
Left Outer Join Tarefas_Processos TP20  with(nolock) on HOU.Num_Proc = TP20.Num_Proc and TP20.ID_Task = '20'
Left Outer Join Tarefas_Processos TP21  with(nolock) on HOU.Num_Proc = TP21.Num_Proc and TP21.ID_Task = '21'
Left Outer Join Tarefas_Processos TP23  with(nolock) on HOU.Num_Proc = TP23.Num_Proc and TP23.ID_Task = '23'
Left Outer Join Tarefas_Processos TP24  with(nolock) on HOU.Num_Proc = TP24.Num_Proc and TP24.ID_Task = '24'
Left Outer Join Tarefas_Processos TP25  with(nolock) on HOU.Num_Proc = TP25.Num_Proc and TP25.ID_Task = '25'
Left Outer Join Tarefas_Processos TP26  with(nolock) on HOU.Num_Proc = TP26.Num_Proc and TP26.ID_Task = '26'
Left Outer Join Tarefas_Processos TP27  with(nolock) on HOU.Num_Proc = TP27.Num_Proc and TP27.ID_Task = '27'
Left Outer Join Tarefas_Processos TP28  with(nolock) on HOU.Num_Proc = TP28.Num_Proc and TP28.ID_Task = '28'
Left Outer Join Tarefas_Processos TP29  with(nolock) on HOU.Num_Proc = TP29.Num_Proc and TP29.ID_Task = '29'
Left Outer Join Tarefas_Processos TP30  with(nolock) on HOU.Num_Proc = TP30.Num_Proc and TP30.ID_Task = '30'
Left Outer Join Tarefas_Processos TP39  with(nolock) on HOU.Num_Proc = TP39.Num_Proc and TP39.ID_Task = '39'
Left Outer Join Tarefas_Processos TP40  with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = '40'
Left Outer Join Tarefas_Processos TP41  with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task = '41'
Left Outer Join Tarefas_Processos TP42  with(nolock) on HOU.Num_Proc = TP42.Num_Proc and TP42.ID_Task = '42'
Left Outer Join Tarefas_Processos TP50  with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task = '50'
Left Outer Join Tarefas_Processos TP59  with(nolock) on HOU.Num_Proc = TP59.Num_Proc and TP59.ID_Task = '59'
Left Outer Join Tarefas_Processos TP60  with(nolock) on HOU.Num_Proc = TP60.Num_Proc and TP60.ID_Task = '60'
Left Outer Join Tarefas_Processos TP63  with(nolock) on HOU.Num_Proc = TP63.Num_Proc and TP63.ID_Task = '63'
Left Outer Join Tarefas_Processos TP67  with(nolock) on HOU.Num_Proc = TP67.Num_Proc and TP67.ID_Task = '67'
Left Outer Join Tarefas_Processos TP78  with(nolock) on HOU.Num_Proc = TP78.Num_Proc and TP78.ID_Task = '78'
Left Outer Join Tarefas_Processos TP104  with(nolock) on HOU.Num_Proc = TP104.Num_Proc and TP104.ID_Task = '104'
Left Outer Join Tarefas_Processos TP108  with(nolock) on HOU.Num_Proc = TP108.Num_Proc and TP108.ID_Task = '108'
Left Outer Join Tarefas_Processos TP117  with(nolock) on HOU.Num_Proc = TP117.Num_Proc and TP117.ID_Task = '117'
Left Outer Join Tarefas_Processos TP142  with(nolock) on HOU.Num_Proc = TP142.Num_Proc and TP142.ID_Task = '142'
Left Outer Join Tarefas_Processos TP153 with(nolock) on HOU.Num_Proc = TP153.Num_Proc and TP153.ID_Task = '153'
Left Outer Join Tarefas_Processos TP154 with(nolock) on HOU.Num_Proc = TP154.Num_Proc and TP154.ID_Task = '154'
Left Outer Join Tarefas_Processos TP155 with(nolock) on HOU.Num_Proc = TP155.Num_Proc and TP155.ID_Task = '155'
Left Outer Join Tarefas_Processos TP156 with(nolock) on HOU.Num_Proc = TP156.Num_Proc and TP156.ID_Task = '156'
Left Outer Join Tarefas_Processos TP163 with(nolock) on HOU.Num_Proc = TP163.Num_Proc and TP163.ID_Task = '163'
Left Outer Join Tarefas_Processos TP164 with(nolock) on HOU.Num_Proc = TP164.Num_Proc and TP164.ID_Task = '164'
Left Outer Join Tarefas_Processos TP165 with(nolock) on HOU.Num_Proc = TP165.Num_Proc and TP165.ID_Task = '165'
Left Outer Join Tarefas_Processos TP168 with(nolock) on HOU.Num_Proc = TP168.Num_Proc and TP168.ID_Task = '168'
Left Outer Join Tarefas_Processos TP169 with(nolock) on HOU.Num_Proc = TP169.Num_Proc and TP169.ID_Task = '169'
Left Outer Join Tarefas_Processos TP174 with(nolock) on HOU.Num_Proc = TP174.Num_Proc and TP174.ID_Task = '174'
Left Outer Join Tarefas_Processos TP173 with(nolock) on HOU.Num_Proc = TP173.Num_Proc and TP173.ID_Task = '173'
Left Outer Join Tarefas_Processos TP176 with(nolock) on HOU.Num_Proc = TP176.Num_Proc and TP176.ID_Task = '176'
Left Outer Join Campo_Processo CP1		with(nolock) on HOU.Num_Proc = CP1.Num_Proc AND CP1.Id_Campo = '1'
Left Outer Join Pessoa PCP				with(nolock) on CP1.Campo_Dados = PCP.Cd_Pes
Left Outer Join Campo_Processo CP2		with(nolock) on HOU.Num_Proc = CP2.Num_Proc AND CP2.Id_Campo = '2'
Left Outer Join Terminal T				with(nolock) on CP2.Campo_Dados = T.Cd_Terminal
Left Outer Join Campo_Processo CP122	with(nolock) on HOU.Num_Proc = CP122.Num_Proc AND CP122.Id_Campo = '122' 
Left Outer Join Orgao_Anuente OA		with(nolock) on CP122.Campo_Dados = OA.ID_Orgao 
Left Outer Join Campo_Processo CP31		with(nolock) on HOU.Num_Proc = CP31.Num_Proc AND CP31.Id_Campo = '31' 
Left Outer Join Campo_Processo CP5		with(nolock) on HOU.Num_Proc = CP5.Num_Proc AND CP5.Id_Campo = '5' 
Left Outer Join Verdade VER				with(nolock) on CP5.Campo_Dados = VER.Id 
Left Outer Join Campo_Processo CP139	with(nolock) on HOU.Num_Proc = CP139.Num_Proc AND CP139.Id_Campo = '139' 
Left Outer Join Tipo_operador_portuario OPER with(nolock) on CP139.Campo_Dados = OPER.Descricao_OP 
Left Outer Join Campo_Processo CP110	with(nolock) on HOU.Num_Proc = CP110.Num_Proc AND CP110.Id_Campo = '110'
Left Outer Join Campo_Processo CP112	with(nolock) on HOU.Num_Proc = CP112.Num_Proc AND CP112.Id_Campo = '112' 
Left Outer Join Campo_Processo CP117	with(nolock) on HOU.Num_Proc = CP117.Num_Proc AND CP117.Id_Campo = '117' 
--where HOU.Num_Proc = 'IACSR201510003BR'
where convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal 
		and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
		

GROUP BY 
HOU.Num_Proc,
TP60.Dt_Conclusao,
HOU.Master,
--PO.Numero_PO,
--PO.Numero_Customer_PO,
PC.cd_Proc_Cliente, 
PD.Lote,
PG.Apelido,
DP.Business_Group_Descr,
DP.Business_Descr,
CP1.Campo_Dados,
P.cd_tipo,
TP50.Dt_Conclusao,
HOU.Dt_Emis,
P.Incoterm,
HOU.Modal,
TC.Nome_Tp_Carga,
SHIP.Apelido,
ENDS.Rua,
CONSIG.Apelido,
ENDC.Rua,
ENDC.Cidade,
CONSIG.Num_CPF_CNPJ,
LD.Pais_Local,
LD.Nome_Local,
LO.Pais_Local,
LO.Nome_Local,
LD.Pais_Local,
TP41.Dt_Conclusao,
HOU.MAWB,
HOU.HAWB,
PC.NCM_Cliente,
PC.cd_Proc_Cliente,
PC.Produto_Descr,
PC.Produto_Descr,
ARM.Nome_Armador,
HOU.Vessel,
PD.Peso_Liquido_TOT,
HOU.Moeda_Invoice,
HOU.Vlr_Invoice,
TP40.Dt_Conclusao,
VER.Descricao,
SLI.Dt_Solicitacao,
SLI.Dt_LI,
TLI.Nome_Tp_LI,
SLI.Dt_Deferimento,
TP20.Dt_Conclusao,
TP153.Dt_Conclusao,
SLI.Dt_Vencimento,
OA.Nome_Orgao_Anuente,
CCXAU.Vlr_Item_Custo,
DC23.Id_DC,
TP5.Dt_Conclusao,
HOU.Peso_Bruto,
HOU.Peso_Liquido,
HOU.Peso_Bruto,
NFDet.Peso_Bruto,
PD.Peso_Bruto_TOT,
CP31.Campo_Dados,
TP163.Dt_Conclusao,
TP30.Dt_Conclusao,
TP164.Dt_Conclusao,
TP1.Dt_Conclusao,
TP59.Dt_Conclusao,
TP27.Dt_Conclusao,
TP16.Dt_Conclusao,
TP155.Dt_Conclusao,
TP174.Dt_Conclusao,
TP60.Dt_Conclusao,
TP156.Dt_Conclusao,
TP168.Dt_Conclusao,
CCXR6.Vlr_Item_Custo,
HOU.Tipo_Frete,
NC.Paridade,
HOU.Moeda_invoice,
HOU.Frete_BL,
NFDet.vlr_frete,
TP39.Dt_Conclusao,
HOU.ETD,
HOU.ATD,
HOU.ETA,
HOU.ATA,
CCINC.Vlr_Item_Custo,
CCXTH.Vlr_Item_Custo,
CCXTA.Vlr_Item_Custo,
TER.Nome_Terminal,
TP42.Dt_Conclusao,
TP28.Dt_Conclusao,
OPER.Descricao_OP,
TP15.Dt_Conclusao,
CXA.Dt_Pgto_Rcto_HIA,
TP29.Dt_Conclusao,
CCXAF.Vlr_Item_Custo,
TP104.Dt_Conclusao,
CCXDB.Vlr_Item_Custo,
CCXIP.Vlr_Item_Custo,
TP25.Dt_Conclusao,
CCXAM.Vlr_Item_Custo,
DC41.Id_DC,
TP176.Dt_Conclusao,
TP21.Dt_Conclusao,
CCXAA.Vlr_Item_Custo,
TP20.Dt_Conclusao,
TP4.Dt_Conclusao,
CCXAD.Vlr_Item_Custo,
CP110.Campo_Dados,
NFDet.ALIQ_II,
CCXAA.Vlr_Item_Custo,
CCXAA.Vlr_Item_Custo,
NFDet.ALIQ_IPI,
CCXAB.Vlr_Item_Custo,
CCXAB.Vlr_Item_Custo,
NFDet.VL_ALIQ_PIS,
CCXAO.Vlr_Item_Custo,
CCXAO.Vlr_Item_Custo,
NFDet.VL_ALIQ_COFINS,
CCXAP.Vlr_Item_Custo,
CCXAP.Vlr_Item_Custo,
CCXDV.Vlr_Item_Custo,
CCXDV.Vlr_Item_Custo,
HOU.Canal,
TP4.Dt_Conclusao,
DC5.Id_DC,
DC6.Id_DC,
CCXAG.Vlr_Item_Custo,
CCXDU.Vlr_Item_Custo,
NFDet.ALIQ_ICMS,
CCXAC.Vlr_Item_Custo,
NFDet.VL_BASE_ICMS,
TP24.Dt_Conclusao,
DC40.Id_DC,
TP142.Dt_Conclusao,
TP7.Dt_Conclusao,
TP108.Dt_Conclusao,
TP169.Dt_Conclusao,
TP67.Dt_Conclusao,
NC.CFOP,
CP112.Campo_Dados,
CP117.Campo_Dados,
DC10.Id_DC,
TP7.Dt_Conclusao,
TP7.Dt_Conclusao,
TP165.Dt_Conclusao,
TP26.Dt_Conclusao,
CCXFI.Vlr_Item_Custo,
CCXAX.Vlr_Item_Custo,
CCXAH.Vlr_Item_Custo,
CXAH.Dt_Pgto_Rcto_HIA,
TP78.Dt_Conclusao,
TP117.Dt_Conclusao,
CCB11.Vlr_Item_Custo,
DC60.Id_DC,
TS.status_descricao,
HOU.Notas,
TP154.Dt_Conclusao,
PCP.Apelido,
T.Nome_Terminal,
PS.cd_produto,
DC2.Id_DC,
DC20.Id_DC,
DC16.Id_DC,
DC11.Id_DC,
TP173.Dt_Conclusao,
TP23.Dt_Conclusao,
TP23.Dt_Conclusao

GO
