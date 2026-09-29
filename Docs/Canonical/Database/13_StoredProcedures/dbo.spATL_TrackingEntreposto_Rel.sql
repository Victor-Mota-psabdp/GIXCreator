SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_TrackingEntreposto_Rel] 'GRUPO LYONDELL BASEL','', '2017-01-01','2017-04-05'
CREATE procedure [dbo].[spATL_TrackingEntreposto_Rel] 

(
@Grupo varchar(20),
@Num_Proc varchar(16),
@DtInicial datetime,
@DtFinal datetime
)
as

if @Num_Proc = '' Begin  set @Num_Proc = '%' End

select
HOU.Num_Proc [BDP Ref.],
PD.Num_PO [PO Number],
PDet.Lote [Delivery Note],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,38) [Proforma Invoice],
PC.cd_Proc_Cliente [Product ID],
OrgPais.Nome_Pais [Country of Origin],
PC.Produto_Descr [Product Description],
--Pdet.Item [Item],
PDet.Finalidade [Drum Number],
PDet.Peso_Bruto_TOT [Gross Weight KG],
PDet.Peso_Liquido_TOT [Net Weight KG],
HOU.Peso_Liquido [Netweight KG Shipment],
HOU.Peso_Bruto [Gross Weight - Shipment - Value],
PDet.Requerimento [Batch Number],
HOU.Booking_Number [Booking Number],
HOU.MAWB [Master],
HOU.Vessel [Vessel],
HOU.Viagem [Voyage],
Dst.Nome_Local [Destination],
TM.Nome_Terminal [Terminal],
HOU.ETD [ETD Date],
HOU.ATD [ATD Date],
HOU.ETA [ETA Date],
HOU.ATA [ATA Date],
TP15.Dt_Conclusao [Port Entry Date],
TR.Apelido [Inland Truncker],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,45)[DTA Clearance - Number],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,45) [DTA Clearance - Date],
c160.Canal [DTA Channel],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,59) [DA Number],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,59) [DA Clearance - Date],
C159.Canal [DA Channel],
TP4.Dt_Conclusao [Customs Clearance Date],
--dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,2) [Invoice Number], Coluna retirada por solicitação da Renata
--dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,5)  [Customs Clearance Date],
dbo.fBusca_HistoricoDescr(HOU.Num_Proc,0,getdate()) [Last Historic],
--[dbo].[FHistoricoLinhas] (HOU.Num_Proc) [Complete Historic],
CP161.Campo_Dados [Expiration Date],
PDet.Requision [Entrega na Planta],
PDeT.Contract [Invoice by Lote],
P163.Nome_Raz_Soc [Armed Escort]

from vwHouse_Imp HOU with(nolock)
left join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
left join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
left join Pedido_Det PDet with(nolock) on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
left join Produto_Cliente PC with(nolock) on PS.cd_produto = PC.cd_prod
left join Localidade Dst with(nolock) on HOU.Cd_Dst = Dst.Cd_Local
left join Terminal TM with(nolock) on HOU.Cd_Terminal = TM.Cd_Terminal
left join Pessoa TR with(nolock) on HOU.cd_transportadora = TR.Cd_Pes
--left join vwPO_Imp DA with(nolock) on HOU.Num_Proc = DA.Num_Proc 
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
left join Campo_Processo CP45 with(nolock) on HOU.Num_Proc = CP45.Num_Proc and CP45.Id_Campo = 45
left join Campo_Processo CP159 with(nolock) on HOU.Num_Proc = CP159.Num_Proc and CP159.Id_Campo = 159
left join Canal C159 with(nolock) on CP159.Campo_Dados = C159.Id
left join Campo_Processo CP160 with(nolock) on HOU.Num_Proc = CP160.Num_Proc and CP160.Id_Campo = 160
left join Canal C160 with(nolock) on CP160.Campo_Dados = C160.Id			
left join Campo_Processo CP161 with(nolock) on HOU.Num_Proc = CP161.Num_Proc and CP161.Id_Campo = 161
left join Localidade Org with(nolock) on HOU.Cd_Org = Org.Cd_Local
left join Pais OrgPais with(nolock) on Org.Cd_Pais = OrgPais.Cd_Pais
left join Tarefas_Processos TP15 with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task = 15
left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = 4
left join Campo_Processo CP163 with(nolock) on HOU.Num_Proc = CP163.Num_Proc and CP163.Id_Campo = 163
left join Pessoa P163 with(nolock) on CP163.Campo_Dados = P163.Cd_Pes
where 
--HOU.Num_Proc = 'IMLYB201703007BR'
	CP45.Campo_Dados = 1 and (HOU.Num_Proc = @Num_Proc or @Num_Proc='%') and convert(datetime,HOU.Dt_Emis,103) between @DtInicial and @DtFinal and  (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
option (hash join)

GO
