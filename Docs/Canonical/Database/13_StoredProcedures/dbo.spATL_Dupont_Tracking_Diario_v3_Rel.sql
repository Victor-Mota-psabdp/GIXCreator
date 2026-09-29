SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Dupont_Tracking_Diario_v3_Rel]
 @Grupo varchar(50),
 @DtInicial datetime,
 @DtFinal datetime
as

Declare @Cd_Grupo varchar(10)

set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = @Grupo)

exec spATL_CalculaPercentual_Ins @Cd_Grupo

Declare @Temp table(
[BDP Ref.] varchar(16),
[Register Date] datetime,
[Requisição do Cliente - Number] varchar(200),
[Order Received - Date] datetime,
[PO Number] varchar(500),
[Order Date] datetime,
--[SAP Number]varchar(50),
[Order Type] varchar(500),
[Customer PO] varchar(500),
[Product ID]varchar(500),
[Product Description] varchar(2000),
[NCM] varchar(200),
[UOM] varchar(200),
[Qty] float,
[UNIT Price] float,
[Invoice Value]float,
[Invoice Currency] varchar(200),
[Manufacturer] varchar(200),
[Country Manufacturer]varchar(200),
[Shipper] varchar(200),
[Shipper Address]varchar(200),
[Country of Origin] varchar(200),
[Consignee] varchar(200),
[Consignee Address] varchar(200),
[Modal] varchar(200),
[Incoterm] varchar(200),
[Origin] varchar(200),
[Destination] varchar(200),
[Booking Request Date] datetime,
[Booking Number] varchar(200),
[Booking Confirmation Date] datetime,
--[ETD Promised] varchar(50),
[ETD - Date] datetime,
[ETA - Date] datetime,
[ETA - Promised] datetime,
[GR Requested - Date] datetime,
[Customer Partner] varchar(200),
[LI Request - Date] datetime,
[LI Date] datetime,
[Import License] varchar(400), -- Alessandra
[LI Expired - Date] datetime,
[Green light - Date] datetime,
[Copy of Docs Received - Date] datetime,
[Invoice] varchar(200),
[Master] varchar(200),
[Freight Type] varchar(200),
[Freight - USD] varchar(200),
[Carrier] varchar(200),
[Vessel] varchar(200),
[Containers]varchar(2000),
[Container Type] varchar(200),
[Container Qty] varchar(200),
[Docs Received Date] datetime,
[Unloaded Date] datetime,
[Terminal Pier Name] varchar(200),
[Terminal] varchar(200),
[Inspection MAPA - Date] datetime,
[Def. LI - Date] datetime,
[Customs Transmission Date] datetime,
[Entry Number] varchar(200),
[NF Number] varchar(200),
[NF Date] datetime,
[Transport. Doc Delivery Date] datetime,
[Loading at the Terminal] datetime,
[Inland trucker] varchar(200),
[Good Receipt Date - Estimated] datetime,
[Good Receipt Date - Actual] datetime,
[GR - Date] datetime,
[Container Returned] datetime,
[Days at the Port] varchar(200),
[Last Historic] varchar(2000),
[Last Update] datetime,
[Process Status] varchar(200),
[Transshipment Arrival - Date] datetime,
[Transshipment Departure - Date] datetime,
--[CIF Value] float,
[Reponsible PO] varchar(200),
[Packing] varchar(200),
[Reason Code Events] varchar(300),
[Customer arquive Number] varchar(200),
[Archived(Y/N)] varchar(200),
[Order Reference] varchar(200),
[Processo Critico(Y/N)] varchar(200),
[Group Name] varchar(200),
[Country of Destination] varchar(100),
[CSR Name] varchar(200),
[PO Request Delivery Date] datetime,
[ETA Requested Date] datetime,
[Plant ID] varchar(100),
[Item] varchar(200),
[Net Weight KG] float,
[Gross Weight KG] float,
[FOB Value] float,
[Voyage] varchar(200),
[ATD Date] datetime,
[ATA Date] datetime,
[CNPJ] varchar(200),
[Type of Cargo] varchar(200),
[Netweight KG- Shipment] float,
[Gross Weight - Shipment - Value] float,
[Volume M3] Float,
[BL Pieces] float,
[Freight Currency] varchar(200),
[Freight BL] varchar(200),
[Original ETA - Date] datetime,
[Notes] varchar(1000),
[BDP Product] varchar(200),
[Despacho] varchar(200),
[Necessidade de LI?] varchar(10),
[LI - Type] varchar(200),
[Government Agency] varchar(200),
[Invoice Date] datetime,
[Container Yard Request Date] datetime,
[Port Entry Date] datetime,
[Protocol MAPA IN26 date] datetime,
[Post Import License Release date] datetime,
[Customs Clearance Date] datetime,
[Channel] varchar(200),
[ICMS Payment Date] datetime,
[ICMS Exoneration Date] datetime,
[Protocol at the Tax Office date] datetime,
[Gross Weight - NF] varchar(200),
[Return Terminal] varchar(200),
[Demurrage Period] varchar(200),
[Demurrage Value] float,
[Aprovação de Draft (copias)] datetime,
[Status DITS] varchar(200),
[Pré-alerta enviado] datetime,
[Nº Protocolo MAPA] varchar(200),
[Delivery Address] varchar(MAX),
cd_produto varchar(200),
cd_pedido varchar(200),
Item_Pedido varchar(200)
)

insert @Temp
Select
HOU.Num_Proc [BDP Ref.],
convert(datetime,HOU.dt_emis,103) [Register Date],
CP170.Campo_Dados [Customer Request - Number],
TP50.Dt_Conclusao [Order Received - Date],
P.Num_PO + '-L'+PD.Item [PO Number],
P.Dt_Pedido [Order Date],
--HOU.SAP_ShipNumber [SAP Number],
(Case when P.Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'I' then 'Third' else
			Case when P.Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'E' then 'Indent' else
			Case when P.Cd_Tipo = '3' then 'Inter-company' else
			Case when P.Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End)[Order Type],
P.Customer_PO [Customer PO],
PC.cd_Proc_Cliente [Product ID],
PC.Produto_Descr [Product Description],
PD.NCM [NCM],
PD.UoM [UOM],
PD.Qty [Qty],
PD.Vlr_Item [UNIT Price],
cast(cast(HOU.vlr_Invoice as Decimal(18,2)) as varchar(25)) [Invoice Value],
HOU.Moeda_invoice [Invoice Currency],
PM.Nome_Raz_Soc [Manufacturer],
PF.Nome_Pais [Country Manufacturer],
SH.Nome_Raz_Soc [Shipper],
left((isnull(EDSH.rua,' ') + isnull(EDSH.numero,' ') + isnull(EDSH.Cidade,'')),150) [Shipper Address],
POrigem.Nome_Pais [Country of Origin],
CS.Nome_Raz_Soc [Consignee],
left((isnull(EDCS.rua,' ') + isnull(EDCS.numero,' ') + isnull(EDCS.Cidade,'')),150) [Consignee Address],
HOU.Modal [Modal],
HOU.Cd_Tp_Oper [Incoterm],
Org.Nome_Local [Origin],
Dst.Nome_Local [Destination],
TP58.Dt_Conclusao [Booking Request Date],
HOU.Booking_Number [Booking Number],
TP5.Dt_Conclusao [Booking Confirmation Date],
--'***Add. Fields**' [ETD Promised],
HOU.ETD [ETD - Date],
HOU.ETA [ETA - Date],
convert(datetime,CP171.Campo_Dados,103) [ETA - Promised],--incluido o convert - 17/05-09:58
--TP221.Dt_Conclusao	[GR Requested - Date],
convert(datetime,CP177.Campo_Dados,103) [GR Requested - Date],
CP172.Campo_Dados  [Customer Partner],
TP46.Dt_Conclusao [LI Request - Date],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,23) as datetime) [LI Date],
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'23'),400) [Import License], -- alessandra
(select max(dt_vencimento) from solicitacao_li with(nolock) where num_proc=HOU.Num_Proc) [LI Expired - Date],
TP46.Dt_Conclusao [Green light - Date],
TP109.Dt_Conclusao [Copy of Docs Received - Date],
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80) [Invoice],
HOU.MAWB [Master],
HOU.Tipo_Frete [Freight Type],
--cast(cast(NCD.Vlr_Frete as decimal(10,2)) * cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto) as decimal(18,10)) as decimal(18,10)) [Freight - USD],
HOU.Frete_BL [Freight - USD],
(Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IA' then CIA.Nome_Cia_Aer else
 Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IM' then CRM.Nome_Armador else
 Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IO' then CRO.Apelido END END END) [Carrier],
HOU.Vessel [Vessel],
left(dbo.[fBusca_Containers_IM](HOU.Num_Proc),2000) [Containers],
left([dbo].[fBusca_Containers_TP](HOU.Num_Proc),120) [Container Type],
[dbo].[Qty_Container](HOU.Num_Proc) [Container Qty],
TP16.Dt_Conclusao [Docs Received Date],
TP29.Dt_Conclusao [Unloaded Date],
TP.Descricao_OP [Terminal Pier Name],
T.Nome_Terminal [Terminal],
TP105.Dt_Conclusao [Inspection MAPA - Date],
TP20.Dt_Conclusao [Def. LI - Date],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Customs Transmission Date],
left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,4),100) [Entry Number],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [NF Number],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [NF Date],
TP7.Dt_Conclusao [Transport. Doc Delivery Date],
TP223.Dt_Conclusao [Loading at the Terminal],
IT.Apelido [Inland trucker],
TP13.Dt_Previsao [Good Receipt Date - Estimated],
TP13.Dt_Conclusao [Good Receipt Date - Actual],
TP222.Dt_Conclusao [GR - Date],
(select max(dt_devolucao) from Container_Additional_Info with (nolock) where num_proc = HOU.Num_Proc) [Container Returned],
datediff(DAY,ISNULL(TP223.Dt_Conclusao, GETDATE()), HOU.ATA) [Days at the Port],
left(dbo.fBusca_HistoricoDescr(HOU.Num_Proc,0,getdate()),2000)   [Last Historic],
(select max(ExcDataAlt) from exchange with (nolock) where ExcProcesso = HOU.Num_Proc) [Last Update],
cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao [Process Status],
TP38.Dt_Conclusao [Transshipment Arrival - Date],
TP37.Dt_Conclusao [Transshipment Departure - Date],
--NULL [CIF Value],
UC.Nome_usuario [Reponsible PO],
NULL [Packing],--update
dbo.fBusca_ListNC_Compl(HOU.Num_Proc) [Reason Code Events],
CP173.Campo_Dados [Customer Arquive Number],
(case when (CP173.Campo_Dados is NULL or CP173.Campo_Dados = '') then 'NO' else 'YES' end) [Archived(Y/N)],
P.Num_Pedido [Order Reference],
(Case when CP36.Campo_Dados = 1 then 'YES' else 'NO' END) [Processo Critico(Y/N)],
@Grupo [Group Name],
PDst.Nome_Pais [Country of Destination],
u.Nome_Usuario [CSR Name],
HOU.PO_Req_Date [PO Request Delivery Date],
HOU.Original_ETA [ETA Requested Date],
ISNULL(cast(Planta as varchar(50)),cast(PLL.CD_PLANTA as varchar(50))) [Plant ID],
PS.Item [Item],
(case when PD.Peso_UOM = 'LB' then PD.peso_liquido_tot * 0.4536 else	
			peso_liquido_tot end)[Net Weight KG],
(case when PD.Peso_UOM = 'LB' then	PD.peso_bruto_tot * 0.4536 else
			peso_bruto_tot	end)[Gross Weight KG],
PDC.Vlr_FOB [FOB Value],
HOU.Viagem [Voyage],
HOU.ATD [ATD Date],
HOU.ATA [ATA Date],
substring(CS.num_cpf_cnpj,1,2) + '.' + substring(CS.num_cpf_cnpj,3,3) + '.' + substring(CS.num_cpf_cnpj,6,3) + '/' + substring(CS.num_cpf_cnpj,9,4) + '-' + substring(CS.num_cpf_cnpj,13,2) [CNPJ],
(Case when SUBSTRING(HOU.Num_Proc,1,2) = 'IA' then 'LCL' else TC.Nome_Tp_Carga end) [Type of Cargo],
HOU.Peso_Liquido [Netweight KG- Shipment],
HOU.Peso_Bruto [Gross Weight - Shipment - Value],
HOU.Vol_tot [Volume M3],
HOU.Qtd_Vol [BL Pieces],
TM.Nome_Tp_Moeda [Freight Currency],
HOU.Moeda_Frete + REPLACE(REPLACE(REPLACE(CONVERT(varchar(20),CONVERT(money,Frete_BL), 1),'.','?'),',','.'),'?',',')[Freight BL],
HOU.original_eta [Original ETA - Date],
left(HOU.Notas,400) [Notes],
BDP.Nome_BDP_Produto [BDP Product],
(Case when CP32.Campo_Dados = 1 then 'YES' else 'NO' END) [Despacho],
(Case when CP5.Campo_Dados = 1 then 'YES' else 'NO' END)[Necessidade de LI?],
NULL [LI - Type],
NULL [Government Agency],
dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,2) [Invoice Date],
TP42.Dt_Conclusao [Container Yard Request Date],
TP15.Dt_Conclusao [Port Entry Date],
TP216.Dt_Conclusao [Protocol MAPA IN26 date],
TP175.Dt_Conclusao [Post Import License Release date],
TP4.Dt_Conclusao [Customs Clearance Date],
HOU.Canal [Channel],
TP24.Dt_Conclusao [ICMS Payment Date],
TP61.Dt_Conclusao [ICMS Exoneration Date],
TP204.Dt_Conclusao [Protocol at the Tax Office date],
NULL [Gross Weight - NF],
TCP3.Nome_Terminal [Return Terminal],
CP102.Campo_Dados [Demurrage Period],
null [Demurrage Value],
TP41.Dt_Conclusao [Aprovação de Draft (copias)],
(Case when CP182.Campo_Dados = 1 then 'YES' else 'NO' END) [Status DITS],
TP1.Dt_Conclusao [Pré-alerta enviado],
CP184.Campo_Dados [Nº Protocolo MAPA],
CP146.Campo_Dados [Delivery Address],
PS.cd_produto,
PS.cd_pedido,
PS.Item

from vwHouse_Imp HOU with(nolock)
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
left join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
left join Pedido_Det PD with(nolock) on P.Cd_pedido = PD.Cd_Pedido and PS.cd_produto = PD.Cd_Produto and PS.Item = PD.Item and PS.Lote = PD.Lote
left join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod
left join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item
left join Pessoa PM with(nolock) on PM.Cd_Pes = PDC.cd_pes_fabricante
left join Pais PF with(nolock) on PF.Cd_Pais = PDC.cd_pais_fabricante
left join Pessoa SH with(nolock) on HOU.Cd_Export = SH.Cd_Pes
left join Endereco EDSH with(nolock) on SH.Cd_Pes = EDSH.Cd_Pes
left Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst
left Join Pais PDst with(nolock) on PDst.cd_pais=Dst.cd_pais
left join Pessoa CS with(nolock) on HOU.Cd_Consig = CS.Cd_Pes
left join Endereco EDCS with(nolock) on CS.Cd_Pes = EDCS.Cd_Pes
left join Tarefas_Processos TP50 with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task =50
left join Tarefas_Processos TP58 with(nolock) on HOU.Num_Proc = TP58.Num_Proc and TP58.ID_Task =58
left join Tarefas_Processos TP5 with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task =5
left join Tarefas_Processos TP46 with(nolock) on HOU.Num_Proc = TP46.Num_Proc and TP46.ID_Task =46
left join Tarefas_Processos TP39 with(nolock) on HOU.Num_Proc = TP39.Num_Proc and TP39.ID_Task =39
left join Tarefas_Processos TP109 with(nolock) on HOU.Num_Proc = TP109.Num_Proc and TP109.ID_Task =109
left join Tarefas_Processos TP16 with(nolock) on HOU.Num_Proc = TP16.Num_Proc and TP16.ID_Task =16
left join Tarefas_Processos TP29 with(nolock) on HOU.Num_Proc = TP29.Num_Proc and TP29.ID_Task =29
left join Tarefas_Processos TP105 with(nolock) on HOU.Num_Proc = TP105.Num_Proc and TP105.ID_Task =105
left join Tarefas_Processos TP20 with(nolock) on HOU.Num_Proc = TP20.Num_Proc and TP20.ID_Task =20
left join Tarefas_Processos TP7 with(nolock) on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task =7
left join Tarefas_Processos TP13 with(nolock) on HOU.Num_Proc = TP13.Num_Proc and TP13.ID_Task =13
left join Tarefas_Processos TP38 with(nolock) on HOU.Num_Proc = TP38.Num_Proc and TP38.ID_Task =38
left join Tarefas_Processos TP37 with(nolock) on HOU.Num_Proc = TP37.Num_Proc and TP37.ID_Task =37
--left join Tarefas_Processos TP221 with(nolock) on HOU.Num_Proc = TP221.Num_Proc and TP221.ID_Task =221
left join Tarefas_Processos TP222 with(nolock) on HOU.Num_Proc = TP222.Num_Proc and TP222.ID_Task =222
left join Tarefas_Processos TP223 with(nolock) on HOU.Num_Proc = TP223.Num_Proc and TP223.ID_Task =223
left join Tarefas_Processos TP42 with(nolock) on HOU.Num_Proc = TP42.Num_Proc and TP42.ID_Task =42
left join Tarefas_Processos TP15 with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task =15
left join Tarefas_Processos TP216 with(nolock) on HOU.Num_Proc = TP216.Num_Proc and TP216.ID_Task =216
left join Tarefas_Processos TP175 with(nolock) on HOU.Num_Proc = TP175.Num_Proc and TP175.ID_Task =175
left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task =4
left join Tarefas_Processos TP24 with(nolock) on HOU.Num_Proc = TP24.Num_Proc and TP24.ID_Task =24
left join Tarefas_Processos TP61 with(nolock) on HOU.Num_Proc = TP61.Num_Proc and TP61.ID_Task =61
left join Tarefas_Processos TP204 with(nolock) on HOU.Num_Proc = TP204.Num_Proc and TP204.ID_Task =204
left join Tarefas_Processos TP41 with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task =41
left join Tarefas_Processos TP1 with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task =1
--left join Nota_Cliente NC with(nolock)	on HOU.Num_Proc = NC.Num_Proc
--left Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf and PD.Cd_Produto = NCD.Cd_Produto
Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=HOU.Cd_Armador
left Join Armador CRM with(nolock) on CRM.cd_armador=HOU.cd_armador
LEft Join Pessoa CRO with(nolock)  on CRO.cd_pes=HOU.cd_armador
left join Campo_Processo CP139 with(nolock)  on CP139.Num_Proc = HOU.Num_Proc and CP139.Id_Campo = 139
left join Campo_Processo CP36 with(nolock)  on CP36.Num_Proc = HOU.Num_Proc and CP36.Id_Campo = 36
left join Campo_Processo CP170 with(nolock)  on CP170.Num_Proc = HOU.Num_Proc and CP170.Id_Campo = 170
left join Campo_Processo CP171 with(nolock)  on CP171.Num_Proc = HOU.Num_Proc and CP171.Id_Campo = 171
left join Campo_Processo CP172 with(nolock)  on CP172.Num_Proc = HOU.Num_Proc and CP172.Id_Campo = 172
left join Campo_Processo CP173 with(nolock)  on CP173.Num_Proc = HOU.Num_Proc and CP173.Id_Campo = 173
left join Campo_Processo CP143 with(nolock)  on CP143.Num_Proc = HOu.Num_Proc and CP143.Id_Campo = 143
left join Campo_Processo CP102 with(nolock)  on CP102.Num_Proc = HOu.Num_Proc and CP102.Id_Campo = 102
left join Campo_Processo CP5 with(nolock)  on CP5.Num_Proc = HOu.Num_Proc and CP5.Id_Campo = 5
left join Campo_Processo CP32 with(nolock)  on CP32.Num_Proc = HOu.Num_Proc and CP32.Id_Campo = 32
left join Campo_Processo CP177 with(nolock)  on CP177.Num_Proc = HOu.Num_Proc and CP177.Id_Campo = 177
left join Campo_Processo CP3 with(nolock) on CP3.id_Campo=3 and CP3.num_proc=HOU.Num_Proc
left join Campo_Processo CP182 with(nolock)  on CP182.Num_Proc = HOu.Num_Proc and CP182.Id_Campo = 182
left join Campo_Processo CP184 with(nolock)  on CP184.Num_Proc = HOu.Num_Proc and CP184.Id_Campo = 184
left join Campo_Processo CP146 with(nolock)  on CP146.Num_Proc = HOu.Num_Proc and CP146.Id_Campo = 146
left join  BDP_Produto BDP with(nolock)  on BDP.ID_PD= CP143.campo_dados 
left join Tipo_operador_Portuario TP with(nolock)  on CP139.Campo_Dados = TP.ID_OP
Left Join Terminal T with(nolock) on T.cd_terminal=Hou.cd_terminal
left join Pessoa IT With(Nolock) on IT.Cd_pes = HOU.Cd_Transportadora
left join Tipo_Status_Processo TSP on TSP.ID_Status = HOU.ID_Status
Left Join DE_PARA_PRODUTO DPC With(nolock) on PC.cd_Proc_Cliente=DPC.GMID and PC.cd_Cliente = DPC.Cd_Cliente
Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo
left Join Usuario U with(nolock) on HOU.cd_usuario = U.Cd_Usuario
left Join Tipo_Carga TC With(Nolock)	on TC.cd_tp_carga=HOU.Tp_Carga
left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Moeda_Frete
Left Join Terminal TCP3 with(nolock) on CP3.campo_dados=TCP3.cd_terminal
where  (PG.Apelido like @Grupo or @Grupo ='Grupo ALL') and convert(datetime,HOU.dt_emis,103) between @DtInicial and @DtFinal and HOU.ID_Status not in ('9','8')

-- Faturamento criado

--NOTA FISCAL
--Declare @TempNF table(
--	Num_Proc varchar(16),
--	Cd_Proc_cliente varchar(50),
--	Vlr_Frete float,
--	FOB float
--)
--insert @TempNF
--			select 
--				NC.Num_Proc,
--				PC.Cd_Proc_cliente,
--				cast(sum(Vlr_Frete) as decimal(10,2)) Vlr_Frete,
--				cast(cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as decimal(18,2)) as varchar(40)) FOB				
--			from @Temp T
--				join Nota_Cliente NC with(nolock) on T.[BDP Ref.] = NC.Num_Proc
--				Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf
--				Join Produto_Cliente PC with(nolock)  on cd_produto=cd_prod
--			Where Cd_Proc_cliente=T.[Product ID]
--			Group by num_proc,cd_proc_Cliente

--update T set  
--T.[Freight - USD] = NF.Vlr_Frete *(case when CP31.campo_dados is null or CP31.campo_dados = '' then 0 else cast(CP31.campo_dados as decimal(18,4)) end),
--T.[CIF Value] = NF.FOB + isnull(C.Vlr_Item_Custo,0)
--from @Temp T
--left join @TempNF NF on T.[BDP Ref.] = NF.Num_Proc and T.[Product ID] = NF.Cd_Proc_cliente
--join Campo_Processo CP31 with(nolock) on T.[BDP Ref.] = CP31.Num_Proc  and CP31.Id_Campo = 31
--Join Produto_Cliente CC with(nolock)  on CC.cd_Proc_Cliente = T.[Product ID] and CC.cd_Cliente = @Cd_Grupo
--left join Custo_Cliente C with(nolock) on C.Num_Proc = T.[BDP Ref.] and CC.cd_prod = C.Cd_Produto
--left Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx and nome_tp_Tx like '%Seguro%'
--where (campo_dados is null or campo_dados = '')

update T set T.Packing = TE.Nome_Tp_Embal from @Temp T
join vwVolume_Imp EMB with(nolock) on EMB.Num_Proc = T.[BDP Ref.]
left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal


update T set T.[LI - Type]= cast(id_tipo as varchar(2)) + '-' + Nome_Tp_LI, [Government Agency] = COALESCE([Government Agency] +';','')+ ltrim(rtrim(nome_orgao_anuente)) from @Temp T
join  solicitacao_li SL with(nolock) on SL.Num_Proc = T.[BDP Ref.]
left join solicitacao_li_orgao_anuente SLA with(nolock) on SL.num_solicitacao=SL.num_solicitacao
left join  Orgao_Anuente OA with(nolock) on OA.ID_orgao=SLA.id_orgao_anuente
left Join Tipo_LI TL on TL.id_Tipo=SL.id_tipo_li

update T set [Demurrage Value] = C.vlr_item_Custo*P.Percentual from @Temp T 
Join (select C.Num_Proc, sum(vlr_item_Custo)vlr_item_Custo from @Temp T
					join Custo_Cliente C with(nolock) on C.Num_Proc = T.[BDP Ref.]
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					where nome_tp_Tx like 'Demurrage%' group by C.Num_Proc )C on C.Num_Proc = T.[BDP Ref.]
join Percentual_Produto_Hexion P on P.Num_Proc = T.[BDP Ref.] and P.Cd_Pedido = T.cd_pedido and P.Cd_Produto = T.Cd_Produto and P.Item = T.Item_Pedido



					

	
					
					
--UPDATE A
--SET [Account Balance] = B.[Account Balance],
--    [Last Transaction Date] = B.[Last Transaction Date]
--FROM [dbo].[Account Balance] A INNER JOIN 
--(SELECT [Account Number], SUM([Transaction Amount]) AS [Account Balance],
--        MAX([Transaction Date]) AS [Last Transaction Date]
-- FROM [dbo].[Account Transaction]
-- GROUP BY [Account Number]) B
--ON A.[Account Number] = B.[Account Number]
/*
select [BDP Ref.],
[Register Date],
[Order Type],
[Incoterm],
[Group name],
[Requisição do Cliente - Number],
[Order Reference],
[Country of Origin],
--[Country of Destination],
[Consignee],
[Customer PO],
[PO Number],
[CSR Name],
[Order Date],
[PO request delivery date],
[ETA requested date],
[Reponsible PO],
[Plant ID],
[Modal],
[Item],
[Product ID],
[Product Description],
[UOM],
[Qty],
[UNIT Price],
[Gross Weight KG],
[Net Weight KG],
[NCM],
[Manufacturer],
[Country Manufacturer],
[Packing],
[FOB value],
[Booking Confirmation Date],
[Master],
[Shipper],
[Shipper Address],
[CNPJ],
[Consignee Address],
[Origin],
[Destination],
[Carrier],
[Vessel],
[Voyage],
[ETD - Date],
[ATD Date],
[ETA - Date],
[ATA Date],
[Type of cargo],
[Netweight KG- Shipment],
[Gross Weight - Shipment - Value],
[Volume M3],
[BL Pieces],
[Freight Currency],
[Freight BL],
[Freight Type],
[Original ETA - Date],
[Notes],
[Process Status],
[GR Requested - Date],
[Customer Partner],
[BDP Product],
[Despacho],
[Necessidade de LI?],
[LI - Type],
[Government Agency],
--[Booking Confirmation Date],
[Copy of Docs Received - Date],
[Invoice],
[Invoice Currency],
[Invoice Value],
[Invoice Date],
[Docs Received Date],
[Container Qty],
[Container Type],
[Containers],
[Container Yard Request Date] [Data da Redestinação],
[Terminal Pier Name],
[Terminal],
[LI Request - Date],
[LI Date],
[Import License],
[LI Expired - Date],
[Port Entry Date],
[Unloaded Date],
[Protocol MAPA IN26 date],
[Inspection MAPA - Date],
[Post Import License Release date],
[Customs Transmission Date] [Data do registro da  DI],
[Entry Number] [Numero da DI],
[Customs Clearance Date],
[Channel],
[ICMS Payment Date],
[ICMS Exoneration Date],
[Protocol at the Tax Office date],
[NF Number],
[NF Date],
--[Gross Weight - NF],
[Transport. Doc Delivery Date],
[Loading at the Terminal],
[Days at the Port],
[Inland trucker],
[Good Receipt Date - Actual] [Entrega na planta],
[GR - Date],
[Return Terminal],
[Container Returned],
[Demurrage Period],
[Demurrage Value],
[Last Historic],
[Last Update],
--[Transshipment Arrival - Date],
--[Transshipment Departure - Date],
[Reason Code Events],
[Customer arquive Number],
[Archived(Y/N)],
[Processo Critico(Y/N)] from @Temp
*/
select 
[Group name],
[CSR Name],
[Order Type],
[Reponsible PO],
[Process Status],
[Processo Critico(Y/N)],
[Register Date],
[Requisição do Cliente - Number],
[Order Date],
[Customer PO],
[Order Reference],
[PO Number],
[Item],
[BDP Ref.],
[Product Description],
[Product ID],
[NCM],
[Qty],
[UOM],
[Gross Weight KG],
[Net Weight KG],
[Packing],
[UNIT Price],
[FOB value],
[Invoice],
[Invoice Currency],
[Invoice Value],
[Invoice Date],
[Manufacturer],
[Country Manufacturer],
[Shipper],
[Shipper Address],
[Country of Origin],
[Plant ID],
[Consignee],
[CNPJ],
[Consignee Address],
[Modal],
[Incoterm],
[Origin],
[Destination],
[Booking Confirmation Date],
[ETD - Date],
[ATD Date],
[ETA requested date],
[ETA - Date],
[Master],
[Carrier],
[Vessel],
[Voyage],
[Type of cargo],
[Container Qty],
[Container Type],
[Containers],
[Freight Currency],
[Freight BL],
[Freight Type],
[Copy of Docs Received - Date],
[Aprovação de Draft (copias)],
[Docs Received Date],
[Status DITS],
[Pré-alerta enviado],
[Necessidade de LI?],
[LI - Type],
[Government Agency],
[LI Request - Date],
[LI Date],
[Import License],
[LI Expired - Date],
[Post Import License Release date],
[Protocol MAPA IN26 date],
[Nº Protocolo MAPA],
[Original ETA - Date],
[ATA Date],
[Terminal Pier Name],
[Container Yard Request Date] [Redestinação],
[Terminal],
[Port Entry Date],
[Unloaded Date],
[Inspection MAPA - Date],
[Customs Transmission Date] [Data do registro da  DI],
[Entry Number] [Numero da DI],
[Customs Clearance Date],
[Channel],
[ICMS Payment Date],
[ICMS Exoneration Date],
[Protocol at the Tax Office date],
[NF Number],
[NF Date],
[Transport. Doc Delivery Date],
[Loading at the Terminal],
[PO request delivery date],
[GR Requested - Date],
[Good Receipt Date - Actual] [Entrega na Planta],
[GR - Date] [GR Actual],
[Days at the Port],
[Inland trucker],
[Return Terminal] [Data de devolução do vazio],
[Container Returned],
[Demurrage Period],
[Demurrage Value],
[Last Update],
[Last Historic],
[Notes],
[Customer Partner],
[BDP Product],
[Despacho],
[Reason Code Events],
[Customer arquive Number],
[Archived(Y/N)],
[Delivery Address] 
from @Temp


GO
