SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[spNFSysncro_INT]

as

select 
	num_proc,nota_fiscal
from 
	nota_cliente NC with(nolock)
	Join PO_HIM DI with(nolock) on DI.num_proc_him=num_proc and id_dc=5
	Join House_Imp_mar HOU with(nolock) on Hou.num_proc_him=num_proc
Where
	data_po_him is not null and (envio='N' or envio is null) and len(data_po_him)>1
	and emissao > '01-01-2009'
	and num_proc like '%CSR%'
	--and cd_dst_him='SSZ'
union


select 
	num_proc,nota_fiscal
from 
	nota_cliente with(nolock)
	Join PO_HIA DI with(nolock) on DI.num_proc_hia=num_proc and id_dc=5
Where
	data_po_hia is not null and (envio='N' or envio is null) and len(data_po_hia)>(1)
	and emissao > '01-01-2009'
	and num_proc like '%CSR%'


union

select 
	num_proc,nota_fiscal
from 
	nota_cliente with(nolock)
	Join PO_HIO DI with(nolock) on DI.num_proc_hio=num_proc and id_dc=5
Where
	data_po_hio is not null and (envio='N' or envio is null) and len(data_po_hio)>(1)
	and emissao > '01-01-2009'
	and num_proc like '%CSR%'







GO
