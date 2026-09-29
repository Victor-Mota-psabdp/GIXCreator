SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  Procedure [dbo].[spTrackingLevisTST_Rel] --[dbo].[spTrackingLevisTST_Rel] '','01-01-2014','01-01-2014',''
	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime,
	@Tipo varchar(1)
as

Declare @Historico Table
	(
		Num_proc varchar(16),
		Historico Varchar(4000)
	
	
	)

insert @Historico 

select num_proc_lim, dbo.FHistoricoLinhas(num_proC_lim) from LLP_Imp_Mar with(nolock)
where isnull(ID_Status ,0) <>9 and SUBSTRING(Num_Proc_Lim,3,3)='LVS'

union all

select num_proc_lia, dbo.FHistoricoLinhas(num_proC_lia) from LLP_Imp_Aer with(nolock)
where isnull(ID_Status ,0) <>9 and SUBSTRING(Num_Proc_Lia,3,3)='LVS'


select 
	PD.Num_PO  [PO Number] ,
	PS.Num_Proc [BDP#],
	'BDP' [Brokerage],
	Nome_Pais [Country of origin],
	SH.Nome_Raz_Soc [Vendor],
	cd_Proc_Cliente [PC9 / SKU],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,2) [Invoice#],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,2) as datetime) [Invoice Date],
	PS.Qty [Qty / units],
	PDD.Vlr_Item 	[Unit Price],
	Cd_Tp_Oper [Incoterm],
	'Air' Modal ,
	DBO.fBusca_Tarefa(PS.Num_Proc,46) [IL Request],
	Dt_LI [IL Registry],
	dt_Deferimento  [IL Approval],
	DBO.fBusca_Tarefa(PS.Num_Proc,146) [Email Broker],
	ISNULL(ATD_LIA,ETD_LIA) [Departure],
	ETA_LIA [ETA],
	ATA_LIA [Actual arrival],
	DBO.fBusca_Tarefa(PS.Num_Proc,15) [Cargo Manifest],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,5) as datetime) [Import declaration date],
	dbo.fBusca_CampoCliente(PS.Num_Proc,31) 	[Taxa DI],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,5) [Import Entry],
	Canal_LIA [Channel],
	DBO.fBusca_Tarefa(PS.Num_Proc,4) [Clearance],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'Imposto de Importação - CHB%') [II],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'PIS%') [PIS],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'Cofins%') [Cofins],
		[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'ICMS%') [ICMS],
	Nome_Terminal [Terminal],
	ISNULL(HAWB_HIA,MAWB_HIA) [BL NR],
	Vlr_Frete_Efet_HIA [Ocen freight USD],
	dbo.fBusca_CustoCliente(PS.Num_Proc,'Frete Interno%') [Inland Freight R$],
	'LCL' [LCL/FCL],
	Vol_Tot_HIA [CBM],
	'' [CONTAINER TYPE],
	Peso_Bruto_HIA [WEIGHT AIR SHIPMENT],
	Qtde_Embal [Qty Cartons],
	Status_Descricao  [Comments (General)],
	Historico  [Comments (DETAILS)],
	DBO.fBusca_Tarefa(PS.Num_Proc,142) [DANFE REQUEST],
	DBO.fBusca_Tarefa(PS.Num_Proc,143) [DANFE RECEIPT],
	DBO.fBusca_Tarefa(PS.Num_Proc,144) [SCHEDULED DELIVERY],
		DBO.fBusca_Tarefa(PS.Num_Proc,145) [EFFECTIVE DELIVERY DATE],
		Num_SOLICITACAO [SLI]
	
from House_Imp_Aer Hou with(nolock)
	Join @Historico H  on H.Num_proc = hou.Num_Proc_HIA 
	Join Pedido_Ship PS with(nolock) on PS.Num_Proc=hou.num_proc_hia
	Join Pedido PD with(nolock) on PD.Cd_pedido = PS.cd_pedido 
	Join Pais PaisOrigem with(nolock) on PaisOrigem.Cd_Pais = Cd_Pais_Org 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_HIA 
	Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto 
	Join Pedido_Det PDD with(nolock) on PDD.Cd_Pedido = PS.cd_pedido and PDD.Cd_Produto = PS.cd_produto and PDD.Lote = PS.Lote and PDD.Item = PS.Item 
	Join LLP_Imp_Aer LLP with(nolock) on num_proc_lia=hou.Num_Proc_HIA 
	Left Join Terminal T with(nolock) on T.Cd_Terminal =LLP.Cd_Terminal 
	Left Join Tipo_Status_Processo  TSP with(nolock) on TSP.ID_Status=LLP.ID_Status 
	Left Join vwSolicitacao_LI LI with(nolock) on LI.num_proc=PS.Num_Proc and PS.cd_produto = LI.cd_produto and id_tipo_LI in (1,2)
where SUBSTRING(num_proc_hia,3,3)='LVS'
and ISNULL(LLP.ID_Status,0) <> 9

union all


select 
	Num_Pedido [PO Number] ,
	PS.Num_Proc [BDP#],
	'BDP' [Brokerage],
	Nome_Pais [Country of origin],
	SH.Nome_Raz_Soc [Vendor],
	cd_Proc_Cliente [PC9 / SKU],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,2) [Invoice#],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,2) as datetime) [Invoice Date],
	PS.Qty [Qty / units],
	PDD.Vlr_Item 	[Unit Price],
	Cd_Tp_Oper [Incoterm],
	'Air' Modal ,
	DBO.fBusca_Tarefa(PS.Num_Proc,46) [IL Request],
	Dt_LI [IL Registry],
	dt_Deferimento  [IL Approval],
	DBO.fBusca_Tarefa(PS.Num_Proc,146) [Email Broker],
	ISNULL(ATD_lim,ETD_lim) [Departure],
	ETA_lim [ETA],
	ATA_lim [Actual arrival],
	DBO.fBusca_Tarefa(PS.Num_Proc,15) [Cargo Manifest],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,5) as datetime) [Import declaration date],
	dbo.fBusca_CampoCliente(PS.Num_Proc,31) 	[Taxa DI],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,5) [Import Entry],
	Canal_lim [Channel],
	DBO.fBusca_Tarefa(PS.Num_Proc,4) [Clearance],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'Imposto de Importação - CHB%') [II],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'PIS%') [PIS],
	[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'Cofins%') [Cofins],
		[dbo].[fBusca_CustoProcessoTAB](PS.Num_Proc,'ICMS%') [ICMS],
	Nome_Terminal [Terminal],
	ISNULL(HAWB_him,MAWB_him) [BL NR],
	Vlr_Frete_Efet_him [Ocen freight USD],
	dbo.fBusca_CustoCliente(PS.Num_Proc,'Frete Interno%') [Inland Freight R$],
	Nome_Tp_Carga  [LCL/FCL],
	Vol_Tot_him [CBM],
	dbo.fBusca_Containers_TP(PS.Num_Proc) [CONTAINER TYPE],
	Peso_Bruto_him [WEIGHT AIR SHIPMENT],
	Qtde_Embal [Qty Cartons],
	
	Status_Descricao  [Comments (General)],
	Historico [Comments (DETAILS)],
	DBO.fBusca_Tarefa(PS.Num_Proc,142) [DANFE REQUEST],
	DBO.fBusca_Tarefa(PS.Num_Proc,143) [DANFE RECEIPT],
	DBO.fBusca_Tarefa(PS.Num_Proc,144) [SCHEDULED DELIVERY],
		DBO.fBusca_Tarefa(PS.Num_Proc,145) [EFFECTIVE DELIVERY DATE],
		Num_SOLICITACAO [SLI]
	
from House_imp_mar Hou with(nolock)
	Join @Historico H  on H.Num_proc = hou.Num_Proc_HIm 
	Join Pedido_Ship PS with(nolock) on PS.Num_Proc=hou.num_proc_him
	Join Pedido PD with(nolock) on PD.Cd_pedido = PS.cd_pedido 
	Join Pais PaisOrigem with(nolock) on PaisOrigem.Cd_Pais = Cd_Pais_Org 
	Join Pessoa SH with(nolock) on SH.Cd_Pes=Cd_Export_him 
	Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto 
	Join Pedido_Det PDD with(nolock) on PDD.Cd_Pedido = PS.cd_pedido and PDD.Cd_Produto = PS.cd_produto and PDD.Lote = PS.Lote and PDD.Item = PS.Item 
	Join LLP_imp_mar LLP with(nolock) on num_proc_lim=hou.Num_Proc_him 
	Left Join Terminal T with(nolock) on T.Cd_Terminal =LLP.Cd_Terminal 
	Left Join vwSolicitacao_LI LI with(nolock) on LI.num_proc=PS.Num_Proc and PS.cd_produto = LI.cd_produto and id_tipo_LI in (1,2)
	Left Join Tipo_Carga TC with(nolock) on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga 
	Left Join Tipo_Status_Processo  TSP with(nolock) on TSP.ID_Status=LLP.ID_Status 

where SUBSTRING(num_proc_him,3,3)='LVS'
and ISNULL(LLP.ID_Status,0) <> 9
GO
