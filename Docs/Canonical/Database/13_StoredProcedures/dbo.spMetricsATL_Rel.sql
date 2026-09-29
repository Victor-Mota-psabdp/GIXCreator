SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spMetricsATL_Rel

	@DataInicial Datetime,
	@DataFinal Datetime,
	@Grupo varchar(100)

as


select 
	V36.Descricao [Urgent Y/N],
	'Import' [Import/Export],
	Status_Descricao [Process Status],
	Nome_usuario [Reponsible PO],
	TP.Nome_Tp_Pedido [Order Type],
	Hou.Num_Proc [BDP Ref.],
	P.Num_Pedido [Sales Order],
	P.Customer_PO [Customer PO],
	PS.ITEM [Item],
	Dst.Nome_Local [Destination],
	Hou.Modal,
	PC.Produto_Descr [Product Description],
	Hou.Qtd_Vol [Container Qty],
	PS.Qty,
	HOU.Vlr_invoice [Invoice Value],
	Case 
	  when [dbo].[fBusca_CampoCliente](hou.num_proc,5)=1 then 'SIM'
	  else 'NAO'
	End [Necessidade de LI?],
	[dbo].[F_BuscaOrgaoAnuente_Sel](hou.Num_Proc) [Government Agency],
	hou.ETD	,
	TP05.Dt_Conclusao [Booking Confirmation Date],
	HOU.Vessel,
	HOU.ATD,
	HOU.ETA,
	TP16.Dt_Conclusao [Docs Received Date],
	dbo.FBusca_Docs(hou.num_proc,44) [PDF - BL Original],
	TP216.Dt_Conclusao [Protocol MAPA IN26 - Date],
	HOU.ATA [ATA],
	TP15.Dt_Conclusao [Port of Entry],
	TP105.Dt_Conclusao [Inspection MAPA - Date],
	TP175.Dt_Conclusao [Post Import License Release - Date],
	[dbo].[fBusca_TipoDocCliente]('D',hou.Num_Proc,5) [Customs Transmission Date],
	Hou.Canal [Channel],
	TP4.Dt_Conclusao [Customs Clearance Date],
	[dbo].[fBusca_TipoDocCliente]('D',hou.Num_Proc,10) [NF Date],
	TP7.Dt_Conclusao [Transport. Doc Delivery Date],
	TP223.Dt_conclusao [Loading at the Terminal - Date],
	TP13.dt_conclusao [Entrega na Planta - Date],
	P.DL_Chegada [GR Original - Date],
	[dbo].[fBusca_CampoCliente](hou.num_proc,177) [GR Previsto - Date],
	TP221.Dt_Conclusao  [GR Atual - Date],
	TP222.Dt_Conclusao [GR Efetivo - Date]
	
from vwHouse_imp HOU
 	left join Campo_Processo CP36 with(nolock) on HOU.Num_Proc = CP36.Num_Proc and CP36.Id_Campo = 36    
	left join Verdade V36 with(nolock) on CP36.Campo_Dados = V36.Id  
	Left join Tipo_Status_Processo TS with(nolock) on Hou.id_Status=TS.ID_Status
	Left Join Pedido_ship PS with(nolock) on hou.num_proc = PS.num_proc
	Left Join Pedido_det PDD with(nolock) on PS.cd_pedido=PDD.Cd_Pedido and PS.cd_produto=PDD.Cd_Produto and PS.Item=PDD.Item and PS.lote = PDD.lote
	Left Join Pedido P with(nolock) on P.cd_pedido=PDD.cd_pedido 
	Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and P.Cd_Grupo=UC.cd_cliente 
	Left Join tipo_pedido TP with(nolock) on TP.cd_tp_pedido=P.Cd_tipo
	Left Join Localidade Dst with(nolock) on HOU.Cd_dst=dst.Cd_Local
	Left Join Produto_Cliente PC with(nolock) on PS.cd_produto=PC.cd_prod
	Left Join Tarefas_Processos TP05 with (nolock) on HOU.num_proc=TP05.num_proc and TP05.ID_Task=5
	Left Join Tarefas_Processos TP16 with (nolock) on HOU.num_proc=TP16.num_proc and TP16.ID_Task=16
	Left Join Tarefas_Processos TP216 with (nolock) on HOU.num_proc=TP216.num_proc and TP216.ID_Task=216
	Left Join Tarefas_Processos TP15 with (nolock) on HOU.num_proc=TP15.num_proc and TP15.ID_Task=15
		Left Join Tarefas_Processos TP105 with (nolock) on HOU.num_proc=TP105.num_proc and TP105.ID_Task=105
		Left Join Tarefas_Processos TP175 with (nolock) on HOU.num_proc=TP175.num_proc and TP175.ID_Task=175
	Left Join Tarefas_Processos TP7 with (nolock) on HOU.num_proc=TP7.num_proc and TP7.ID_Task=7
	Left Join Tarefas_Processos TP223 with (nolock) on HOU.num_proc=TP223.num_proc and TP223.ID_Task=223
	Left Join Tarefas_Processos TP13 with (nolock) on HOU.num_proc=TP13.num_proc and TP13.ID_Task=13
	Left Join Tarefas_Processos TP221 with (nolock) on HOU.num_proc=TP221.num_proc and TP221.ID_Task=221
	Left Join Tarefas_Processos TP222 with (nolock) on HOU.num_proc=TP222.num_proc and TP222.ID_Task=222
	Join Pessoa GRP with(nolock) on GRP.cd_pes=P.Cd_Grupo
		Left Join Tarefas_Processos TP4 with (nolock) on HOU.num_proc=TP4.num_proc and TP4.ID_Task=4
	where	
		GRP.Apelido=@Grupo and TP222.Dt_Conclusao between @DataInicial and @DataFinal

GO
