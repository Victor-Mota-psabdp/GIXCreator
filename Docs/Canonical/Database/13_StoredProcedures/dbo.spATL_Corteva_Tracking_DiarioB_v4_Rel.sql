SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE   procedure [dbo].[spATL_Corteva_Tracking_DiarioB_v4_Rel] 
--[dbo].[spATL_Corteva_Tracking_DiarioB_v4_Rel]  '2021-08-05','2021-11-03'    
     
 @DtInicial datetime,    
 @DtFinal datetime    
as    
  
/*    
- Reported created by Anderson Oliveira 06.26.2019 requested by Marcia Silva    
- 01.17.2020 - Changed the historic by Anderson       
*/    
    
/*  
SLA    
 Dupont = 10 dias da ATA vs GR Efetivo (Mar) / Urgent (n=15 / y=10) / 8 = Air / 13 = Rodoviario    
 Dow =15 dias ATA vs GR efeito (DMA 160 = 15 dias)
*/    
    
    
Declare @Cd_Grupo varchar(10)    
Declare @Grupo varchar(50)    
set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = 'GRUPO CORTEVA')        
exec spATL_CalculaPercentual_Ins @Cd_Grupo  

    
    
    
Declare @Temp table(    
[BDP Ref.] varchar(16),    
[Register Date] datetime,    
[Requisição do Cliente - Number] varchar(200),    
[Order Received - Date] datetime,    
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
[Import License] varchar(400),    
[Green light - Date] datetime,    
[Invoice] varchar(200),    
[Master] varchar(200),    
[House] varchar(200),-- Alessandra 06/08/2019    
[Freight Type] varchar(200),    
[Freight - USD] varchar(200),    
[Carrier] varchar(200),    
[Vessel] varchar(200),    
[Containers]varchar(2000),    
[Container Type] varchar(200),    
[Container Qty] varchar(200),    
[Docs Received Date] datetime,    
[Unloaded Date] datetime,    
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
[Container Returned CC] varchar(10), 
[Container Returned] datetime,    
[Days at the Port] varchar(200),    
[Last Historic] varchar(2000),    
[Process Status] varchar(200),    
[Transshipment Arrival - Date] datetime,    
[Transshipment Departure - Date] datetime,    
--[CIF Value] float,    
[Reponsible PO] varchar(200),    
[Packing] varchar(200),    
[Reason Code Events] varchar(300),    
[Order Reference] varchar(200),    
[Processo Critico(Y/N)] varchar(200),    
[Country of Destination] varchar(100),    
[CSR Name] varchar(200),    
[PO Request Delivery Date] datetime,    
[ETA Requested Date] datetime,    
[Plant ID] varchar(100),    
[Item] varchar(200),    
[Net Weight KG] float,    
[Gross Weight KG] float,    
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
[Freight BL VALUE] float,  --Beatriz 09/09/2021 criando o mesmo campo tipo float para fazer a conta
[Original ETA - Date] datetime,    
[Notes] varchar(1000),    
[BDP Product] varchar(200),    
[Despacho] varchar(200),    
[Necessidade de LI?] varchar(10),    

[Invoice Date] datetime,    
[Container Yard Request Date] datetime,    
[Port Entry Date] datetime,    
[Protocol MAPA IN26 date] datetime,    
[Post Import License Release date] datetime,    
[Customs Clearance Date] datetime,    
[Channel] varchar(200),    
[Gross Weight - NF] varchar(200),    
[Demurrage Period] varchar(200), 

[Demurrage Value] float,    
[Aprovação de Draft (copias)] datetime,    
[Pré-alerta enviado] datetime,    
[Nº Protocolo MAPA] varchar(200),    
[Delivery Address] varchar(MAX),    
cd_produto varchar(200),    
cd_pedido varchar(200),    
Item_Pedido varchar(200),    
[GR Original] datetime, -- ALESSANDRA 06/08/2019    
[Documentos OK para Registro] datetime, -- ALESSANDRA 06/08/2019    
[MADEIRA LIBERADA] datetime, -- ALESSANDRA 06/08/2019    
[SLA Calculado] Datetime,    
[SLA Ontime] Varchar(20),    
[Responsability] Varchar(50),   
[Free Time] varchar(500),   --Marcela 11/06/2020 |#100-194127 (inserção free time, responsability,calculo sla) 
[Taxa Moeda da Fatura] float, --Bia 25/08/2021 |#100-293089 (criar campos taxa moeda da fatura, taxa moeda do frete, PRG e margem)
[Taxa Moeda do Frete] float, 
[Valor PRG]float,
[Margem] varchar(100),
[Liberação de BL] datetime, --Bia 05/10/2021 |#100-293089 (criar campos: Liberação de BL e Courier Number)
[Valor PGR R$] float,
[Courier Number] varchar(100)
)       
insert @Temp    
Select    
HOU.Num_Proc [BDP Ref.],    
convert(datetime,HOU.dt_emis,103) [Register Date],    
CP170.Campo_Dados [Customer Request - Number],    
TP50.Dt_Conclusao [Order Received - Date],    
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
convert(datetime,CP177.Campo_Dados,103) [GR Requested - Date],    
CP172.Campo_Dados  [Customer Partner],    
TP46.Dt_Conclusao [LI Request - Date],    
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,23) as datetime) [LI Date],    
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'23'),400) [Import License],    
TP46.Dt_Conclusao [Green light - Date],    
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80) [Invoice],    
    
case when Modal = 'Other Import' then    
HOU.HAWB     
else    
HOU.MAWB     
end as [Master],    
HOU.HAWB [House], -- Alessandra 06/08/2019    
HOU.Tipo_Frete [Freight Type],    
--cast(cast(NCD.Vlr_Frete as decimal(10,2)) * cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto) as decimal(18,10)) as decimal(18,10)) [Freight - USD],   
 
HOU.Frete_BL [Freight - USD],    
(Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IA' then CIA.Nome_Cia_Aer else    
 Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IM' then CRM.Nome_Armador else    
 Case When SUBSTRING(HOU.Num_Proc,1,2) = 'IO' then CRO.Apelido END END END) [Carrier],    
--HOU.Vessel [Vessel], -- Beatriz e Alessandra 22/09/21 
Case SUBSTRING(HOU.Num_Proc,1,2) 
when 'IA' then 'N/A'
when 'IO' then 'N/A'
ELSE HOU.Vessel end [Vessel],
--left(dbo.[fBusca_Containers_IM](HOU.Num_Proc),2000) [Containers], -- Beatriz 22/09/21   
Case SUBSTRING(HOU.Num_Proc,1,2) 
when 'IA' then 'N/A'
when 'IO' then 'N/A'
else left(dbo.[fBusca_Containers_IM](HOU.Num_Proc),2000) end [Containers],
--left([dbo].[fBusca_Containers_TP](HOU.Num_Proc),120) [Container Type],-- Beatriz 22/09/21
Case SUBSTRING(HOU.Num_Proc,1,2) 
when 'IA' then 'N/A'
when 'IO' then 'N/A'
else left([dbo].[fBusca_Containers_TP](HOU.Num_Proc),120) end [Container Type],
--[dbo].[Qty_Container](HOU.Num_Proc) [Container Qty], -- Beatriz 22/09/21
Case SUBSTRING(HOU.Num_Proc,1,2) 
when 'IA' then 'N/A'
when 'IO' then 'N/A'
else cast([dbo].[Qty_Container](HOU.Num_Proc) as varchar(10))  end [Container Qty],
TP16.Dt_Conclusao [Docs Received Date],    
TP29.Dt_Conclusao [Unloaded Date],    
T.Nome_Terminal [Terminal],    
TP105.Dt_Conclusao [Inspection MAPA - Date],    
TP20.Dt_Conclusao [Def. LI - Date],    
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Customs Transmission Date],    
--left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,4),100) [Entry Number], -- Alessandra 07/08/2019    
null as [Entry Number],    
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [NF Number],    
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [NF Date],    
TP7.Dt_Conclusao [Transport. Doc Delivery Date],    
TP223.Dt_Conclusao [Loading at the Terminal],    
IT.Apelido [Inland trucker],    
TP13.Dt_Previsao [Good Receipt Date - Estimated],    
TP13.Dt_Conclusao [Good Receipt Date - Actual],    
TP222.Dt_Conclusao [GR - Date],   
[dbo].[fBusca_Containers_Data_Devolucao](HOU.Num_Proc) [Container Returned CC],
(select max(dt_devolucao) from Container_Additional_Info with (nolock) where num_proc = HOU.Num_Proc) [Container Returned],    
datediff(DAY,ISNULL(TP223.Dt_Conclusao, GETDATE()), HOU.ATA) [Days at the Port],    
left(dbo.fBusca_HistoricoDescr(HOU.Num_Proc,116,getdate()),2000)   [Last Historic],    
cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao [Process Status],    
TP38.Dt_Conclusao [Transshipment Arrival - Date],    
TP37.Dt_Conclusao [Transshipment Departure - Date],    
--NULL [CIF Value],    
UC.Nome_usuario [Reponsible PO],    
Te.Nome_Tp_Embal [Packing],--Aleessandra 07/08/2019    
dbo.fBusca_ListNC_Compl(HOU.Num_Proc) [Reason Code Events],    
P.Num_Pedido [Order Reference],    
(Case when CP36.Campo_Dados = 1 then 'YES' else 'NO' END) [Processo Critico(Y/N)],    
PDst.Nome_Pais [Country of Destination],    
u.Nome_Usuario [CSR Name],    
HOU.PO_Req_Date [PO Request Delivery Date],    
--HOU.Original_ETA [ETA Requested Date],    
convert(datetime,CP183.Campo_Dados,103)  [ETA Requested Date],    
ISNULL(cast(Planta as varchar(50)),cast(PLL.CD_PLANTA as varchar(50))) [Plant ID],    
PS.Item [Item],    
(case when PD.Peso_UOM = 'LB' then PD.peso_liquido_tot * 0.4536 else     
   peso_liquido_tot end)[Net Weight KG],    
(case when PD.Peso_UOM = 'LB' then PD.peso_bruto_tot * 0.4536 else    
   peso_bruto_tot end)[Gross Weight KG],    
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
Frete_BL [Freight BL VALUE],
HOU.original_eta [Original ETA - Date],    
left(HOU.Notas,400) [Notes],    
BDP.Nome_BDP_Produto [BDP Product],    
(Case when CP32.Campo_Dados = 1 then 'YES' else 'NO' END) [Despacho],    
(Case when CP5.Campo_Dados = 1 then 'YES' else 'NO' END)[Necessidade de LI?],    
    
dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,2) [Invoice Date],    
TP42.Dt_Conclusao [Container Yard Request Date],
TP15.Dt_Conclusao [Port Entry Date],    
TP216.Dt_Conclusao [Protocol MAPA IN26 date],    
TP175.Dt_Conclusao [Post Import License Release date],    
TP4.Dt_Conclusao [Customs Clearance Date],    
HOU.Canal [Channel],    
NULL [Gross Weight - NF],    
--CP102.Campo_Dados [Demurrage Period],-- Beatriz 23/09/21
Case SUBSTRING(HOU.Num_Proc,1,2) 
when 'IA' then 'N/A'
when 'IO' then 'N/A'
else CP102.Campo_Dados end [Demurrage Period],
null [Demurrage Value], 

TP41.Dt_Conclusao [Aprovação de Draft (copias)],    
    
TP1.Dt_Conclusao [Pré-alerta enviado],    
CP184.Campo_Dados [Nº Protocolo MAPA],    
CP146.Campo_Dados [Delivery Address],    
PS.cd_produto,    
PS.cd_pedido,    
PS.Item,    
P.dl_Chegada [GR Original],-- ALESSANDRA 06/08/2019    
TP63.Dt_Conclusao [Documentos OK para Registro],    
TP164.Dt_Conclusao  [MADEIRA LIBERADA],    
Null [SLA Calculado],     
Null [SLA Ontime] ,    
CP197.Campo_Dados + ' - ' + tsla.Nome_tp_SLA [Responsability],    
CP138.Campo_dados [Free Time]   --Marcela 11/06/2020 |#100-194127 (inserção free time, responsability, calculo sla)  
,MoedaFatura.Par_Moeda [TAXA MOEDA DA FATURA]
,MoedaFrete.Par_Moeda [TAXA MOEDA DO FRETE] 
,Null [VALOR PRG]
--,T.Nome_Terminal [MARGEM]
--		Beatriz 05/10/21 
, (case    
		when T.Nome_Terminal = 'Santos Brasil Log-EADI Santos' then ' Margem Direita'
		when T.Nome_Terminal = 'Santos Brasil Log-EADI Guarujá' then 'Margem Esquerda'
        when T.Nome_Terminal = 'SANTOS BRASIL' then 'Margem Esquerda'
		when SUBSTRING(HOU.Num_Proc,1,2)  = 'IA' then 'N/A'
		when SUBSTRING(HOU.Num_Proc,1,2)  = 'IO' then 'N/A'
  else ''
  end) [MARGEM] 
,TP21.Dt_Conclusao [Liberação de BL]

,NULL [Valor PGR R$]

,Num_Courier[Courier Number]

from vwHouse_Imp HOU with(nolock)  
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig    
join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo    
join pessoa PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo    
left join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc    
left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido 
left join Pedido_Det PD with(nolock) on P.Cd_pedido = PD.Cd_Pedido and PS.cd_produto = PD.Cd_Produto and PS.Item = PD.Item and PS.Lote = PD.Lote    
left join tipo_embalagem TE with(nolock) on Te.cd_tp_embal = PD.cd_tp_embal    
left join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod    
left join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item    
left join Pessoa PM with(nolock) on PM.Cd_Pes = PDC.cd_pes_fabricante    
left join Pais PF with(nolock) on PF.Cd_Pais = PDC.cd_pais_fabricante    
left join Pessoa SH with(nolock) on HOU.Cd_Export = SH.Cd_Pes    
left join Endereco EDSH with(nolock) on SH.Cd_Pes = EDSH.Cd_Pes and EDSH.Cd_Tp_End = 'COM'    
left Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org    
left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais    
left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst    
left Join Pais PDst with(nolock) on PDst.cd_pais=Dst.cd_pais    
left join Pessoa CS with(nolock) on HOU.Cd_Consig = CS.Cd_Pes    
left join Endereco EDCS with(nolock) on CS.Cd_Pes = EDCS.Cd_Pes and EDCS.Cd_Tp_End = 'COM'    
left join Tarefas_Processos TP50 with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task =50    
left join Tarefas_Processos TP58 with(nolock) on HOU.Num_Proc = TP58.Num_Proc and TP58.ID_Task =58    
left join Tarefas_Processos TP5 with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task =5    
left join Tarefas_Processos TP46 with(nolock) on HOU.Num_Proc = TP46.Num_Proc and TP46.ID_Task =46    
left join Tarefas_Processos TP16 with(nolock) on HOU.Num_Proc = TP16.Num_Proc and TP16.ID_Task =16    
left join Tarefas_Processos TP29 with(nolock) on HOU.Num_Proc = TP29.Num_Proc and TP29.ID_Task =29    
left join Tarefas_Processos TP105 with(nolock) on HOU.Num_Proc = TP105.Num_Proc and TP105.ID_Task =105    
left join Tarefas_Processos TP20 with(nolock) on HOU.Num_Proc = TP20.Num_Proc and TP20.ID_Task =20
left join Tarefas_Processos TP21 with(nolock) on HOU.Num_Proc = TP21.Num_Proc and TP21.ID_Task =21 
left join Tarefas_Processos TP7 with(nolock) on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task =7    
left join Tarefas_Processos TP13 with(nolock) on HOU.Num_Proc = TP13.Num_Proc and TP13.ID_Task =13    
left join Tarefas_Processos TP38 with(nolock) on HOU.Num_Proc = TP38.Num_Proc and TP38.ID_Task =38    
left join Tarefas_Processos TP37 with(nolock) on HOU.Num_Proc = TP37.Num_Proc and TP37.ID_Task =37    
left join Tarefas_Processos TP222 with(nolock) on HOU.Num_Proc = TP222.Num_Proc and TP222.ID_Task =222    
left join Tarefas_Processos TP223 with(nolock) on HOU.Num_Proc = TP223.Num_Proc and TP223.ID_Task =223    
left join Tarefas_Processos TP42 with(nolock) on HOU.Num_Proc = TP42.Num_Proc and TP42.ID_Task =42    
left join Tarefas_Processos TP15 with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task =15    
left join Tarefas_Processos TP216 with(nolock) on HOU.Num_Proc = TP216.Num_Proc and TP216.ID_Task =216    
left join Tarefas_Processos TP175 with(nolock) on HOU.Num_Proc = TP175.Num_Proc and TP175.ID_Task =175    
left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task =4    
left join Tarefas_Processos TP41 with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task =41    
left join Tarefas_Processos TP1 with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task =1    
left join Tarefas_Processos TP63 with(nolock) on HOU.Num_Proc = TP63.Num_Proc and TP63.ID_Task =63 -- Alessandra 07/08/2019    
left join Tarefas_Processos TP164 with(nolock) on HOU.Num_Proc = TP164.Num_Proc and TP164.ID_Task = 164 -- Alessandra 07/08/2019    
Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=HOU.Cd_Armador    
left Join Armador CRM with(nolock) on CRM.cd_armador=HOU.cd_armador    
LEft Join Pessoa CRO with(nolock)  on CRO.cd_pes=HOU.cd_armador    
left join Campo_Processo CP139 with(nolock)  on CP139.Num_Proc = HOU.Num_Proc and CP139.Id_Campo = 139    
left join Campo_Processo CP36 with(nolock)  on CP36.Num_Proc = HOU.Num_Proc and CP36.Id_Campo = 36    
left join Campo_Processo CP170 with(nolock)  on CP170.Num_Proc = HOU.Num_Proc and CP170.Id_Campo = 170    
left join Campo_Processo CP171 with(nolock)  on CP171.Num_Proc = HOU.Num_Proc and CP171.Id_Campo = 171    
left join Campo_Processo CP172 with(nolock)  on CP172.Num_Proc = HOU.Num_Proc and CP172.Id_Campo = 172    
left join Campo_Processo CP143 with(nolock)  on CP143.Num_Proc = HOu.Num_Proc and CP143.Id_Campo = 143    
left join Campo_Processo CP102 with(nolock)  on CP102.Num_Proc = HOu.Num_Proc and CP102.Id_Campo = 102    
left join Campo_Processo CP5 with(nolock)  on CP5.Num_Proc = HOu.Num_Proc and CP5.Id_Campo = 5    
left join Campo_Processo CP32 with(nolock)  on CP32.Num_Proc = HOu.Num_Proc and CP32.Id_Campo = 32    
left join Campo_Processo CP177 with(nolock)  on CP177.Num_Proc = HOu.Num_Proc and CP177.Id_Campo = 177    
left join Campo_Processo CP3 with(nolock) on CP3.id_Campo=3 and CP3.num_proc=HOU.Num_Proc    
left join Campo_Processo CP184 with(nolock)  on CP184.Num_Proc = HOu.Num_Proc and CP184.Id_Campo = 184    
left join Campo_Processo CP146 with(nolock)  on CP146.Num_Proc = HOu.Num_Proc and CP146.Id_Campo = 146    
left join Campo_Processo CP183 with(nolock)  on CP183.Num_Proc = HOu.Num_Proc and CP183.Id_Campo = 183    
left join  BDP_Produto BDP with(nolock)  on BDP.ID_PD= CP143.campo_dados     
left join Tipo_operador_Portuario TP with(nolock)  on CP139.Campo_Dados = TP.ID_OP    
Left Join Terminal T with(nolock) on T.cd_terminal=Hou.cd_terminal    
left join Pessoa IT With(Nolock) on IT.Cd_pes = HOU.Cd_Transportadora    
left join Tipo_Status_Processo TSP on TSP.ID_Status = HOU.ID_Status    
Left Join DE_PARA_PRODUTO DPC With(nolock) on PC.cd_Proc_Cliente=DPC.GMID and PC.cd_Cliente = DPC.Cd_Cliente    
Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo    
left Join Usuario U with(nolock) on HOU.cd_usuario = U.Cd_Usuario    
left Join Tipo_Carga TC With(Nolock) on TC.cd_tp_carga=HOU.Tp_Carga    
left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Moeda_Frete    
left join Campo_Processo CP197 with(nolock)  on CP197.Num_Proc = HOu.Num_Proc and CP197.Id_Campo = 197    
left join Campo_Processo CP138 with(nolock) on CP138.Num_Proc = Hou.Num_proc and CP138.Id_campo = 138  
left join Tipo_SLA tsla with(nolock) on tsla.ID_tp_SLA = CP197.Campo_Dados  
  --Marcela 11/06/2020 |#100-194127 (inserção free time, responsability, calculo sla)  
left join VWUltimaParidade MoedaFatura with(nolock) on HOU.Moeda_invoice = MoedaFatura.Cd_Tp_Moeda and MoedaFatura.Cd_Tp_Par = 'OFC'
left join VWUltimaParidade MoedaFrete with(nolock) on HOU.Moeda_Frete = MoedaFrete.Cd_Tp_Moeda and MoedaFrete.Cd_Tp_Par = 'OFC'
left join Courier_Processo CPRO with(nolock) on HOU.Num_Proc = CPRO.Num_Proc
where      
(    
(CS.Apelido like 'DOW AGRO%' or CS.Apelido like 'DUPONT%' or CS.Apelido like 'DU PONT%' OR CS.Apelido = 'DOW - 3770C')    
or    
PG.Apelido = 'GRUPO CORTEVA'    
)     

--- Antonio 23/12/2022 - pegar somente Inter-company e Third.
and P.Cd_Tipo <> '4'   

--and CP36.Campo_Dados <> ''  
--and TP222.Dt_Conclusao <> ''  
--and hou.Num_Proc in('IMDPT201905061BR','IMDPT201904068BR','IMDPT201902031BR','IMDPT201806028BR')

-- Antonio 27/12/2022 
--and hou.Num_Proc in(
--'IMCTV202104168BR',
--'IMCTV202105044BR',
--'IMCTV202203109BR',
--'IMCTV202206047BR',
--'IMCTV202206048BR',
--'IMCTV202206049BR',
--'IMCTV202206050BR',
--'IMCTV202206051BR',
--'IMCTV202206052BR',
--'IMCTV202206008BR',
--'IMCTV202206009BR',
--'IMCTV202208201BR',
--'IMCTV202208096BR',
--'IMCTV202207076BR',
--'IMCTV202206010BR'
--)
    
and convert(datetime,HOU.dt_emis,103) between @DtInicial and @DtFinal     
and HOU.ID_Status not in ('9')    
and P.Num_Pedido not like '%teste%'    
and BDP.Nome_BDP_Produto <> 'Freight Forward'    
--and isnull(TP222.Dt_Conclusao,'2019-01-01')>= '2019-01-01'    
    
-- Pegar tudo que a gr for maior de 01/01/2019 OU que a gr for vazia e que o job creation seja maior de 01/06/2018   
--and ((TP222.Dt_Conclusao >= '2019-01-01') or (TP222.Dt_Conclusao is null and convert(datetime,HOU.dt_emis,103) >= '2018-06-01')) 
--a regra do "Report: Tracking Corteva" para que no relatorio só demonstre job com a coluna "GR Efetivo" em branco ou maior ou igual a 01/01/2022.
and (
		(TP222.Dt_Conclusao >= '2022-01-01') 
	or 
		(TP222.Dt_Conclusao is null)
	)    
     
update T set [Demurrage Value] = C.vlr_item_Custo*P.Percentual from @Temp T     
Join (select C.Num_Proc, sum(vlr_item_Custo)vlr_item_Custo from @Temp T    
     join Custo_Cliente C with(nolock) on C.Num_Proc = T.[BDP Ref.]    
     Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx     
     where nome_tp_Tx like 'Demurrage%' group by C.Num_Proc )C on C.Num_Proc = T.[BDP Ref.]    
join Percentual_Produto_Hexion P on P.Num_Proc = T.[BDP Ref.] and P.Cd_Pedido = T.cd_pedido and P.Cd_Produto = T.Cd_Produto and P.Item = T.Item_Pedido    
     
-- Alessandra 06/08/2019    
update T set [Customer PO] = [Customer Reference] from @Temp T    
join vwPO_Modal_Sel VPO with(nolock) on VPO.job = T.[BDP Ref.]    
WHERE  [doc type CODE] = 9    
   
update T set [Entry Number] = [Customer Reference] from @Temp T    
join vwPO_Modal_Sel VPO with(nolock) on VPO.job = T.[BDP Ref.]    
WHERE  [doc type CODE] = 5    
  
update T     
set [Reponsible PO] = ltrim(rtrim(SUBSTRING([Reponsible PO],1,CHARINDEX('[',[Reponsible PO])-1)))    
from @Temp T    
WHERE CHARINDEX('[',[Reponsible PO])>1     
      
--Standard Ocean = 15 days    
Update @Temp Set    
  [SLA Calculado] =[ATA Date]+15    
where     
 left([BDP Ref.],2)='IM'and [ATA Date] is not null    
  
--Standard Air = 8 days  
Update @Temp Set    
  [SLA Calculado] =[ATA Date]+8    
where     
 left([BDP Ref.],2)='IA'and [ATA Date] is not null    
 
 --Standard Others = 8 days    
Update @Temp Set    
  [SLA Calculado] =[ATA Date]+13    
where     
 left([BDP Ref.],2)='IO'and [ATA Date] is not null    

--- Antonio 23-12-2022 calcular a ATA date -1 ou - 2 dias  
--  para encontar a sexta feira anterior , caso o data seja sabadoo ou domingo  
--10 days for urgent Ocean shipments    
Update @Temp Set 
[SLA Calculado]=(Case When DATEPART(weekday,[ATA Date]+10)  = 1 then [ATA Date]+ 8  else 
				  Case When DATEPART(weekday,[ATA Date]+10) = 7 then [ATA Date]+ 9  else [ATA Date]+ 10				   
				  End End)
where     
 left([BDP Ref.],2) IN ('IM', 'IO')  
 and [ATA Date] is not null    
 AND  [Processo Critico(Y/N)]='YES' 
--- Antonio 23/12/2022 So serve para Dow e Dupont se não mantem os 15 dias 
--- ou acrescenta os Consignee no and abaixo 
-- AND ([Consignee] LIKE 'DU%' OR [Consignee] LIKE 'CORT%' )    
 AND ([Consignee] LIKE 'DU%' OR [Consignee] LIKE 'CORT%' OR [Consignee] LIKE 'CTVA%' )    
    
  
--Standard Others 15 Days for specific product due the Customs procedure    
Update @Temp Set    
  [SLA Calculado] =[ATA Date]+15    
where     
 left([BDP Ref.],2)='IM'and [ATA Date] is not null    
 AND  ([Consignee] LIKE 'DOW%' OR [Consignee] LIKE 'CORTEVA%' )    
 AND [Product ID]='00095249'    
    
  
   /* [GR - Date]  == GR efetivo]   
  [SLA Calculado] == [ATA Date]  
  [ATA Date] == vwHouse_Imp HOU ==  HOU.ATA     
    select HOU.ATA ,* from  vwHouse_Imp HOU   
 where hou.Num_Proc in('IACTV202005001BR','IACTV202004001BR','IMCTV202004151BR','IMCTV202004007BR','IACTV202005004BR','IACTV202003011BR','IMCTV202003057BR','IMCTV202004153BR','IMCTV202004152BR')  
  
  */  
--Set flag on OnTime  

Update @Temp Set    
  [SLA Ontime] ='On time'     
Where  [SLA Calculado] >= [GR - Date]      
 
Update @Temp Set    
  [SLA Ontime] ='Delayed'     
Where  [SLA Calculado] < [GR - Date]  
  
Update @Temp Set    
  [VALOR PRG] = [Invoice Value] + [Freight BL VALUE] * [TAXA MOEDA DA FATURA] 

Update @Temp Set    
  [Valor PGR R$] = 
  (Case 
when [Freight Type] = 'Prepaid' then [Invoice Value]  * [TAXA MOEDA DA FATURA] 
else ([Invoice Value]*[TAXA MOEDA DA FATURA])+([Freight BL VALUE]*[TAXA MOEDA DO FRETE])

end) 
  
    
-- GM 00095249 [Product ID]    
/*    
[SLA Ontime] Varchar(20)    
 [Processo Critico(Y/N)]    
    
 [ATA Date]     
 [GR - Date][GR Efetivo]    
 [Product ID]    
 */    

select     
[CSR Name]     
,[Reponsible PO]     
,[Process Status]     
,[Order Reference]     
,[Customer PO]     
,[Register Date]     
,[BDP Ref.]     
,[Processo Critico(Y/N)]     
,[Order Type]     
,[Product ID]     
,[Product Description]     
,[Item]     
,[NCM]     
,[Necessidade de LI?]      
,[LI Request - Date]     
,[LI Date]     
,[Import License]     
,[UOM]     
,[Qty]     
,[Net Weight KG]     
,[Gross Weight KG]     
    
,[Packing]     
,[UNIT Price]      
,[Invoice]     
,[Invoice Currency]     
,[Invoice Value]     
,[Invoice Date]     
,[Shipper]     
,[Shipper Address]     
,[Manufacturer]     
,[Country Manufacturer]     
,[Country of Origin]     
,[Consignee]     
,[CNPJ]     
,[Consignee Address]     
,[Incoterm]     
,[Modal]     
,[Origin]     
,[Booking Confirmation Date]     
,[ETD - Date]     
,[ATD Date]     
,[Master]     
,[House]     
,[Carrier]     
,[Vessel]     
,[Voyage]     
,[Type of cargo]     
,[Container Qty]     
,[Container Type]     
,[Containers]     
,[Freight Currency]     
,[Freight BL VALUE] [Freight BL]     
,[Freight Type]     
,[ETA requested date]     
,[ETA - Date]     
,[Original ETA - Date]     
,[ATA Date]     
,[Destination]     
,[Container Yard Request Date] [Redestinação]     
,[Docs Received Date]     
,[Aprovação de Draft (copias)]     
,[Documentos OK para Registro]    
,[Pré-alerta enviado]      
,[Nº Protocolo MAPA]     
,[Protocol MAPA IN26 date]     
,[Post Import License Release date]     
,[Terminal]     
,[Port Entry Date]     
,[Inspection MAPA - Date]     
,[MADEIRA LIBERADA]     
,[Customs Transmission Date] [Data do registro da  DI]     
,[Entry Number] [Numero da DI]     
,[Channel]     
,[Customs Clearance Date]     
,[NF Number]     
,[NF Date]     
,[Transport. Doc Delivery Date]     
,[Inland trucker]     
,[Loading at the Terminal]     
,[Days at the Port]     
,[Plant ID]     
,[Delivery Address]     
,[Good Receipt Date - Actual] [Entrega na Planta]    
,[GR Original][GR Original]     
,[GR Requested - Date][GR Previsto]     
,[PO request delivery date][GR Atual]     
,[GR - Date][GR Efetivo] 
,isnull([Container Returned], convert(datetime, [Container Returned CC],103) ) [Data de devolução do vazio]   
--,[Container Returned] [Data de devolução do vazio]    
,[Demurrage Period]     
,[Demurrage Value]     
,[Last Historic]     
,[Notes]     
,[Reason Code Events]     
,[Customer Partner]     
,[BDP Product]     
,[Despacho]     
,[SLA Calculado]     
,[SLA Ontime]    
,[Responsability]    
,[Free Time] 
,[TAXA MOEDA DA FATURA] 
,[TAXA MOEDA DO FRETE]
,[Valor PGR R$]
,[MARGEM] 
,[Liberação de BL]
--,[Valor PGR R$] -- Beatriz 10/11/2021 ticket 100-293089
,[Courier Number]
from @Temp  


GO
