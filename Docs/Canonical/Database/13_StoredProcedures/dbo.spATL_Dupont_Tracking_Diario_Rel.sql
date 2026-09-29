SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Dupont_Tracking_Diario] 'Grupo Dupont', '2018-01-01','2018-04-12'
create procedure [dbo].[spATL_Dupont_Tracking_Diario_Rel]
 @Grupo varchar(50),
 @DtInicial datetime,
 @DtFinal datetime
as

Declare @Cd_Grupo varchar(10)

set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P join Grupo G on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = @Grupo)

--spATL_CalculaPercentual_Ins 'P000031345'
Declare @Temp table(
[BDP Ref.] varchar(16),
[Register Date] datetime,
[Requisição do Cliente - Number] varchar(50),
[Order Received - Date] datetime,
[PO Number] varchar(50),
[Order Date] datetime,
--[SAP Number]varchar(50),
[Order Type] varchar(50),
[Customer PO] varchar(50),
[Product ID]varchar(50),
[Product Description] varchar(500),
[NCM] varchar(50),
[UOM] varchar(50),
[Qty] float,
[UNIT Price] float,
[Invoice Value]float,
[Invoice Currency] varchar(50),
[Manufacturer] varchar(50),
[Country Manufacturer]varchar(50),
[Shipper] varchar(60),
[Shipper Address]varchar(150),
[Country of Origin] varchar(50),
[Consignee] varchar(60),
[Consignee Address] varchar(150),
[Modal] varchar(50),
[Incoterm] varchar(50),
[Origin] varchar(50),
[Destination] varchar(50),
[Booking Request Date] datetime,
[Booking Number] varchar(50),
[Booking Confirmation Date] datetime,
--[ETD Promised] varchar(50),
[ETD - Date] datetime,
[ETA - Date] datetime,
[ETA - Promised] varchar(50),
[GR Requested - Date] varchar(50),
[Customer Partner] varchar(50),
[LI Request - Date] datetime,
[LI Date] datetime,
[Import License] varchar(50),
[LI Expired - Date] datetime,
[Green light - Date] datetime,
[Copy of Docs Received - Date] datetime,
[Invoice] varchar(50),
[Master] varchar(50),
[Freight Type] varchar(50),
[Freight - USD] varchar(50),
[Carrier] varchar(50),
[Vessel] varchar(50),
[Containers]varchar(2000),
[Container Type] varchar(120),
[Container Qty] varchar(50),
[Docs Received Date] datetime,
[Unloaded Date] datetime,
[Terminal Pier Name] varchar(50),
[Terminal] varchar(50),
[Inspection MAPA - Date] datetime,
[Def. LI - Date] datetime,
[Customs Transmission Date] datetime,
[Entry Number] varchar(100),
[NF Number] varchar(400),
[NF Date] datetime,
[Transport. Doc Delivery Date] datetime,
[Loading at the Terminal] varchar(50),
[Inland trucker] varchar(50),
[Good Receipt Date - Estimated] datetime,
[Good Receipt Date - Actual] datetime,
[GR - Date] varchar(50),
[Container Returned] datetime,
[Days at the Port] datetime,
[Last Historic] varchar(2000),
[Last Update] datetime,
[Process Status] varchar(50),
[Transshipment Arrival - Date] datetime,
[Transshipment Departure - Date] datetime,
--[CIF Value] float,
[Reponsible PO] varchar(50),
[Packing] varchar(50),
[Reason Code Events] varchar(300),
[Customer arquive Number] varchar(50),
[Archived(Y/N)] varchar(50),
[Order Reference] varchar(50),
[Processo Critico(Y/N)] varchar(50)
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
CP171.Campo_Dados  [ETA - Promised],
TP221.Dt_Conclusao	[GR Requested - Date],
CP172.Campo_Dados  [Customer Partner],
TP46.Dt_Conclusao [LI Request - Date],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,23) as datetime) [LI Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'23') [Import License],
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
(Case when CP36.Campo_Dados = 1 then 'YES' else 'NO' END) [Processo Critico(Y/N)]
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
left join Tarefas_Processos TP221 with(nolock) on HOU.Num_Proc = TP221.Num_Proc and TP221.ID_Task =221
left join Tarefas_Processos TP222 with(nolock) on HOU.Num_Proc = TP222.Num_Proc and TP222.ID_Task =222
left join Tarefas_Processos TP223 with(nolock) on HOU.Num_Proc = TP223.Num_Proc and TP223.ID_Task =223
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
left join Tipo_operador_Portuario TP with(nolock)  on CP139.Campo_Dados = TP.ID_OP
Left Join Terminal T with(nolock) on T.cd_terminal=Hou.cd_terminal
left join Pessoa IT With(Nolock) on IT.Cd_pes = HOU.Cd_Transportadora
left join Tipo_Status_Processo TSP on TSP.ID_Status = HOU.ID_Status
Left Join DE_PARA_PRODUTO DPC With(nolock) on PC.cd_Proc_Cliente=DPC.GMID and PC.cd_Cliente = DPC.Cd_Cliente
Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo
where  (PG.Apelido like @Grupo or @Grupo ='Grupo ALL') and convert(datetime,HOU.dt_emis,103) between @DtInicial and @DtFinal

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


select * from @Temp
GO
