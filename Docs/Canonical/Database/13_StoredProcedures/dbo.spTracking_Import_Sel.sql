SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTracking_Import_Sel] -- [spTracking_Import_Sel] 'GRUPO DOW', '2016-01-01', '2016-01-05'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
				
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

Select DISTINCT
HOU.Master		[Consol Ref.],
HOU.Num_Proc	[BDP Ref.],
HOU.MAWB		[Master],
HOU.HAWB		[House],
PG.Apelido		[Group Name],
BDPCSR.Nome_Usuario [CSR Name],
LO.Nome_Local	[Origin],
LD.Nome_Local	[Destination],
HOU.Vessel		[Vessel],
(Case when HOU.Modal = 'Air Import' then CIA.Nome_Cia_Aer else ARM.Nome_Armador end)	[Carrier],
HOU.ATD			[ATD Date],
HOU.ETA			[ETA Date],
HOU.ATD			[ATD Date],
HOU.ATA			[ATA Date],
(Case when HOU.Modal = 'Air Import' then 'LCL' else TC.Nome_Tp_Carga end) [Type of cargo],
[dbo].[Qty_Container](HOU.Num_Proc) [Container Qty],
[dbo].[fBusca_Containers_TP] (HOU.Num_Proc)	[Container Type],
[dbo].[fBusca_Containers] (HOU.Num_Proc)	[Containers],
HOU.Peso_Bruto	[Gross Weight KG],
HOU.Peso_Cubado [Chargeable Weight],
CONSIGMAS.Apelido [Shipper-Master],
SHIP.Apelido	[Shipper],
CONSIG.Apelido	[Consignee],
TP41.Dt_Conclusao [Draft Approval Imp - Date],
TP60.Dt_Conclusao [File Open Date],
TP905.Dt_Conclusao [Profit Register - Date],
TP1.Dt_Conclusao  [Pre-Alert Sending - Date],
TP903.Dt_Conclusao [Siscarga Register - Date],
TP8.Dt_Conclusao [Manifest Date],
TER.Nome_Terminal [Terminal],
TP87.Dt_Conclusao [Transmission Value - Date],
TP88.Dt_Conclusao [Process OK to payment of HBL - Date],
TP21.Dt_Conclusao [BL Payment Date],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'85')[CE Mercante Master],
Case when DC29.Id_DC='29' then 'YES' else 'NO' End [CE Mercante - PDF],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'29') [CE Mercante.]
from vwHouse_Imp HOU
Left Join Pedido_Ship PS		with(nolock) on HOU.Num_Proc = PS.Num_Proc
Left Join Pedido_Det PD		with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto
Left Join Pedido P				with(nolock) on PD.cd_pedido = P.Cd_pedido
Left Join Produto_Cliente PC	with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod
Join Pessoa CONSIG		with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
Join Endereco ENDC		with(nolock) on CONSIG.Cd_Pes = ENDC.Cd_Pes and ENDC.Cd_Tp_End = 'COM'
Join Pessoa SHIP			with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
Join Endereco ENDS		with(nolock) on SHIP.Cd_Pes = ENDS.Cd_Pes and ENDS.Cd_Tp_End = 'COM'
Join vwMaster_imp MAS	with(nolock) on HOU.Master = MAS.Num_proc_MAS
Left Join Pessoa CONSIGMAS		with(nolock)on MAS.Cd_Export_MAS = CONSIGMAS.Cd_Pes 
Left Join Pessoa_LLP PLL		with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
Left Join Grupo G				with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
Left Join pessoa	PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Join Localidade LO		with(nolock) on LO.cd_local = HOU.Cd_Org
Join Localidade LD		with(nolock) on LD.cd_local = HOU.Cd_Dst
Left Join Armador	ARM 		with(nolock) on HOU.cd_armador = ARM.cd_Armador and HOU.Modal <> 'Air Import'
Left Join Cia_Aerea CIA 		with(nolock) on HOU.cd_armador = CIA.Cd_Cia_Aer and HOU.Modal = 'Air Import'
Left Join Terminal TER			with(nolock) on HOU.Cd_Terminal = TER.Cd_Terminal
Left Join Usuario BDPCSR		with(nolock) on BDPCSR.cd_usuario= HOU.Cd_Usuario
Left Join Tipo_Carga TC		with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
Left Join Doc_Anexos DC29		with(nolock) on Hou.Num_Proc = DC29.Num_Proc and DC29.Id_DC = '29'
Left Join Tarefas_Processos TP1	with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task = '1'
Left Join Tarefas_Processos TP905  with(nolock) on HOU.Num_Proc = TP905.Num_Proc and TP905.ID_Task = '905'
Left Join Tarefas_Processos TP21	with(nolock) on HOU.Num_Proc = TP21.Num_Proc and TP21.ID_Task = '21'
Left Join Tarefas_Processos TP41	with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task = '41'
Left Join Tarefas_Processos TP60	with(nolock) on HOU.Num_Proc = TP60.Num_Proc and TP60.ID_Task = '60'
Left Join Tarefas_Processos TP903  with(nolock) on HOU.Num_Proc = TP903.Num_Proc and TP903.ID_Task = '903'
Left Join Tarefas_Processos TP8	with(nolock) on HOU.Num_Proc = TP8.Num_Proc and TP8.ID_Task = '8'
Left Join Tarefas_Processos TP87	with(nolock) on HOU.Num_Proc = TP87.Num_Proc and TP87.ID_Task = '87'
Left Join Tarefas_Processos TP88	with(nolock) on HOU.Num_Proc = TP88.Num_Proc and TP88.ID_Task = '88'
Join Campo_Processo CP		with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
--where HOU.Num_Proc = 'IMATL201409032BR'
where convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
		and CP.Campo_Dados in ('2','3')
		and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
		
OPTION(HASH JOIN)
GO
