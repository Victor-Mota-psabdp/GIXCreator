SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vwMetricas

as

select Nome_tp_carga,month(dt_conclusao) MEs,nome_local,num_proc,dbo.quantidade_dias(ATA_LIM,dt_conclusao)Dias_Uteis from llp_imp_mar LLP
Join  Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_task=4
Join House_Imp_mar hou on hou.num_proc_him=num_proc_lim
Join Localidade Dst on Dst.cd_local=cd_dst_him
Join Tipo_carga TC on TC.cd_tp_carga=llp.cd_tp_carga
where dt_conclusao is not null
union all


select 'LCL',month(dt_conclusao) MEs,nome_local,num_proc,dbo.quantidade_dias(ATA_lia,dt_conclusao)Dias_Uteis from llp_imp_aer LLP
Join  Tarefas_Processos TP on TP.num_proc=num_proc_lia and Id_task=4
Join House_Imp_aer hou on hou.num_proc_hia=num_proc_lia
Join Localidade Dst on Dst.cd_local=cd_dst_hia

where dt_conclusao is not null
GO
