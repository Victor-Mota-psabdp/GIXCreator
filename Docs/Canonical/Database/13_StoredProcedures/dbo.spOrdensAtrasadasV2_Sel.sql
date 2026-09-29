SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create procedure [dbo].[spOrdensAtrasadasV2_Sel]

as

select DISTINCT
	Num_Proc_lia			Processo,
	'Air'					Modal,
	Num_pedido				Ordem,
	num_po					Numero_PO,
	Customer_PO,
	US.Nome_Usuario			PO_R,
	UD.Nome_Usuario,
	ETD_LIA					ETD,
	ATD_LIA					ATD,
	ETA_LIA					ETA,
	ATA_LIA					ATA,
	Presenca.Dt_previsao	Presenca_Previsao,
	Presenca.Dt_Conclusao	Presenca_Conclusao,
	Canal_Lia				Canal,
	Registro.dt_previsao	Registro_DI,
	DI.Numero_PO_HIA		DI_Number,
	DI.Data_PO_HIA			DI_Data,
	DDP.dt_previsao			Desembaraco_Previsao,
	DDP.dt_conclusao		Desembaraco_Conclusao,
	DOOR.Dt_Previsao		Entrega_Previsao,
	Door.Dt_Conclusao		Entrega_Conclusao,
	PO_GRP,
	DL_Chegada				PO_Original,
	dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lia,getdate()) Historico,
	cd_pes_ctt PO_CTT,
	CSR.Nome_Usuario CSR_Desk

 from 
	llp_imp_aer LLP With(nolock)
	Join Pedido_ship			PS With(nolock) on num_proc_lia=PS.num_proc
	Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Usuario_Cliente	US With(nolock) on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente	UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente	CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
	Left Join Tarefas_Processos Presenca With(nolock) on LLP.num_proc_lia=Presenca.num_proc and Presenca.Id_task=15
	Left Join Tarefas_Processos Registro With (nolock) on LLP.num_proc_lia=Registro.num_proc and Registro.Id_task=9
	Left Join PO_HIA			DI on DI.num_proc_hia=num_proc_lia and DI.ID_DC=5
	Left Join Tarefas_Processos DDP With(nolock) on LLP.num_proc_lia=DDP.num_proc and DDP.Id_task=4
	Left Join Tarefas_Processos DOOR With (nolock) on LLP.num_proc_lia=DOOR.num_proc and DOOR.Id_task=13
	Join Pedido_Det				PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto

where
	Door.Dt_Conclusao  is null and 
	substring(num_proc_lia,3,3) in ('CSR','STB')
	and etd_lia >=getdatE()-365
	AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
	AND ISNULL(ID_STATUS,0) <> 9

union all

select DISTINCT
	Num_Proc_lio			Processo,
	'Outros'				Modal,
	Num_pedido				Ordem,
	num_po					Numero_PO,
	Customer_PO,
	US.Nome_Usuario			PO_R,
	UD.Nome_Usuario,
	ETD_lio					ETD,
	ATD_lio					ATD,
	ETA_lio					ETA,
	ATA_lio					ATA,
	Presenca.Dt_previsao	Presenca_Previsao,
	Presenca.Dt_Conclusao	Presenca_Conclusao,
	Canal_lio				Canal,
	--Registro.dt_previsao	Registro_DI,
	DI.Data_PO_hio			Registro_DI,
	DI.Numero_PO_hio		DI_Number,
	DI.Data_PO_hio			DI_Data,
	DDP.dt_previsao			Desembaraco_Previsao,
	DDP.dt_conclusao		Desembaraco_Conclusao,
	DOOR.Dt_Previsao		Entrega_Previsao,
	Door.Dt_Conclusao		Entrega_Conclusao,
	PO_GRP,DL_Chegada		PO_Original,
	dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lio,getdate()) Historico,
	cd_pes_ctt PO_CTT,
	CSR.Nome_Usuario CSR_Desk


 from 
	llp_imp_out LLP wITH(NOLOCK)
	Join Pedido_ship			PS With(nolock) on num_proc_lio=PS.num_proc
	Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Usuario_Cliente	US With(nolock)on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente	UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente	CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
	Left Join Tarefas_Processos Presenca With(nolock) on LLP.num_proc_lio=Presenca.num_proc and Presenca.Id_task=15
	Left Join Tarefas_Processos Registro  With(nolock) on LLP.num_proc_lio=Registro.num_proc and Registro.Id_task=9
	Left Join PO_hio			DI With(nolock) on DI.num_proc_hio=num_proc_lio and DI.ID_DC=5
	Left Join Tarefas_Processos DDP With(nolock) on LLP.num_proc_lio=DDP.num_proc and DDP.Id_task=4
	Left Join Tarefas_Processos DOOR With(nolock) on LLP.num_proc_lio=DOOR.num_proc and DOOR.Id_task=13
	Join Pedido_Det				PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto

where --Atd_lio is not null and 
	Door.Dt_Conclusao  is null
	and substring(num_proc_lio,3,3) in ('CSR','STB')
	and etd_lio >=getdatE()-365
	AND ISNULL(ID_STATUS,0) <> 9
	AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
union all


select 
	Num_Proc_lim					Processo,
	'Marine'						Modal,
	Num_pedido						Ordem,
	num_po							Numero_PO,
	Customer_PO,
	US.Nome_Usuario					PO_R,
	UD.Nome_Usuario,
	ETD_lim							ETD,
	ATD_lim							ATD,
	ETA_lim							ETA,
	ATA_lim							ATA,
	Presenca.Dt_previsao			Presenca_Previsao,
	Presenca.Dt_Conclusao			Presenca_Conclusao,
	Canal_lim						Canal,
	--Registro.Dt_previsao			Registro_DI,
	DI.Data_PO_him					Registro_DI,
	DI.Numero_PO_him				DI_Number,
	DI.Data_PO_him					DI_Data,
	DDP.dt_previsao					Desembaraco_Previsao,
	DDP.dt_conclusao				Desembaraco_Conclusao,
	DOOR.Dt_Previsao				Entrega_Previsao,
	Door.Dt_Conclusao				Entrega_Conclusao,
	PO_GRP,
	DL_Chegada						PO_Original,
	dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lim,getdate()) Historico,
	cd_pes_ctt PO_CTT,
	CSR.Nome_Usuario CSR_Desk


 from 
	llp_imp_mar LLP wITH(nOLOCK)
	Join Pedido_ship				PS With(nolock) on num_proc_lim=PS.num_proc
	Join Pedido						PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Usuario_Cliente		US With(nolock) on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente		UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
	Left Join Usuario_Cliente	CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
	Left Join Tarefas_Processos		Presenca  With(nolock) on LLP.num_proc_lim=Presenca.num_proc and Presenca.Id_task=15
	Left Join Tarefas_Processos		Registro With(nolock)  on LLP.num_proc_lim=Registro.num_proc and Registro.Id_task=9
	Left Join PO_him				DI on DI.num_proc_him=num_proc_lim and DI.ID_DC=5
	Left Join Tarefas_Processos		DDP  With(nolock) on LLP.num_proc_lim=DDP.num_proc and DDP.Id_task=4
	Left Join Tarefas_Processos		DOOR With(nolock) on LLP.num_proc_lim=DOOR.num_proc and DOOR.Id_task=13
	Join Pedido_Det					PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto
where 
	Door.Dt_Conclusao  is null and 
	substring(num_proc_lim,3,3) in ('CSR','STB')
	and etd_lim >=getdatE()-365
	AND ISNULL(ID_STATUS,0) <> 9
	AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
Group by
	Num_Proc_lim,Num_pedido,num_po,
	Customer_PO,US.Nome_Usuario,UD.Nome_Usuario,
	ETD_lim,ATD_lim,ETA_lim,ATA_lim,Presenca.Dt_previsao,
	Presenca.Dt_Conclusao,Canal_lim,DI.Data_PO_him,
	DI.Numero_PO_him,DI.Data_PO_him,DDP.dt_previsao,
	DDP.dt_conclusao,DOOR.Dt_Previsao,Door.Dt_Conclusao,
	PO_GRP,DL_Chegada,cd_pes_ctt ,CSR.nome_usuario







GO
