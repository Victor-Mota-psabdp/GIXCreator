SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCambioReport]

as


SELECT 
	Sales.Numero_PO_HIM Order_Number,PO.Numero_PO_HIM PO_Number,num_proc_lim Job,TP.dt_conclusao Desembaraco, DOC.Dt_Conclusao DOC,dbo.fBusca_HistoricoDescr(num_proc_lim,67,getdate()) Historico
FROM 
	LLP_IMP_MAR LLP
	JOIN TAREFAS_PROCESSOS TP ON TP.NUM_PROC=NUM_PROC_LIM AND TP.ID_TASK=4
	Join tarefas_processos DOC on DOC.num_proc=num_proc_lim and DOC.Id_task=23
	Join PO_HIM PO on PO.num_proc_him=num_proc_lim and PO.ID_DC=1
	Join PO_HIM SALES on SALES.num_proc_him=num_proc_lim and SALES.ID_DC=1

Where 
	TP.dt_Conclusao is not null and Doc.dt_conclusao is null
	and Sales.numero_po_him not like '%Sample%' and
	Sales.numero_po_him <> PO.numero_po_him


union



SELECT 
	Sales.Numero_PO_hia,PO.Numero_PO_hia PO_Number,num_proc_lia,TP.dt_conclusao Desembaraco, DOC.Dt_Conclusao DOC,dbo.fBusca_HistoricoDescr(num_proc_lia,67,getdate()) Historico
FROM 
	LLP_IMP_aer LLP
	JOIN TAREFAS_PROCESSOS TP ON TP.NUM_PROC=NUM_PROC_lia AND TP.ID_TASK=4
	Join tarefas_processos DOC on DOC.num_proc=num_proc_lia and DOC.Id_task=23
	Join PO_hia PO on PO.num_proc_hia=num_proc_lia and PO.ID_DC=1
	Join PO_hia SALES on SALES.num_proc_hia=num_proc_lia and SALES.ID_DC=1

Where 
	TP.dt_Conclusao is not null and Doc.dt_conclusao is null
	and Sales.numero_po_hia not like '%Sample%' 
	and Sales.numero_po_hia <> PO.numero_po_hia






union



SELECT 
	Sales.Numero_PO_hio,PO.Numero_PO_hio PO_Number,num_proc_lio,TP.dt_conclusao Desembaraco, DOC.Dt_Conclusao DOC,dbo.fBusca_HistoricoDescr(num_proc_lio,67,getdate()) Historico
FROM 
	LLP_IMP_out LLP
	JOIN TAREFAS_PROCESSOS TP ON TP.NUM_PROC=NUM_PROC_lio AND TP.ID_TASK=4
	Join tarefas_processos DOC on DOC.num_proc=num_proc_lio and DOC.Id_task=23
	Join PO_hio PO on PO.num_proc_hio=num_proc_lio and PO.ID_DC=1
	Join PO_hio SALES on SALES.num_proc_hio=num_proc_lio and SALES.ID_DC=1

Where 
	TP.dt_Conclusao is not null and Doc.dt_conclusao is null
	and Sales.numero_po_hio not like '%Sample%'
	and	Sales.numero_po_hio <> PO.numero_po_hio



GO
