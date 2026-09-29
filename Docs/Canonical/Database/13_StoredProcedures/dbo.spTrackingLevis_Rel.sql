SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spTrackingLevis_Rel] --[dbo].[spTrackingLevis_Rel] '','01-01-2014','01-01-2014',''
	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime,
	@Tipo varchar(1)
as

Declare @Qtty Table
	(
		Num_proc varchar(16),
		Qty decimal(10,2)
	)

insert @Qtty 
select Num_Proc ,SUM(quantidade) from DI_Item_BR 
Where substring(Num_Proc,3,3) ='LVS'
group by Num_Proc 

/*

Declare @Historico Table
	(
		Num_proc varchar(16),
		Historico Varchar(4000)
	
	
	)
*/	
/*
insert @Historico 

select num_proc_lim, dbo.FHistoricoLinhas(num_proC_lim) from LLP_Imp_Mar with(nolock)
where isnull(ID_Status ,0) <>9 and SUBSTRING(Num_Proc_Lim,3,3)='LVS'

union all

select num_proc_lia, dbo.FHistoricoLinhas(num_proC_lia) from LLP_Imp_Aer with(nolock)
where isnull(ID_Status ,0) <>9 and SUBSTRING(Num_Proc_Lia,3,3)='LVS'
*/

select distinct 
	Num_Pedido [PO Number] ,
	PS.Num_Proc [BDP#],
	'BDP' [Brokerage],
	Nome_Pais [Country of origin],
	SH.Nome_Raz_Soc [Vendor],
	cd_Proc_Cliente [PC9 / SKU],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,2) [Invoice#],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,2) as datetime) [Invoice Date],
	sum(PS.Qty )[Qty / units],
	PDD.Vlr_Item 	[Unit Price],
	Cd_Tp_Oper [Incoterm],
	'Air' Modal ,
	DBO.fBusca_Tarefa(PS.Num_Proc,46) [IL Request],
	Dt_LI [IL Registry],
	dt_Deferimento  [IL Approval],
	DBO.fBusca_Tarefa(PS.Num_Proc,146) [Email Broker],
	ETD_LIA [Departure - Estimated],
	ATD_LIA [Departure - Actual],
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
	--Historico  [Comments (DETAILS)],
	CONVERT(varchar(10),hsg.HSGData,103) + ' - ' + hsg.HSDDescricao [Comments (DETAILS)] ,
	DBO.fBusca_Tarefa(PS.Num_Proc,142) [DANFE REQUEST],
	DBO.fBusca_Tarefa(PS.Num_Proc,143) [DANFE RECEIPT],
	DBO.fBusca_Tarefa(PS.Num_Proc,7) [DOCS DELIVERED TO TRUCK],
	DBO.fBusca_Tarefa(PS.Num_Proc,145) [EFFECTIVE DELIVERY DATE],
	Num_SOLICITACAO [SLI],
	'' [Container Numbers],
	Case [dbo].[fBusca_CampoCliente](PS.Num_Proc,144)
		When 1 then 'Yes'
		When 2 then 'No'
		else ''
	End [Part-Lote],
	Q.Qty [Qtty of Units],
	DBO.fBusca_Tarefa(PS.Num_Proc,23) [DOCS TO CAMBIO],
	DBO.fBusca_Tarefa(PS.Num_Proc,40) [INVOICE SENT DATE]	
from House_Imp_Aer Hou with(nolock)
	--Join @Historico H  on H.Num_proc = hou.Num_Proc_HIA 
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
	left Join Hist_Geral_UltimoHistorico hsg on HSGProcesso = num_proc_lia
	Left Join @Qtty Q on Q.Num_proc = PS.Num_Proc 
where SUBSTRING(num_proc_hia,3,3)='LVS'
and ISNULL(LLP.ID_Status,0) <> 9
Group by Num_Pedido,PS.Num_Proc,PaisOrigem.Nome_Pais,SH.Nome_Raz_Soc,cd_proc_cliente,vlr_item,cd_tp_oper,dt_Li,Dt_Deferimento,ETA_LIA,ETD_LIA,ATD_LIA,ATA_LIA,Canal_LIA,Nome_Terminal,HAWB_HIA,MAWB_HIA,Vlr_Frete_Efet_HIA,Vol_Tot_HIA,Peso_Bruto_HIA,Qtde_Embal,Status_Descricao,HSGData,HSDDescricao,num_solicitacao,Q.Qty

union all


select distinct 
	Num_Pedido [PO Number] ,
	PS.Num_Proc [BDP#],
	'BDP' [Brokerage],
	Nome_Pais [Country of origin],
	SH.Nome_Raz_Soc [Vendor],
	cd_Proc_Cliente [PC9 / SKU],
	[dbo].[fBusca_Docs_PO_Modal](PS.Num_Proc ,2) [Invoice#],
	cast([dbo].fBusca_TipoDocCliente('D',PS.Num_Proc,2) as datetime) [Invoice Date],
	sum(PS.Qty) [Qty / units],
	PDD.Vlr_Item 	[Unit Price],
	Cd_Tp_Oper [Incoterm],
	'Ocean' Modal ,
	DBO.fBusca_Tarefa(PS.Num_Proc,46) [IL Request],
	Dt_LI [IL Registry],
	dt_Deferimento  [IL Approval],
	DBO.fBusca_Tarefa(PS.Num_Proc,146) [Email Broker],
	ETD_LIM [Departure - Estimated],
	ATD_LIM [Departure - Actual],
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
	CONVERT(varchar(10),hsg.HSGData,103) + ' - ' + hsg.HSDDescricao [Comments (DETAILS)] ,
	--Historico [Comments (DETAILS)],
	DBO.fBusca_Tarefa(PS.Num_Proc,142) [DANFE REQUEST],
	DBO.fBusca_Tarefa(PS.Num_Proc,143) [DANFE RECEIPT],
	DBO.fBusca_Tarefa(PS.Num_Proc,7) [DOCS DELIVERED TO TRUCK],
	DBO.fBusca_Tarefa(PS.Num_Proc,145) [EFFECTIVE DELIVERY DATE],
	Num_SOLICITACAO [SLI],
	[dbo].[fBusca_Containers](ps.num_proc) [Container Number],
	Case [dbo].[fBusca_CampoCliente](PS.Num_Proc,144)
		When 1 then 'Yes'
		When 2 then 'No'
		else ''
	End [Part-Lote],
	Q.Qty [Qtty of Units],
		DBO.fBusca_Tarefa(PS.Num_Proc,23) [DOCS TO CAMBIO],
	DBO.fBusca_Tarefa(PS.Num_Proc,40) [INVOICE SENT DATE]	


	
from House_imp_mar Hou with(nolock)
	--Join @Historico H  on H.Num_proc = hou.Num_Proc_HIm 
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
	left Join Hist_Geral_UltimoHistorico hsg on HSGProcesso = num_proc_lim
	Left Join @Qtty Q on Q.Num_proc = PS.Num_Proc 

where SUBSTRING(num_proc_him,3,3)='LVS'
and ISNULL(LLP.ID_Status,0) <> 9

Group by Nome_Tp_Carga,Vlr_FRete_EFet_him, Num_Pedido,PS.Num_Proc,PaisOrigem.Nome_Pais,SH.Nome_Raz_Soc,cd_proc_cliente,vlr_item,cd_tp_oper,dt_Li,Dt_Deferimento,ETA_LIM,ETD_LIM,ATD_LIM,ATA_LIM,Canal_LIM,Nome_Terminal,HAWB_HIM,MAWB_HIM,Vol_Tot_HIM,Peso_Bruto_HIM,Qtde_Embal,Status_Descricao,HSGData,HSDDescricao,num_solicitacao,Q.Qty
GO
