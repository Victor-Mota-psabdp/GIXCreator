SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--spATL_Tracking_IMP_Rel 'GRUPO FMC','2011-07-01','2011-07-31','0'


CREATE  Procedure [dbo].[spATL_TrackingbyItem_IMP_Rel] 
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
As
Select 
	Num_Proc_LIA [BDP Ref.], Num_Proc_MIA [Consol Ref.], 'N' [Urgent Y/N], Cast(LLP.ID_Status as varchar(10)) + ' - '  + Status_Descricao [Process Status],
	US.Nome_Usuario [CSR Name],Nome_local Destination,Cd_Planta [Plant ID],Customer_PO,Lote [Delivery Note],Num_PO [PO Number],Dt_Pedido [Order Date],
	TP50.Dt_Conclusao [Order Received - Date], Convert(datetime,dt_emis_hia,105) [Register Date],cd_proc_Cliente [Product ID],Produto_Descr [Product Description],
	Qty,'KG' UOM,DL_Chegada [PO Request Del Date],tp13.dt_previsao [Good Receipt Date - Estimated],tp13.Dt_Conclusao [Good Receipt Date - Actual],
	dbo.fBusca_CampoCliente (Num_ProC_Lia,5),Voo_HIA Navio,hou.MAWB_HIA Master,HAWB_HIA House,etd_Lia ETD,ATD_LIA ATD,TP7.dt_conclusao [Docs Received Date],
	TP41.dt_conclusao [Draft Approval IMP - Date],ETA_LIA ETA,ATA_LIA ATA,TP15.dt_conclusao [Port Entry Date],Data_PO_HIA [Customs Transmission Date],
	DI.numero_po_hia [Entry Number],canal_lia Canal,tp4.dt_conclusao CCD,TP7.dt_conclusao , [dbo].[fBusca_HistoricoDescr_Completo](num_proc_lia)
	
From
	LLP_Imp_AER LLP With(nolock)
	Join House_Imp_Aer hou with(nolock) on hou.num_proc_hia=num_proc_lia
	Join Tipo_Status_PRocesso TS with (nolock) on TS.id_status=LLP.id_status
	Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lia
	Join Pedido	PD with(nolock) on PD.cd_pedido=ps.cd_pedido
	Join Job_Imp_Aer JOb with(nolock) on job.num_proc_hia=num_proc_lia
	Join Usuario US with(nolock) on us.cd_usuario=job.cd_usuario
	Join Localidade DST with (nolock) on DST.cd_local=cd_dst_hia
	Join Pessoa_LLP P with(nolock) on P.cd_pes=cd_consig_hia
	Join Tarefas_Processos TP50 with(nolock) on TP50.num_proc=num_proc_lia and TP50.id_task=50
	Join Tarefas_Processos TP13 with(nolock) on TP13.num_proc=num_proc_lia and TP13.id_task=13
	Join Tarefas_Processos TP7 with(nolock) on TP7.num_proc=num_proc_lia and TP7.id_task=7
	Join Tarefas_Processos TP41 with(nolock) on TP41.num_proc=num_proc_lia and TP41.id_task=41
	Join Tarefas_Processos TP15 with(nolock) on TP15.num_proc=num_proc_lia and TP15.id_task=15
	Join Tarefas_Processos TP4 with(nolock) on TP4.num_proc=num_proc_lia and TP4.id_task=4

	Left Join PO_HIA DI with(nolock) on DI.num_proc_hia=num_proc_lia and DI.id_Dc=5
	Join PRoduto_Cliente PC on cd_prod=cd_produto
Where
	substring(num_proc_lia,3,3)='SUN'


GO
