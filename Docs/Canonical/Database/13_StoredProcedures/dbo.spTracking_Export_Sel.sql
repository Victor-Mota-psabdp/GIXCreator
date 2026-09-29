SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTracking_Export_Sel] -- [spTracking_Export_Sel] 'GRUPO ALL', '2016-01-01', '2016-01-5'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
				
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

select distinct
'Export'			[Import / Export],
HOU.Modal			[Modal],
HOU.Num_Proc		[BDP Ref.],
HOU.Master			[Consol Ref.],
HOU.HAWB			[Master],
HOU.MAWB			[House],
HOU.Booking_Number	[Booking Number],
PO.Numero_PO		[PO Number],
HOU.Cut_Date		[Dead at Terminal - Date],
HOU.Dead_line		[Dead Line Draft - Date],
LO.Nome_Local		[Origin],
LD.Nome_Local		[Destination],
(Case when HOU.Modal = 'Air Export' then CIA.Nome_Cia_Aer else ARM.Nome_Armador end)	[Carrier],
TC.Nome_Tp_Carga	[Type of cargo],
[dbo].[fBusca_Containers]	 (HOU.Num_Proc) [Containers],
[dbo].[Qty_Container](HOU.Num_Proc) [Container Qty],
[dbo].[fBusca_Containers_TP] (HOU.Num_Proc) [Container Type],
HOU.Peso_Bruto		[Gross Weight KG],
HOU.Peso_Cubado [Chargeable Weight],
HOU.Vol_Tot			[Volume M³],
SHIP.Apelido		[Shipper],
CONSIG.Apelido		[Consignee],
HOU.Vessel			[Vessel],
HOU.viagem			[Voyage],
HOU.ETD				[ETD Date],
HOU.ATD				[ATD Date],
HOU.ETA				[ETA Date],
HOU.ATA				[ATA Date],
BDPCSR.Nome_Usuario [CSR Name],
TP50.Dt_Conclusao	[Order Received - Date],
TP58.Dt_Conclusao	[Booking Request Date],
TP5.Dt_Conclusao	[Booking Confirmation Date],
TP41.Dt_Conclusao	[Draft Approval Imp - Date],
TP83.Dt_Conclusao	[Draft Received - Date],
TP1.Dt_Conclusao	[Pre-Alert Sending - Date],
TP905.Dt_Conclusao	[Profit Register - Date],
TP124.Dt_Conclusao	[Sending of Banking Collection Date],
P.Incoterm,
PO.Shipment_Data [Shipping Confirmation - Date]
From vwHouse_Exp HOU with(nolock)
INNER HASH JOIN vwPO_Exp PO		with(nolock) on HOU.Num_Proc = PO.Num_Proc
left HASH JOIN Pedido_Ship PS	with(nolock) on HOU.Num_Proc = PS.Num_Proc
left HASH JOIN Pedido_Det PD	with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto
left HASH JOIN Pedido P		with(nolock) on PD.cd_pedido = P.Cd_pedido 			
INNER HASH JOIN Tipo_Status_Processo TS	with(nolock) on HOU.ID_status = TS.ID_status
INNER HASH JOIN Pessoa CONSIG				with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
INNER HASH JOIN Pessoa SHIP				with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
left HASH JOIN Pessoa_LLP PLL	with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
left HASH JOIN Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
left HASH JOIN pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
INNER HASH JOIN Localidade LO				with(nolock) on LO.cd_local = HOU.Cd_Org
INNER HASH JOIN Localidade LD				with(nolock) on LD.cd_local = HOU.Cd_Dst
left HASH JOIN Regiao REG			with(nolock) on LD.cd_regiao = REG.cd_regiao
left HASH JOIN Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario= HOU.Cd_Usuario
left HASH JOIN Armador	ARM 	with(nolock) on HOU.cd_armador = ARM.cd_Armador and HOU.Modal <> 'Air Export'
left HASH JOIN Cia_Aerea CIA 	with(nolock) on HOU.cd_armador = CIA.Cd_Cia_Aer and HOU.Modal = 'Air Export'
left HASH JOIN Nature_Goods NG with(nolock) on HOU.Num_proc = NG.Num_Proc
left HASH JOIN Tipo_Carga TC WITH (nolock) ON  HOU.Cd_Tp_Carga = TC.Cd_Tp_Carga 
left HASH JOIN Tarefas_Processos TP50  with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task = '50'
left HASH JOIN Tarefas_Processos TP905 with(nolock) on HOU.Num_Proc = TP905.Num_Proc and TP905.ID_Task = '905'
left HASH JOIN Tarefas_Processos TP58  with(nolock) on HOU.Num_Proc = TP58.Num_Proc and TP58.ID_Task = '58'
left HASH JOIN Tarefas_Processos TP5   with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task = '5'
left HASH JOIN Tarefas_Processos TP1   with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task = '1'
left HASH JOIN Tarefas_Processos TP124  with(nolock) on HOU.Num_Proc = TP124.Num_Proc and TP124.ID_Task = '124'
left HASH JOIN Tarefas_Processos TP83  with(nolock) on HOU.Num_Proc = TP83.Num_Proc and TP83.ID_Task = '83'
left HASH JOIN Tarefas_Processos TP41  with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task = '41'
INNER HASH JOIN Campo_Processo CP with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
--where HOU.Num_Proc = 'EMCSR201602072BR'
where convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
		and CP.Campo_Dados in ('2','3')
		and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
OPTION(HASH JOIN)
GO
