SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_Exp_Completo] --[spReport_Exp_Completo] 'GRUPO ALL', '2016-02-16', '2017-02-16'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	--select * from tipo_doc_cliente		
AS

	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)


declare @TempExc Table (
			[ExcProcesso] varchar(16)
	)
		insert into @TempExc
			select distinct ExcProcesso from  Exchange with(nolock) where ExcDataAlt >= getdate()-2 and substring(ExcProcesso,1,1) = 'E'  --and ExcProcesso = 'IMUPL201404008BR'
	
	delete Report_Exp_Completo where [BDP Ref.] in (select ExcProcesso from @TempExc)
	
Insert Report_Exp_Completo
select

HOU.Num_Proc		[BDP Ref.],
HOU.HAWB			[HAWB],
HOU.MAWB			[MAWB],
HOU.Master			[Master],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'3')		[Sales Order],
HOU.Dt_Emis			[Register Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')	[Customer PO],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')		[PO Number],
HOU.PO_Req_Date		[PO Request Del Date],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'3')		[Order Date],
TP50.Dt_Conclusao	[Order Received - Date],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'8')	[Shipment Creation Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'8')	[Shipment Number],
HOU.Modal			[Modal],
SHIP.Apelido		[Shipper],
CONSIG.Apelido		[Consignee],
PG.Apelido			[Group Name],
LO.Nome_Local		[Origin],
LD.Nome_Local		[Destination],
LD.Pais_Local		[Country of Destination],
REG.Nome_Regiao		[Region of Destination],
ARM.Nome_Armador	[Carrier],
[dbo].[fBusca_Containers]	 (HOU.Num_Proc) [Containers],
[dbo].[fBusca_Containers_TP] (HOU.Num_Proc) [Container Type],
TP166.Dt_Conclusao	[CONTAINER PARA O REDEX],
TP160.Dt_Conclusao	[ABERTURA DE GATE],
TP158.Dt_Conclusao	[REVISÃO DE DRAFT DE BL],
TP161.Dt_Conclusao	[DEPÓSITO CONTAINER NO TERMINAL],
HOU.Peso_Bruto		[Gross Weight - Shipment - Value],
HOU.Vessel			[Vessel],
TP150.Dt_Conclusao	[PAGTO FRETE E TAXAS AO ARMADOR],
TP153.Dt_Conclusao	[AUTORIZAÇÃO DE EMBARQUE],
HOU.ETD					[ETD Date],
HOU.ATD					[ATD Date],
HOU.Original_ETA		[Original ETA - Date],
HOU.ETA					[ETA Date],
HOU.ATA					[ATA Date],
TP170.Dt_Conclusao		[EMISSÃO DE FORM A],
TP159.Dt_Conclusao		[EMISSÃO DE CO],
TP157.Dt_Conclusao		[PROTOCOLO DE MDGF],
TP151.Dt_Conclusao		[ENVIO DE MAS/ENS AO DESTINO],
TP152.Dt_Conclusao		[ENVIO DE ISF AO DESTINO],
TP13A.Dt_Conclusao		[Good Receipt Date - Actual],
TP13E.Dt_Previsao		[Good Receipt Date - Estimated],
TP59.Dt_Conclusao	    [Advanced Request Date],
CXA.Dt_Pgto_Rcto_HIA	[Advancement Received Date],
TP66.Dt_Conclusao		[Draft EXP - Date],
HOU.Dead_line			[Dead Line Draft - Date],
TP21.Dt_Conclusao		[BL Payment Date],
TP21.Dt_Conclusao		[BL Released - Date],
NG.Descr				[BL Description],
HOU.Cut_Date			[Cut-off - Date],
TP15.Dt_Conclusao		[Port Entry Date],
HOU.Cut_Date			[Dead at Terminal - Date],
TP10A.Dt_Conclusao      [Plant Exit Date - Actual],
TP10E.Dt_Previsao       [Plant Exit Date - Estimated],
TP12.Dt_Conclusao       [Doc Sent - Date],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'2')        [Invoice Date],
TP40.Dt_Conclusao       [Invoice Sent Date],
TP89.Dt_Conclusao       [1 Envio Docs Brasilia - Date],
TP90.Dt_Conclusao       [1 Receb. em Brasilia - Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'103')				[Courier Number],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'94')		[Courier Number - 2nd],
HOU.Banco				[Bank],
TC.Nome_Tp_Carga		[Dispatch Type],
OA.Nome_Orgao_Anuente	[Government Agency],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'4')			[RE Number],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'12')			[DDE Number],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'12')				[DDE - Date],
TP4.Dt_Conclusao		[Customs Clearance Date],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'4')				[Customs Transmission Date],
TP91.Dt_Conclusao		[1 Deferimento - Date],
HOU.Canal				[Channel],
(datename(mm,TP4.Dt_Conclusao)) [Month of Clearance],
TP15A.Dt_Conclusao [Averbacao EXP - Date],
HOU.Booking_Number [Booking Number],
TP58.Dt_Conclusao  [Booking Request Date],
TP5.Dt_Conclusao   [Booking Confirmation Date],
TP1.Dt_Conclusao   [Pre-Alert Sending - Date],
TP148.Dt_Conclusao [SOLICIT. APROVAÇÃO IMO],
TP122.Dt_Conclusao [IMO Approval - Date],
TP149.Dt_Conclusao [ENVIO DE DOCS IMO],
TP162.Dt_Conclusao [ENTREGA DOCS P/ FAT.CHB],
TP78.Dt_Conclusao  [NF BDP Date],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		   [NF Date],
TP26.Dt_Conclusao  [Docs to BDP Billing Date],
TP76.Dt_Conclusao  [BDP Invoice Creation - Date],
(select top 1 isnull(fatdtemissao,fatdtvenc) 
from fatura fat with(nolock) 
Left hash Join vwcliente C with(nolock) on C.num_proc=left(fat.fatcod,16) 
where fatstatus<>0 and left(fatcod,16)= HOU.Num_Proc order by 1 desc) [BDP Invoice Date],
Case when DC2.Id_DC='2' then 'YES' else 'NO' End	[PDF - Invoice],
Case when DC11.Id_DC='11' then 'YES' else 'NO' End	[PDF - PL],
Case when DC16.Id_DC='16' then 'YES' else 'NO' End	[PDF - COA],
Case when DC13.Id_DC='13' then 'YES' else 'NO' End	[PDF - COO],
Case when DC10.Id_DC='10' then 'YES' else 'NO' End	[PDF - NF],
Case when DC20.Id_DC='20' then 'YES' else 'NO' End	[PDF - BL],
Case when DC65.Id_DC='65' then 'YES' else 'NO' End	[PDF - Saque],
Case when DC4.Id_DC='4' then 'YES' else 'NO' End	[PDF - RE],
Case when DC12.Id_DC='12' then 'YES' else 'NO' End	[PDF - DDE],
Case when DC103.Id_DC='103' then 'YES' else 'NO' End [PDF - Courier],
Case when DC94.Id_DC='94' then 'YES' else 'NO' End	[PDF - Courier 2],
Case when DC14.Id_DC='14' then 'YES' else 'NO' End	[PDF - Form A],
Case when DC22.Id_DC='22' then 'YES' else 'NO' End	[PDF - Fumigacao],
Case when DC21.Id_DC='21' then 'YES' else 'NO' End	[PDF - Insurance],
Case when DC60.Id_DC='60' then 'YES' else 'NO' End	[PDF - PC],
Case when DC27.Id_DC='27' then 'YES' else 'NO' End	[PDF - Arqueacao],
Case when DC26.Id_DC='26' then 'YES' else 'NO' End  [PDF - DSE],
TS.status_descricao [Process Status],
[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Cd_BDP Last Historic],
[dbo].[fBusca_HistoricoDescr](HOU.Num_Proc,0,getdate()) [Last Historic],
[dbo].[fBusca_Hist_Geral_Sistema_UltimaAtualizacao] (HOU.Num_Proc,47) [Last Update],
[dbo].[FHistoricoLinhas] (HOU.Num_Proc)				[Complete Historic],
TP905.Dt_Conclusao  [REGISTRO DE PROFIT],
TP154.Dt_Conclusao  [AUDITORIA DATA MANEGMENT],
TP107.Dt_Conclusao  [Arrival at the border - Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'2') [Invoice],
HOU.Vlr_invoice		[Invoice value],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'36') [Direct Collection],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'30')		[Arktec Number],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')[NF Number],
HOU.Peso_Liquido	[Net weight],
PD.NCM				[NCM PO],
sum(PD.vlr_Total_Item)	[FOB Value],
TP178.Dt_Conclusao	[Registro AMS],
TP179.Dt_Conclusao	[Envio ISF]
--into Report_Exp_Completo
From vwHouse_Exp HOU with(nolock)
JOIN @TempExc				EX 		on HOU.num_proc= Ex.ExcProcesso
--Left hash Join vwPO_Exp PO		with(nolock) on HOU.Num_Proc = PO.Num_Proc
Left hash Join Pedido_Ship PS	with(nolock) on HOU.Num_Proc = PS.Num_Proc
Join Pedido_Det PD	with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto
Join Pedido P		with(nolock) on PD.cd_pedido = P.Cd_pedido 			
Join Tipo_Status_Processo TS	with(nolock) on HOU.ID_status = TS.ID_status
Join Pessoa CONSIG				with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
Join Pessoa SHIP				with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
Left hash Join  Pessoa_LLP PLL	with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
Left hash Join  Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
Left hash Join  pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Join Localidade LO				with(nolock) on LO.cd_local = HOU.Cd_Org
Join Localidade LD				with(nolock) on LD.cd_local = HOU.Cd_Dst
Left Join Regiao REG			with(nolock) on LD.cd_regiao = REG.cd_regiao
Left hash Join Armador	ARM 	with(nolock) on HOU.cd_armador = ARM.cd_Armador
Left hash Join Nature_Goods NG with(nolock) on HOU.Num_proc = NG.Num_Proc
Left hash Join Tipo_Carga TC WITH (nolock) ON  HOU.Cd_Tp_Carga = TC.Cd_Tp_Carga 
Left hash Join Campo_Processo CP WITH (nolock) ON HOU.Num_Proc = CP.Num_Proc AND CP.Id_Campo = '122' 
Left hash Join Orgao_Anuente OA WITH (nolock) ON CP.Campo_Dados = OA.ID_Orgao 
Left hash Join Doc_Anexos DC2	with(nolock) on HOU.Num_Proc = DC2.Num_Proc and DC2.Id_DC = '2'
Left hash Join Doc_Anexos DC4	with(nolock) on Hou.Num_Proc = DC4.Num_Proc and DC4.Id_DC = '4'
Left hash Join Doc_Anexos DC10 with(nolock) on Hou.Num_Proc = DC10.Num_Proc and DC10.Id_DC = '10'
Left hash Join Doc_Anexos DC11 with(nolock) on Hou.Num_Proc = DC11.Num_Proc and DC11.Id_DC = '11'
Left hash Join Doc_Anexos DC12 with(nolock) on Hou.Num_Proc = DC12.Num_Proc and DC12.Id_DC = '12'
Left hash Join Doc_Anexos DC13 with(nolock) on Hou.Num_Proc = DC13.Num_Proc and DC13.Id_DC = '13'
Left hash Join Doc_Anexos DC14 with(nolock) on Hou.Num_Proc = DC14.Num_Proc and DC14.Id_DC = '14'
Left hash Join Doc_Anexos DC16 with(nolock) on Hou.Num_Proc = DC16.Num_Proc and DC16.Id_DC = '16'
Left hash Join Doc_Anexos DC20 with(nolock) on Hou.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
Left hash Join Doc_Anexos DC21 with(nolock) on Hou.Num_Proc = DC21.Num_Proc and DC21.Id_DC = '21'
Left hash Join Doc_Anexos DC22 with(nolock) on Hou.Num_Proc = DC22.Num_Proc and DC22.Id_DC = '22'
Left hash Join Doc_Anexos DC26 with(nolock) on Hou.Num_Proc = DC26.Num_Proc and DC26.Id_DC = '26'
Left hash Join Doc_Anexos DC27 with(nolock) on Hou.Num_Proc = DC27.Num_Proc and DC27.Id_DC = '27'
Left hash Join Doc_Anexos DC60 with(nolock) on Hou.Num_Proc = DC60.Num_Proc and DC60.Id_DC = '60'
Left hash Join Doc_Anexos DC65 with(nolock) on Hou.Num_Proc = DC65.Num_Proc and DC65.Id_DC = '65'
Left hash Join Doc_Anexos DC94 with(nolock) on Hou.Num_Proc = DC94.Num_Proc and DC94.Id_DC = '94'
Left hash Join Doc_Anexos DC103 with(nolock)on Hou.Num_Proc = DC103.Num_Proc and DC103.Id_DC = '103'
Left hash Join vwcxas CXA		with(nolock) on HOU.Num_Proc = CXA.Num_Proc_HIA and dc_hia='C' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like 'Adiantamento%')
Left hash Join Tarefas_Processos TP50  with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task = '50'
Left hash Join Tarefas_Processos TP66  with(nolock) on HOU.Num_Proc = TP66.Num_Proc and TP66.ID_Task = '66'
Left hash Join Tarefas_Processos TP21  with(nolock) on HOU.Num_Proc = TP21.Num_Proc and TP21.ID_Task = '21'
Left hash Join Tarefas_Processos TP15  with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP21.ID_Task = '15'
Left hash Join Tarefas_Processos TP10A with(nolock) on HOU.Num_Proc = TP10A.Num_Proc and TP10A.ID_Task = '10'
Left hash Join Tarefas_Processos TP10E with(nolock) on HOU.Num_Proc = TP10E.Num_Proc and TP10E.ID_Task = '10'
Left hash Join Tarefas_Processos TP13A with(nolock) on HOU.Num_Proc = TP13A.Num_Proc and TP13A.ID_Task = '13'
Left hash Join Tarefas_Processos TP13E with(nolock) on HOU.Num_Proc = TP13E.Num_Proc and TP13E.ID_Task = '13'
Left hash Join Tarefas_Processos TP59  with(nolock) on HOU.Num_Proc = TP59.Num_Proc and TP59.ID_Task = '59'
Left hash Join Tarefas_Processos TP12  with(nolock) on HOU.Num_Proc = TP12.Num_Proc and TP12.ID_Task = '12'
Left hash Join Tarefas_Processos TP40  with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = '40'
Left hash Join Tarefas_Processos TP89  with(nolock) on HOU.Num_Proc = TP89.Num_Proc and TP89.ID_Task = '89'
Left hash Join Tarefas_Processos TP90  with(nolock) on HOU.Num_Proc = TP90.Num_Proc and TP90.ID_Task = '90'
Left hash Join Tarefas_Processos TP26  with(nolock) on HOU.Num_Proc = TP26.Num_Proc and TP26.ID_Task = '26'
Left hash Join Tarefas_Processos TP78  with(nolock) on HOU.Num_Proc = TP78.Num_Proc and TP78.ID_Task = '78'
Left hash Join Tarefas_Processos TP154 with(nolock) on HOU.Num_Proc = TP154.Num_Proc and TP154.ID_Task = '154'
Left hash Join Tarefas_Processos TP905 with(nolock) on HOU.Num_Proc = TP905.Num_Proc and TP905.ID_Task = '905'
Left hash Join Tarefas_Processos TP162 with(nolock) on HOU.Num_Proc = TP162.Num_Proc and TP162.ID_Task = '162'
Left hash Join Tarefas_Processos TP149 with(nolock) on HOU.Num_Proc = TP149.Num_Proc and TP149.ID_Task = '149'
Left hash Join Tarefas_Processos TP91  with(nolock) on HOU.Num_Proc = TP91.Num_Proc and TP91.ID_Task = '91'
Left hash Join Tarefas_Processos TP166 with(nolock) on HOU.Num_Proc = TP166.Num_Proc and TP166.ID_Task = '166'
Left hash Join Tarefas_Processos TP160 with(nolock) on HOU.Num_Proc = TP160.Num_Proc and TP160.ID_Task = '160'
Left hash Join Tarefas_Processos TP170 with(nolock) on HOU.Num_Proc = TP170.Num_Proc and TP170.ID_Task = '170'
Left hash Join Tarefas_Processos TP158 with(nolock) on HOU.Num_Proc = TP158.Num_Proc and TP158.ID_Task = '158'
Left hash Join Tarefas_Processos TP161 with(nolock) on HOU.Num_Proc = TP161.Num_Proc and TP161.ID_Task = '161'
Left hash Join Tarefas_Processos TP150 with(nolock) on HOU.Num_Proc = TP150.Num_Proc and TP150.ID_Task = '150'
Left hash Join Tarefas_Processos TP153 with(nolock) on HOU.Num_Proc = TP153.Num_Proc and TP153.ID_Task = '153'
Left hash Join Tarefas_Processos TP159 with(nolock) on HOU.Num_Proc = TP159.Num_Proc and TP159.ID_Task = '159'
Left hash Join Tarefas_Processos TP157 with(nolock) on HOU.Num_Proc = TP157.Num_Proc and TP157.ID_Task = '157'
Left hash Join Tarefas_Processos TP151 with(nolock) on HOU.Num_Proc = TP151.Num_Proc and TP151.ID_Task = '151'
Left hash Join Tarefas_Processos TP152 with(nolock) on HOU.Num_Proc = TP152.Num_Proc and TP152.ID_Task = '152'
Left hash Join Tarefas_Processos TP148 with(nolock) on HOU.Num_Proc = TP148.Num_Proc and TP148.ID_Task = '148'
Left hash Join Tarefas_Processos TP58  with(nolock) on HOU.Num_Proc = TP58.Num_Proc and TP58.ID_Task = '58'
Left hash Join Tarefas_Processos TP4   with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Left hash Join Tarefas_Processos TP5   with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task = '5'
Left hash Join Tarefas_Processos TP1   with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task = '1'
Left hash Join Tarefas_Processos TP122 with(nolock) on HOU.Num_Proc = TP122.Num_Proc and TP122.ID_Task = '122'
Left hash Join Tarefas_Processos TP15A with(nolock) on HOU.Num_Proc = TP15A.Num_Proc and TP15A.ID_Task = '15'
Left hash Join Tarefas_Processos TP4A  with(nolock) on HOU.Num_Proc = TP4A.Num_Proc and TP4A.ID_Task = '4' 
Left hash Join Tarefas_Processos TP76  with(nolock) on HOU.Num_Proc = TP76.Num_Proc and TP76.ID_Task = '76'
Left hash Join Tarefas_Processos TP107  with(nolock) on HOU.Num_Proc = TP107.Num_Proc and TP107.ID_Task = '107'
Left hash Join Tarefas_Processos TP178  with(nolock) on HOU.Num_Proc = TP178.Num_Proc and TP178.ID_Task = '178'
Left hash Join Tarefas_Processos TP179  with(nolock) on HOU.Num_Proc = TP179.Num_Proc and TP179.ID_Task = '179'
--where HOU.Num_Proc = 'EMCSR201412061BR'
where 
convert(Datetime,HOU.dt_emis,105) >= GETDATE()-365
--convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal 
		and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
		
Group by
HOU.Num_Proc,
HOU.HAWB,
HOU.MAWB,
HOU.Master,
HOU.Dt_Emis,
HOU.PO_Req_Date,
TP50.Dt_Conclusao,
HOU.Modal,
SHIP.Apelido,
CONSIG.Apelido,
PG.Apelido,
LO.Nome_Local,
LD.Nome_Local,
LD.Pais_Local,
REG.Nome_Regiao,
ARM.Nome_Armador,
TP166.Dt_Conclusao,
TP160.Dt_Conclusao,
TP158.Dt_Conclusao,
TP161.Dt_Conclusao,
HOU.Peso_Bruto,
HOU.Vessel,
TP150.Dt_Conclusao,
TP153.Dt_Conclusao,
HOU.ETD,
HOU.ATD,
HOU.Original_ETA,
HOU.ETA,
HOU.ATA,
TP170.Dt_Conclusao,
TP159.Dt_Conclusao,
TP157.Dt_Conclusao,
TP151.Dt_Conclusao,
TP152.Dt_Conclusao,
TP13A.Dt_Conclusao,
TP13E.Dt_Previsao,
TP59.Dt_Conclusao,
CXA.Dt_Pgto_Rcto_HIA,
TP66.Dt_Conclusao,
HOU.Dead_line,
TP21.Dt_Conclusao,
TP21.Dt_Conclusao,
NG.Descr,
HOU.Cut_Date,
TP15.Dt_Conclusao,
HOU.Cut_Date,
TP10A.Dt_Conclusao,
TP10E.Dt_Previsao,
TP12.Dt_Conclusao,
TP40.Dt_Conclusao,
TP89.Dt_Conclusao,
TP90.Dt_Conclusao,
HOU.Banco,
TC.Nome_Tp_Carga,
OA.Nome_Orgao_Anuente,
TP4.Dt_Conclusao,
TP91.Dt_Conclusao,
HOU.Canal,
TP4.Dt_Conclusao,
TP15A.Dt_Conclusao,
HOU.Booking_Number,
TP58.Dt_Conclusao,
TP5.Dt_Conclusao,
TP1.Dt_Conclusao,
TP148.Dt_Conclusao,
TP122.Dt_Conclusao,
TP149.Dt_Conclusao,
TP162.Dt_Conclusao,
TP78.Dt_Conclusao,
TP26.Dt_Conclusao,
TP76.Dt_Conclusao,
DC2.Id_DC,
DC11.Id_DC,
DC16.Id_DC,
DC13.Id_DC,
DC10.Id_DC,
DC20.Id_DC,
DC65.Id_DC,
DC4.Id_DC,
DC12.Id_DC,
DC103.Id_DC,
DC94.Id_DC,
DC14.Id_DC,
DC22.Id_DC,
DC21.Id_DC,
DC60.Id_DC,
DC27.Id_DC,
DC26.Id_DC,
TS.status_descricao,
TP905.Dt_Conclusao,
TP154.Dt_Conclusao,
TP107.Dt_Conclusao,
HOU.Vlr_invoice,
HOU.Peso_Liquido,
PD.NCM,
TP178.Dt_Conclusao,
TP179.Dt_Conclusao


GO
