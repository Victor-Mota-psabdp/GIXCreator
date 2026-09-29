SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSynchroImport_Rel] --'CSR','01-01-2011','08-31-2011','%'
		@DataInicial	Datetime,
		@DataFinal		Datetime
as

select 
	Distinct 
	TP.num_proc Job,convert(varchar(10),dt_conclusao,103) [Data Desambaraço - Date],nota_fiscal,convert(varchar(10),emissao,103) [Data Emissao - Date],data_envio [Data Envio Synchro],dst.nome_local Destino,po.numero_po_him [Invoice Number],di.numero_po_him [DI] 
from 
	tarefas_processos TP WIth(Nolock)
	Left Join Nota_Cliente NC With (Nolock) on NC.num_proc=TP.num_proc
	Join House_Imp_Mar Hou with(nolock) on hou.num_proc_him=tp.num_proc
	Join Localidade DST with(nolock) on dst.cd_local=cd_dst_him
	Left Join Po_Him PO with(nolock) on  PO.id_dc=2 and po.num_proc_him=TP.num_proc
	Left Join Po_Him DI with(nolock) on  DI.id_dc=5 and DI.num_proc_him=TP.num_proc

where 
	substring(TP.num_proc,3,3) in ('CSR','STB')
	and dt_conclusao between @DataInicial and @DataFinal and id_Task=4 and left(TP.num_proc,1)='I'


Union all


select 
	Distinct 
	TP.num_proc,convert(varchar(10),dt_conclusao,103),nota_fiscal,convert(varchar(10),emissao,103),data_envio,dst.nome_local destino ,po.numero_po_hia ,di.numero_po_hia
from 
	tarefas_processos TP WIth(Nolock)
	Left Join Nota_Cliente NC With (Nolock) on NC.num_proc=TP.num_proc
	Join House_Imp_aer Hou with(nolock) on hou.num_proc_hia=tp.num_proc
	Join Localidade DST with(nolock) on dst.cd_local=cd_dst_hia
	Left Join Po_Hia PO with(nolock) on  PO.id_dc=2 and po.num_proc_hia=Tp.num_proc
	Left Join Po_HiA DI with(nolock) on  DI.id_dc=5 and DI.num_proc_hia=TP.num_proc

where 
	substring(TP.num_proc,3,3) in ('CSR','STB')
	and dt_conclusao between @DataInicial and @DataFinal and left(TP.num_proc,1)='I'


Union all


select 
	Distinct 
	TP.num_proc,convert(varchar(10),dt_conclusao,103),nota_fiscal,convert(varchar(10),emissao,103),data_envio,dst.nome_local destino  ,po.numero_po_hio,di.numero_po_hio
from 
	tarefas_processos TP WIth(Nolock)
	Left Join Nota_Cliente NC With (Nolock) on NC.num_proc=TP.num_proc
	Join House_Imp_Out Hou with(nolock) on hou.num_proc_hio=tp.num_proc
	Join Localidade DST with(nolock) on dst.cd_local=cd_dst_hio
	Left Join Po_Hio PO with(nolock) on  PO.id_dc=2 and po.num_proc_hio=TP.num_proc
	Left Join Po_Hio DI with(nolock) on  DI.id_dc=5 and DI.num_proc_hio=TP.num_proc

where 
	substring(TP.num_proc,3,3) in ('CSR','STB')
	and dt_conclusao between @DataInicial and @DataFinal and left(TP.num_proc,1)='I'
GO
