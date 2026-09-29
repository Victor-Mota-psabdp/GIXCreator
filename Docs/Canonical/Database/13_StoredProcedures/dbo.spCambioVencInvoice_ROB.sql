SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE Procedure [dbo].[spCambioVencInvoice_ROB] --40
		(
			@Dias	int
		)

as

select TF.Num_Proc,Inv.Numero_Po_Him Invoice,INV.data_po_him Data_Inv, PO.Numero_Po_Him PO,SO.Numero_Po_Him SO, cast(getdate()-Isnull(INV.data_po_him,getdate()-@Dias) as float) Dias from po_him INV
Join Tarefas_processos TF on TF.num_proc=INV.num_proc_him and TF.id_task=23
Left Join PO_HIM SO on INV.num_proc_him = SO.num_proc_him and SO.ID_Dc=3
Left Join PO_HIM PO on INV.num_proc_him = PO.num_proc_him and PO.ID_Dc=1
Join tarefas_processos CCD on CCD.num_proc=INV.num_proc_him and CCD.id_task=4
Where INV.id_dc=2 and TF.dt_conclusao is null
and PO.Numero_Po_Him <> SO.Numero_Po_Him and PO.Numero_Po_Him not like '%FORM%'
and PO.Numero_Po_Him not like '%SAMP%' and SO.Numero_Po_Him not like '%SAMP%'
and inv.data_po_him is not null and TF.Num_Proc like '%ROB%' and
cast(getdate()-Isnull(INV.data_po_him,getdate()-@Dias) as float) >=@Dias
and CCD.dt_conclusao is not null

UNION

select TF.Num_Proc,Inv.Numero_Po_HIA,INV.data_po_HIA, PO.Numero_Po_HIA,SO.Numero_Po_HIA, cast(getdate()-Isnull(INV.data_po_hia,getdate()-@Dias) as float) Dias from po_HIA INV
Join Tarefas_processos TF on TF.num_proc=INV.num_proc_HIA and id_task=23
Left Join PO_HIA SO on INV.num_proc_HIA = SO.num_proc_HIA and SO.ID_Dc=3
Left Join PO_HIA PO on INV.num_proc_HIA = PO.num_proc_HIA and PO.ID_Dc=1
Join tarefas_processos CCD on CCD.num_proc=INV.num_proc_hia and CCD.id_task=4

Where INV.id_dc=2 and TF.dt_conclusao is  null
and PO.Numero_Po_Hia <> SO.Numero_Po_Hia and PO.Numero_Po_Hia not like '%FORM%'
and PO.Numero_Po_Hia not like '%SAMP%' and SO.Numero_Po_Hia not like '%SAMP%'
and cast(getdate()-Isnull(INV.data_po_hia,getdate()-@Dias) as float) >=@Dias
and CCD.Dt_conclusao is not null and TF.Num_Proc like '%ROB%'


union

select TF.Num_Proc,Inv.Numero_Po_hio,INV.data_po_hio, PO.Numero_Po_hio,SO.Numero_Po_hio, cast(getdate()-Isnull(INV.data_po_hio,getdate()-@Dias) as float)  Dias from po_hio INV
Join Tarefas_processos TF on TF.num_proc=INV.num_proc_hio and id_task=23
Left Join PO_hio SO on INV.num_proc_hio = SO.num_proc_hio and SO.ID_Dc=3
Left Join PO_hio PO on INV.num_proc_hio = PO.num_proc_hio and PO.ID_Dc=1
Join tarefas_processos CCD on CCD.num_proc=INV.num_proc_hio and CCD.id_task=4

Where INV.id_dc=2 and TF.dt_conclusao is  null
and PO.Numero_Po_Hio <> SO.Numero_Po_Hio and PO.Numero_Po_Hio not like '%FORM%'
and PO.Numero_Po_Hio not like '%SAMP%' and SO.Numero_Po_Hio not like '%SAMP%'
and cast(getdate()-Isnull(INV.data_po_hio,getdate()-@Dias) as float) >=@Dias
and CCD.dt_conclusao is not null and TF.Num_Proc like '%ROB%'

order by Dias desc
GO
