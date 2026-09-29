SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[spRegistroDI_Alert]

as

select 
	distinct apelido, tp.num_proc,tp.dt_conclusao, di.numero_po_him, dbo.fBusca_HistoricoDescr_Completo(HIM.num_proc_him) Historico, SAL.Numero_po_him PO
from tarefas_processos TP 
	left join po_him DI on DI.num_proc_him=TP.num_proc and DI.id_dc='5' 
	left join po_him SAL on SAL.num_proc_him=TP.num_proc and SAL.id_dc='1'
	left join house_imp_mar HIM on him.num_proc_him=tp.num_proc 
	Left Join Grupo on grupo=right(left(him.num_proc_him,5),3)
	Join Pessoa PP on PP.cd_pes=cd_pes_grupo
	Left join po_master DIM on DIM.num_proc_master=HIM.num_proc_mim and DIM.id_dc='5'
where 
	left(num_proc,2)='IM' and id_task='15' and 
	tp.dt_conclusao is not null and him.cd_dst_him='SSZ'
	and (DI.numero_po_him is null and DIM.numero_po is null)

Union all

select
	distinct apelido,tp.num_proc,tp.dt_conclusao, di.numero_po_hia, dbo.fBusca_HistoricoDescr_Completo(HIA.num_proc_hia) Historico, SAL.Numero_po_hia PO
from tarefas_processos TP 
	left join po_hia DI on DI.num_proc_hia=TP.num_proc and DI.id_dc='5' 
	left join po_hia SAL on SAL.num_proc_hia=TP.num_proc and SAL.id_dc='1'
	left join house_imp_aer HIA on hia.num_proc_hia=tp.num_proc 
	Left Join Grupo on grupo=right(left(hia.num_proc_hia,5),3)
	Join Pessoa PP on PP.cd_pes=cd_pes_grupo
	Left join po_master DIM on DIM.num_proc_master=HIA.num_proc_mia and DIM.id_dc='5'
where 
	left(num_proc,2)='IA' and id_task='15' and tp.dt_conclusao 
	is not null and DI.numero_po_hia is null and hia.cd_dst_hia in ('GRU','VCP')

order by tp.dt_conclusao



GO
