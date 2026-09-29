SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spValoresDI_REL]
	@Num_Proc Varchar(16)

as

select 
	Nome_tp_tx, Valor , DI.Data_PO_HIM Data_DI, DI.Numero_PO_HIM DI,PO.numero_po_him PO
from 
	custo_processo CP
	Join Tipo_TAxa TT on TT.cd_tp_tx=CP.cd_tp_tx
	Join PO_HIM DI on DI.num_proc_him=num_proc and DI.ID_DC=5
	join po_him PO on po.num_proc_him=num_proc and PO.ID_DC=1
Where
	num_proc=@num_proc

UNION

select 
	Nome_tp_tx, Valor , DI.Data_PO_HIA Data_DI, DI.Numero_PO_HIA DI,PO.numero_po_hia PO
from 
	custo_processo CP
	Join Tipo_TAxa TT on TT.cd_tp_tx=CP.cd_tp_tx
	Join PO_HIA DI on DI.num_proc_hia=num_proc and DI.ID_DC=5
	join po_hiA PO on po.num_proc_hia=num_proc and PO.ID_DC=1
Where
	num_proc=@num_proc

UNION

select 
	Nome_tp_tx, Valor , DI.Data_PO_HIO Data_DI, DI.Numero_PO_HIO DI,PO.numero_po_hio PO
from 
	custo_processo CP
	Join Tipo_TAxa TT on TT.cd_tp_tx=CP.cd_tp_tx
	Join PO_HIO DI on DI.num_proc_hio=num_proc and DI.ID_DC=5
	join po_hio PO on po.num_proc_hio=num_proc and PO.ID_DC=1
Where
	num_proc=@num_proc



GO
