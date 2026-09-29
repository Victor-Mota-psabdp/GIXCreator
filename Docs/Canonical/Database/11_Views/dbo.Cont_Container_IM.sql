SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    View Cont_Container_IM

AS

select 
	Dt_Vcto_Devol_IM ,mas.cd_armador, cm.cd_tp_cont,nome_armador, apelido, dt_atrac_mim, nome_tp_cont, count(ch.num_proc_him) Qty,navio_mim, dt_devol_im from container_hou_imp_mar ch

inner join container_mas_imp_mar cm on cm.num_proc_mim=ch.num_proc_mim and cm.item_cont_im=ch.item_cont_im
inner join tipo_container tp on tp.cd_tp_cont=cm.cd_tp_cont
inner join master_imp_mar mas on mas.num_proc_mim=ch.num_proc_mim
inner join armador arm on arm.cd_armador=mas.cd_armador
inner join house_imp_mar hou on hou.num_proc_him=ch.num_proc_him
inner join pessoa pp on pp.cd_pes=cd_import_him

where 
	cm.cd_tp_cont <> 'LCL' and right(dt_devol_im,4)<1000 and convert(datetime, Dt_Vcto_Devol_IM, 105) >= convert(datetime, '01/06/2005',105)
group by 
	nome_armador, apelido, dt_atrac_mim, nome_tp_cont,navio_mim,dt_devol_im,mas.cd_armador, cm.cd_tp_cont, Dt_Vcto_Devol_IM





GO
